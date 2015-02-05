//
//  FilterOption.m
//  Yelp
//
//  Created by WeiSheng Su on 2/2/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterOption.h"

@implementation FilterOption


- (id)init {
    self = [super init];
    if (self) {
        self.location = @"San Francisco";
        self.latitude = 37.900000;
        self.longitude = -122.500000;
        self.radiusFilter = 0;
        self.sortFilter = 0;
        self.dealsFilter = NO;
        self.categories = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(id)copyWithFilterOption:(FilterOption *)filter
{
    // We'll ignore the zone for now
    FilterOption *copyFilter = [[FilterOption alloc] init];
    copyFilter = [copyFilter copyWithFilterOption: filter];
    return copyFilter;
}


@end
