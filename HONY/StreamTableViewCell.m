//
//  StreamTableViewCell.m
//  HONY
//
//  Created by Jan Willem Kothe on 02.06.15.
//  Copyright (c) 2015 Magnus Langanke. All rights reserved.
//

#import "StreamTableViewCell.h"

@implementation StreamTableViewCell
@synthesize cellImageView, textview;
- (void)awakeFromNib {
    // Initialization code
    textview.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
