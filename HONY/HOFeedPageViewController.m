//
//  HOFeedPageViewController.m
//  HONY
//
//  Created by Magnus Langanke on 27.06.14.
//  Copyright (c) 2014 Magnus Langanke. All rights reserved.
//

#import "HOFeedPageViewController.h"

@interface HOFeedPageViewController ()

@end

@implementation HOFeedPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    ImageScrollViewController* imageView = [self.storyboard instantiateViewControllerWithIdentifier:@"scrollImageViewController"];
    imageView.post = [[HPPostHandler sharedPostHandler].posts objectAtIndex:self.startingIndex];
    imageView.index = self.startingIndex;
    imageView.view.frame = self.view.frame;
    [self setViewControllers:@[imageView] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
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

-(UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    ImageScrollViewController* imageViewController = (ImageScrollViewController*) viewController;
    if (imageViewController.index >= [HPPostHandler sharedPostHandler].posts.count - 1) {
        [[HPPostHandler sharedPostHandler] addOldPosts:9 withRealAmount:YES];
    }
    ImageScrollViewController* nextImageView = [self.storyboard instantiateViewControllerWithIdentifier:@"scrollImageViewController"];
    nextImageView.post = [[HPPostHandler sharedPostHandler].posts objectAtIndex:imageViewController.index + 1];
    nextImageView.view.frame = self.view.frame;
    nextImageView.index = imageViewController.index + 1;
    return nextImageView;
    
}
-(UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    ImageScrollViewController* imageViewController = (ImageScrollViewController*) viewController;
    if (imageViewController.index == 0) {
        return NULL;
    }
    ImageScrollViewController* previousImageView = [self.storyboard instantiateViewControllerWithIdentifier:@"scrollImageViewController"];
    previousImageView.post = [[HPPostHandler sharedPostHandler].posts objectAtIndex:imageViewController.index - 1];
    previousImageView.view.frame = self.view.frame;
    previousImageView.index = imageViewController.index - 1;
    return previousImageView;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
