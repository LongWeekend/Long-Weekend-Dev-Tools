/*
 *  LWEMacros.h
 *  phone
 *
 *  Created by Mark Makdad on 1/31/11.
 *  Copyright 2011 Long Weekend LLC. All rights reserved.
 *
 */

#define LWE_DELEGATE_CALL(SELECTOR,OBJ) do { \
if (self.delegate && ([self.delegate respondsToSelector:SELECTOR])) \
{\
  [self.delegate performSelector:SELECTOR withObject:OBJ];\
}\
else\
{\
  NSLog(@"Delegate is not set or does not respond to SELECTOR");\
}\
} while(0)

#define LWE_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]