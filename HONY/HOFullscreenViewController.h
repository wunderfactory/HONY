//
//  HOFullscreenViewController.h
//  HONY
//
//  Created by Magnus Langanke on 26.05.14.
//  Copyright (c) 2014 Magnus Langanke & David Pflugpeil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "HPTumblrPost.h"

@interface HOFullscreenViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property(strong, nonatomic) HPTumblrPost* post;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *quoteView;
@property (strong, nonatomic) IBOutlet UIButton* closeButton;
@property (strong, nonatomic) IBOutlet UITextView* quote;
@property (strong, nonatomic) IBOutlet UIButton* moreQuoteButton;
@property (strong, nonatomic) UIButton* shareButton;
@property () bool fullQuoteShown;
@property (strong, nonatomic) IBOutlet UIScrollView* scroll;
@property BOOL shuffel;
@property int totalPosts;
@end
