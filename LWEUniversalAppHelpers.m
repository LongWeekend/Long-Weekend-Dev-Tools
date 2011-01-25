//
//  LWEUniversalAppHelpers.m
//  Rikai
//
//  Created by Ross on 10/11/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import "LWEUniversalAppHelpers.h"


@implementation LWEUniversalAppHelpers

+ (BOOL) isAnIPad
{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200  // this is when the UI_USER_INTERFACE_IDIOM was added
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
      else 
        // This is a 3.2.0+ but not an iPad (for future, when iPhone/iPod Touch runs with same OS than iPad)    
        return NO;
    #else
      // It's an iPhone/iPod Touch (OS < 3.2.0)
      return NO;
    #endif
}

+ (BOOL)isAnIPhone
{
  return ![LWEUniversalAppHelpers isAnIPad];
}

/**
 * Returns the filename passed to it, UNLESS the device is an iPad AND the
 * same filename + "@HD" exists.  (ala @2x)
 */
+ (NSString*) fileNamed:(NSString*)fileName
{
  if ([LWEUniversalAppHelpers isAnIPad])
  {
    NSString *stringToAdd = @"@HD.";
    NSRange lastPeriod = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    NSString *ipadName = [fileName stringByReplacingCharactersInRange:lastPeriod withString:stringToAdd];
    if ([LWEFile fileExists:ipadName])
    {
      return ipadName;
    }
  }
  // Let Cocoa handle it - just return as-is.
  return fileName;
}

@end
