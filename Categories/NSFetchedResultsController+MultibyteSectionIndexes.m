// NSFetchedResultsController+MultibyteSectionIndexes.m
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

#import "NSFetchedResultsController+MultibyteSectionIndexes.h"

@implementation NSFetchedResultsController (MultibyteSectionIndexes)

/** Overrides sectionIndexTitles property to return a multibyte safe list of indexes (indices) */
-(NSArray*)sectionIndexTitles
{
  // This code avoids outputting mojibake proof
  // Reference: http://hitoshiohtubo.blog.fc2.com/blog-entry-3.html
  NSMutableArray *indexArray = [NSMutableArray array];
  for (id <NSFetchedResultsSectionInfo>s in [self sections])
  {
    NSString *name = [s name];
    if([name length] > 0)
    {
      [indexArray addObject:[name substringFromIndex:0]];
    }
  }
  return (NSArray*)indexArray;
}
@end
