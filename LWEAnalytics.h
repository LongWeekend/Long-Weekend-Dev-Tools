//
//  LWEAnalytics.h
//  phone
//
//  Created by Mark Makdad on 8/1/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWEAnalytics : NSObject

+ (void) logEvent:(NSString*)eventName parameters:(NSDictionary*)userInfo;

@end
