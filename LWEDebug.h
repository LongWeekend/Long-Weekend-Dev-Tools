/*
 *  LWEDebug.h
 *  jFlash
 *
 *  Created by Ross Sharrott on 2/13/10.
 *  Copyright 2010 LONG WEEKEND LLC. All rights reserved.
 *
 */

// Assertions
#if defined(LWE_RELEASE_APP_STORE)
  #define LWE_ASSERT(STATEMENT) do { (void) sizeof(STATEMENT); } while(0)
#else
  #define LWE_ASSERT(STATEMENT) do { assert(STATEMENT); } while(0)
#endif

// For dumping anything to the console
#if defined(LWE_RELEASE_APP_STORE)
#define LWE_LOG(format, ...);
#else
#define LWE_LOG(format, ...) NSLog(format, ## __VA_ARGS__);
//  #define LWE_LOG(format, ...) NSLog([NSString stringWithFormat: format, ## __VA_ARGS__]);
#endif