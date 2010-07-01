/*
 *  LWEDebug.h
 *  jFlash
 *
 *  Created by Ross Sharrott on 2/13/10.
 *  Copyright 2010 LONG WEEKEND LLC. All rights reserved.
 *
 */

// Assertions
#if defined(APP_STORE_FINAL)
  #define LWE_ASSERT(STATEMENT) do { (void) sizeof(STATEMENT); } while(0)
#else
  #define LWE_ASSERT(STATEMENT) do { assert(STATEMENT); } while(0)
#endif

// For dumping dictionaries to the console
#if defined(APP_STORE_FINAL)
  #define LWE_DICT_DUMP(objectname);
#else
  #define LWE_DICT_DUMP(objectname) do \
  { \
    NSEnumerator *LWEDebug_enum = [objectname keyEnumerator]; \
    NSString *LWEDebug_key = nil; \
    while (LWEDebug_key = [LWEDebug_enum nextObject]) \
    { \
      NSLog(@"Key '%@': %@",LWEDebug_key,[objectname objectForKey:LWEDebug_key]); \
    } \
  } while (0)
#endif

// For dumping anything to the console
#if defined(APP_STORE_FINAL)
  #define LWE_LOG(format, ...);
#else
  #define LWE_LOG(format, ...) NSLog(format, ## __VA_ARGS__);
//  #define LWE_LOG(format, ...) NSLog([NSString stringWithFormat: format, ## __VA_ARGS__]);
#endif