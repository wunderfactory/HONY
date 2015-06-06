//
//  HONYViewController.m
//  HONY
//
//  Created by David Pflugpeil on 27.05.14.
//  Copyright (c) 2014 Magnus Langanke & David Pflugpeil. All rights reserved.
//

#import "HONYViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "SWRevealViewController.h"

#define distanceButtons 35.0f

@interface HONYViewController ()

@end

@implementation HONYViewController
@synthesize topBar, honyLabel, infoText, bottomBar;

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
    // Do any additional setup after loading the view.
    
    
    UIFont *bebasNeue = [UIFont fontWithName:@"BebasNeue" size:32.0];
    UIFont *raleway = [UIFont fontWithName:@"Raleway-Regular" size:17.0];
    
   // UIColor *honyBlue = [UIColor colorWithRed:59.0/255.0 green:88.0/255.0 blue:152.0/255.0 alpha:1.0];
    
    
    // Setup Top Bar
    honyLabel.text = @"ABOUT HONY";
    honyLabel.textAlignment = NSTextAlignmentCenter;
    honyLabel.textColor = [UIColor whiteColor];
    honyLabel.font = bebasNeue;
    [topBar addSubview:honyLabel];
    topBar.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0.75];
    topBar.backgroundColor = [UIColor blackColor];
    
    //Add Menu Item to Top Bar
    SWRevealViewController* revealViewController = self.revealViewController;
    if(revealViewController){
        UIButton* menuItem = [[UIButton alloc] initWithFrame:CGRectMake(5, topBar.bounds.size.height - 5- 25, 20, 20)];
        [menuItem addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents: UIControlEventTouchDown];
        //[menuItem setTitle:@"Menu" forState:UIControlStateNormal];
        [menuItem setImage:[UIImage imageNamed:@"MenuIcon"] forState:UIControlStateNormal];
        [topBar addSubview:menuItem];
    }
    
    
    
    // Text View & Buttons
    infoText.selectable = NO;
    infoText.editable = NO;
    infoText.userInteractionEnabled = YES;
    infoText.scrollEnabled = YES;
    infoText.font = raleway;
    infoText.text = @"Brandon Stanton started HONY in the summer of 2010 with the idea of building an exhaustive catalogue of New York City’s inhabitants. He set out to photograph and map more than 10.000 people. Collecting quotes and short stories from the persons he met on the streets of New York he has created one of the most colourful and vibrant blogs on the web. His book has become a #1 NYT bestseller and HONY now has millions of followers around the globe.";
    
    //Bottom Bar Setup
    bottomBar.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0.75];
    bottomBar.backgroundColor = [UIColor blackColor];
    
    
    
    UIButton *facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(distanceButtons, 20, 22, 22)];
    [facebookButton setBackgroundImage:[UIImage imageNamed:@"fb"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(openFacebook) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tumblrButtom = [[UIButton alloc] initWithFrame:CGRectMake(facebookButton.frame.size.width + facebookButton.frame.origin.x + distanceButtons, 20, 22, 22)];
    [tumblrButtom setBackgroundImage:[UIImage imageNamed:@"tumblr"] forState:UIControlStateNormal];
    [tumblrButtom addTarget:self action:@selector(openTumblr) forControlEvents:UIControlEventTouchUpInside];

    UIButton *twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(tumblrButtom.frame.size.width + tumblrButtom.frame.origin.x + distanceButtons, 20, 22, 22)];
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(openTwitter) forControlEvents:UIControlEventTouchUpInside];

    UIButton *instaButton = [[UIButton alloc] initWithFrame:CGRectMake(twitterButton.frame.size.width + twitterButton.frame.origin.x + distanceButtons, 20, 22, 22)];
    [instaButton setBackgroundImage:[UIImage imageNamed:@"insta"] forState:UIControlStateNormal];
    [instaButton addTarget:self action:@selector(openInsta) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *amazonButton = [[UIButton alloc] initWithFrame:CGRectMake(instaButton.frame.size.width + instaButton.frame.origin.x + distanceButtons, 20, 22, 22)];
    [amazonButton setBackgroundImage:[UIImage imageNamed:@"amazon"] forState:UIControlStateNormal];
    [amazonButton addTarget:self action:@selector(openAmazon) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Add subviews
    [bottomBar addSubview:facebookButton];
    [bottomBar addSubview:tumblrButtom];
    [bottomBar addSubview:twitterButton];
    [bottomBar addSubview:instaButton];
    [bottomBar addSubview:amazonButton];
}



- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)openFacebook
{
    BOOL facebookInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb:"]];
    
    if (facebookInstalled) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/102099916530784"]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/humansofnewyork"]];
    }
}


- (void)openAmazon
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.amazon.de/Humans-New-York-Brandon-Stanton/dp/1250038820/ref=sr_1_1?ie=UTF8&qid=1401289564&sr=8-1&keywords=humans+of+new+york"]];
}

-(void)openTwitter {
    NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=humansofny"];
    if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
        [[UIApplication sharedApplication] openURL:twitterURL];
    } else {
        NSURL *httpTwitterURL = [NSURL URLWithString:@"https://twitter.com/humansofny"];
        [[UIApplication sharedApplication] openURL:httpTwitterURL];
    }
    
}

-(void)openTumblr {
    NSURL *tumblrURL = [NSURL URLWithString:@"tumblr://x-callback-url/blog?blogName=humansofnewyork"];
    if ([[UIApplication sharedApplication] canOpenURL:tumblrURL]) {
        [[UIApplication sharedApplication] openURL:tumblrURL];
    } else {
        NSURL *httpTumblrURL = [NSURL URLWithString:@"http://humansofnewyork.com"];
        [[UIApplication sharedApplication] openURL:httpTumblrURL];
    }
    
}

-(void) openInsta {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=humansofny"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    } else {
        NSURL *httpInstagramURL = [NSURL URLWithString:@"http://instagram.com/humansofny"];
        [[UIApplication sharedApplication] openURL:httpInstagramURL];
    }
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


@end
