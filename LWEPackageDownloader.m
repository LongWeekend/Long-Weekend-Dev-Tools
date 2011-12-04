// LWEPackageDownloader.m
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

#import "LWEPackageDownloader.h"
#import "LWEFile.h"

// Private Method Prototypes
@interface LWEPackageDownloader ()
- (ASIHTTPRequest*) _requestForPackage:(LWEPackage *)package;
- (void) _updateStatusMessage:(NSString *)status;
@property (retain) NSString *currentStatus;
@end

@implementation LWEPackageDownloader
@synthesize queue;
@synthesize packages;
@synthesize delegate, progressDelegate;
@synthesize currentStatus;

NSString * const kLWEPackageDownloaderTempDirectory = @"LWEPackageDownloader";
NSString * const kLWEPackageUserInfoKey = @"LWEPackage";

#pragma mark - Class Setup/Teardown

- (id) init
{
  self = [super init];
  if (self)
  {
    self.queue = [ASINetworkQueue queue];
    self.queue.downloadProgressDelegate = self;
    self.packages = [NSArray array];
    
    // Will throttle bandwidth based on a user-defined limit when WWAN (not Wi-Fi) is active
    [ASIHTTPRequest throttleBandwidthForWWANUsingLimit:14800];
  }
  return self;
}

- (id) initWithDownloaderDelegate:(id<LWEPackageDownloaderDelegate>)aDelegate
{
  self = [self init];
  if (self)
  {
    self.delegate = aDelegate;
  }
  return self;
}

- (void) dealloc
{
  [self.queue cancelAllOperations];
  self.queue.delegate = nil;
  self.queue.downloadProgressDelegate = nil;
  [currentStatus release];
  [queue release];
  [packages release];
  [super dealloc];
}

#pragma mark - Public Methods

// TODO: Let's get rid of this guy if we can. MMA 11.29.2011
- (void) unwrapPackage:(LWEPackage*)package
{
  LWE_ASSERT_EXC([self.packages containsObject:package] == NO,@"You can't manually unpackage a queued package.");
  ASIHTTPRequest *request = [self _requestForPackage:package];
  request.downloadProgressDelegate = self;
  [request start];
}


- (BOOL) isSuccessState
{
  // This is wrong
  return (self.queue.operationCount == 0);
}

- (BOOL) isFailureState
{
  // This is wrong
  return (self.queue.operationCount == 0);
}

- (BOOL) isActive
{
  return (self.queue.isSuspended == NO);
}

- (BOOL) canCancelTask
{
  return [self isActive];
}

- (BOOL) canStartTask
{
  return self.queue.isSuspended;
}

- (void) start
{
  // Create the final temporary directory in the library folder if we need to
  NSError *error = nil;
  NSString *downloadTempDirectory = [LWEFile createLibraryPathWithFilename:kLWEPackageDownloaderTempDirectory];
  if ([LWEFile createDirectoryIfNotExisting:downloadTempDirectory withIntermediateDirectories:YES attributes:nil error:&error])
  {
    for (LWEPackage *package in self.packages)
    {
      ASIHTTPRequest *request = [self _requestForPackage:package];
      [self.queue addOperation:request];
    }
    [self.queue go];
    [self _updateStatusMessage:NSLocalizedString(@"Connecting to server", @"LWEPackageDownloader.Status.ConnectingToServer")];
  }
  else
  {
    LWE_LOG_ERROR(@"Error creating temporary download directory: %@, error: %@",downloadTempDirectory,error);
  }
}

- (CGFloat) progress
{
  return ((CGFloat)self.queue.bytesDownloadedSoFar / (CGFloat)self.queue.totalBytesToDownload);
}

- (void) cancel
{
  [self.queue cancelAllOperations];
}

- (NSString *) taskMessage
{
  return self.currentStatus;
}

- (void) dequeuePackage:(LWEPackage*)package
{
  NSMutableArray *newPackages = [self.packages mutableCopy];
  [newPackages removeObject:package];
  self.packages = (NSArray*)[newPackages autorelease];
}

- (void) queuePackage:(LWEPackage*)package
{
  NSMutableArray *newPackages = [self.packages mutableCopy];
  [newPackages addObject:package];
  self.packages = (NSArray*)[newPackages autorelease];
}

#pragma mark - Privates

