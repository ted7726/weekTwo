//
//  FilterOption.h
//  Yelp
//
//  Created by WeiSheng Su on 2/2/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterOption : NSObject


@property (nonatomic, strong) NSString * term;
@property (nonatomic, strong) NSString * location;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) int radiusFilter;
@property (nonatomic) int sortFilter;
@property (nonatomic) BOOL dealsFilter;
@property (nonatomic, strong) NSMutableArray * categories;


@end
