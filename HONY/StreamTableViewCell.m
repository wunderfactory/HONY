//
//  StreamTableViewCell.m
//  HONY
//
//  Created by Jan Willem Kothe on 02.06.15.
//  Copyright (c) 2015 Magnus Langanke. All rights reserved.
//

#import "StreamTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface StreamTableViewCell ()

@end

@implementation StreamTableViewCell


@synthesize cellImageView, textview;
@synthesize imageHeightConstraint, textViewHeightConstraint, blur, delegate;


- (void)awakeFromNib {
    // Initialization code
    
//    UITapGestureRecognizer* blurTapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTextHiddenStatus)];
//    [self addGestureRecognizer:blurTapper];
    
    
//    blur = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    blur.blurEnabled = YES;
    blur.tintColor = [UIColor blackColor];
    blur.blurRadius = 40;
    blur.alpha = 0.0;
//    blur.layer.opacity = 0.0;
//    [self addSubview:blur];
    
    //    textview.hidden = YES;
    textview.backgroundColor = [UIColor clearColor];
    textview.textColor = [UIColor whiteColor];
    textview.clipsToBounds = YES;
    textview.text = @"";
    
//    [blur addSubview:textview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}





#pragma mark Cell Touch Events

- (void)showBlur
{
    NSLog(@"show");
    
    
    [UIView animateWithDuration:0.2 animations:^{
        blur.alpha = 1.0;
        blur.layer.opacity = 1.0;
//        [self bringSubviewToFront:blur];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideBlur
{
    NSLog(@"hide");
    
    [UIView animateWithDuration:0.2 animations:^{
        blur.alpha = 0.0;
        blur.layer.opacity = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}






-(void)setText:(NSString *)postText{
    textview.text = postText;
    textview.font = [UIFont fontWithName:@"SFUIText-Medium" size:10];
}


+(UIImage*) scaleIfNeeded:(CGImageRef)cgimg {
    bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
    if (isRetina) {
        return [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp];
    } else {
        return [UIImage imageWithCGImage:cgimg];
    }
}

-(void)prepareForReuse{
    cellImageView.image = nil;
    textview.text = @"";
    textview.hidden = NO;
//    imageHeightConstraint.priority = 250;
//    imageHeightConstraint.constant = 100;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}



@end
