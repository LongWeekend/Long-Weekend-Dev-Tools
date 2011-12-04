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
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "LWEPackage.h"
#import "LWEDecompressor.h"
#import "LWELongRunningTaskProtocol.h"

@class LWEPackageDownloader;
@protocol LWEPackageDownloaderDelegate <NSObject>
@optional
- (void) unpackageFinished:(LWEPackage*)package;
- (void) unpackageFailed:(LWEPackage*)package withError:(NSError*)error;
@end

@protocol LWEPackageDownloaderProgressDelegate <NSObject>
@optional
- (void) packageDownloader:(LWEPackageDownloader *)downloader progressDidUpdate:(CGFloat)progress;
- (void) packageDownloader:(LWEPackageDownloader *)downloader statusDidUpdate:(NSString *)string;
@end

/**
 * This class downloads & unzips "packages".  Any time you have a ZIP file available
 * via HTTP that you want to download, unzip, and do osmething with, this is your class.
 * You can define what is to be downloaded and where it should be unzipped to by 
 * using the LWEPackage class.  
 */
@interface LWEPackageDownloader : NSObject <ASIHTTPRequestDelegate, LWEDecompressorDelegate, LWELongRunningTaskProtocol>

//! Implement this to receive events when a package unwrap succeeds or fails
@property (assign) id<LWEPackageDownloaderDelegate> delegate;

//! Implement this to receive events as the progress completes
@property (assign) id<LWEPackageDownloaderProgressDelegate> progressDelegate;

//! The underlying network queue for HTTP requests to get the packages
@property (retain) ASINetworkQueue *queue;

//! List of packages this class is handling.  Packages are removed from this array after unwrapping/error.
@property (retain) NSArray *packages;

/**
 * Designated initializer.
 */
- (id) initWithDownloaderDelegate:(id<LWEPackageDownloaderDelegate>)aDelegate;

/**
 * Call this method to remove an LWEPackage object.  NOTE that 
 * after a package is unwrapped, this method is called automatically 
 * by the class *BEFORE* the delegate callbacks to -unpackageFinished: or 
 * -unpackageFailed:.  Failed unpackages should be re-queued.
 */
- (void) dequeuePackage:(LWEPackage*)package;

/**
 * Call this method to add an LWEPackage object to the end of the 
 * downloader queue.  Calling this method alone will not start
 * downloading - you must call -startUnwrapping to start the 
 * process.
 */
- (void) queuePackage:(LWEPackage*)package;

/**
 * Starts the queue, downloading & unwrapping each package
 */
- (void) start;

/**
 * Cancels the queue - note that if something is actively downloading, this will not stop it
 */
- (void) cancel;

/**
 * Returns YES if it is possible to call -cancel.
 */
- (BOOL) canCancelTask;

/**
 * Returns YES if it is possible to call -start
 */
- (BOOL) canStartTask;

//! Returns YES if the task is in a successful terminal state.
- (BOOL) isSuccessState;

//! Returns YES if the task is in a failed terminal state.
- (BOOL) isFailureState;


/**
 * Call this method to begin downloading immediately and then
 * unwrap the package.  This bypasses the queue.
 * TODO: consider taking this internal?
 */
- (void) unwrapPackage:(LWEPackage*)package;

@end
