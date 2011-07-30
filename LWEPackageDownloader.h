// LWEPackageDownloader.h
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

#import <Foundation/Foundation.h>
#import "UA_ASINetworkQueue.h"
#import "UA_ASIHTTPRequest.h"
#import "LWEPackage.h"
#import "LWEDecompressor.h"

@protocol LWEPackageDownloaderDelegate <NSObject>
- (void) unpackageFinished:(LWEPackage*)package;
- (void) unpackageFailed:(LWEPackage*)package withError:(NSError*)error;
@end

@interface LWEPackageDownloader : NSObject <UA_ASIHTTPRequestDelegate, LWEDecompressorDelegate>

//! Implement this to receive events when a package unwrap succeeds or fails
@property (assign) id<LWEPackageDownloaderDelegate> delegate;

//! The underlying network queue for HTTP requests to get the packages
@property (retain) UA_ASINetworkQueue *queue;

//! List of packages this class is handling.  Packages are not removed from this array after unwrapping.
@property (retain) NSArray *packages;

/**
 * Call this method to add an LWEPackage object to the end of the 
 * downloader queue.  Calling this method alone will not start
 * downloading - you must call -startUnwrapping to start the 
 * process.
 */
- (void) queuePackage:(LWEPackage*)package;

/**
 * Starts the queue, downloading & unwrapping each package serially
 */
- (void) startUnwrapping;

/**
 * Call this method to begin downloading immediately and then
 * unwrap the package.  This bypasses the queue.
 */
- (void) unwrapPackage:(LWEPackage*)package;

@end
