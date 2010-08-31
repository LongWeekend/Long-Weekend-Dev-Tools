//
//  UIColor+LWEUtilities.h
//  LocationBasedMessaging
//
//  Created by Rendy Pranata on 31/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (LWEUtilities)

//! This method will initialize a color object with the provided hexadecimal number. (Currently it only supports 24 bits color)
- (id)initWithHex:(NSNumber *)hex;

//! This is the class method, that will call the method above, and give the autorelease object. It will transform the hexadecimal color, into individual red, green, blue color.
+ (id)colorWithHex:(NSNumber *)hex;

@end
