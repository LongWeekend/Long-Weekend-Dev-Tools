//
//  LWEDecompressor.m
//  phone
//
//  Created by Mark Makdad on 6/20/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "LWEDecompressor.h"
#import "UA_ZipArchive.h"

// Private method
@interface LWEDecompressor ()
- (void) _decompressContentAtPath:(NSString*)contentPath;
- (void) _decompressFinished;
- (void) _failWithError:(NSError*)error;
- (void) _failWithErrorOnMainThread:(NSError*)error;
@end


@implementation LWEDecompressor

@synthesize compressedContentFilepath, decompressedContentPath;
@synthesize delegate, isDecompressing = _isDecompressing, userInfo;

#pragma mark -
#pragma mark Decompress

/**
 * Pass this an ASIHTTPRequest with a file download to have the file decompressed.
 * The decompression will happen on a background thread and your delegate
 * will receive a callback when done.
 */
- (void)decompressContentAtPath:(NSString*)zipPath toPath:(NSString*)unzippedPath asynchronously:(BOOL)asynch
{
  LWE_ASSERT_EXC(zipPath,@"You can't call this method if the request didn't download its contents to a file.");
  LWE_ASSERT_EXC(unzippedPath,@"Must provide an unzipped path!");
  LWE_ASSERT_EXC(_isDecompressing == NO, @"You can't call this when you're actively decompressing something with the same object");

  @synchronized(self)
  {
    _isDecompressing = YES;
    
    self.compressedContentFilepath = zipPath;
    self.decompressedContentPath = unzippedPath;
    
    // Yes, we actually want to retain self here.  This means that THIS object is interested in 
    // itself - it WANTS to live until the code returns from the background thread.
    // Mimics the functionality of NSURLConnection - it hangs out on its own after you start it.
    [self retain];
    
    if (asynch)
    {
      [self performSelectorInBackground:@selector(_decompressContentAtPath:) withObject:zipPath];
    }
    else
    {
      [self _decompressContentAtPath:zipPath];
    }
  }
}


// TODO: MMA implement GZIP decompression in this class

/**
 * Unzips the downloaded file (gzip ONLY)
 */
/*- (BOOL) _unzipDownloadedFile
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  LWE_LOG(@"Unzip for file: %@",_compressedFilename);
  LWE_LOG(@"Target filename: %@",[self targetFilename]);
  
  gzFile file = gzopen([_compressedFilename UTF8String], "rb");
  FILE *dest = fopen([[self targetFilename] UTF8String], "w");
  unsigned char buffer[CHUNK];
  int uncompressedLength;
  int totalUncompressed = 0;
  
  // This is a hack but I am NO C programmer.  I Cannot figure out the uncompressed size of a zip file to save my life
  // Despite googling it... apparently the last four bytes of the file contain the answer but good luck getting that to work
  int guessedFilesize = (requestSize * 2.4);
  float decompressionProgress = 0.0f;
  
  while (uncompressedLength = gzread(file, buffer, CHUNK))
  {
    // Update progress bar
    totalUncompressed = totalUncompressed + CHUNK;
    if (requestSize > 0) decompressionProgress = ((float)totalUncompressed / (float)guessedFilesize);
    
    // Don't do this EVERY time
    if ((totalUncompressed % (CHUNK * 10)) == 0)
    {
      [self performSelectorOnMainThread:@selector(setProgressFromBackgroundThread:) withObject:[NSNumber numberWithFloat:decompressionProgress] waitUntilDone:NO];
    }
    
    // Check for cancellation
    if (_unzipShouldCancel)
    {
      LWE_LOG(@"Cancelling unzip");
      [self _updateInternalState:kDownloaderCancelled withTaskMessage:NSLocalizedString(@"Download cancelled",@"LWEDownloader.cancelled")];
      [pool release];
      return NO;
    }
    if (fwrite(buffer, 1, uncompressedLength, dest) != uncompressedLength || ferror(dest))
    {
      LWE_LOG(@"error writing data");
      [self _updateInternalState:kDownloaderDecompressFail withTaskMessage:NSLocalizedString(@"Failed to decompress",@"LWEDownloader.decompressFail")];
      [pool release];
      return NO;
    }
  }
  fclose(dest);
  gzclose(file);
  
  // TODO: just in case our hack above didn't work
  [self setProgress:1.0];
  
  // Delete the temporary download file
  [LWEFile deleteFile:_compressedFilename];
  
  // Get our main thread involved again on the next step
  [self performSelectorOnMainThread:@selector(_verifyDownload) withObject:nil waitUntilDone:NO];
  [pool release];
  return YES;
}

*/


