// LWEDateUtils.m
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

#import "LWEDateUtils.h"

@implementation NSDateFormatter (LWEUtilities)

/**
 * This method exists in NSDateFormatter in iOS4 but not before that,
 * so this convenience method helps us cut down on extra code w/o requiring
 * iOS4.
 */
+ (NSString*) localizedStringFromDate:(NSDate*)inputDate dateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle useRelative:(BOOL)relative
{
  NSDateFormatter *tmpFormatter = [[[NSDateFormatter alloc] init] autorelease];
  [tmpFormatter setDateStyle:dateStyle];
  [tmpFormatter setTimeStyle:timeStyle];
  
  // This is an iOS4 call
  if ([tmpFormatter respondsToSelector:@selector(setDoesRelativeDateFormatting:)])
  {
    [tmpFormatter setDoesRelativeDateFormatting:relative];
  }
  return [tmpFormatter stringFromDate:inputDate];
}

/**
 * This method exists in NSDateFormatter in iOS4 but not before that,
 * so this convenience method helps us cut down on extra code w/o requiring
 * iOS4.
 */
+ (NSString*) localizedStringFromDate:(NSDate*)inputDate dateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
  return [[self class] localizedStringFromDate:inputDate dateStyle:dateStyle timeStyle:timeStyle useRelative:NO];
}

@end
