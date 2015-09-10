// LWEUniversalAppHelpers.h
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

NS_ASSUME_NONNULL_BEGIN

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// There can only be X device types where X = (number of bits - 4) in an int on this platform.  Since that's
// usually 32-bits for compatibility, we have 28 device classes.
typedef enum
{
  kLWEDeviceClassUnknown,
  kLWEDeviceClassSimulator,
  kLWEDeviceClassIPhone,
  kLWEDeviceClassIPodTouch,
  kLWEDeviceClassIPad,
  kLWEDeviceClassCount
} kLWEDeviceClass;

typedef enum
{
  // Device class keys - least significant bits, use kLWEDeviceClass
  // Device "ranking" flags - more significant bits
  kLWEDeviceTypeUnknown    = (0 << kLWEDeviceClassCount) | kLWEDeviceClassUnknown,
  kLWEDeviceTypeIPhone     = (0 << kLWEDeviceClassCount) | kLWEDeviceClassIPhone,
  kLWEDeviceTypeIPodTouch1 = (0 << kLWEDeviceClassCount) | kLWEDeviceClassIPodTouch,
  kLWEDeviceTypeIPhone3G   = (1 << kLWEDeviceClassCount) | kLWEDeviceClassIPhone,
  kLWEDeviceTypeIPodTouch2 = (1 << kLWEDeviceClassCount) | kLWEDeviceClassIPodTouch,
  kLWEDeviceTypeIPhone3GS  = (2 << kLWEDeviceClassCount) | kLWEDeviceClassIPhone,
  kLWEDeviceTypeIPodTouch3 = (2 << kLWEDeviceClassCount) | kLWEDeviceClassIPodTouch,
  kLWEDeviceTypeIPhone4    = (3 << kLWEDeviceClassCount) | kLWEDeviceClassIPhone,
  kLWEDeviceTypeIPodTouch4 = (3 << kLWEDeviceClassCount) | kLWEDeviceClassIPodTouch,
  kLWEDeviceTypeIPad       = (4 << kLWEDeviceClassCount) | kLWEDeviceClassIPad,
  kLWEDeviceTypeIPad2      = (5 << kLWEDeviceClassCount) | kLWEDeviceClassIPad,
  kLWEDeviceTypeIPhone4S   = (5 << kLWEDeviceClassCount) | kLWEDeviceClassIPhone,
  kLWEDeviceTypeIPad3      = (6 << kLWEDeviceClassCount) | kLWEDeviceClassIPad,
  kLWEDeviceTypeIPhone5    = (7 << kLWEDeviceClassCount) | kLWEDeviceClassIPhone,
  kLWEDeviceTypeSimulator  = (7 << kLWEDeviceClassCount) | kLWEDeviceClassSimulator,
} kLWEDeviceType;

/**
 * This class helps applications be universal: work on any iOS device (iPhone, iPod Touch, iPad)
 * This includes device identification helper methods, filename selector methods (e.g. using 
 * HD file extensions for iPad-specific resources).
 * 
 * Note that this class is RELATED to LWERetinaUtils, which is responsible for device resolution/display
 * universality issues, but the roles of each class are distinct.  An iPad could theoretically also be
 * Retina someday; this class should/would not care about that at that point.
 */
@interface LWEUniversalAppHelpers : NSObject

//! Determines if the device is an iPad or not. Works with pre 3.2 iOS versions as well
+ (BOOL)isAnIPad;

//! Determines if the device is an iPhone or not. Works with pre 3.2 iOS versions as well
+ (BOOL)isAnIPhone;

+ (BOOL)is3Point5InchRetinaDisplay;

//! Determines if the device is an 4" retina display or not. Works with pre 3.2 iOS versions as well
+ (BOOL)isFourInchRetinaDisplay;

/** Returns `YES` for iPhone screen larger than 4"  */
+ (BOOL)isLargeScreenSizePhone;

+ (BOOL)is4Point7InchRetinaDisplay;

+ (BOOL)is5Point5InchRetinaDisplay;

/**
 * Used by client code when running with a non 4" screen that wants to adjust layout optimized for 4"
 * NOTE: Currently this method returns incorrect results when run in the resizable iPhone simulator.
 */
+ (CGFloat)screenHeightDifferenceFrom4InchDisplay;

/** 
 * Derrived the number from `screenHeightDifferenceFrom4InchDisplay` method, it takes the height ratio,
 * how much bigger in a percentage.
 *
 * Returns 1 for smaller iPhone and iPad.
 */
+ (CGFloat)ratioHeightDifferenceFrom4InchDisplay;

/**
 * Given a measurement number for iPhone with 4" screen, it gets the
 * screen difference ratio and return what the scaled measurement for bigger iPhone.
 */
+ (CGFloat)scaledInBiggerIphoneFor:(CGFloat)number;

/** Used by client code when running with a non 3.5" screen that wants to adjust layout optimized for 3.5" */
+ (CGFloat)threePoint5InchDisplayHeight;

/** Used by client code when running with a non 4" screen that wants to adjust layout optimized for 4" */
+ (CGFloat)fourInchDisplayHeight;

/** Used by client code when running with a non 4" screen that wants to adjust layout optimized for 4" */
+ (CGSize)fourInchDisplaySize;

+ (BOOL)isiOS8OrAbove;
+ (BOOL)isiOS9OrAbove;

//! Determines if touch ID is available or not.
+ (BOOL)isTouchIDAvailable;

/**
 * \brief Returns the name of this device, e.g. "iPhone 2,1" for an iPhone 3GS.
 * This method returns the string by making a C system call asking the system to identify its
 * hardware.
 */
+ (NSString *)deviceModelString;

/**
 * Converts a device string (retrieved likely from the hardware via a call to -deviceModelString)
 * into a kLWEDeviceType enum value that identifies the device.
 * \param deviceString Should be a string from -deviceModelString -- something of the format "iPhone 2,1"
 * \return The device type, as a member of enum kLWEDeviceType
 */
+ (kLWEDeviceType)deviceTypeWithString:(NSString *)deviceString;

/**
 * Helper method that calls +deviceTypeWithString: with the return val of +deviceModelString as the param
 */
+ (kLWEDeviceType)deviceType;

/** Adds a @HD extension to the name, if it is an iPad */
+ (NSString *)fileNamed:(NSString*)fileName;

/**
 * Adds an @HD extension to the name if the device is an iPad.  If the @HD filename does not exist
 * and useRetinaIfMissing is YES, it will be @2x instead.
 * Also, if NON ipad and is a retina device on 4.0.x, this method will return @2x
 */
+ (NSString *)fileNamed:(NSString *)fileName useRetinaIfMissing:(BOOL)useRetina;

/**
 * Returns an appropriate filename based on the filename given, making considerations for whether the device is an iPad or not, and whether the device is Retina or not.
 * \param fileName The name of the file to Retina-icize or iPadHD-icize
 * \param useRetina If the device is an iPad, and no iPad HD file is found for the given fileName, setting this param to YES will return the retina filename instead.
 * \return Returns a filename based on the input fileName -- e.g. foo.png => foo@HD.png or foo@2x.png ... or maybe just foo.png.
 */
+ (NSString *)fileNamed:(NSString *)fileName useRetinaIfMissing:(BOOL)useRetina;

/**
 * Returns the rotation transform needed to rotate a window or view to appear upright given the specified orientation of the device.
 */
+ (CGAffineTransform)rotationTransformForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

NS_ASSUME_NONNULL_END
