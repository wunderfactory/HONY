//
//  StreamTableViewCell.h
//  HONY
//
//  Created by Jan Willem Kothe on 02.06.15.
//  Copyright (c) 2015 Magnus Langanke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) UIImage* unblurredImage;
@property (strong, nonatomic) UIImage* blurredImage;
@property (nonatomic) BOOL imageBlurred;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

-(void)changeTextHiddenStatus;
-(void)setText:(NSString*)postText;

-(UIImage*)blurImage: (UIImage*)theImage;

-(void)prepareForReuse;
@end
