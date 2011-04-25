//
//  LWEUniversalAppHelpers.m
//  Rikai
//
//  Created by Ross on 10/11/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import "LWEUniversalAppHelpers.h"
#include <sys/types.h>
#include <sys/sysctl.h>

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

+ (kLWEDeviceType) deviceType
{
  NSString *deviceString = [LWEUniversalAppHelpers deviceModelString];
  return [LWEUniversalAppHelpers deviceTypeWithString:deviceString];
}

/**
 * We have this method separated out so we can unit test it.
 * Techincally this could be private, as deviceType is the only
 * one that calls it.
 */
+ (kLWEDeviceType) deviceTypeWithString:(NSString*)deviceString
{
  // Check simulator first because we want to fast return when working on simulator
  if ([deviceString isEqualToString:@"i386"])
  {
    return kLWEDeviceTypeSimulator;
  }

  kLWEDeviceType device = kLWEDeviceTypeUnknown;
  NSArray *components = [deviceString componentsSeparatedByString:@","];
  
  // If we didn't find "," in the device string, we don't know how to class this device type unless simulator
  if ([components count] > 1)
  {
    NSInteger minorRevision = [(NSString*)[components objectAtIndex:1] integerValue];
    
    // Naive implementation - assumes 1 digit version number.   Could use Regex but this would
    // break iOS3.1+ compatability.
    NSString *deviceClassWithVersion = [components objectAtIndex:0];
    NSInteger versionIndex = ([deviceClassWithVersion length]-1);
    NSInteger majorRevision = [[deviceClassWithVersion substringFromIndex:versionIndex] integerValue];
    NSString *deviceClass = [deviceClassWithVersion substringToIndex:versionIndex];
    
    // Now determine our device type based on all this info.
    if ([deviceClass isEqualToString:@"iPhone"])
    {
      switch (majorRevision)
      {
        case 4:
          device = kLWEDeviceTypeIPhone5;
          break;
        case 3:
          device = kLWEDeviceTypeIPhone4;
          break;
        case 2:
          device = kLWEDeviceTypeIPhone3GS;
          break;
        case 1:
          if (minorRevision == 1)
          {
            device = kLWEDeviceTypeIPhone;
          }
          else if (minorRevision == 2)
          {
            device = kLWEDeviceTypeIPhone3G;
          }
          break;
      }
    }
    else if ([deviceClass isEqualToString:@"iPod"])
    {
      switch (majorRevision)
      {
        case 4:
          device = kLWEDeviceTypeIPodTouch4;
          break;
        case 3:
          device = kLWEDeviceTypeIPodTouch3;
          break;
        case 2:
          device = kLWEDeviceTypeIPodTouch2;
          break;
        case 1:
          device = kLWEDeviceTypeIPodTouch1;
          break;
      }
    }
    else if ([deviceClass isEqualToString:@"iPad"])
    {
      switch (majorRevision)
      {
        case 2:
          device = kLWEDeviceTypeIPad2;
          break;
        case 1:
          device = kLWEDeviceTypeIPad;
          break;
      }
    }
  }
  return device;
}

+ (NSString*) deviceModelString
{
  // This implementation is courtesy of John Muchow
  // http://iphonedevelopertips.com/device/determine-if-iphone-is-3g-or-3gs-determine-if-ipod-is-first-or-second-generation.html
  size_t size;
  
  // Set 'oldp' parameter to NULL to get the size of the data
  // returned so we can allocate appropriate amount of space
  sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
  
  // Allocate the space to store name
  char *name = malloc(size);
  
  // Get the platform name
  sysctlbyname("hw.machine", name, &size, NULL, 0);
  
  // Place name into a string
  NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
  free(name);
  return machine;
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
    NSRange lastPeriod = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    NSString *ipadName = nil;
    if (lastPeriod.location == NSNotFound)
    {
      // Append only
      ipadName = [fileName stringByAppendingString:@"@HD"];
    }
    else
    {
      ipadName = [fileName stringByReplacingCharactersInRange:lastPeriod withString:@"@HD."];
    }
    
    if (useRetina)
    {
      if ([LWEFile fileExists:ipadName])
      {
        returnVal = ipadName;
      }
      else
      {
        returnVal = [LWERetinaUtils retinaFilenameForName:fileName];
      }
    }
    else
    {
      // Don't care about whether the file exists or not
      returnVal = ipadName;
    }
    return returnVal;
  }
  
  return fileName; // we didn't do anything fancy, just return the fileName
}

@end
