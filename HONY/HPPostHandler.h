//
//  HOPostHandler.h
//  HOPE
//
//  Created by Magnus Langanke on 27.05.14.
//  Copyright (c) 2014 Magnus Langanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPTumblrPost.h"

@interface HPPostHandler : NSObject

-(instancetype) initWithTumblrName:(NSString*)blogName;
@property(nonatomic, strong) NSString* blogName;
@property (strong, nonatomic) NSMutableArray* posts;
@property () int totalPosts;
@property () int offset;
@property () int realAmount;
+ (instancetype)sharedPostHandler;
- (void) startSession;
- (void)addOldPosts:(int)amount withRealAmount:(BOOL) withRealAmount;
- (void)loadNewPosts;
- (HPTumblrPost*)shuffeledPost;
-(void)loadShuffledPosts: (int) amount;
-(void)loadMoreShuffledPosts: (int)amount;
@end
