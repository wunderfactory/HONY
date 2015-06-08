//
//  StreamTableViewCell.m
//  HONY
//
//  Created by Jan Willem Kothe on 02.06.15.
//  Copyright (c) 2015 Magnus Langanke. All rights reserved.
//

#import "StreamTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation StreamTableViewCell{
    
}
@synthesize cellImageView, textview;
@synthesize unblurredImage, blurredImage, imageBlurred;
@synthesize imageHeightConstraint, textViewHeightConstraint;
- (void)awakeFromNib {
    // Initialization code
    textview.hidden = YES;
    textview.backgroundColor = [UIColor clearColor];
    textview.textColor = [UIColor whiteColor];
    textview.text = @"";
    UITapGestureRecognizer* blurTapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTextHiddenStatus)];
    [self addGestureRecognizer:blurTapper];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)changeTextHiddenStatus{
    //Only show text, if the image has been downloaded already
    if(cellImageView.image){
        if(!unblurredImage){
            unblurredImage = cellImageView.image;
        }
        if(!blurredImage){
            blurredImage = [self blurImage:cellImageView.image];
        }
        if(imageBlurred){
            cellImageView.image = unblurredImage;
            textview.hidden = YES;
        }else{
            cellImageView.image = blurredImage;
            textview.hidden = NO;
        }
        imageBlurred = !imageBlurred;
    }else{
        //Prepare a blurred image for performance reasons
        if(!blurredImage){
            blurredImage = [self blurImage:cellImageView.image];
        }
    }
}

-(void)setText:(NSString *)postText{
    textview.text = postText;
    textview.font = [UIFont fontWithName:@"Raleway" size:17];
}

//From StackOverflow: http://stackoverflow.com/questions/17041669/creating-a-blurring-overlay-view

-(UIImage*)blurImage:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *blurResult = [filter valueForKey:kCIOutputImageKey];
    
    //Darken the image
    filter= [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:blurResult forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:0.2] forKey:@"inputBrightness"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

+(UIImage*) scaleIfNeeded:(CGImageRef)cgimg {
    bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
    if (isRetina) {
        return [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp];
    } else {
        return [UIImage imageWithCGImage:cgimg];
    }
}

-(void)prepareForReuse{
    cellImageView.image = nil;
    textview.text = @"";
    textview.hidden = YES;
    textview.scrollEnabled = NO;
    imageHeightConstraint.priority = 250;
    imageHeightConstraint.constant = 100;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
@end
