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
} } while(0)
