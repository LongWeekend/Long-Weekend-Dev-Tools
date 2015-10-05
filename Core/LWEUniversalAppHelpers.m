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

@import Foundation;
#import "LWEUniversalAppHelpers.h"
#import "LWERetinaUtils.h"
#import "LWEFile.h"

#import <sys/utsname.h>

#ifdef __IPHONE_8_0
#import <LocalAuthentication/LocalAuthentication.h>
#endif


static const CGSize Retina5Point5InchDisplaySize = { 414, 736 };
static const CGSize Retina4Point7InchDisplaySize = { 375, 667 };
static const CGSize FourInchDisplaySize = { 320.0, 568.0 };
static const CGFloat ThreePointFiveInchDisplayHeight = 480.0;


@implementation LWEUniversalAppHelpers

+ (BOOL)isiOS8OrAbove
{
  return [@"8.0" compare:[[UIDevice currentDevice] systemVersion] options:NSNumericSearch] != NSOrderedDescending;
}

+ (BOOL)isiOS9OrAbove
{
  return [@"9.0" compare:[[UIDevice currentDevice] systemVersion] options:NSNumericSearch] != NSOrderedDescending;
}

+ (BOOL)isAnIPad
{
  UIDevice *currentDevice = [UIDevice currentDevice];
  return ([currentDevice userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

+ (BOOL)isAnIPhone
{
  UIDevice *currentDevice = [UIDevice currentDevice];
  return ([currentDevice userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

+ (BOOL)is3Point5InchRetinaDisplay
{
  return ([LWEUniversalAppHelpers isAnIPhone] &&
          ([self screenHeight_] < [self fourInchDisplayHeight]));
}

+ (BOOL)isFourInchRetinaDisplay
{
  return fequal((double)[self screenHeight_], (double)[self fourInchDisplayHeight]);
}

+ (BOOL)isLargeScreenSizePhone
{
  if ([LWEUniversalAppHelpers isAnIPhone])
  {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return screenSize.width > FourInchDisplaySize.width || screenSize.height > FourInchDisplaySize.height;
  }
  else
  {
    return NO;
  }
}

+ (BOOL)is4Point7InchRetinaDisplay
{
  return CGSizeEqualToSize([UIScreen mainScreen].bounds.size, Retina4Point7InchDisplaySize);
}

+ (BOOL)is5Point5InchRetinaDisplay
{
  return CGSizeEqualToSize([UIScreen mainScreen].bounds.size, Retina5Point5InchDisplaySize);
}

+ (CGFloat)screenHeightDifferenceFrom4InchDisplay
{
  return [self screenHeight_] - [self fourInchDisplayHeight];
}

+ (CGFloat)ratioHeightDifferenceFrom4InchDisplay
{
  static CGFloat ratio__ = 0;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if ([self isLargeScreenSizePhone] == NO)
    {
      ratio__ = 1;
    }
    else
    {
      ratio__ = [self screenHeightDifferenceFrom4InchDisplay]/[LWEUniversalAppHelpers fourInchDisplayHeight];
    }
  });
  return ratio__;
}

+ (CGFloat)scaledInBiggerIphoneFor:(CGFloat)number
{
  if ([self isLargeScreenSizePhone])
  {
    CGFloat ratio = [self ratioHeightDifferenceFrom4InchDisplay];
    return number+(ratio*number);
  }
  return number;
}

+ (CGFloat)threePoint5InchDisplayHeight
{
  return ThreePointFiveInchDisplayHeight;
}

+ (CGFloat)fourInchDisplayHeight
{
  return FourInchDisplaySize.height;
}

+ (CGSize)fourInchDisplaySize
{
  return FourInchDisplaySize;
}

+ (CGFloat)screenHeight_
{
  return [UIScreen mainScreen].bounds.size.height;
}

+ (BOOL)isTouchIDAvailable
{
#ifdef __IPHONE_8_0
  // Don't crash if we're on iOS 7 or below
  if ([self isiOS8OrAbove] == NO)
  {
    return NO;
  }
  
  // We don't care about the error, we just want to know if we can use touch ID or not
  LAContext *context = [[LAContext alloc] init];
  return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
#else
  return NO;
#endif
}

+ (kLWEDeviceType)deviceType
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

+ (NSString *)deviceModelString
{
  // Borrowed from:
  // http://stackoverflow.com/a/11197770/516969
  struct utsname systemInfo;
  uname(&systemInfo);

  return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

/**
 * If iPad, will append "@HD" to the filename - does NOT check for file existence
 */
+ (NSString *)fileNamed:(NSString*)fileName
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


+ (NSString *)fileNamed:(NSString *)fileName useRetinaIfMissing:(BOOL)useRetina
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

+ (CGAffineTransform)rotationTransformForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  switch (interfaceOrientation)
  {
    case UIInterfaceOrientationLandscapeLeft:
      return CGAffineTransformMakeRotation(-0.5*M_PI);
    case UIInterfaceOrientationLandscapeRight:
      return CGAffineTransformMakeRotation(0.5*M_PI);
    case UIInterfaceOrientationPortraitUpsideDown:
      return CGAffineTransformMakeRotation(M_PI);
    default:
      return CGAffineTransformIdentity;
  }
}

@end
