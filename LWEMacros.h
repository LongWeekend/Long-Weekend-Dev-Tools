/*
 *  LWEMacros.h
 *  phone
 *
 *  Created by Mark Makdad on 1/31/11.
 *  Copyright 2011 Long Weekend LLC. All rights reserved.
 *
 */

// Delegate stuff

#define LWE_DELEGATE_CALL(SELECTOR,OBJ) do { \
if (self.delegate && ([self.delegate respondsToSelector:SELECTOR])) \
{\
  [self.delegate performSelector:SELECTOR withObject:OBJ];\
}\
else\
{\
  NSLog(@"Delegate is not set, or does not respond to %@,",NSStringFromSelector(SELECTOR));\
}\
} while(0)

// UI Color

#define LWE_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// Timers!

//! Use this one in the dealloc method
#define LWE_DEALLOC_TIMER(OBJ) do { \
[OBJ invalidate];\
[OBJ release];\
} while(0)

//! Use this in other methods with a "self." timer - don't use with a non-retain synthesized retain setter timer (self.something) otherwise it will leak!
#define LWE_STOP_TIMER(OBJ) do { \
if (OBJ)\
{\
  if ([OBJ isValid]) {\
    [OBJ invalidate];\
  }\
  else\
  {\
    NSLog(@"Tried to stop timer: %@ but it is not valid, setting to nil",OBJ);\
  }\
  OBJ = nil;\
}\
} while(0)
