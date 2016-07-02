//
//  HOFullscreenViewController.m
//  HONY
//
//  Created by Magnus Langanke on 26.05.14.
//  Copyright (c) 2014 Magnus Langanke & David Pflugpeil. All rights reserved.
//



// !!! Change this number to change the height for the qoute view // Original was 120

#define minimumSize 80

#define animateTime 0.5


#import "HOFullscreenViewController.h"
#import "MBProgressHUD.h"
#import "DPWebConnector.h"
#import "HPPostHandler.h"

@interface HOFullscreenViewController ()



@end

@implementation HOFullscreenViewController
@synthesize post, imageView, quoteView, quote, moreQuoteButton, fullQuoteShown, scroll, totalPosts, shuffel,shareButton;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)closeFullscreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [self centerScrollViewContents];
    CGRect scrollViewFrame = scroll.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / scroll.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / scroll.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    scroll.minimumZoomScale = minScale;
    scroll.maximumZoomScale = 1.0f;
    [self.scroll setZoomScale:minScale animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    scroll.backgroundColor = [UIColor blackColor];
    scroll.delegate = self;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [scroll addGestureRecognizer:doubleTapRecognizer];
    
    imageView = [[UIImageView alloc] init];
    [scroll addSubview:imageView];
    [self.view addSubview:scroll];
    
    

    UIButton* closebutton = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width-22-5, 5, 22, 22)];
    [closebutton setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    [closebutton addTarget:self action:@selector(closeFullscreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closebutton];
    
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 23, 18)];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(sharePost) forControlEvents:UIControlEventTouchUpInside];
    shareButton.hidden = YES;
    [self.view addSubview:shareButton];
    
    UIButton* shuffelButton = [[UIButton alloc] initWithFrame:CGRectMake(closebutton.frame.origin.x - 10 - 33, 5, 28, 28)];
    [shuffelButton setBackgroundImage:[UIImage imageNamed:@"reshuffel"] forState:UIControlStateNormal];
    [shuffelButton addTarget:self action:@selector(nextShuffel) forControlEvents:UIControlEventTouchUpInside];
    shuffelButton.hidden = !shuffel;
    [self.view addSubview:shuffelButton];
    
    quoteView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height - minimumSize, rect.size.width, rect.size.height)];
    quoteView.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0.75];
    
    moreQuoteButton = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width/2-32, 5, 50, 30)];
    [moreQuoteButton setBackgroundImage:[UIImage imageNamed:@"Up"] forState:UIControlStateNormal];
    [moreQuoteButton addTarget:self action:@selector(showComQuoteView) forControlEvents:UIControlEventTouchUpInside];
    [quoteView addSubview: moreQuoteButton];
    
    quote = [[UITextView alloc] initWithFrame:CGRectMake(10, moreQuoteButton.frame.size.height, quoteView.frame.size.width - 25, minimumSize - moreQuoteButton.frame.size.height)];
    quote.text = post.caption;
    quote.font = [UIFont fontWithName:@"BebasNeue" size:18];
    quote.editable = NO;
    quote.selectable = NO;
    quote.textColor = [UIColor whiteColor];
    quote.backgroundColor = [UIColor colorWithRed:26/255.0 green:33/255.0 blue:41/255.0 alpha:0];
    [quoteView addSubview:quote];
    [self.view addSubview:quoteView];
    __block UIImageView* currentView = imageView;
    __block UIScrollView* currentScrollView = scroll;
    __block UIButton* currentShareButton = shareButton;
    __block HOFullscreenViewController* blockSelf = self;
    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:post.originalPhoto[@"url"]] placeholderImage:NULL success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        currentView.frame = CGRectMake(currentView.frame.origin.x, currentView.frame.origin.y, image.size.width, image.size.height);
        [currentView setImage:image];
        currentScrollView.contentSize = image.size;
        CGRect scrollViewFrame = currentScrollView.frame;
        CGFloat scaleWidth = scrollViewFrame.size.width / currentScrollView.contentSize.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / currentScrollView.contentSize.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        currentScrollView.minimumZoomScale = minScale;
        currentScrollView.maximumZoomScale = 1.0f;
        currentScrollView.zoomScale = minScale;
        currentShareButton.hidden = NO;
        [blockSelf centerScrollViewContents];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error");
    }];
    if (shuffel) {
        UITapGestureRecognizer* nextShuffelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextShuffel)];
        nextShuffelTap.numberOfTapsRequired = 2;
        nextShuffelTap.numberOfTouchesRequired = 1;
        [scroll addGestureRecognizer:nextShuffelTap];
    }
    // Hide & Show Gestures
    
    UISwipeGestureRecognizer *swipeDownHideText = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(minimizeQuoteView)];
    swipeDownHideText.delegate = self;
    swipeDownHideText.direction = UISwipeGestureRecognizerDirectionDown;
    
    UISwipeGestureRecognizer *swipeUpShowText = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showComQuoteView)];
    swipeUpShowText.delegate = self;
    swipeUpShowText.direction = UISwipeGestureRecognizerDirectionUp;
    
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minimizeQuoteView)];
    tapper.numberOfTapsRequired = 1;
    
    
    UISwipeGestureRecognizer* swippeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeFullscreen:)];
    swippeDown.delegate = self;
    swippeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    
    
    [quoteView addGestureRecognizer:swipeDownHideText];
    [quoteView addGestureRecognizer:swipeUpShowText];
    
    [self.view addGestureRecognizer:swipeUpShowText];
    [self.view addGestureRecognizer:tapper];
    [self.view addGestureRecognizer:swippeDown];
    [self setNeedsStatusBarAppearanceUpdate];
    fullQuoteShown = NO;
    // Do any additional setup after loading the view.
    
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scroll.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    if (scroll.zoomScale == scroll.maximumZoomScale) {
        [self.scroll setZoomScale:scroll.minimumZoomScale animated:YES];
    } else {
        CGPoint pointInView = [recognizer locationInView:self.imageView];
    
        CGFloat newZoomScale = self.scroll.zoomScale * 1.5f;
        newZoomScale = MIN(newZoomScale, self.scroll.maximumZoomScale);
    
        CGSize scrollViewSize = self.scroll.bounds.size;
    
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w / 2.0f);
        CGFloat y = pointInView.y - (h / 2.0f);
    
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
        [self.scroll zoomToRect:rectToZoomTo animated:YES];
    }
}
-(void)showComQuoteView {
    if (fullQuoteShown) {
        [self minimizeQuoteView];
    } else {
        fullQuoteShown = YES;
        moreQuoteButton.transform = CGAffineTransformMakeRotation(M_PI);
        if (quote.contentSize.height < self.view.frame.size.height / 2 - quote.frame.origin.y) {
            [UIView animateWithDuration:animateTime animations:^{
                quoteView.frame = CGRectMake(0, self.view.frame.size.height - (quote.frame.origin.y + quote.contentSize.height), quoteView.frame.size.width, quote.frame.origin.y + quote.contentSize.height);
                quote.frame = CGRectMake(quote.frame.origin.x, quote.frame.origin.y, quote.frame.size.width, quoteView.frame.size.height - quote.frame.origin.y);
            }];
        } else {
            [UIView animateWithDuration:animateTime animations:^{
                quoteView.frame = CGRectMake(0, self.view.frame.size.height/2, quoteView.frame.size.width, self.view.frame.size.height/2);
                quote.frame = CGRectMake(quote.frame.origin.x, quote.frame.origin.y, quote.frame.size.width, quoteView.frame.size.height - quote.frame.origin.y);
            }];
        }
    }
}

