//
//  FiltersViewController.m
//  Yelp
//
//  Created by WeiSheng Su on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "FilterOption.h"
#import "RegularCell.h"




static NSArray *sortByOptions;
static NSArray *radiusOptions;

static FilterOption *staticFilterOption;

typedef enum{
    SORT_BY_SECTION     = 0,
    RADIUS_SECTION      = 1,
    DEALS_SECTION       = 2,
    CATEGORIES_SECTION  = 3
} filtersTableSection;


@interface FiltersViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;


@property (nonatomic)BOOL categoriesExpanded;

@property (nonatomic, strong) FilterOption * filterOption;


- (void) initCategories;

@end

@implementation FiltersViewController
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.selectedCategories = [NSMutableSet set];
        if(staticFilterOption) {
            _filterOption= staticFilterOption;
        }else{
            _filterOption = [[FilterOption alloc]init];
        }
        [self initCategories];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Filters";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RegularCell" bundle:nil] forCellReuseIdentifier:@"RegularCell"];
    
    
    /* define options */
    sortByOptions = @[@"Best Match", @"Distance", @"Highest Rated"];
    radiusOptions = @[@"Auto",@"10 miles",@"20 miles",@"30 miles",@"40 miles"];
    
    self.categoriesExpanded = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch(section){
        case SORT_BY_SECTION:
            return sortByOptions.count;
        case RADIUS_SECTION:
            return radiusOptions.count;
        case DEALS_SECTION:
            return 1;
        case CATEGORIES_SECTION:
            if (self.categoriesExpanded){
                return self.categories.count;
            }else{
                return 5;
            }
            
    }
    
    return self.categories.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section){
        case SORT_BY_SECTION:
            return @"Sort By";
        case RADIUS_SECTION:
            return @"Radius";
        case DEALS_SECTION:
            return @"Deals";
        case CATEGORIES_SECTION:
            return @"Category";
    }
    return @"section title";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    RegularCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RegularCell"];
    cell.accessoryView = nil;
    switch (section){
        case SORT_BY_SECTION:{
            cell.titleLabel.text = sortByOptions[row];
            if(_filterOption.sortFilter == row){
                cell.accessoryType =  UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType =  UITableViewCellAccessoryNone;
            }

            return cell;
        }case RADIUS_SECTION:{
            cell.titleLabel.text = radiusOptions[row];
            if(_filterOption.radiusFilter == row){
                cell.accessoryType =  UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType =  UITableViewCellAccessoryNone;
            }
            return cell;
            
        }case DEALS_SECTION:{
            cell.titleLabel.text = @"Make a Deal!";
            UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(263, 6, 0, 0)];
            [cellSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
            cellSwitch.on = _filterOption.dealsFilter;
            cell.accessoryView=cellSwitch;
            
            return cell;
            
        }case CATEGORIES_SECTION:{
            if (!self.categoriesExpanded && row==4){
                cell.titleLabel.text = @"See All";
                cell.textLabel.tintColor = [UIColor redColor];
            }else{
                cell.titleLabel.text = self.categories[row][@"name"];
            }
            if ([_filterOption.categories containsObject:@(row)]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
    }
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section){
        case SORT_BY_SECTION:{
            _filterOption.sortFilter = (int)row;
            break;
        }case RADIUS_SECTION:{
            _filterOption.radiusFilter = (int)row;
            break;
            
        }case DEALS_SECTION:{
            _filterOption.dealsFilter = !_filterOption.dealsFilter;
            break;
        }case CATEGORIES_SECTION:{
            
            if(!_categoriesExpanded && row == 4){
                _categoriesExpanded = YES;
            }else{
                if([_filterOption.categories containsObject:@(row)]){
                    [_filterOption.categories removeObject:@(row)];
                }else{
                    [_filterOption.categories addObject:@(row)];
                }
            }
            break;
        }
    }
    [self.tableView reloadData];
    
}
#pragma mark - Switch cell delegate methods

