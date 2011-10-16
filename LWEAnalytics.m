//
//  LWEAnalytics.m
//  phone
//
//  Created by Mark Makdad on 8/1/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "LWEAnalytics.h"
#import "LWEDebug.h"
#import "FlurryAPI.h"

@implementation LWEAnalytics

+ (void) logEvent:(NSString*)eventName parameters:(NSDictionary*)userInfo
{
#if defined(LWE_RELEASE_APP_STORE) || defined(LWE_RELEASE_ADHOC)
  [FlurryAPI logEvent:eventName withParameters:userInfo];
#else
  LWE_LOG(@"LWEAnalytics Event: %@",eventName);
  LWE_LOG(@"LWEAnalytics Parameters: %@",userInfo);
#endif
  
}

@end
