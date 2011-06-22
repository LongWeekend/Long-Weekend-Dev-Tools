//
//  NSArray+Enums.m
//  phone
//
//  Created by paul on 9/06/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

@implementation NSArray (LWEEnumExtensions)

//! Converts a string to an enumVal
- (NSString*) stringWithEnum: (NSUInteger) enumVal;
{
  if([self objectAtIndex:enumVal]
  {
     return [self objectAtIndex:enumVal];
  }
  else
  {
    //[NSException raise:NSInternalInconsistencyException format:@"Enum value does not match index in array!"];

    // Decided this shouldn't fail noisily
    return @"enumUnknown";
  }
}

//! Converts a string from an enumVal and supports passing in a default
- (NSUInteger) enumFromString: (NSString*) strVal default: (NSUInteger) def;
{
  NSUInteger n = [self indexOfObject:strVal];
  if(n < 0)
  {
    n = def;
  }
  return n;
}

//! Converts a string from an enumVal
- (NSUInteger) enumFromString: (NSString*) strVal;
{
  return [self enumFromString:strVal default:0];
}

@end