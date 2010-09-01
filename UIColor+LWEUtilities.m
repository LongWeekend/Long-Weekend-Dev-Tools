//
//  UIColor+LWEUtilities.m
//  LocationBasedMessaging
//
//  Created by Rendy Pranata on 31/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIColor+LWEUtilities.h"


@implementation UIColor (LWEUtilities)

/**
 * \brief		This is the method that will initialize a UIColor with the hexadecimal NSNumber. 
 *					Keep in mind that the parameter is the hexadecimal so it will be something like [NSNumber numberWithInt:0xFFFFFF]
 * \param		Color code in hexadecimal
 * \details This method is currently only supports 24bits color, so please dont give 12bits color like 0xFFF but instead give it 0xFFFFFF. It might be
 *					upgraded, or extended in the future. But now it is nice to have a 24 bits color converter from hexa to RGB.
 */
- (id)initWithHex:(NSNumber *)hex
{
	//This things just to avoid the wrong parameter, and the caller does not give 24 bits color. 
	//It will gets messy with the bits shifting, and operator if it is not 6 digits hexa.
	NSString *hexString = [[NSString alloc] initWithFormat:@"%x", [hex intValue]];
	NSAssert(([hexString length] == 6), @"Only 24 bits color supported here at the moment");
	[hexString release];
	
	//What it does here is, whatever (and) F should return itself, and whatever (and) 0 should return 0. So first it tries to 
	//do and (&) operator to take the first two digit for red. second two digit for green, and the rest is for blue. after that, cause 2 digits hexa is 
	//8 digits binary, we only want the value for those red, green or blue component. so for red, we shift the binary by 16 digits, green by 8 digit, and the
	//rest should be blue. (Does not need to shift the binary). By the end of the calculation, it will need to divide the number by 255 (maximum byte), so it will gets
	//value between 0.0, and 1.0 (float)
	float red = (float) (([hex intValue] & 0xFF0000) >> 16) / 255.0f;
	float green = (float) (([hex intValue] & 0x00FF00) >> 8) / 255.0f;
	float blue = (float) (([hex intValue] & 0x000FF) >> 0) / 255.0f;

	//after getting the individual color component, it calls the initWithRed:green:blue:alpha: method, and it will return itself.
	if (self = [self initWithRed:red green:green blue:blue alpha:1.0f])
	{
		//possible future customization after initialization
	}
	return self;
}

/**
 * \brief		This is the method that will initialize a UIColor with the hexadecimal NSNumber, and also returns a autorelease color object.
 *					Keep in mind that the parameter is the hexadecimal so it will be something like [NSNumber numberWithInt:0xFFFFFF]
 * \param		Color code in hexadecimal
 * \details This method is currently only supports 24bits color, so please dont give 12bits color like 0xFFF but instead give it 0xFFFFFF. It might be
 *					upgraded, or extended in the future. But now it is nice to have a 24 bits color converter from hexa to RGB.
 */
+ (id)colorWithHex:(NSNumber *)hex
{
	UIColor *tmpColor = [[[UIColor alloc] initWithHex:hex] autorelease];
	return tmpColor;
}

@end
