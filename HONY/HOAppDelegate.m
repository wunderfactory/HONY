//
//  HOAppDelegate.m
//  HONY
//
//  Created by Magnus Langanke on 26.05.14.
//  Copyright (c) 2014 Magnus Langanke & David Pflugpeil. All rights reserved.
//

#import "HOAppDelegate.h"
#import "DPWebConnector.h"

@interface HOAppDelegate ()

@property (strong, nonatomic) NSString *deviceTokenString;

@end


@implementation HOAppDelegate

@synthesize deviceTokenString;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Setting up Push Notification

    //TBD: This does not work in iOS 8 & later.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    //[[UIApplication sharedApplication] registerUserNotificationSettings:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    
    return YES;
}





// Push Notification

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    deviceTokenString = [[[deviceToken description]
                          stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSURL *bounceBirdServerURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://lab.wunderfactory.de/controller/push/insert_new_ud_id.php?ud_id=%@", deviceTokenString]];
    
    
    NSMutableURLRequest *bounceBirdServerRequest = [[NSMutableURLRequest alloc] initWithURL:bounceBirdServerURL];
    [bounceBirdServerRequest setHTTPMethod:@"GET"];
    [bounceBirdServerRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Conten-Type"];
    
    
    NSURLConnection *bounceBirdConnection = [NSURLConnection connectionWithRequest:bounceBirdServerRequest delegate:self];
    [bounceBirdConnection start];
}



- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to register: %@", error);
    
    
    
    if (error) {
        NSURL *bounceBirdServerURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://lab.wunderfactory.de/insert_new_ud_id.php?ud_id=%@", deviceTokenString]];
        
        
        NSMutableURLRequest *bounceBirdServerRequest = [[NSMutableURLRequest alloc] initWithURL:bounceBirdServerURL];
        [bounceBirdServerRequest setHTTPMethod:@"GET"];
        [bounceBirdServerRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Conten-Type"];
        
        
        NSURLConnection *bounceBirdConnection = [NSURLConnection connectionWithRequest:bounceBirdServerRequest delegate:self];
        [bounceBirdConnection start];
    }
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //NSLog(@"Notification arrived");
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
