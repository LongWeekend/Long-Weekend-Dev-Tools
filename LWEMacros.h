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
  NSLog(@"Delegate does not respond to selector SELECTOR");\
}\
} while(0)