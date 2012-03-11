// LWERetinaUtils.m
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

#import "LWERetinaUtils.h"
#import "LWEUniversalAppHelpers.h"

@implementation LWERetinaUtils

+ (BOOL) isRetinaDisplay
{
  BOOL returnVal = NO;
  // 1. Does the screen respond to "scale"?
  // 2. Is the scale 2?
  // 3. Is it not an iPad-type device (i.e. it could be scale = 2 because of iPhone app scaling)
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] &&
      [[UIScreen mainScreen] scale] == 2)
    //      ([LWEUniversalAppHelpers deviceType] & kLWEDeviceClassIPad) == 0)
  {
    returnVal = YES;
  }
  return returnVal;
}

// This method changes the name no matter what
+ (NSString*) retinaFilenameForName:(NSString *)name
{
  NSString *retinaName = nil;
  NSRange lastPeriod = [name rangeOfString:@"." options:NSBackwardsSearch];
  if (lastPeriod.location == NSNotFound)
  {
    // Append only - there is no extension (ticket #568)
    retinaName = [name stringByAppendingString:@"@2x"];
  }
  else
  {
    retinaName = [name stringByReplacingCharactersInRange:lastPeriod withString:@"@2x."];
  }
  return retinaName;
}

// This method tests for Retina before changing the name
// While iOS handles this on reading for us, when we write an image, we need to know
// the right name to name the file (e.g. if we create two versions)
+ (NSString*) retinaSafeImageName:(NSString*)name
{
  if ([LWERetinaUtils isRetinaDisplay])
  {
    return [[self class] retinaFilenameForName:name];
  }
  else
  {
    return name;
  }
}

@end
