// LWECrashUtils.m
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

#import "LWECrashUtils.h"
#import "LWEDebug.h"
#import "LWEUniversalAppHelpers.h"

#pragma mark - C Functions for FlurryAPI

/**
 * Unhandled exception handler (only installed in adhoc and final app store version)
 * Makes the assumption that you're using Flurry in the project.
 * For clients running iOS4.0+, it will send a stack trace for all stack frames containing the name
 * of your app.
 */
void LWEUncaughtExceptionHandler(NSException *exception)
{
  NSString *appBinaryName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
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
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:debugInfoStr forKey:@"backtrace"];
  [LWEAnalytics logError:exception.name parameters:userInfo];
}
