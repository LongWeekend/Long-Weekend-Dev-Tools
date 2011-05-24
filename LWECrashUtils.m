//
//  LWECrashUtils.m
//  phone
//
//  Created by Mark Makdad on 5/24/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "LWECrashUtils.h"

#pragma mark C Functions for FlurryAPI

/**
 * Unhandled exception handler (only installed in adhoc and final app store version)
 * Makes the assumption that you're using Flurry in the project.
 * For clients running iOS4.0+, it will send a stack trace for all stack frames containing the name
 * of your app.
 */
void LWEUncaughtExceptionHandler(NSException *exception)
{
  NSString *appBinaryName = CONVERT_SYMBOL_TO_NSSTRING(${PRODUCT_NAME});
  NSMutableString *debugInfoStr = [NSMutableString string];
  
  // Get device (HW) & version information
  [debugInfoStr appendFormat:@"%@,%@;",[LWEUniversalAppHelpers deviceModelString],[[UIDevice currentDevice] systemVersion]];
  
  // callStackSymbols only available in iOS4.0+
  if ([exception respondsToSelector:@selector(callStackSymbols)])
  {
    NSArray *callstack = [exception callStackSymbols];
    for (NSString *stackFrame in callstack)
    {
      // We have very limited space on Flurry, so don't log any stack frame that's not our code / hex addresses
      NSRange range = [stackFrame rangeOfString:appBinaryName];
      if (range.location != NSNotFound)
      {
        // Trim out the app name as well as the whitespace
        NSString *stackFrameHexOnly = [stackFrame substringFromIndex:(range.location+range.length)];
        NSString *trimmedStackFrame = [stackFrameHexOnly stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [debugInfoStr appendFormat:@"%@;",trimmedStackFrame];
      }
    }
  }
#if defined(LWE_RELEASE_APP_STORE) || defined(LWE_RELEASE_ADHOC)
  [NSClassFromString(@"FlurryAPI") logError:[exception name] message:debugInfoStr exception:exception];
#else
  LWE_LOG(@"Unhandled exception %@: stack trace (if available) follows\n%@",[exception name],debugInfoStr);
#endif
}
