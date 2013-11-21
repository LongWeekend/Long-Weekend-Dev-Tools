// LWEMacros.h
//
// Copyright (c) 2011 Long Weekend LLC
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

#pragma mark - Delegate Stuff

#define LWE_DELEGATE_CALL(SELECTOR,OBJ) do { \
if (self.delegate && ([self.delegate respondsToSelector:SELECTOR])) \
{\
  [self.delegate performSelector:SELECTOR withObject:OBJ];\
}\
} while(0)

#pragma mark - Timers

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

#pragma mark - NSString 

// Equality for a double variable.
// Return `YES` if X (double) is equal to Y (double)
#define fequal(x,y) (fabs(x-y) < DBL_EPSILON)

//Convert a preprocessor symbol to an NSString
//EXAMPLE//  NSString *version = CONVERT_SYMBOL_TO_NSSTRING(SRC_ROOT);

#define CONVERT_SYMBOL_TO_NSSTRING_2(x) @#x
#define CONVERT_SYMBOL_TO_NSSTRING(x) CONVERT_SYMBOL_TO_NSSTRING_2(x)
