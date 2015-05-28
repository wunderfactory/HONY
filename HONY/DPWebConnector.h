//
//  DPWebConnector.h
//  DPWebConnector
//
//  Created by David Pflugpeil on 24.03.14.
//  Copyright (c) 2014 David Pflugpeil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPWebConnector : NSObject


+ (void)asynchronusConnectionWithURLString:(NSString *)webURLString;

+ (NSDictionary *)synchronusConnectionWithURLString:(NSString *)webURLString;


@end
