//
//  LWETRequestDelegate.h
//  TweetSimulationWithLWE
//
//  Created by Rendy Pranata on 18/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This request delegate is the protocol that has to be conformed to, as a twitter engine 
 * request delegate. All of the request given to the twitter engine, the result (whether it fails)
 * or succeed, it will goes in these methods. 
 *
 */
@protocol LWETRequestDelegate
@optional
- (void)didFinishProcessWithData:(NSData *)data;
- (void)didFailedWithError:(NSError *) error;
- (void)didFinishAuth;
- (void)didFailedAuth:(NSError *)error;
@end