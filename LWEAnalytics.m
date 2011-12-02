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

+ (void) logEvent:(NSString *)eventName
{
  return [[self class] logEvent:eventName parameters:nil];
}

+ (void) logEvent:(NSString*)eventName parameters:(NSDictionary*)userInfo
{
#if defined(LWE_RELEASE_APP_STORE) || defined(LWE_RELEASE_ADHOC)
  #if defined(LWE_USE_FLURRY)
  [FlurryAPI logEvent:eventName withParameters:userInfo];
  #elif defined(LWE_USE_GAN)
  NSError *error = nil;
  [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"\%@", eventName] withError:&error];
  // Some GAN code here
  #endif
#else
  LWE_LOG(@"LWEAnalytics Event: %@",eventName);
  LWE_LOG(@"LWEAnalytics Parameters: %@",userInfo);
#endif
}


+ (void) logError:(NSString *)errorName message:(NSString *)errorMsg
{
#if defined(LWE_RELEASE_APP_STORE) || defined(LWE_RELEASE_ADHOC)
#if defined(LWE_USE_FLURRY)
  [FlurryAPI logError:errorName message:errorMsg exception:nil];
#elif defined(LWE_USE_GAN)
  NSError *error = nil;
  [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"\%@", errorName] withError:&error];
  // Some GAN code here
#endif
#else
  LWE_LOG(@"LWEAnalytics ERROR: %@ MSG : %@",errorName,errorMsg);
#endif
}

//! Instantiate a GAN session with apiKey (e.g. UA-00000000-1)
+ (void)startSession:(NSString *)apiKey
{
#if defined(LWE_USE_GAN)
  [[GANTracker sharedTracker] startTrackerWithAccountID:apiKey dispatchPeriod:kGANDispatchPeriodSec delegate:nil];
#endif
}

//! Log a GAN Event with all details provided
+ (void)logEvent:(NSString *)eventName withAction:(NSString*)actionString withLabel:(NSString*)label andValue:(NSInteger)intValue
{
#if defined(LWE_USE_GAN)
  NSError *error;
  if( ![[GANTracker sharedTracker] trackEvent:eventName action:actionString label:label value:intValue withError:&error] )
  {
    NSLog(@"error in trackEvent");
  }
#endif
}

//! Set a custom GAN variable, not sure how to use these?!?!
+ (void)setVariableAtIndex:(NSInteger)index withName:(NSString*)name andValue:(NSString*)valueString
{
#if defined(LWE_USE_GAN)
  NSError *error;
  if (![[GANTracker sharedTracker] setCustomVariableAtIndex:index name:name value:valueString withError:&error]) 
  {
    NSLog(@"error in setCustomVariableAtIndex");
  }
#endif
}

//! Simple wrapper for stopping the tracker
+ (void) stopTracker
{
#if defined(LWE_USE_GAN)
  [[GANTracker sharedTracker] stopTracker];
#endif
}

@end