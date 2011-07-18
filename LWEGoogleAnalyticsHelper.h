//
//  LWEGoogleAnalyticsHelper.h
//
//  Created by paul on 18/07/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWEGoogleAnalyticsHelper : NSObject

/*
 start session, attempt to send saved sessions to server 
 */
+ (void)startSession:(NSString *)apiKey;

/*
 log events or errors after session has started
 */
+ (void)logEvent:(NSString *)eventName;
+ (void)logEvent:(NSString *)eventName withAction:(NSString*)actionString withLabel:(NSString*)label andValue:(NSInteger)intValue;
+ (void)setVariableAtIndex:(NSInteger)index withName:(NSString*)name andValue:(NSString*)valueString;

/* 
 wrapper for calling the stop tracker method
 */
+ (void) stopTracker;

@end