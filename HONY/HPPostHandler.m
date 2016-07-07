//
//  HOPostHandler.m
//  HOPE
//
//  Created by Magnus Langanke on 27.05.14.
//  Copyright (c) 2014 Magnus Langanke. All rights reserved.
//

#import "HPPostHandler.h"
#import "DPWebConnector.h"


static HPPostHandler* handler = NULL;
@implementation HPPostHandler

-(instancetype) initWithTumblrName:(NSString*)blogName {
    self = [super init];
    if (self) {
        self.blogName = blogName;
        self.posts = [NSMutableArray array];
        [self addOldPosts:0 withRealAmount:YES];
        
    }
    return self;
}
- (void) loadNewPosts {
    if([self hasConnectivity]){
        NSMutableArray* newPosts = [NSMutableArray array];
        int new0ffeset = 0;
        do {
            NSDictionary* rawPosts = [DPWebConnector synchronusConnectionWithURLString:[NSString stringWithFormat: @"http://api.tumblr.com/v2/blog/%@/posts?api_key=7ag2CJXOuxuW3vlVS5wQG6pYA6a2ZQcSCjzZsAp2pDbVwf3xEk&notes_info=false&filter=text&limit=10&offset=%i", self.blogName, new0ffeset]];
            if (![rawPosts[@"response"] isKindOfClass:[NSDictionary class]]) {
                return;
            } else {
                for (NSDictionary* post in rawPosts[@"response"][@"posts"]) {
                    HPTumblrPost* tPost = [[HPTumblrPost alloc] init];
                    tPost.caption = post[@"caption"];
                    tPost.shortURL = [NSURL URLWithString:post[@"short_url"]];
                    tPost.postURL = [NSURL URLWithString:post[@"post_url"]];
                    tPost.timestamp = [post[@"timestamp"] integerValue];
                    NSDictionary* photos = post[@"photos"][0];
                    if ([photos[@"original_size"]isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary* photoDict = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:photos[@"original_size"][@"width"],photos[@"original_size"][@"height"], [NSURL URLWithString:photos[@"original_size"][@"url"]], nil] forKeys:[NSArray arrayWithObjects:@"width", @"height",@"url", nil]];
                        tPost.originalPhoto = photoDict;
                    } else {
                        continue;
                    }
                    if ([photos[@"alt_sizes"]isKindOfClass:[NSArray class]]) {
                        NSMutableArray* altPhoto = [NSMutableArray array];
                        for (NSDictionary* photo in photos[@"alt_sizes"]) {
                            [altPhoto addObject:[[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:photo[@"width"],photo[@"height"], [NSURL URLWithString:photo[@"url"]], nil] forKeys:[NSArray arrayWithObjects:@"width", @"height",@"url", nil]]];
                        }
                        tPost.photos = altPhoto;
                    } else {
                        continue;
                    }
                    [newPosts addObject:tPost];
                }
            }
            new0ffeset += 10;
        } while ([(HPTumblrPost*)[newPosts lastObject] timestamp] > [(HPTumblrPost *)[self.posts firstObject] timestamp]);
        for (int i = 0; i<newPosts.count;i++) {
            if ([ (HPTumblrPost*) newPosts[i] timestamp] <= [(HPTumblrPost*)self.posts.firstObject timestamp]) {
                [newPosts removeObject:newPosts[i]];
            }
        }
        for (int i = (int)[newPosts count] - 1; i >=0; i--) {
            [self.posts insertObject:newPosts[i] atIndex:0];
        }
    }
    
}

