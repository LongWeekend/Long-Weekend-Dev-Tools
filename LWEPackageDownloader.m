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
- (UA_ASIHTTPRequest*) _requestForPackage:(LWEPackage*)package;
@end

@implementation LWEPackageDownloader
@synthesize queue;
@synthesize packages;
@synthesize delegate;

NSString * const kLWEPackageDownloaderTempDirectory = @"LWEPackageDownloader";
NSString * const kLWEPackageUserInfoKey = @"LWEPackage";

#pragma mark - Class Setup/Teardown

- (id) init
{
  self = [super init];
  if (self)
  {
    self.queue = [UA_ASINetworkQueue queue];
    self.packages = [NSArray array];
    
    // Will throttle bandwidth based on a user-defined limit when WWAN (not Wi-Fi) is active
    [UA_ASIHTTPRequest throttleBandwidthForWWANUsingLimit:14800];
  }
  return self;
}

- (void) dealloc
{
  [self.queue cancelAllOperations];
  [queue release];
  [packages release];
  [super dealloc];
}

#pragma mark - Public Methods

- (void) unwrapPackage:(LWEPackage*)package
{
  LWE_ASSERT_EXC([self.packages containsObject:package] == NO,@"You can't manually unpackage a queued package.");
  UA_ASIHTTPRequest *request = [self _requestForPackage:package];
  [request start];
}

- (void) startUnwrapping
{
  // Create the final temporary directory in the library folder if we need to
  NSError *error = nil;
  NSString *downloadTempDirectory = [LWEFile createLibraryPathWithFilename:kLWEPackageDownloaderTempDirectory];
  if ([LWEFile createDirectoryIfNotExisting:downloadTempDirectory withIntermediateDirectories:YES attributes:nil error:&error])
  {
    for (LWEPackage *package in self.packages)
    {
      UA_ASIHTTPRequest *request = [self _requestForPackage:package];
      [self.queue addOperation:request];
    }
    [self.queue go];
  }
  else
  {
    LWE_LOG_ERROR(@"Error creating temporary download directory: %@, error: %@",downloadTempDirectory,error);
  }
}

- (void) queuePackage:(LWEPackage*)package
{
  NSMutableArray *newPackages = [self.packages mutableCopy];
  [newPackages addObject:package];
  self.packages = (NSArray*)[newPackages autorelease];
}

#pragma mark - Privates

- (UA_ASIHTTPRequest*) _requestForPackage:(LWEPackage*)package
{
  UA_ASIHTTPRequest *request = [UA_ASIHTTPRequest requestWithURL:package.packageUrl];
  request.userInfo = [NSDictionary dictionaryWithObject:package forKey:kLWEPackageUserInfoKey];
  request.downloadDestinationPath = package.destinationFilepath;      // The full file will be moved here if and when the request completes successfully
  request.temporaryFileDownloadPath = [LWEFile createLibraryPathWithFilename:[NSString stringWithFormat:@"%@/%@",kLWEPackageDownloaderTempDirectory,[package packageFilename]]];
  request.allowResumeForFileDownloads = YES;
  request.delegate = self;
  return request;
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestReceivedResponseHeaders:(UA_ASIHTTPRequest *)request
{
  LWE_LOG(@"Server Header Response: %d, %@", request.responseStatusCode, request.responseHeaders);
  
  // Handle server error
  if (request.responseStatusCode != 200 && request.responseStatusCode != 206) 
  {    
    // TODO: fail to the delegate!
    LWE_LOG_ERROR(@"Failure downloading content, headers: %@",request.requestHeaders);
  }
}

- (void)requestFinished:(UA_ASIHTTPRequest *)request
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
}

- (void)requestFailed:(UA_ASIHTTPRequest *)request
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
  
  LWE_DELEGATE_CALL(@selector(unpackageFinished:),package);
}

- (void) decompressFailed:(LWEDecompressor*)aDecompressor error:(NSError*)error
{
  LWEPackage *package = [aDecompressor.userInfo objectForKey:kLWEPackageUserInfoKey];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(unpackageFailed:withError:)])
  {
    [self.delegate unpackageFailed:package withError:error];
  }
}

@end
