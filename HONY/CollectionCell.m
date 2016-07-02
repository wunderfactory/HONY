//
//  CollectionCell.m
//  HONY
//
//  Created by David Pflugpeil on 25.05.14.
//  Copyright (c) 2014 wunderfactory. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell
@synthesize cellPostImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        cellPostImage.frame = frame;
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.backgroundView = cellPostImage;
    UIView * backgroundSelected = [[UIView alloc] initWithFrame:rect];
    backgroundSelected.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.selectedBackgroundView = backgroundSelected;
}



@end
