//
//  NSString+LWEResolutionHelpers.m
//  Journal
//
//  Created by Mark Makdad on 5/17/12.
//  Copyright (c) 2012 Moneytree. All rights reserved.
//

#import "NSString+LWEResolutionHelpers.h"

@implementation NSString (LWEResolutionHelpers)

//! converts filename string into HD
-(NSString*)stringByAddingHDSpecifier
{
  NSArray *filenameComponents = [self componentsSeparatedByString:@"."];
  NSString *newFilename = [NSString stringWithFormat:@"%@-hd", [filenameComponents objectAtIndex:0]];
  if ([filenameComponents count] > 1)
  {
    newFilename = [NSString stringWithFormat:@"%@.%@", newFilename, [filenameComponents objectAtIndex:1]];
  }
  return newFilename;
}


//! Converts filename string into Retina (@2x)
- (NSString*)stringByAddingRetinaSpecifier
{
  NSString *retinaName = nil;
  NSRange lastPeriod = [self rangeOfString:@"." options:NSBackwardsSearch];
  if (lastPeriod.location == NSNotFound)
  {
    // Append only - there is no extension (ticket #568)
    retinaName = [self stringByAppendingString:@"@2x"];
  }
  else
  {
    retinaName = [self stringByReplacingCharactersInRange:lastPeriod withString:@"@2x."];
  }
  return retinaName;
}

@end
