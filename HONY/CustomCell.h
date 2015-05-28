//
//  CustomCell.h
//  HONY
//
//  Created by David Pflugpeil on 29.05.14.
//  Copyright (c) 2014 Magnus Langanke & David Pflugpeil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellDate;
@property (weak, nonatomic) IBOutlet UITextView *cellText;

@end
