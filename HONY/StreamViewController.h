//
//  StreamViewController.h
//  HONY
//
//  Created by Jan Willem Kothe on 02.06.15.
//  Copyright (c) 2015 Magnus Langanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPTumblrPost.h"

@interface StreamViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIRefreshControl *topRefreshControl;
@property (weak, nonatomic) IBOutlet UITableView *streamTableView;
@property (weak, nonatomic) IBOutlet UIView *topBar;

@property int selectedIndex;
@property int totalPosts;

@property (strong, nonatomic) HPTumblrPost* shuffelPost;
@property BOOL shuffel;

@end
