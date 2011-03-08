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

+ (NSString*) fileNamed:(NSString*)fileName;
+ (NSString*) fileNamed:(NSString *)fileName useRetinaIfMissing:(BOOL)useRetina;

@end
