//
//  HOFeedPageViewController.h
//  HONY
//
//  Created by Magnus Langanke on 27.06.14.
//  Copyright (c) 2014 Magnus Langanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollViewController.h"
#import "HPPostHandler.h"

@interface HOFeedPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property () NSInteger startingIndex;

@end
