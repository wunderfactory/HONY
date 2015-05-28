//
//  PageViewController.h
//  Avanti
//
//  Created by David Pflugpeil on 30.12.13.
//  Copyright (c) 2013 Wunderfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface PageViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) NSArray *pageTitles;

@end