- (ASIHTTPRequest*) _requestForPackage:(LWEPackage*)package
{
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:package.packageUrl];
  request.userInfo = [NSDictionary dictionaryWithObject:package forKey:kLWEPackageUserInfoKey];
  request.downloadDestinationPath = package.destinationFilepath;      // The full file will be moved here if and when the request completes successfully
  request.temporaryFileDownloadPath = [LWEFile createLibraryPathWithFilename:[NSString stringWithFormat:@"%@/%@",kLWEPackageDownloaderTempDirectory,[package packageFilename]]];
  request.allowResumeForFileDownloads = YES;
  request.delegate = self;
  return request;
}

- (void) _updateStatusMessage:(NSString*)status
{
  self.currentStatus = status;
  if (self.progressDelegate && [self.progressDelegate respondsToSelector:@selector(packageDownloader:statusDidUpdate:)])
  {
    [self.progressDelegate packageDownloader:self statusDidUpdate:status];
  }
}

#pragma mark - ASIHTTPRequestDelegate

- (void)setProgress:(CGFloat)newProgress
{
  // Just pass this on to our delegate
  if (self.progressDelegate && [self.progressDelegate respondsToSelector:@selector(packageDownloader:progressDidUpdate:)])
  {
    [self.progressDelegate packageDownloader:self progressDidUpdate:newProgress];
  }

  // Total amount downloaded so far for all requests in this queue
  NSInteger kbDownloaded = (NSInteger)((CGFloat)self.queue.bytesDownloadedSoFar / 1024.0f);
  NSString *status = [NSString stringWithFormat:NSLocalizedString(@"Downloading (%d KB)",@"LWEPackageDownloader.status.DownloadingWithKB"),kbDownloaded];
  [self _updateStatusMessage:status];
}

- (void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request
{
  LWE_LOG(@"Server Header Response: %d, %@", request.responseStatusCode, request.responseHeaders);
  
  // Handle server error
  if (request.responseStatusCode != 200 && request.responseStatusCode != 206) 
  {    
    // TODO: fail to the delegate!
    LWE_LOG_ERROR(@"Failure downloading content, headers: %@",request.requestHeaders);
  }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
  LWEPackage *package = (LWEPackage*)[request.userInfo objectForKey:kLWEPackageUserInfoKey];
  LWE_ASSERT_EXC(package,@"This request had no package associated with it!");

  // TODO: MMA this logic should really be in the decompressor.
  NSString *ext = [request.downloadDestinationPath pathExtension];
  LWE_ASSERT_EXC(([ext caseInsensitiveCompare:@"zip"] == NSOrderedSame),@"Download extension must be zip, was '%@'",ext);
  
  // Decompress the content, passing the user info along so we can keep the package.
  LWEDecompressor *decompressor = [LWEDecompressor decompressorWithDelegate:self];
  decompressor.userInfo = request.userInfo;
  [decompressor decompressContentAtPath:request.downloadDestinationPath
                                 toPath:package.unpackagePath asynchronously:YES];
  
  [self _updateStatusMessage:NSLocalizedString(@"Decompressing", @"LWEPackageDownloader.Status.Decompressing")];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  LWEPackage *package = [request.userInfo objectForKey:kLWEPackageUserInfoKey];
  if (self.delegate && [self.delegate respondsToSelector:@selector(unpackageFailed:withError:)])
  {
    [self.delegate unpackageFailed:package withError:request.error];
  }
}

#pragma mark - LWEDecompressorDelegate

- (void) decompressFinished:(LWEDecompressor*)aDecompressor
{
  LWEPackage *package = [aDecompressor.userInfo objectForKey:kLWEPackageUserInfoKey];
  package.isUnwrapped = YES;
  [self dequeuePackage:package];
  [self _updateStatusMessage:NSLocalizedString(@"Finished", @"LWEPackageDownloader.Status.Finished")];
  LWE_DELEGATE_CALL(@selector(unpackageFinished:),package);
}

- (void) decompressFailed:(LWEDecompressor*)aDecompressor error:(NSError*)error
{
  LWEPackage *package = [aDecompressor.userInfo objectForKey:kLWEPackageUserInfoKey];
  [self dequeuePackage:package];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(unpackageFailed:withError:)])
  {
    [self.delegate unpackageFailed:package withError:error];
  }
}

@end
