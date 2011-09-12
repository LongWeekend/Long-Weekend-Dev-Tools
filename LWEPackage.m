// LWEPackage.m
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

#import "LWEPackage.h"

@implementation LWEPackage

@synthesize packageUrl, destinationFilepath, unpackagePath, isUnwrapped, userInfo;

//! Initializer, conveninence method autoreleased
+ (id) packageWithUrl:(NSURL*)url destinationFilepath:(NSString*)filepath
{
  LWEPackage *package = [[[LWEPackage alloc] init] autorelease];
  package.destinationFilepath = filepath;
  package.packageUrl = url;
  package.isUnwrapped = NO;
  
  // This sets the unpackaging to happen as the same dir as the destination file, default behavior
  package.unpackagePath = [filepath stringByDeletingLastPathComponent];
  return package;
}

//! Trims out everything but the filename of the URL to be unwrapped
- (NSString *) packageFilename
{
  NSString *returnVal = nil;
  NSString *urlString = [self.packageUrl path];
  NSRange range = [urlString rangeOfString:@"/" options:NSBackwardsSearch];
  if (range.location != NSNotFound)
  {
    returnVal = [urlString substringFromIndex:(range.location+1)];
  }
  return returnVal;
}

//! Trims the extension off of -packageFilename
- (NSString *) packageName
{
  return [[self packageFilename] stringByDeletingPathExtension];
}

- (void) dealloc
{
  [userInfo release];
  [packageUrl release];
  [unpackagePath release];
  [destinationFilepath release];
  [super dealloc];
}

@end
