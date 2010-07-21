//
//  LWETRequestDelegate.h
//  TweetSimulationWithLWE
//
//  Created by Rendy Pranata on 18/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import <UIKit/UIKit.h>

// RENDY: doc
@protocol LWETRequestDelegate
@optional
- (void)didFinishProcessWithData:(NSData *)data;
- (void)didFailedWithError:(NSError *) error;
- (void)didFinishAuth;
- (void)didFailedAuth:(NSError *)error;
@end