/*
 *  LWEDebug.h
 *  jFlash
 *
 *  Created by Ross Sharrott on 2/13/10.
 *  Copyright 2010 LONG WEEKEND LLC. All rights reserved.
 *
 */

// Assertions - for app store do nothing, otherwise assert!
#if defined(LWE_RELEASE_APP_STORE)
  #define LWE_ASSERT(STATEMENT) do { (void) sizeof(STATEMENT); } while(0)
#else
  #define LWE_ASSERT(STATEMENT) do { assert(STATEMENT); } while(0)
#endif

// Errors
#if defined(LWE_RELEASE_APP_STORE) || defined(LWE_RELEASE_ADHOC)
  #define LWE_LOG_ERROR(MSG,...) do {\
  [FlurryAPI logError:MSG message:[NSString stringWithFormat:MSG,## __VA_ARGS__] error:nil]; \
  } while (0)
#else
  #define LWE_LOG_ERROR(MSG,...);
#endif

// Exceptions - for app store, do nothing, otherwise throw!
#if defined(LWE_RELEASE_APP_STORE)
  #define LWE_ASSERT_EXC(STATEMENT,MSG,...) do { (void) sizeof(STATEMENT); } while(0)
#else
  #define LWE_ASSERT_EXC(STATEMENT,MSG,...) do {\
  if (!(STATEMENT)) {\
  [NSException raise:NSGenericException format:MSG,## __VA_ARGS__];\
  }\
  } while (0)
#endif

// For dumping anything to the console
#if defined(LWE_RELEASE_APP_STORE)
  #define LWE_LOG(format, ...);
#else
  #define LWE_LOG(format, ...) NSLog(format, ## __VA_ARGS__);
#endif