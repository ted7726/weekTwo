//
//  Business.m
//  Yelp
//
//  Created by WeiSheng Su on 1/29/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business


- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self){
        self.name =         dictionary[@"name"];

        self.imageUrl =     dictionary[@"image_url"];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        self.numReviews =   [dictionary[@"review_count"] integerValue];
        float milesPerMeter = 0.000621371;
        self.distance =     [dictionary[@"distance"] integerValue] * milesPerMeter;
        

        NSString *street = [dictionary valueForKeyPath:@"location.address"][0];
        NSString *neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
        self.address = [NSString stringWithFormat:@"%@, %@",street,neighborhood];
        
        
        NSArray *categories =dictionary[@"categories"];
        
        
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];
               
//        NSLog(@"name:%@ \nimageUrl:%@ \nratingImageUrl:%@ \n:numReviews:%ld \ndistance:%.3f \naddress:%@ \ncategories:%@",
//              self.name,
//              self.imageUrl,
//              self.ratingImageUrl,
//              self.numReviews,
//              self.distance,
//              self.address,
//              self.categories);
    }
    return self;
}

+ (NSArray *) businessesWithDictionaries:(NSArray *)dictionaries{
    NSMutableArray *businesses =[NSMutableArray array];
    for(NSDictionary *dictionary in dictionaries){
        Business *business = [[Business alloc] initWithDictionary:dictionary ];
        [businesses addObject:business];
        
    }
    return businesses;
}


@end
