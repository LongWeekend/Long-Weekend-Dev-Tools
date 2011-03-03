//
//  LWEUniversalAppHelpers.h
//  Rikai
//
//  Created by Ross on 10/11/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWEUniversalAppHelpers : NSObject
{
}
//! Determines if the device is an iPad or not. Works with pre 3.2 iOS versions as well
+(BOOL)isAnIPad;

//! Determines if the device is an iPhone or not. Works with pre 3.2 iOS versions as well
+(BOOL)isAnIPhone;

/**
 * Returns the filename passed to it, UNLESS the device is an iPad AND the same filename + "@HD" exists.  (ala @2x)
 */
+ (NSString*) fileNamed:(NSString*)fileName;

/**
 * Returns an appropriate filename based on the filename given, making considerations for whether the device is an iPad or not.
 * \param fileName The name of the file to Retina-icize or iPadHD-icize
 * \param useRetina If the device is an iPad, and no iPad HD file is found for the given fileName, setting this param to YES will return the retina filename instead.
 * \return Returns a filename based on the input fileName -- e.g. foo.png => foo@HD.png or foo@2x.png ... or maybe just foo.png.
 */
+ (NSString*) fileNamed:(NSString *)fileName useRetinaIfMissing:(BOOL)useRetina;


@end