- (void)onSwitch: (UISwitch *)cell{
    NSLog(@"toggle UISwitchCell!");
    _filterOption.dealsFilter = !_filterOption.dealsFilter;
    cell.on =_filterOption.dealsFilter;
}

# pragma mark - Private methods
- (void) onCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton{
    
    [self.delegate filtersViewController:self didChangeFilters:[self convertFilterOptionToParams]];
    staticFilterOption = _filterOption;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDictionary *) convertFilterOptionToParams{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setObject:[NSString stringWithFormat:@"%f,%f",_filterOption.latitude,_filterOption.longitude] forKey:@"ll"];
    [param setObject:[@(_filterOption.sortFilter) stringValue] forKey:@"sort"];
    
    if(_filterOption.dealsFilter){
        [param setObject:@"true" forKey:@"deals_filter"];
    }
    
    if(_filterOption.radiusFilter>0){
        [param setObject:[@(_filterOption.radiusFilter*16093) stringValue] forKey:@"radius_filter"];
    }
    
    if(_filterOption.categories.count>0){
        NSString *categoriesString = [self.categories objectAtIndex:[[_filterOption.categories objectAtIndex:0] intValue]][@"value"];
        for(int i=1;i<[_filterOption.categories count];i++){
            categoriesString = [categoriesString stringByAppendingString:@","];
            categoriesString = [categoriesString stringByAppendingString:[self.categories objectAtIndex:[[_filterOption.categories objectAtIndex:i] intValue]][@"value"]];
        }
        [param setObject:categoriesString forKey:@"category_filter"];
        
    }
    NSDictionary *parameters = [[NSDictionary alloc]initWithDictionary:param];
    
    return parameters;
}


