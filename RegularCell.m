//
//  RegularCell.m
//  Yelp
//
//  Created by WeiSheng Su on 2/4/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "RegularCell.h"

@implementation RegularCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
