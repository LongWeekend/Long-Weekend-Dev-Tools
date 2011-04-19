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

+ (NSString*) deviceModel
{
  /*
  iPhone Simulator == i386
  iPhone == iPhone1,1
  3G iPhone == iPhone1,2
  3GS iPhone == iPhone2,1
  4 iPhone == iPhone3,1
  1st Gen iPod == iPod1,1
  2nd Gen iPod == iPod2,1
  3rd Gen iPod == iPod3,1
  */
  
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
  NSString *machine = [NSString stringWithCString:name];
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
