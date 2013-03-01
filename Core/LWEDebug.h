// LWEDebug.h
//
// Copyright (c) 2010, 2011 Long Weekend LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


// Assertions - for app store do nothing, otherwise assert!
#if defined(LWE_RELEASE_APP_STORE)
  #define LWE_ASSERT(STATEMENT) do { (void) sizeof(STATEMENT); } while(0)
#else
  #define LWE_ASSERT(STATEMENT) do { assert(STATEMENT); } while(0)
#endif

// Errors - do nothing in production, crash otherwise
#if defined(LWE_RELEASE_APP_STORE) || defined(LWE_RELEASE_ADHOC)
  #define LWE_LOG_ERROR(MSG,...);
#else
  #define LWE_LOG_ERROR(MSG,...) do {\
  [NSException raise:NSGenericException format:MSG,## __VA_ARGS__];\
  } while (0)
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

// Throws an exception if we have the wrong type.
#define LWE_ASSERT_TYPE(OBJ,EXPECTED) do { LWE_ASSERT_EXC(([OBJ isKindOfClass:EXPECTED]), @"Expected class type: %@, got class type: %@ (obj was: %@)", EXPECTED, [OBJ class], OBJ); } while(0)

// Throws an exception if we dont conforms to a specific protocol
#define LWE_ASSERT_PROTOCOL(OBJ,EXPECTED_PROTOCOL) do { LWE_ASSERT_EXC(([OBJ conformsToProtocol:EXPECTED_PROTOCOL]), @"Object: %@ is expected to conforms with protocol: %@, (obj was: %@)", OBJ, EXPECTED_PROTOCOL, [OBJ class]); } while(0)

// For dumping anythiang to the console
#if defined(LWE_RELEASE_APP_STORE)
  #define LWE_LOG(format, ...);
#else
  #define LWE_LOG(format, ...) NSLog(format, ## __VA_ARGS__);
#endif