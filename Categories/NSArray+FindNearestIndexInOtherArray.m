// NSArray+FindNearestIndexInOtherArray.m
//
// Copyright (c) 2012 Long Weekend LLC
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

#import "NSArray+FindNearestIndexInOtherArray.h"

@implementation NSArray (FindNearestIndexInOtherArray)

/**
 * Finds nearest object in one array (self) that exists in another given array (otherArray).
 * Useful for UITableView indexes that display more section letters than there are sections for.
 * Searches forward or backward from the specified index and chooses the "closest" one.
 *
 * Returns NSNotFound is no match was found. Uses [NSObject isEqual:] method for comparison.
 *
 * @params object The index in array "self" to the object we want matched in the other array
 * @params otherArray The other array, containing potentially fewer objects, fro which we want the nearest match
*/
-(NSInteger)findNearestIndex:(NSInteger)index inOtherArray:(NSArray*)otherArray
{
  NSArray *sourceArray = self;
  NSString *targetObject = [self objectAtIndex:index]; // the object we want
  NSInteger startIdx = index; // index of letter we want (e.g. @"D")
  
  NSInteger fwdSteps = 0;
  NSInteger fwdMatchIdx = NSIntegerMax;
  
  // loop forwards until we find a matching letter
  for (int targetIdx = startIdx; targetIdx < [sourceArray count]; targetIdx++)
  {
    targetObject = [sourceArray objectAtIndex:targetIdx];
    if([otherArray containsObject:targetObject])
    {
      fwdMatchIdx = [otherArray indexOfObject:targetObject];
      break;
    }
    fwdSteps++;
  }
  
  NSInteger bkwdSteps = 0;
  NSInteger bkwdMatchIdx = NSIntegerMax;
  
  if(startIdx-1 > 0)
  {
    // loop backwards until we find a matching letter
    for (int targetIdx = startIdx-1; targetIdx >= 0; targetIdx--)
    {
      targetObject = [sourceArray objectAtIndex:targetIdx];
      if([otherArray containsObject:targetObject])
      {
        bkwdMatchIdx = [otherArray indexOfObject:targetObject];
        break;
      }
      bkwdSteps++;
    }
  }
  
  BOOL bkwdMatchFound  = (bkwdMatchIdx != NSIntegerMax);
  BOOL fwdMatchFound   = (fwdMatchIdx != NSIntegerMax);
  BOOL fwdMatchNearest = (fwdSteps <= bkwdSteps);
  
  // if a fwd match is found in less/equal steps, show it
  if((fwdMatchFound && fwdMatchNearest) || (fwdMatchFound && bkwdMatchFound == NO))
  {
    //LWE_LOG(@"** fwd match used (in %d steps) **", fwdSteps);
    return fwdMatchIdx;
  }
  // otherwise show a backwards match
  else if(bkwdMatchFound)
  {
    //LWE_LOG(@"** bkwd match used (in %d steps) **", bkwdSteps);
    return bkwdMatchIdx;
  }
  
  // otherwise return NSNotFound
  return NSNotFound;
}

@end
