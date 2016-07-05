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

@property NSUInteger selectedRow;

@end

@implementation StreamViewController
@synthesize selectedIndex, topRefreshControl, totalPosts, shuffelPost;
@synthesize streamTableView, topBar, shuffelButton;
@synthesize shuffel, streamLoadingActivityIndicator, streamCollectionView, selectedRow;

- (void)viewDidAppear:(BOOL)animated
{
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Avalue"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"Avalue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"feedToWalkthrough" sender:nil];
    }
    
    if(![[HPPostHandler sharedPostHandler] hasConnectivity]){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error connecting to internet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [streamTableView reloadData];
    [streamTableView setNeedsLayout];
    [streamTableView layoutIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedRow = -1;
    
    streamTableView.dataSource = self;
    streamTableView.delegate = self;
    
    streamCollectionView.dataSource = self;
    streamCollectionView.delegate = self;
    
    NSLog(@"%i", [[NSUserDefaults standardUserDefaults] boolForKey:@"listInFeed"]);
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"listInFeed"] == YES) {
        streamCollectionView.hidden = true;
        [streamTableView reloadData];
    }
    else {
        streamTableView.hidden = true;
        [streamCollectionView reloadData];
    }
    
    //streamTableView.rowHeight = UITableViewAutomaticDimension;
    //streamTableView.estimatedRowHeight = 110;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[HPPostHandler sharedPostHandler] startSession];
    topRefreshControl = [[UIRefreshControl alloc] init];
    [topRefreshControl addTarget:self action:@selector(loadNewPosts) forControlEvents:UIControlEventValueChanged];
    [streamTableView addSubview:topRefreshControl];
    streamTableView.alwaysBounceVertical = YES;
    
    streamTableView.bottomRefreshControl = [UIRefreshControl new];
    [streamTableView.bottomRefreshControl addTarget:self action:@selector(loadOldPosts) forControlEvents:UIControlEventValueChanged];
    
    
    
//    [streamCollectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    [streamCollectionView addSubview:topRefreshControl];
    streamCollectionView.alwaysBounceVertical = YES;
    
    streamCollectionView.bottomRefreshControl = [UIRefreshControl new];
    [streamCollectionView.bottomRefreshControl addTarget:self action:@selector(loadOldPostsCollection) forControlEvents:UIControlEventValueChanged];
    
    
    
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
    
    
    
    shuffelButton = [[UIButton alloc] initWithFrame:CGRectMake(topBar.bounds.size.width - 8 - 20, topBar.bounds.size.height - 5- 25, 20, 20)];
    [shuffelButton addTarget:self action:@selector(shuffleButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIImage* shuffelButtonImage = [[UIImage imageNamed:@"NewShuffle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [shuffelButton setImage:shuffelButtonImage forState:UIControlStateNormal];
    shuffelButton.tintColor = [UIColor whiteColor];
//    [shuffelButton setBackgroundImage:[UIImage imageNamed:@"NewShuffle"] forState:UIControlStateNormal];
    [topBar addSubview:shuffelButton];
    
    
//    [streamCollectionView layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark streamTableView


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 100;
    CGFloat aspectRatio;
    
    
    // NSString* reuseIdentifier = [NSString stringWithFormat:@"ImageCell%li", (long)indexPath.row];
    NSString* reuseIdentifier = @"ImageCell";
    StreamTableViewCell *cell = [streamTableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//    NSLog(@"cell %ld", (long)indexPath.row);
    
    if (indexPath.row == selectedRow) {
        cell.blur.alpha = 1;
    }
    else {
        cell.blur.alpha = 0;
    }
    
//    [cell prepareForReuse];
//    if(!cell){
//        cell = [[StreamTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
//    }
    
    NSMutableArray* postArray = [HPPostHandler sharedPostHandler].posts;
    NSInteger postNumberInTableView = indexPath.row;
    HPTumblrPost* post = (HPTumblrPost *)[postArray objectAtIndex:postNumberInTableView];
    
    
    
    NSURL *url = NULL;
    for (NSDictionary* photo in post.photos) {
        if ([photo[@"width"]integerValue] > self.view.bounds.size.width/3*2 && [photo[@"width"] integerValue]>self.view.bounds.size.width/3*2) {
            url = photo[@"url"];
            aspectRatio = streamTableView.bounds.size.width / [photo[@"width"] integerValue];
            cellHeight = [photo[@"height"] integerValue] * aspectRatio;
            break;
        }
    }
    if (url == NULL) {
        url = post.originalPhoto[@"url"];
    }
    
    cell.imageLoadingActivityIndicator.hidesWhenStopped = YES;
    [cell.imageLoadingActivityIndicator startAnimating];
    //[cell.cellImageView setImageWithURL:url placeholderImage:NULL];
    [cell.cellImageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:NULL
                                       success: ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                           //[cell.cellImageView setAlpha:0.0];
                                           //[streamTableView reloadData];
                                           [cell.cellImageView setImage:image];
                                           [cell.imageLoadingActivityIndicator stopAnimating];
                                           
                                           [cell.cellImageView setNeedsLayout];
                                           [cell.cellImageView layoutIfNeeded];
                                           [cell setNeedsLayout];
                                           [cell layoutIfNeeded];
                                           [streamTableView layoutIfNeeded];
                                           [streamTableView setNeedsLayout];
                                           
                                           /*[UIView animateWithDuration:0.25
                                            animations:^{
                                            cell.cellImageView.alpha = 1.0;
                                            }]*/
                                       }
                                       failure:NULL];
    cell.textview.text = post.caption;
    
    CGFloat textViewHeight = [cell.textview sizeThatFits:CGSizeMake(cell.textview.bounds.size.width, CGFLOAT_MAX)].height;
    CGFloat textViewTopMargin = 10;
    if(textViewHeight > (cellHeight - 2* textViewTopMargin)){
        cell.textViewHeightConstraint.constant = cellHeight - 2* textViewTopMargin;
    }else{
        cell.textViewHeightConstraint.constant = textViewHeight;
    }
    
    cell.imageHeightConstraint.constant = cellHeight;
    //cell.imageHeightConstraint.priority = 800;
    [cell.cellImageView setNeedsLayout];
    [cell.cellImageView layoutIfNeeded];
    [cell.textview setNeedsLayout];
    [cell.textview layoutIfNeeded];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    [streamTableView layoutIfNeeded];
    [streamTableView setNeedsLayout];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[HPPostHandler sharedPostHandler].posts count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    NSMutableArray* postArray = [HPPostHandler sharedPostHandler].posts;
    NSInteger postNumberInTableView = indexPath.row;
    HPTumblrPost* post = (HPTumblrPost *)[postArray objectAtIndex:postNumberInTableView];
    
    for (NSDictionary* photo in post.photos) {
        if ([photo[@"width"]integerValue] > self.view.bounds.size.width/3*2 && [photo[@"width"] integerValue]>self.view.bounds.size.width/3*2) {
            CGFloat aspectRatio = streamTableView.bounds.size.width / [photo[@"width"] integerValue];
            cellHeight = [photo[@"height"] integerValue] * aspectRatio;
            break;
        }
    }
    
    
    return cellHeight;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString* reuseIdentifier = @"ImageCell";
    StreamTableViewCell *cell = [streamTableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSLog(@"index %ld", selectedRow);
    
    if (selectedRow == indexPath.row) {
//        [cell hideBlur];
        selectedRow = -5;
    }
    else {
        
        if (selectedRow != -5) {
            
            NSUInteger row = selectedRow;
            selectedRow = indexPath.row;
            
            [streamTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        }
        else {
            selectedRow = indexPath.row;
        }
    }
    
    
    
    [streamTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
}



- (IBAction)switchLayout:(id)sender {
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"listInFeed"] == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"listInFeed"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"listInFeed"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%i", [[NSUserDefaults standardUserDefaults] boolForKey:@"listInFeed"]);
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"listInFeed"] == YES) {
        streamCollectionView.hidden = true;
        streamTableView.hidden = false;
        [streamTableView reloadData];
    }
    else {
        streamTableView.hidden = true;
        streamCollectionView.hidden = false;
        [streamCollectionView reloadData];
    }
}

/*
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
 */

- (void) loadNewPosts {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HPPostHandler sharedPostHandler] loadNewPosts];
        dispatch_async(dispatch_get_main_queue(), ^{
            [topRefreshControl endRefreshing];
            [streamTableView reloadData];
            [streamCollectionView reloadData];
        });
    });
}

