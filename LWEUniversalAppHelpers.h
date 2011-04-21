//
//  LWEUniversalAppHelpers.h
//  Rikai
//
//  Created by Ross on 10/11/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

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
  kLWEDeviceTypeIPhone5    = (5 << kLWEDeviceClassCount) | kLWEDeviceClassIPhone,
  kLWEDeviceTypeIPad2      = (5 << kLWEDeviceClassCount) | kLWEDeviceClassIPad,
  kLWEDeviceTypeSimulator  = (6 << kLWEDeviceClassCount) | kLWEDeviceClassSimulator,
} kLWEDeviceType;

@interface LWEUniversalAppHelpers : NSObject
{
}
//! Determines if the device is an iPad or not. Works with pre 3.2 iOS versions as well
+(BOOL)isAnIPad;

//! Determines if the device is an iPhone or not. Works with pre 3.2 iOS versions as well
+(BOOL)isAnIPhone;

//! Returns the name of this device
+ (NSString*)deviceModelString;

+ (kLWEDeviceType)deviceTypeWithString:(NSString*)deviceString;
+ (kLWEDeviceType)deviceType;

/**
 * Returns the filename passed to it, UNLESS the device is an iPad AND the same filename + "@HD" exists.  (ala @2x)
 */
+ (NSString*) fileNamed:(NSString*)fileName;
+ (NSString*) fileNamed:(NSString *)fileName useRetinaIfMissing:(BOOL)useRetina;

/**
 * Returns an appropriate filename based on the filename given, making considerations for whether the device is an iPad or not, and whether the device is Retina or not.
 * \param fileName The name of the file to Retina-icize or iPadHD-icize
 * \param useRetina If the device is an iPad, and no iPad HD file is found for the given fileName, setting this param to YES will return the retina filename instead.
 * \return Returns a filename based on the input fileName -- e.g. foo.png => foo@HD.png or foo@2x.png ... or maybe just foo.png.
 */
+ (NSString*) fileNamed:(NSString *)fileName useRetinaIfMissing:(BOOL)useRetina;


@end