- (void) initCategories{
    self.categories =
    @[@{@"name":@"Afghan", @"value":@"afghani"},
      @{@"name":@"African", @"value":@"african"},
      @{@"name":@"American (New)", @"value":@"newamerican"},
      @{@"name":@"American (Traditional)", @"value":@"tradamerican"},
      @{@"name":@"Argentine", @"value":@"argentine"},
      @{@"name":@"Asian Fusion", @"value":@"asianfusion"},
      @{@"name":@"Barbeque", @"value":@"bbq"},
      @{@"name":@"Basque", @"value":@"basque"},
      @{@"name":@"Belgian", @"value":@"belgian"},
      @{@"name":@"Brasseries", @"value":@"brasseries"},
      @{@"name":@"Brazilian", @"value":@"brazilian"},
      @{@"name":@"Breakfast & Brunch", @"value":@"breakfast_brunch"},
      @{@"name":@"British", @"value":@"british"},
      @{@"name":@"Buffets", @"value":@"buffets"},
      @{@"name":@"Burgers", @"value":@"burgers"},
      @{@"name":@"Burmese", @"value":@"burmese"},
      @{@"name":@"Cafes", @"value":@"cafes"},
      @{@"name":@"Cajun/Creole", @"value":@"cajun"},
      @{@"name":@"Cambodian", @"value":@"cambodian"},
      @{@"name":@"Caribbean", @"value":@"caribbean"},
      @{@"name":@"Cheesesteaks", @"value":@"cheesesteaks"},
      @{@"name":@"Chicken Wings", @"value":@"chicken_wings"},
      @{@"name":@"Chinese", @"value":@"chinese"},
      @{@"name":@"Creperies", @"value":@"creperies"},
      @{@"name":@"Cuban", @"value":@"cuban"},
      @{@"name":@"Delis", @"value":@"delis"},
      @{@"name":@"Diners", @"value":@"diners"},
      @{@"name":@"Ethiopian", @"value":@"ethiopian"},
      @{@"name":@"Fast Food", @"value":@"hotdogs"},
      @{@"name":@"Filipino", @"value":@"filipino"},
      @{@"name":@"Fish & Chips", @"value":@"fishnchips"},
      @{@"name":@"Fondue", @"value":@"fondue"},
      @{@"name":@"Food Stands", @"value":@"foodstands"},
      @{@"name":@"French", @"value":@"french"},
      @{@"name":@"Gastropubs", @"value":@"gastropubs"},
      @{@"name":@"German", @"value":@"german"},
      @{@"name":@"Gluten-Free", @"value":@"gluten_free"},
      @{@"name":@"Greek", @"value":@"greek"},
      @{@"name":@"Halal", @"value":@"halal"},
      @{@"name":@"Hawaiian", @"value":@"hawaiian"},
      @{@"name":@"Himalayan/Nepalese", @"value":@"himalayan"},
      @{@"name":@"Hot Dogs", @"value":@"hotdog"},
      @{@"name":@"Hungarian", @"value":@"hungarian"},
      @{@"name":@"Indian", @"value":@"indpak"},
      @{@"name":@"Indonesian", @"value":@"indonesian"},
      @{@"name":@"Irish", @"value":@"irish"},
      @{@"name":@"Italian", @"value":@"italian"},
      @{@"name":@"Japanese", @"value":@"japanese"},
      @{@"name":@"Korean", @"value":@"korean"},
      @{@"name":@"Kosher", @"value":@"kosher"},
      @{@"name":@"Latin American", @"value":@"latin"},
      @{@"name":@"Live/Raw Food", @"value":@"raw_food"},
      @{@"name":@"Malaysian", @"value":@"malaysian"},
      @{@"name":@"Mediterranean", @"value":@"mediterranean"},
      @{@"name":@"Mexican", @"value":@"mexican"},
      @{@"name":@"Middle Eastern", @"value":@"mideastern"},
      @{@"name":@"Modern European", @"value":@"modern_european"},
      @{@"name":@"Mongolian", @"value":@"mongolian"},
      @{@"name":@"Moroccan", @"value":@"moroccan"},
      @{@"name":@"Pakistani", @"value":@"pakistani"},
      @{@"name":@"Persian/Iranian", @"value":@"persian"},
      @{@"name":@"Peruvian", @"value":@"peruvian"},
      @{@"name":@"Pizza", @"value":@"pizza"},
      @{@"name":@"Polish", @"value":@"polish"},
      @{@"name":@"Portuguese", @"value":@"portuguese"},
      @{@"name":@"Russian", @"value":@"russian"},
      @{@"name":@"Salad", @"value":@"salad"},
      @{@"name":@"Sandwiches", @"value":@"sandwiches"},
      @{@"name":@"Scandinavian", @"value":@"scandinavian"},
      @{@"name":@"Seafood", @"value":@"seafood"},
      @{@"name":@"Singaporean", @"value":@"singaporean"},
      @{@"name":@"Soul Food", @"value":@"soulfood"},
      @{@"name":@"Soup", @"value":@"soup"},
      @{@"name":@"Southern", @"value":@"southern"},
      @{@"name":@"Spanish", @"value":@"spanish"},
      @{@"name":@"Steakhouses", @"value":@"steak"},
      @{@"name":@"Sushi Bars", @"value":@"sushi"},
      @{@"name":@"Taiwanese", @"value":@"taiwanese"},
      @{@"name":@"Tapas Bars", @"value":@"tapas"},
      @{@"name":@"Tapas/Small Plates", @"value":@"tapasmallplates"},
      @{@"name":@"Tex-Mex", @"value":@"tex-mex"},
      @{@"name":@"Thai", @"value":@"thai"},
      @{@"name":@"Turkish", @"value":@"turkish"},
      @{@"name":@"Ukrainian", @"value":@"ukrainian"},
      @{@"name":@"Vegan", @"value":@"vegan"},
      @{@"name":@"Vegetarian", @"value":@"vegetarian"},
      @{@"name":@"Vietnamese", @"value":@"vietnamese"}];
    
}
@end
