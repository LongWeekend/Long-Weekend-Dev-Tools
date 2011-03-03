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

+ (NSString*) fileNamed:(NSString*)fileName
{
  return [LWEUniversalAppHelpers fileNamed:fileName useRetinaIfMissing:NO];
}

+ (NSString*) fileNamed:(NSString *)fileName useRetinaIfMissing:(BOOL)useRetina
{
  NSString *returnVal = nil;
  if ([LWEUniversalAppHelpers isAnIPad])
  {
    NSString *stringToAdd = @"@HD.";
    NSRange lastPeriod = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    NSString *ipadName = [fileName stringByReplacingCharactersInRange:lastPeriod withString:stringToAdd];
    if ([LWEFile fileExists:ipadName])
    {
      returnVal = ipadName;
    }
    else if (useRetina)
    {
      returnVal = [LWERetinaUtils retinaFilenameForName:fileName];
    }
  }
  else
  {
    returnVal = [LWERetinaUtils retinaSafeImageName:fileName];
  }
  return returnVal;
}

@end
