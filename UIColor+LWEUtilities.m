// UIColor+LWEUtilities.m
//
// Copyright (c) 2010 Long Weekend LLC
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
  return [self initWithHex:hex alpha:1.0f];
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
	UIColor *tmpColor = [[[UIColor alloc] initWithHex:hex alpha:1.0f] autorelease];
	return tmpColor;
}

//! This method will initialize a color object with the provided hexadecimal number, and alpha (0.0-1.0). (Currently it only supports 24 bits color)
- (id)initWithHex:(NSNumber *)hex alpha:(CGFloat)alpha
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
	if (self = [self initWithRed:red green:green blue:blue alpha:alpha])
	{
		//possible future customization after initialization
	}
	return self;
	
}

//! This is the class method, that will call the method above, and give the autorelease object. It will transform the hexadecimal color, into individual red, green, blue color.
+ (id)colorWithHex:(NSNumber *)hex alpha:(CGFloat)alpha
{
	UIColor *tmpColor = [[[UIColor alloc] initWithHex:hex alpha:alpha] autorelease];
	return tmpColor;
}

@end
