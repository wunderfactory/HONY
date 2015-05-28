//
//  PageContentViewController.h
//  HONY
//
//  Created by David Pflugpeil on 30.12.13.
//  Copyright (c) 2013 Wunderfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@property (strong, nonatomic) IBOutlet UIButton *jumpToAppButton;

@end
