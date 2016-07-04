//
//  StreamTableViewCell.h
//  HONY
//
//  Created by Jan Willem Kothe on 02.06.15.
//  Copyright (c) 2015 Magnus Langanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"


@protocol StreamTableViewCellDelegate <NSObject>

- (void)blurCell;

@end

@interface StreamTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FXBlurView *blur;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *textview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingActivityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeightConstraint;

@property BOOL blurred;

@property (nonatomic, weak) id <StreamTableViewCellDelegate> delegate;

-(void)setText:(NSString*)postText;

-(void)prepareForReuse;

- (void)showBlur;
- (void)hideBlur;


@end
