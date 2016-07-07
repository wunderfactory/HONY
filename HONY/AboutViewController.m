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
#import <YYText/YYText.h>

#import "UIScrollView+APParallaxHeader.h"

@import SafariServices;



#define distanceButtons 14.0f


@interface AboutViewController () <MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet YYTextView *textView;

@end

@implementation AboutViewController
@synthesize topBar, honyLabel, bottomBar, infoText;
@synthesize joinButton, websiteButton, facebookButton, textView;

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
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    
    
    
    UIFont *bebasNeue = [UIFont fontWithName:@"BebasNeue" size:32.0];
    
    //UIColor *honyBlue = [UIColor colorWithRed:59.0/255.0 green:88.0/255.0 blue:152.0/255.0 alpha:1.0];
    
    
    // Setup Top Bar
    
    //UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    //UILabel *honyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 30)];
    honyLabel.text = @"ABOUT US";
    honyLabel.textAlignment = NSTextAlignmentCenter;
    honyLabel.textColor = [UIColor whiteColor];
    honyLabel.font = bebasNeue;
    [topBar addSubview:honyLabel];
    topBar.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0.75];
    topBar.backgroundColor = [UIColor blackColor];
    
    //Add Menu Item to Top Bar
    SWRevealViewController* revealViewController = self.revealViewController;
    if(revealViewController){
        UIButton* menuItem = [[UIButton alloc] initWithFrame:CGRectMake(5, topBar.bounds.size.height - 5- 35, 40, 40)];
        [menuItem addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents: UIControlEventTouchDown];
        //[menuItem setTitle:@"Menu" forState:UIControlStateNormal];
        [menuItem setImage:[UIImage imageNamed:@"MenuIcon"] forState:UIControlStateNormal];
        [topBar addSubview:menuItem];
    }
    
    
    
    
    // Text View & Buttons
    
    
    NSString *text = @"This app has been created by more than 30 followers of HONY from all over the world. Starting with a simple comment by Patrick on one of the photos posted on the HONY Facebook page, dozens of skilled and creative young people from all over the world and the wunderfactory team have come together to bring this idea to the AppStore. It is a project that aims to give back to what is one of the most fascinating communities on the web.\n\nThis application has been developed to support the HONY project founded and managed by Brandon Stanton. We are supporting his project in any way possible and everything displayed here roots back to the original HONY project.\n\nPlease consider donating to the many charity projects that Brandon has already launched to help many people in need.\n\nMoreover, feel free to visit our website, like our Facebook page and join our team.\n\n\nJoin Us!\n\n";
    
    NSRange patrick = [text rangeOfString:@"Patrick"];
    NSRange wunderfactory = [text rangeOfString:@"wunderfactory"];
    NSRange join = [text rangeOfString:@"Join Us!"];
    
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:text];
    textString.yy_font = [UIFont fontWithName:@"Open Sans" size:13];
    textString.yy_color = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    textString.yy_alignment = NSTextAlignmentJustified;
    [textString yy_setColor:[UIColor colorWithRed:0.97 green:0.41 blue:0.15 alpha:1.00] range:patrick];
    [textString yy_setColor:[UIColor colorWithRed:0.97 green:0.41 blue:0.15 alpha:1.00] range:wunderfactory];
    [textString yy_setColor:[UIColor colorWithRed:0.97 green:0.41 blue:0.15 alpha:1.00] range:join];
    
    [textString yy_setTextHighlightRange:patrick color:[UIColor colorWithRed:0.97 green:0.41 blue:0.15 alpha:1.00] backgroundColor:[UIColor clearColor] tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        
        NSURL *URL = [NSURL URLWithString:@"https://www.facebook.com/patrickhaede"];
        
        if (URL) {
            if ([SFSafariViewController class] != nil) {
                SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];
                sfvc.delegate = self;
                [self presentViewController:sfvc animated:YES completion:nil];
            } else {
                if (![[UIApplication sharedApplication] openURL:URL]) {
                    NSLog(@"%@%@",@"Failed to open url:",[URL description]);
                }
            }
        } else {
            // will have a nice alert displaying soon.
        }
        
    }];
    
    [textString yy_setTextHighlightRange:wunderfactory color:[UIColor colorWithRed:0.97 green:0.41 blue:0.15 alpha:1.00] backgroundColor:[UIColor clearColor] tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        
        NSURL *URL = [NSURL URLWithString:@"http://www.wunderfactory.de"];
        
        if (URL) {
            if ([SFSafariViewController class] != nil) {
                SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];
                sfvc.delegate = self;
                [self presentViewController:sfvc animated:YES completion:nil];
            } else {
                if (![[UIApplication sharedApplication] openURL:URL]) {
                    NSLog(@"%@%@",@"Failed to open url:",[URL description]);
                }
            }
        } else {
            // will have a nice alert displaying soon.
        }
    }];
    
    [textString yy_setTextHighlightRange:join color:[UIColor colorWithRed:0.97 green:0.41 blue:0.15 alpha:1.00] backgroundColor:[UIColor clearColor] tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            
            [mailCont setSubject:@"Join HONY"];
            [mailCont setToRecipients:[NSArray arrayWithObject:@"info@wunderfactory.de"]];
            
            [self presentViewController:mailCont animated:YES completion:nil];
        }
    }];
    
    
    textView.attributedText = textString;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.selectable = NO;
    textView.backgroundColor = [UIColor clearColor];
    
    [_scrollView addParallaxWithImage:[UIImage imageNamed:@"coverphoto1.png"] andHeight:[UIImage imageNamed:@"coverphoto1.png"].size.height];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + 90);
    _scrollView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    
    /*
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(facebookButton.frame.size.width + facebookButton.frame.origin.x + distanceButtons, 20, 40, 25)];
    [helpButton setTitle:@"faq" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButton) forControlEvents:UIControlEventTouchUpInside];
    helpButton.titleLabel.font = raleway;
    helpButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    helpButton.layer.borderWidth = 1.0f;
    helpButton.layer.cornerRadius = 5;
    */
    
    [bottomBar addSubview:joinButton];
    [bottomBar addSubview:websiteButton];
    [bottomBar addSubview:facebookButton];
}



- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinButton:(id)sender {
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@"I want to join the HONY App team"];
    [mailViewController setMessageBody:@"" isHTML:NO];
    [mailViewController setToRecipients:@[@"honyapp@gmail.com"]];
    
    [self presentViewController:mailViewController animated:YES completion:NULL];
}

- (IBAction)websiteButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://honyapp.com"]];
}

- (IBAction)facebookButton:(id)sender {
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
