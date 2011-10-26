// LWEGoogleAnalyticsHelper.m
//
// Copyright (c) 2011 Long Weekend LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "LWEAnalytics.h"
#import "LWEDebug.h"
#if defined(LWE_USE_FLURRY)
  #import "FlurryAPI.h"
#endif 
#if defined(LWE_USE_GAN)
  #import "GANTracker.h"
#endif

static const NSInteger kGANDispatchPeriodSec = 10;

@implementation LWEAnalytics

//================= FLURRY ANALYTICS METHODS =============

#if defined(LWE_USE_FLURRY)

+ (void) logEvent:(NSString*)eventName parameters:(NSDictionary*)userInfo
{
#if defined(LWE_RELEASE_APP_STORE) || defined(LWE_RELEASE_ADHOC)
  [FlurryAPI logEvent:eventName withParameters:userInfo];
#else
  LWE_LOG(@"LWEAnalytics Event: %@",eventName);
  LWE_LOG(@"LWEAnalytics Parameters: %@",userInfo);
#endif
}

#endif

//================= GOOGLE ANALYTICS METHODS =============

#if defined(LWE_USE_GAN)

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

#endif

@end