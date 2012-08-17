// NSString+LWEResolutionHelpers.h
//
// Copyright (c) 2012 Long Weekend LLC
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

#import <Foundation/Foundation.h>

/**
 In some environments, it is useful to manually create retina & HD filenames on your 
 own.  This is a category of helpers on NSString that will take regular filenames and 
 create their associated HD and @2x components.
 
 TODO: Does not yet support the new iPad 3 (@HD@2x?).
 */
@interface NSString (LWEResolutionHelpers)
/**
 Creates a filename for the iPad 1/2 by appending `@-hd` before the file extension.
 */
- (NSString*)stringByAddingHDSpecifier;

/**
 Creates a filename for a Retina device by appending `@2x` before the file extension.
 */
- (NSString*)stringByAddingRetinaSpecifier;
@end
