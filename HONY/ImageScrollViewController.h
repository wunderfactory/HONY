//
//  ImageScrollViewController.h
//  ImageScroll
//
//  Created by Evgenii Neumerzhitckii on 19/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "HPTumblrPost.h"

@interface ImageScrollViewController : UIViewController
- (instancetype)initWithTumblrPost:(HPTumblrPost *)tumblrPost andRect:(CGRect)rect andIndex:(NSInteger) index;
@property(strong, nonatomic) HPTumblrPost* post;
@property (strong, nonatomic) IBOutlet UIView *quoteView;
@property (strong, nonatomic) IBOutlet UIButton* closeButton;
@property (strong, nonatomic) IBOutlet UITextView* quote;
@property (strong, nonatomic) IBOutlet UIButton* moreQuoteButton;
@property (strong, nonatomic) UIButton* shareButton;
@property () bool fullQuoteShown;
@property () NSInteger index;
@property BOOL shuffel;

@end
