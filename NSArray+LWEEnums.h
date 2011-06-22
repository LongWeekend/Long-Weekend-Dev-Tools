//
//  NSArray+Enums.h
//  phone
//
//  Created by paul on 9/06/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

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
