// NSArray+LWEEnums.h
//
// Copyright (c) 2011 Long Weekend LLC
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


/********************************************************
 * NSArray Category for adding enum helper methods
 ********************************************************
 *
 * How to Use This?
 
  // 1. In your header file, place an enum declaration in a header file like this
  typedef enum {
    JPG,
    PNG,
    GIF,
    PVR
  } kImageType;

  // 2. Add a macro array of strings corresponding to the enum above
  #define kImageTypeArray @"JPEG", @"PNG", @"GIF", @"PowerVR", nil

  // 3. In your implementation add a property to hold the string array
  self.imageTypeArray = [NSArray arrayWithObjects:kImageTypeArray];
 
  // 4A. You can now do cool things like this ...
  [imageTypeArray stringWithEnum:GIF];                 // returns @"GIF"
  [imageTypeArray enumFromString:@"GIF"];              // returns GIF
  [imageTypeArray enumFromString:@"MOV" default:PNG];  // returns PNG
  
**/

@interface NSArray (LWEEnumExtensions)

//! Converts a string to an enumVal
- (NSString*) stringWithEnum: (NSUInteger) enumVal;

//! Converts a string from an enumVal and supports passing in a default
- (NSUInteger) enumFromString: (NSString*) strVal default: (NSUInteger) def;

//! Converts a string from an enumVal
- (NSUInteger) enumFromString: (NSString*) strVal;

@end
