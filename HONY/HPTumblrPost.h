//
//  HOTumblrPost.h
//  HOPE
//
//  Created by Magnus Langanke on 29.05.14.
//  Copyright (c) 2014 Magnus Langanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPTumblrPost : NSObject
@property (nonatomic, strong, readwrite) NSArray* photos;
@property (nonatomic, strong, readwrite) NSDictionary* originalPhoto;
@property (nonatomic, strong, readwrite) NSString* caption;
@property (nonatomic, strong, readwrite) NSURL* postURL;
@property (nonatomic, strong, readwrite) NSURL* shortURL;
@property (nonatomic, strong, readwrite) NSDate* date;
@property (readwrite) NSInteger timestamp;


@end