/**
 * Private method, called in the background
 */
- (void) _decompressContentAtPath:(NSString*)contentPath
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  UA_ZipArchive *za = [[[UA_ZipArchive alloc] init] autorelease];
  
  // 1. Make sure we can open the file (e.g the path exists & we have permission)
  if ([za UnzipOpenFile:contentPath] == NO) 
  {
    NSString *errorMsg = [NSString stringWithFormat:@"File not found/able to be opened: %@",contentPath];
    NSDictionary *errUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorMsg,NSLocalizedDescriptionKey,nil];
    // TODO: get a proper error domain here
    NSError *error = [NSError errorWithDomain:@"LWEDomain" code:1 userInfo:errUserInfo];
    [self _failWithError:error];
    [pool release];
    return;
  }
  
  // 2. Unzip it
  BOOL success = [za UnzipFileTo:self.decompressedContentPath overWrite:YES];
  if (success == NO)
  {
    NSString *errorMsg = [NSString stringWithFormat:@"File not able to be unzipped: %@",contentPath];
    NSDictionary *errUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorMsg,NSLocalizedDescriptionKey,nil];

    // TODO: get a proper error domain here
    NSError *error = [NSError errorWithDomain:@"LWEDomain" code:2 userInfo:errUserInfo];
    [self _failWithError:error];
    [pool release];
    return;
  }
  
  // 3. Can we delete the original?
  NSError *error = nil;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager removeItemAtPath:contentPath error:&error] == NO)
  {
    // Pass down their error.
    [self _failWithError:error];
    [pool release];
    return;
  }
  
  // request is retained until after the selector is performed
  [self performSelectorOnMainThread:@selector(_decompressFinished) withObject:nil waitUntilDone:NO];
  [za UnzipCloseFile];
  
  [pool release];

  // Get rid of the extra retain count on us now that we are done
  [self release];
  _isDecompressing = NO;
}


/**
 * Simple delegate callback on completion
 */
- (void) _decompressFinished
{
  LWE_DELEGATE_CALL(@selector(decompressFinished:),self);
}


/**
 * Used for failing on either thread
 */
- (void) _failWithError:(NSError*)error
{
  if ([NSThread isMainThread])
  {
    [self _failWithErrorOnMainThread:error];
  }
  else
  {
    [self performSelectorOnMainThread:@selector(_failWithErrorOnMainThread:) withObject:error waitUntilDone:[NSThread isMainThread]];
  }
  
  // Get rid of the extra retain count on us now that we are done
  [self release];
  _isDecompressing = NO;
}

/**
 * Fail callback to the delegate
 */
- (void) _failWithErrorOnMainThread:(NSError*)error
{
  LWE_ASSERT_EXC([NSThread isMainThread],@"you can only call this from the main thread");
  if (self.delegate && [self.delegate respondsToSelector:@selector(decompressFailed:error:)])
  {
    [self.delegate decompressFailed:self error:error];
  }
}

#pragma mark - Class Plumbing

+ (id) decompressorWithDelegate:(id<LWEDecompressorDelegate>)aDelegate
{
  return [[[[self class] alloc] initWithDelegate:aDelegate] autorelease];
}

- (id) initWithDelegate:(id<LWEDecompressorDelegate>)aDelegate
{
  self = [super init];
  if (self)
  {
    self.delegate = aDelegate;
  }
  return self;
}

- (void) dealloc
{
  [userInfo release];
  [compressedContentFilepath release];
  [decompressedContentPath release];
  [super dealloc];
}


@end
