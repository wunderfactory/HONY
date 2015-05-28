//
//  ImageScrollViewController.m
//  ImageScroll
//
//  Created by Evgenii Neumerzhitckii on 19/05/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//
#define minimumSize 80

#define animateTime 0.5


#import "ImageScrollViewController.h"
#import "MBProgressHUD.h"
#import "DPWebConnector.h"
#import "HPPostHandler.h"

@interface ImageScrollViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (nonatomic) CGFloat lastZoomScale;

@end

@implementation ImageScrollViewController
@synthesize post, imageView, quoteView, quote, moreQuoteButton, fullQuoteShown, shuffel,shareButton, scrollView;

- (instancetype)initWithTumblrPost:(HPTumblrPost *)tumblrPost andRect:(CGRect)rect andIndex:(NSInteger) index{
    self = [super init];
    if (self) {
        post = tumblrPost;
        self.index = index;
        shuffel = NO;
        [self.view setFrame:rect];
    }
    return self;
}


- (void)viewDidLoad {
    self.scrollView.delegate = self;
    CGRect rect = self.view.bounds;
    
    UIButton* closebutton = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width-22-5, 5, 22, 22)];
    [closebutton setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    [closebutton addTarget:self action:@selector(closeFullscreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closebutton];
    
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 23, 18)];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(sharePost) forControlEvents:UIControlEventTouchUpInside];
    shareButton.hidden = YES;
    [self.view addSubview:shareButton];
    
    UIButton* shuffelButton = [[UIButton alloc] initWithFrame:CGRectMake(closebutton.frame.origin.x - 10 - 33, 5, 33, 22)];
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
    __block UIButton* currentShareButton = shareButton;
    __block ImageScrollViewController* blockSelf = self;
    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:post.originalPhoto[@"url"]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [currentView setImage:image];
        currentShareButton.hidden = NO;
        [blockSelf updateConstraints];
        [blockSelf updateZoom];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    if (shuffel) {
        UITapGestureRecognizer* nextShuffelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextShuffel)];
        nextShuffelTap.numberOfTapsRequired = 2;
        nextShuffelTap.numberOfTouchesRequired = 1;
        [scrollView addGestureRecognizer:nextShuffelTap];
    }
    // Hide & Show Gestures
    
    UISwipeGestureRecognizer *swipeDownHideText = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(minimizeQuoteView)];
    swipeDownHideText.direction = UISwipeGestureRecognizerDirectionDown;
    
    UISwipeGestureRecognizer *swipeUpShowText = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showComQuoteView)];
    swipeUpShowText.direction = UISwipeGestureRecognizerDirectionUp;
    
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minimizeQuoteView)];
    tapper.numberOfTapsRequired = 1;
    
    
    UISwipeGestureRecognizer* swippeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeFullscreen:)];
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


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:animated];
    [self updateZoom];
    [self updateConstraints];
}

// Update zoom scale and constraints
// It will also animate because willAnimateRotationToInterfaceOrientation
// is called from within an animation block
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
  [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];

  [self updateZoom];
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
  [self updateConstraints];
}

- (void) updateConstraints {
  float imageWidth = self.imageView.image.size.width;
  float imageHeight = self.imageView.image.size.height;

  float viewWidth = self.view.bounds.size.width;
  float viewHeight = self.view.bounds.size.height;

  // center image if it is smaller than screen
  float hPadding = (viewWidth - self.scrollView.zoomScale * imageWidth) / 2;
  if (hPadding < 0) hPadding = 0;

  float vPadding = (viewHeight - self.scrollView.zoomScale * imageHeight) / 2;
  if (vPadding < 0) vPadding = 0;

  self.constraintLeft.constant = hPadding;
  self.constraintRight.constant = hPadding;

  self.constraintTop.constant = vPadding;
  self.constraintBottom.constant = vPadding;
}

// Zoom to show as much image as possible unless image is smaller than screen
- (void) updateZoom {
  float minZoom = MIN(self.view.bounds.size.width / self.imageView.image.size.width,
                      self.view.bounds.size.height / self.imageView.image.size.height);

  if (minZoom > 1) minZoom = 1;

  self.scrollView.minimumZoomScale = minZoom;

  // Force scrollViewDidZoom fire if zoom did not change
  if (minZoom == self.lastZoomScale)
      minZoom += 0.000001;

  self.lastZoomScale = self.scrollView.zoomScale = minZoom;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


-(void)showComQuoteView {
    if (fullQuoteShown) {
        [self minimizeQuoteView];
    } else {
        fullQuoteShown = YES;
        moreQuoteButton.transform = CGAffineTransformMakeRotation(M_PI);
        if (quote.contentSize.height < self.view.frame.size.height / 2 - quote.frame.origin.y && quote.contentSize.height + quote.frame.origin.y > minimumSize) {
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
    [self updateZoom];
    [self updateConstraints];
    [self updateZoom];
    [self.scrollView scrollsToTop];
    [self presentViewController:controller animated:YES completion:nil];
}


-(void) nextShuffel {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    shareButton.hidden = YES;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        post = [[HPPostHandler sharedPostHandler] shuffeledPost];
        __block UIImageView* currentImageView = imageView;
        __block ImageScrollViewController* blockSelf = self;
        __block UIButton* currentShareButton = shareButton;
        dispatch_async(dispatch_get_main_queue(), ^{
            quote.text = post.caption;
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL: post.originalPhoto[@"url"]] placeholderImage:NULL success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [currentImageView setImage:image];
                [blockSelf updateConstraints];
                [blockSelf updateZoom];
                currentShareButton.hidden = NO;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"error");
            }];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (IBAction)closeFullscreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