-(void)addOldPosts:(int)amount withRealAmount:(BOOL) withRealAmount {
    if([self hasConnectivity]){
        if (amount == 0)
            amount =  30;
        if (self.totalPosts != 0 && self.totalPosts < self.offset + amount) {
            return;
        }
        NSDictionary* rawPosts = [DPWebConnector synchronusConnectionWithURLString:[NSString stringWithFormat: @"http://api.tumblr.com/v2/blog/%@/posts?api_key=7ag2CJXOuxuW3vlVS5wQG6pYA6a2ZQcSCjzZsAp2pDbVwf3xEk&notes_info=false&filter=text&limit=%i&offset=%i", self.blogName, amount,self.offset]];
        if (![rawPosts[@"response"] isKindOfClass:[NSDictionary class]]) {
            return;
        } else {
            self.totalPosts = [rawPosts[@"response"][@"blog"][@"posts"] integerValue];
            
            for (NSDictionary* post in rawPosts[@"response"][@"posts"]) {
                HPTumblrPost* tPost = [[HPTumblrPost alloc] init];
                tPost.caption = post[@"caption"];
                tPost.shortURL = [NSURL URLWithString:post[@"short_url"]];
                tPost.postURL = [NSURL URLWithString:post[@"post_url"]];
                tPost.timestamp = [post[@"timestamp"] integerValue];
                NSDictionary* photos = post[@"photos"][0];
                if ([photos[@"original_size"]isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary* photoDict = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:photos[@"original_size"][@"width"],photos[@"original_size"][@"height"], [NSURL URLWithString:photos[@"original_size"][@"url"]], nil] forKeys:[NSArray arrayWithObjects:@"width", @"height",@"url", nil]];
                    tPost.originalPhoto = photoDict;
                } else {
                    continue;
                }
                if ([photos[@"alt_sizes"]isKindOfClass:[NSArray class]]) {
                    NSMutableArray* altPhoto = [NSMutableArray array];
                    for (NSDictionary* photo in photos[@"alt_sizes"]) {
                        [altPhoto addObject:[[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:photo[@"width"],photo[@"height"], [NSURL URLWithString:photo[@"url"]], nil] forKeys:[NSArray arrayWithObjects:@"width", @"height",@"url", nil]]];
                    }
                    tPost.photos = altPhoto;
                } else {
                    continue;
                }
                [self.posts addObject:tPost];
            }
        }
        self.offset+= amount;
        if (withRealAmount) {
            self.realAmount += amount;
        }
        
        while (self.realAmount > self.posts.count) {
            [self addOldPosts:self.realAmount - self.posts.count withRealAmount:NO];
        }
    }
}

- (HPTumblrPost*) shuffeledPost {
    if([self hasConnectivity]){
        if (self.totalPosts == 0) {
            self.totalPosts = (int)[[DPWebConnector synchronusConnectionWithURLString:[NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/info?api_key=7ag2CJXOuxuW3vlVS5wQG6pYA6a2ZQcSCjzZsAp2pDbVwf3xEk", self.blogName]][@"response"][@"blog"][@"posts"] integerValue];
        }
        int offest = arc4random() % self.totalPosts;
        NSDictionary* rawPost = [DPWebConnector synchronusConnectionWithURLString:[NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/posts?api_key=7ag2CJXOuxuW3vlVS5wQG6pYA6a2ZQcSCjzZsAp2pDbVwf3xEk&notes_info=false&filter=text&limit=1&offset=%i",self.blogName,offest]];
        if (![rawPost[@"response"] isKindOfClass:[NSDictionary class]]) {
            return [self shuffeledPost];
        }
        NSDictionary* post = rawPost[@"response"][@"posts"][0];
        HPTumblrPost* tPost = [[HPTumblrPost alloc] init];
        tPost.caption = post[@"caption"];
        tPost.shortURL = [NSURL URLWithString:post[@"short_url"]];
        tPost.postURL = [NSURL URLWithString:post[@"post_url"]];
        tPost.timestamp = [post[@"timestamp"] integerValue];
        NSDictionary* photos = post[@"photos"][0];
        if ([photos[@"original_size"]isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary* photoDict = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:photos[@"original_size"][@"width"],photos[@"original_size"][@"height"], [NSURL URLWithString:photos[@"original_size"][@"url"]], nil] forKeys:[NSArray arrayWithObjects:@"width", @"height",@"url", nil]];
            tPost.originalPhoto = photoDict;
        } else {
            return [self shuffeledPost];
        }
        if ([photos[@"alt_sizes"]isKindOfClass:[NSArray class]]) {
            NSMutableArray* altPhoto = [NSMutableArray array];
            for (NSDictionary* photo in photos[@"alt_sizes"]) {
                [altPhoto addObject:[[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:photo[@"width"],photo[@"height"], [NSURL URLWithString:photo[@"url"]], nil] forKeys:[NSArray arrayWithObjects:@"width", @"height",@"url", nil]]];
            }
            tPost.photos = altPhoto;
        } else {
            return [self shuffeledPost];
        }
        return tPost;
    }else{
        return nil;
    }
}

- (void) startSession {
    handler = [[HPPostHandler alloc] initWithTumblrName:@"humansofnewyork.com"];
}

+ (instancetype)sharedPostHandler {
    if (handler == NULL) {
        handler = [[HPPostHandler alloc] initWithTumblrName:@"humansofnewyork.com"];
    }
    return handler;
}

-(void)loadShuffledPosts: (int) amount completion:(void (^)())completion{
    self.posts = [NSMutableArray array];
    for(int i=0; i<amount; i++){
        
        [self.posts addObject:[self shuffeledPost]];
    }
    completion();
}

-(void)loadMoreShuffledPosts:(int)amount completion:(void (^)())completion{
    NSLog(@"more Shuffled Posts");
    completion();
}



//From Stack Overflow:
/*
 Connectivity testing code pulled from Apple's Network Example: http://developer.apple.com/library/ios/#samplecode/Network
 */
-(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

@end