-(void) minimizeQuoteView {
    fullQuoteShown = NO;
    moreQuoteButton.transform = CGAffineTransformMakeRotation(M_PI * 2);
    [UIView animateWithDuration:animateTime animations:^{
        quoteView.frame = CGRectMake(0, self.view.frame.size.height - minimumSize, quoteView.frame.size.width, minimumSize);
        quote.frame = CGRectMake(quote.frame.origin.x, quote.frame.origin.y, quote.frame.size.width, minimumSize-moreQuoteButton.frame.size.height);
    }];
}

- (void)sharePost {
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:@[post.caption, post.shortURL, imageView.image] applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) nextShuffel {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    shareButton.hidden = YES;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        post = [[HPPostHandler sharedPostHandler] shuffeledPost];
        __block UIImageView* currentImageView = imageView;
        __block UIScrollView* currentScrollView = scroll;
        __block HOFullscreenViewController* blockSelf = self;
        __block UIButton* currentShareButton = shareButton;
        dispatch_async(dispatch_get_main_queue(), ^{
            quote.text = post.caption;
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL: post.originalPhoto[@"url"]] placeholderImage:NULL success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                currentImageView.frame = CGRectMake(currentImageView.frame.origin.x, currentImageView.frame.origin.y, image.size.width, image.size.height);
                [currentImageView setImage:image];
                currentScrollView.contentSize = image.size;
                CGRect scrollViewFrame = currentScrollView.frame;
                CGFloat scaleWidth = scrollViewFrame.size.width / currentScrollView.contentSize.width;
                CGFloat scaleHeight = scrollViewFrame.size.height / currentScrollView.contentSize.height;
                CGFloat minScale = MIN(scaleWidth, scaleHeight);
                currentScrollView.minimumZoomScale = minScale;
                currentScrollView.maximumZoomScale = 1.0f;
                currentScrollView.zoomScale = minScale;
                [blockSelf centerScrollViewContents];
                currentShareButton.hidden = NO;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"error");
            }];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}
@end
