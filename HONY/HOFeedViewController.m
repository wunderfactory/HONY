//
//  HOFeedViewController.m
//  HONY
//
//  Created by Magnus Langanke on 26.05.14.
//  Copyright (c) 2014 Magnus Langanke & David Pflugpeil. All rights reserved.
//

#import "HOFeedViewController.h"
#import "CollectionCell.h"
#import "DPWebConnector.h"
#import "HOFullscreenViewController.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "MBProgressHUD.h"
#import "HPPostHandler.h"
#import "HPTumblrPost.h"
#import "ImageScrollViewController.h"
#import "HOFeedPageViewController.h"

@interface HOFeedViewController ()

@property (strong, nonatomic) UIRefreshControl *topRefreshControl;

@property int selectedIndex;
@property int totalPosts;

@property (strong, nonatomic) HPTumblrPost* shuffelPost;


@end

@implementation HOFeedViewController
@synthesize selectedIndex, topRefreshControl, totalPosts, shuffelPost;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidAppear:(BOOL)animated
{
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Avalue"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"Avalue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"feedToWalkthrough" sender:nil];
    }
    [self.collectionView reloadData];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    [[HPPostHandler sharedPostHandler] startSession];
    topRefreshControl = [[UIRefreshControl alloc] init];
    [topRefreshControl addTarget:self action:@selector(loadNewPosts) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:topRefreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.bottomRefreshControl = [UIRefreshControl new];
    [self.collectionView.bottomRefreshControl addTarget:self action:@selector(loadOldPosts) forControlEvents:UIControlEventValueChanged];

    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    UILabel *honyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 30)];
    honyLabel.text = @"Humans of New York";
    honyLabel.textAlignment = NSTextAlignmentCenter;
    honyLabel.textColor = [UIColor whiteColor];
    honyLabel.font = [UIFont fontWithName:@"BebasNeue" size:32.0];
    
    [topBar addSubview:honyLabel];
    topBar.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0.75];
    [self.view addSubview:topBar];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height)];
    view.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0.75];
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tabbarBackground = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.tabBarController.tabBar.backgroundImage = tabbarBackground;
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    
    UIScrollView *scroll = (UIScrollView*)self.collectionView;
    [scroll setContentInset:UIEdgeInsetsMake(topBar.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0)];
    
    UIButton* shuffelButton = [[UIButton alloc] initWithFrame:CGRectMake(topBar.bounds.size.width - 5 - 28, topBar.bounds.size.height - 5- 25, 28, 20)];
    [shuffelButton addTarget:self action:@selector(loadShuffelView) forControlEvents:UIControlEventTouchUpInside];
    [shuffelButton setBackgroundImage:[UIImage imageNamed:@"shuffel"] forState:UIControlStateNormal];
    [topBar addSubview:shuffelButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[HPPostHandler sharedPostHandler].posts count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
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
    
    [collectionCell.cellPostImage setImageWithURL:url placeholderImage:NULL];
    
    return collectionCell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/3, self.view.bounds.size.width/3);
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = (int)indexPath.row;
//    [self performSegueWithIdentifier:@"toTestFull" sender:self];
    [self performSegueWithIdentifier:@"testingshit" sender:self];

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
            [self.collectionView reloadData];
        });
    });
}

- (void) loadOldPosts {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[HPPostHandler sharedPostHandler] addOldPosts:30 withRealAmount:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.bottomRefreshControl endRefreshing];
                [self.collectionView reloadData];
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
