//
//  LWEHDUtils.m
//  jFlash
//
//  Created by Mark Makdad on 8/10/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import "LWERetinaUtils.h"


@implementation LWERetinaUtils

+ (BOOL) isRetinaDisplay
{
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
  {
    return YES;
  }
  else
  {
    return NO;
  }
}


+ (NSString*) retinaSafeImageName:(NSString*)name
{
  if ([LWERetinaUtils isRetinaDisplay])
  {
    NSString *stringToAdd = @"@2x.";
    NSRange lastPeriod = [name rangeOfString:@"." options:NSBackwardsSearch];
    NSString *retinaName = [name stringByReplacingCharactersInRange:lastPeriod withString:stringToAdd];
    return retinaName;
  }
  else
  {
    return name;
  }
}

@end
