//
//  AboutViewController.m
//  HONY
//
//  Created by David Pflugpeil on 29.05.14.
//  Copyright (c) 2014 Magnus Langanke & David Pflugpeil. All rights reserved.
//

#import "AboutViewController.h"

#import "NewsViewController.h"

#import <MessageUI/MessageUI.h>

#import "SWRevealViewController.h"



#define distanceButtons 14.0f


@interface AboutViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation AboutViewController

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
    
    UIColor *honyBlue = [UIColor colorWithRed:59.0/255.0 green:88.0/255.0 blue:152.0/255.0 alpha:1.0];
    
    
    // Setup Top Bar
    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    UILabel *honyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 30)];
    honyLabel.text = @"HUMANS OF NEW YORK";
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
    
    
    // Blue area
    
    UIView *blueAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.frame.size.height, self.view.bounds.size.width, 185)];
    blueAreaView.backgroundColor = honyBlue;
    
    // Label
    UILabel *abouthonyLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, self.view.bounds.size.width, 40)];
    abouthonyLabel.textAlignment = NSTextAlignmentLeft;
    abouthonyLabel.font = bebasNeue;
    abouthonyLabel.textColor = [UIColor whiteColor];
    
    NSMutableAttributedString *abouthonyString = [[NSMutableAttributedString alloc] initWithString:@"ABOUT US"];
    [abouthonyString addAttribute: NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[abouthonyString length]
                            }];
    abouthonyLabel.attributedText = abouthonyString;
    
    
    UIImageView *presentationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 66, self.view.bounds.size.width, 119)];
    presentationImage.image = [UIImage imageNamed:@"coverphoto1.png"];
    presentationImage.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
    
    // Text View & Buttons
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, blueAreaView.frame.origin.y + blueAreaView.frame.size.height, self.view.bounds.size.width, self.view.frame.size.height -(blueAreaView.frame.origin.y + blueAreaView.frame.size.height + 60 + self.tabBarController.tabBar.frame.size.height))];
    textView.backgroundColor = [UIColor whiteColor];
    
    UITextView *infoText = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, textView.frame.size.height)];
    infoText.selectable = NO;
    infoText.editable = NO;
    infoText.userInteractionEnabled = YES;
    infoText.scrollEnabled = YES;
    infoText.font = raleway;
    infoText.text = @"This app has been created by more than 30 followers of HONY from all over the world. Starting with a simple comment on one of the photos posted on the HONY Facebook page, dozens of skilled and creative persons have come together to make this idea come true and to give this app back to what is from our perspective the most amazing blog and community on the web.\n\nThis app has been developed to support the HONY project founded and managed by Brandon Stanton. We are supporting his project in any kind and everything displayed here goes back to the original HONY project.\n\nFeel free to visit our website, like our Facebook page and join our team.";
    
    
    
    
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height -60, self.view.frame.size.width, 60)];
    bottomBar.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0.75];
    bottomBar.backgroundColor = [UIColor blackColor];
    
    
    
    
    UIButton *joinButton = [[UIButton alloc] initWithFrame:CGRectMake(distanceButtons, 20, 60, 25)];
    [joinButton setTitle:@"join us" forState:UIControlStateNormal];
    [joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinButton addTarget:self action:@selector(joinButton) forControlEvents:UIControlEventTouchUpInside];
    joinButton.titleLabel.font = raleway;
    joinButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    joinButton.layer.borderWidth = 1.0f;
    joinButton.layer.cornerRadius = 5;
    [joinButton.layer setMasksToBounds:YES];
    
    
    UIButton *websiteButtom = [[UIButton alloc] initWithFrame:CGRectMake(joinButton.frame.size.width + joinButton.frame.origin.x + distanceButtons, 20, 70, 25)];
    [websiteButtom setTitle:@"website" forState:UIControlStateNormal];
    [websiteButtom addTarget:self action:@selector(websiteButton) forControlEvents:UIControlEventTouchUpInside];
    [websiteButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    websiteButtom.titleLabel.font = raleway;
    websiteButtom.titleLabel.font = raleway;
    websiteButtom.layer.borderColor = [[UIColor whiteColor] CGColor];
    websiteButtom.layer.borderWidth = 1.0f;
    websiteButtom.layer.cornerRadius = 5;
    
    
    UIButton *facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(websiteButtom.frame.size.width + websiteButtom.frame.origin.x + distanceButtons, 20, 80, 25)];
    [facebookButton setTitle:@" facebook " forState:UIControlStateNormal];
    [facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(facebookButton) forControlEvents:UIControlEventTouchUpInside];
    facebookButton.titleLabel.font = raleway;
    facebookButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    facebookButton.layer.borderWidth = 1.0f;
    facebookButton.layer.cornerRadius = 5;
    
    
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(facebookButton.frame.size.width + facebookButton.frame.origin.x + distanceButtons, 20, 40, 25)];
    [helpButton setTitle:@"faq" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButton) forControlEvents:UIControlEventTouchUpInside];
    helpButton.titleLabel.font = raleway;
    helpButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    helpButton.layer.borderWidth = 1.0f;
    helpButton.layer.cornerRadius = 5;
    
    
    [bottomBar addSubview:joinButton];
    [bottomBar addSubview:websiteButtom];
    [bottomBar addSubview:facebookButton];
    [bottomBar addSubview:helpButton];
    
    [textView addSubview:infoText];
    
    [blueAreaView addSubview:presentationImage];
    [blueAreaView addSubview:abouthonyLabel];
    
    [self.view addSubview:topBar];
    [self.view addSubview:blueAreaView];
    [self.view addSubview:textView];
    [self.view addSubview:bottomBar];
}



- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)joinButton
{
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@"I want to join the HONY App team"];
    [mailViewController setMessageBody:@"" isHTML:NO];
    [mailViewController setToRecipients:@[@"honyapp@gmail.com"]];
    
    [self presentViewController:mailViewController animated:YES completion:NULL];
}


- (void)websiteButton
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://honyapp.com"]];
}


- (void)facebookButton
{
    BOOL facebookInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb:"]];
    
    if (facebookInstalled) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/889864191030242"]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/honyapp"]];
    }
}


- (void)helpButton
{
    [self performSegueWithIdentifier:@"aboutViewToNewsView" sender:nil];
}





- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *titleAlertView;
    NSString *messageAlertView;
    
    
    switch (result) {
        case MFMailComposeResultSent:
            titleAlertView = @"Mail was sent successfully";
            messageAlertView = @"Thank's for your mail!\nWe will answer your mail as soon, as we can.";
            break;
            
        case MFMailComposeResultFailed:
            titleAlertView = @"There was an error sending your mail";
            messageAlertView = @"Please try to send your mail again.";
            break;
            
        default:
            titleAlertView = @"Cancel";
            messageAlertView = @"";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIAlertView *reservierenMailAlertView = [[UIAlertView alloc] initWithTitle:titleAlertView message:messageAlertView delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [reservierenMailAlertView show];
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