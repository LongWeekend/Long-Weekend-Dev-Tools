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
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2 && ![LWERetinaUtils isPadDevice])
  {
    return YES;
  }
  else
  {
    return NO;
  }
  
}

+(BOOL) isPadDevice {
  BOOL isPadDevice=NO;
  NSString* model = [UIDevice currentDevice].model;
  if ([model rangeOfString:@"iPad"].location != NSNotFound) 
  {
    return YES;
  }
  return isPadDevice;
}

+ (NSString*) retinaFilenameForName: (NSString *) name
{
  NSString *stringToAdd = @"@2x.";
  NSRange lastPeriod = [name rangeOfString:@"." options:NSBackwardsSearch];
  NSString *retinaName = [name stringByReplacingCharactersInRange:lastPeriod withString:stringToAdd];
  return retinaName;
}

+ (NSString*) retinaSafeImageName:(NSString*)name
{
  if ([LWERetinaUtils isRetinaDisplay])
  {
    return [[self class] retinaFilenameForName:name];
  }
  else
  {
    return name;
  }
}

+ (CGRect) retinaSafeCGRect:(CGRect)rect
{
  if ([LWERetinaUtils isRetinaDisplay])
  {
    rect.size.width = rect.size.width * 2.0f;
    rect.size.height = rect.size.height * 2.0f;
    rect.origin.x = rect.origin.x * 2.0f;
    rect.origin.y = rect.origin.y * 2.0f;
  }
  return rect;
}

+ (CGPoint) retinaSafeCGPoint:(CGPoint)point
{
  if ([LWERetinaUtils isRetinaDisplay])
  {
    point.x = point.x * 2.0f;
    point.y = point.y * 2.0f;
  }
  return point;
}

+ (NSInteger) retinaSafeDimension:(NSInteger)dimension
{
  if ([LWERetinaUtils isRetinaDisplay])
  {
    return dimension *2;
  }
  else
  {
    return dimension;
  }
}

@end
