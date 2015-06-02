//
//  StreamViewController.m
//  HONY
//
//  Created by Jan Willem Kothe on 02.06.15.
//  Copyright (c) 2015 Magnus Langanke. All rights reserved.
//

#import "StreamViewController.h"
#import "CollectionCell.h"
#import "DPWebConnector.h"
#import "HOFullscreenViewController.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "MBProgressHUD.h"
#import "HPPostHandler.h"
#import "ImageScrollViewController.h"
#import "HOFeedPageViewController.h"
#import "SWRevealViewController.h"
#import "StreamTableViewCell.h"

@interface StreamViewController ()

@end

@implementation StreamViewController
@synthesize selectedIndex, topRefreshControl, totalPosts, shuffelPost;
@synthesize streamTableView, topBar;

- (void)viewDidAppear:(BOOL)animated
{
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Avalue"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"Avalue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"feedToWalkthrough" sender:nil];
    }
    [streamTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    streamTableView.dataSource = self;
    streamTableView.delegate = self;
    streamTableView.estimatedRowHeight = 50;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[HPPostHandler sharedPostHandler] startSession];
    topRefreshControl = [[UIRefreshControl alloc] init];
    [topRefreshControl addTarget:self action:@selector(loadNewPosts) forControlEvents:UIControlEventValueChanged];
    [streamTableView addSubview:topRefreshControl];
    streamTableView.alwaysBounceVertical = YES;
    
    streamTableView.bottomRefreshControl = [UIRefreshControl new];
    [streamTableView.bottomRefreshControl addTarget:self action:@selector(loadOldPosts) forControlEvents:UIControlEventValueChanged];
    
    
    /*UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    UILabel *honyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 30)];
    honyLabel.text = @"Humans of New York";
    honyLabel.textAlignment = NSTextAlignmentCenter;
    honyLabel.textColor = [UIColor whiteColor];
    honyLabel.font = [UIFont fontWithName:@"BebasNeue" size:32.0];*/
    
    //Add Menu Item to Top Bar
    SWRevealViewController* revealViewController = self.revealViewController;
    if(revealViewController){
        revealViewController.rearViewRevealWidth = 150;
        [self.view addGestureRecognizer:[revealViewController panGestureRecognizer]];
        UIButton* menuItem = [[UIButton alloc] initWithFrame:CGRectMake(5, topBar.bounds.size.height - 5- 25, 20, 20)];
        [menuItem addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents: UIControlEventTouchDown];
        //[menuItem setTitle:@"Menu" forState:UIControlStateNormal];
        [menuItem setImage:[UIImage imageNamed:@"MenuIcon"] forState:UIControlStateNormal];
        [topBar addSubview:menuItem];
    }
    
    /*
    [topBar addSubview:honyLabel];
    topBar.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0.75];
    [self.view addSubview:topBar];
    */
    
    //TBD: This Code only creates an image from the color right? Why not do this:
    //self.tabBarController.tabBar.backgroundColor = ...
    /*UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height)];
     view.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0.75];
     UIGraphicsBeginImageContext(view.bounds.size);
     [view.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIImage *tabbarBackground = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     self.tabBarController.tabBar.backgroundImage = tabbarBackground;
     
     [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];*/
    
    //[scroll setContentInset:UIEdgeInsetsMake(topBar.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0)];
    
    UIButton* shuffelButton = [[UIButton alloc] initWithFrame:CGRectMake(topBar.bounds.size.width - 5 - 20, topBar.bounds.size.height - 5- 25, 20, 20)];
    [shuffelButton addTarget:self action:@selector(loadShuffelView) forControlEvents:UIControlEventTouchUpInside];
    [shuffelButton setBackgroundImage:[UIImage imageNamed:@"NewShuffle"] forState:UIControlStateNormal];
    [topBar addSubview:shuffelButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark streamTableView


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


/*-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = (int)indexPath.row;
    //    [self performSegueWithIdentifier:@"toTestFull" sender:self];
    [self performSegueWithIdentifier:@"testingshit" sender:self];
    
}*/


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StreamTableViewCell* cell = [streamTableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    if(!cell){
        cell = [[StreamTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"ImageCell"];
    }
    
    HPTumblrPost* post = (HPTumblrPost *)[[HPPostHandler sharedPostHandler].posts objectAtIndex:indexPath.row];
    
    
    
    NSURL *url = NULL;
    for (NSDictionary* photo in post.photos) {
        if ([photo[@"width"]integerValue] > self.view.bounds.size.width/3*2 && [photo[@"width"] integerValue]>self.view.bounds.size.width/3*2) {
            url = photo[@"url"];
            break;
        }
    }
    if (url == NULL) {
        url = post.originalPhoto[@"url"];
    }
    
    [cell.cellImageView setImageWithURL:url placeholderImage:NULL];

    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[HPPostHandler sharedPostHandler].posts count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqual:@"toFullscreen"]) {
        HOFullscreenViewController* full = (HOFullscreenViewController *) segue.destinationViewController;
        full.post = (HPTumblrPost *)[[HPPostHandler sharedPostHandler].posts objectAtIndex:selectedIndex];
        full.shuffel = NO;
    } else if ([[segue identifier] isEqual:@"toShuffel"]) {
        HOFullscreenViewController* full = (HOFullscreenViewController *) segue.destinationViewController;
        full.post = shuffelPost;
        full.totalPosts = totalPosts;
        full.shuffel = YES;
    } else if ([[segue identifier] isEqual:@"toTestFull"]){
        ImageScrollViewController* full = (ImageScrollViewController *) segue.destinationViewController;
        full.post = (HPTumblrPost *)[[HPPostHandler sharedPostHandler].posts objectAtIndex:selectedIndex];
        full.shuffel = NO;
    } else if ([[segue identifier] isEqual:@"toTestShuffel"]) {
        ImageScrollViewController* full = (ImageScrollViewController *) segue.destinationViewController;
        full.post = shuffelPost;
        full.shuffel = YES;
        [MBProgressHUD showHUDAddedTo:full.view animated:YES];
    } else if ([segue.identifier isEqualToString:@"testingshit"]) {
        HOFeedPageViewController* feedPage = (HOFeedPageViewController *) segue.destinationViewController;
        if (selectedIndex >= [HPPostHandler sharedPostHandler].posts.count - 1) {
            [[HPPostHandler sharedPostHandler] addOldPosts:9 withRealAmount:YES];
        }
        feedPage.startingIndex = selectedIndex;
    }
}

- (void) loadNewPosts {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HPPostHandler sharedPostHandler] loadNewPosts];
        dispatch_async(dispatch_get_main_queue(), ^{
            [topRefreshControl endRefreshing];
            [streamTableView reloadData];
        });
    });
}

- (void) loadOldPosts {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HPPostHandler sharedPostHandler] addOldPosts:30 withRealAmount:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [streamTableView.bottomRefreshControl endRefreshing];
            [streamTableView reloadData];
        });
    });
}

- (void) loadShuffelView {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        shuffelPost = [[HPPostHandler sharedPostHandler] shuffeledPost];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"toTestShuffel" sender:self];
        });
    });
}
@end
