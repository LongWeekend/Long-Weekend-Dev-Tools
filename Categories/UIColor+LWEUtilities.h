// UIColor+LWEUtilities.m
//
// Copyright (c) 2010-2 Long Weekend LLC
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

#import <UIKit/UIKit.h>

#pragma mark - UIColor

@interface UIColor (LWEUtilities)

//! This method will initialize a color object with the provided hexadecimal number. (Currently it only supports 24 bits color)
- (id)initWithHex:(NSUInteger)hex;

//! This is the class method, that will call the method above, and give the autorelease object. It will transform the hexadecimal color, into individual red, green, blue color.
+ (id)colorWithHex:(NSUInteger)hex;

//! This method will initialize a color object with the provided hexadecimal number, and alpha (0.0-1.0). (Currently it only supports 24 bits color)
- (id)initWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;

//! This is the class method, that will call the method above, and give the autorelease object. It will transform the hexadecimal color, into individual red, green, blue color.
+ (id)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;

@end
