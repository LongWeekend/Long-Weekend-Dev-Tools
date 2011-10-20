// NSArray+LWEEnums.m
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

@implementation NSArray (LWEEnumExtensions)

//! Converts a string to an enumVal
- (NSString*) stringWithEnum: (NSUInteger) enumVal;
{
  NSString *retVal = nil;
  if([self objectAtIndex:enumVal])
  {
     retVal = [self objectAtIndex:enumVal];
  }
  else
  {
    //[NSException raise:NSInternalInconsistencyException format:@"Enum value does not match index in array!"];
    // Decided this shouldn't fail noisily
    retVal = @"enumUnknown";
  }
  return retVal;
}

//! Converts a string from an enumVal and supports passing in a default
- (NSUInteger) enumFromString: (NSString*) strVal default: (NSUInteger) def;
{
  NSUInteger n = [self indexOfObject:strVal];
  if(n==NSNotFound)
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