- (void) loadOldPosts {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(!shuffel){
            [[HPPostHandler sharedPostHandler] addOldPosts:30 withRealAmount:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [streamTableView.bottomRefreshControl endRefreshing];
                [streamTableView reloadData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HPPostHandler sharedPostHandler] loadMoreShuffledPosts:30 completion:^{
                    NSLog(@"More Shuffled Posts loaded");
                    [streamTableView.bottomRefreshControl endRefreshing];
                    [streamTableView reloadData];
                }];
            });
        }
    });
}

- (void) shuffleButtonPressed {
    NSLog(@"Shuffle Button Pressed");
    //Scroll to top
    [streamTableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
    if(shuffel){
        shuffelButton.tintColor = [UIColor whiteColor];
        [[HPPostHandler sharedPostHandler] startSession];
        streamTableView.hidden = NO;
        [streamLoadingActivityIndicator stopAnimating];
        [streamTableView reloadData];
    }else{
        shuffelButton.tintColor = [UIColor colorWithRed:0 green:145.0/255.0 blue:247.0/255.0 alpha:1];
        [streamLoadingActivityIndicator startAnimating];
        streamTableView.hidden = YES;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*shuffelPost = [[HPPostHandler sharedPostHandler] shuffeledPost];
             dispatch_async(dispatch_get_main_queue(), ^{
             [self performSegueWithIdentifier:@"toTestShuffel" sender:self];
             });*/
            
            [[HPPostHandler sharedPostHandler] loadShuffledPosts:10 completion:^{
                NSLog(@"Completion Block");
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [streamTableView reloadData];
                    streamTableView.hidden = NO;
                    [streamLoadingActivityIndicator stopAnimating];
                });
            }];
        });
    }
    shuffel = !shuffel;
    
}





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
    return CGSizeMake(streamCollectionView.frame.size.width / 3, streamCollectionView.frame.size.width / 3);
}



- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
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


- (void) loadOldPostsCollection {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HPPostHandler sharedPostHandler] addOldPosts:30 withRealAmount:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [streamCollectionView.bottomRefreshControl endRefreshing];
            [streamCollectionView reloadData];
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
