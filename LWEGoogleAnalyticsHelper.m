//
//  LWEGoogleAnalyticsHelper.m
//
//  Created by paul on 18/07/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "LWEGoogleAnalyticsHelper.h"
#import "GANTracker.h"

static const NSInteger kGANDispatchPeriodSec = 10;

@implementation LWEGoogleAnalyticsHelper

//! Instantiate a GAN session with apiKey (e.g. UA-00000000-1)
+ (void)startSession:(NSString *)apiKey
{
  [[GANTracker sharedTracker] startTrackerWithAccountID:apiKey dispatchPeriod:kGANDispatchPeriodSec delegate:nil];
}

//! Log a simple GAN Event with the string provided (logged as pageview)
+ (void)logEvent:(NSString *)eventName
{
  NSError *error;
  if (![[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"\%@", eventName] withError:&error])
  {
    NSLog(@"error in trackPageview");
  }
}

//! Log a GAN Event with all details provided
+ (void)logEvent:(NSString *)eventName withAction:(NSString*)actionString withLabel:(NSString*)label andValue:(NSInteger)intValue
{
  NSError *error;
  if( ![[GANTracker sharedTracker] trackEvent:eventName action:actionString label:label value:intValue withError:&error] )
  {
    NSLog(@"error in trackEvent");
  }
}

//! Set a custom GAN variable, not sure how to use these?!?!
+ (void)setVariableAtIndex:(NSInteger)index withName:(NSString*)name andValue:(NSString*)valueString
{
  NSError *error;
  if (![[GANTracker sharedTracker] setCustomVariableAtIndex:index name:name value:valueString withError:&error]) 
  {
    NSLog(@"error in setCustomVariableAtIndex");
  }
}

//! Simple wrapper for stopping the tracker
+ (void) stopTracker
{
  [[GANTracker sharedTracker] stopTracker];
}

@end