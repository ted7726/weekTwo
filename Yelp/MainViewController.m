//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"
#import "FilterOption.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *paramsFromFilters;
- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        //fetch Businesses With Query!
        [self fetchBusinessesWithQuery:@"Restaurants" params:self.paramsFromFilters];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.paramsFromFilters = nil;
    
    
    /* setup Table View */
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    
    
    /* setup search bar */
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self;
    self.searchBar.text = @"Restaurants";
    //self.searchBar.barTintColor = [UIColor purpleColor];
    self.navigationItem.titleView = self.searchBar;
    //self.tableView.tableHeaderView = self.searchBar;
    
    /* setup refresh Control */
    [self onRefresh];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    
    /* setup navigation left Button */
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton)];
    
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    /* setup navigation Bar */
    self.title = @"yelp";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    self.navigationController.navigationBar.translucent = NO;
    
    /* setup Filter Optinos */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params{
   
    [self.client searchWithTerm:query params: params success:^(AFHTTPRequestOperation *operation, id response) {
        
        //            NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        self.businesses = [Business businessesWithDictionaries:businessDictionaries];
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self fetchBusinessesWithQuery:self.searchBar.text params:self.paramsFromFilters];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.businesses count] > 0 ){
        return self.businesses.count;
        
    }else{
        return 1;
  
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    
    return cell;
}

- (void) onRefresh{
    [self fetchBusinessesWithQuery:_searchBar.text params:self.paramsFromFilters];
}

#pragma mark - Filter delegate methods
- (void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters{
    // fire another network event
    self.paramsFromFilters = filters;

    
    [self fetchBusinessesWithQuery:self.searchBar.text params:filters];
    NSLog(@"fire new network event: %@", filters);
    
}

#pragma mark - Private methods
- (void) onFilterButton {
    FiltersViewController *filterVC =[[FiltersViewController alloc]init];
    
    filterVC.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:filterVC];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void) onSearchButton{
    [self fetchBusinessesWithQuery:_searchBar.text params:self.paramsFromFilters];
}

@end
