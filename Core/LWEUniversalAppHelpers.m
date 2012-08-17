// LWEUniversalAppHelpers.m
//
// Copyright (c) 2010, 2011 Long Weekend LLC
//
// EXCEPT for +(NSString*)deviceModelString method implementation, courtesy of 
// John Muchow:
// http://iphonedevelopertips.com/device/determine-if-iphone-is-3g-or-3gs-determine-if-ipod-is-first-or-second-generation.html
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

#import "LWEUniversalAppHelpers.h"
#import "LWERetinaUtils.h"
#import "LWEFile.h"
#import <UIKit/UIKit.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation LWEUniversalAppHelpers

// TODO: this is a bit of a naive implementation - change this to use deviceModelString?
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

// TODO: this is a bit of a naive implementation
+ (BOOL)isAnIPhone
{
  return ([LWEUniversalAppHelpers isAnIPad] == NO);
}

+ (kLWEDeviceType) deviceType
{
  NSString *deviceString = [LWEUniversalAppHelpers deviceModelString];
  return [LWEUniversalAppHelpers deviceTypeWithString:deviceString];
}

/**
 * This method is separated out so we can unit test it.
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
        case 5:
          device = kLWEDeviceTypeIPhone5;
          break;
        case 4:
          device = kLWEDeviceTypeIPhone4S;
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
        case 3:
          // We are not yet 100% sure that this is major revision 3, but 95% sure :)
          device = kLWEDeviceTypeIPad3;
          break;
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

/**
 * If iPad, will append "@HD" to the filename - does NOT check for file existence
 */
+ (NSString*) fileNamed:(NSString*)fileName
{
  NSString *returnVal = fileName;
  if ([LWEUniversalAppHelpers isAnIPad])
  {
    NSRange lastPeriod = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    if (lastPeriod.location == NSNotFound)
    {
      // Append only
      returnVal = [fileName stringByAppendingString:@"@HD"];
    }
    else
    {
      returnVal = [fileName stringByReplacingCharactersInRange:lastPeriod withString:@"@HD."];
    }
  }
  return returnVal;
}


+ (NSString*) fileNamed:(NSString *)fileName useRetinaIfMissing:(BOOL)useRetina
{
  NSString *returnVal = fileName;
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
    
    // Assign first, if we care about retina/file existence, we may change once more
    returnVal = ipadName;
    if (useRetina && [LWEFile fileExists:ipadName] == NO)
    {
      returnVal = [fileName stringByAddingRetinaSpecifier];
    }
  }
  else
  {
    // We have an iPod Touch/iPhone.  Do the bug check for 4.0.x and be done with it. (ticket #449)
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    if ([ver isEqualToString:@"4.0"] || [ver isEqualToString:@"4.0.1"] || [ver isEqualToString:@"4.0.2"])
    {
      // "Upsize" the filename here instead of just returning the image, because UIImage won't
      // do it for us given a 1x filename.
      returnVal = [LWERetinaUtils retinaSafeImageName:fileName];
    }
  }
  
  return returnVal;
}

@end
