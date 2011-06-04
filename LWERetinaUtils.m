//
//  LWERetinaUtils.m
//
//  Created by Mark Makdad on 8/10/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import "LWERetinaUtils.h"
#import "LWEUniversalAppHelpers.h"

@implementation LWERetinaUtils

// TODO: This needs to be redone? - an iPad may someday be Retina.  Sigh this is hard...
+ (BOOL) isRetinaDisplay
{
  BOOL returnVal = NO;
  // 1. Does the screen respond to "scale"?
  // 2. Is the scale 2?
  // 3. Is it not an iPad-type device (i.e. it could be scale = 2 because of iPhone app scaling)
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] &&
      [[UIScreen mainScreen] scale] == 2 &&
      ([LWEUniversalAppHelpers deviceType] & kLWEDeviceClassIPad) == 0)
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
