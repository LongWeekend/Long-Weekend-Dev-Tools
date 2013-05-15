// LWEFile.m
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

#import "LWEFile.h"
#import "LWEDebug.h"
#include <sys/xattr.h>

@implementation LWEFile

/**
 * Creates a directory.  This method will create intermediary directories (recursive) as necessary.
 * \param pathname the full path to the directory to be created
 * \param error an NSError object passed by reference
 */
+ (BOOL) createDirectory:(NSString*)pathname error:(NSError**)error
{
  NSFileManager *fm = [NSFileManager defaultManager];
  return [fm createDirectoryAtPath:pathname withIntermediateDirectories:YES attributes:nil error:error];
}

/**
 * Takes a single filename and returns a full path pointing at that filename in the main bundle
 */
+ (NSString*) createBundlePathWithFilename:(NSString*)filename
{
  NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
  return bundlePath;
}


/**
 * Takes a single filename and returns a full path pointing at that filename in the current app's document directory
 */
+ (NSString*) createDocumentPathWithFilename:(NSString*)filename
{
  NSString *returnVal = nil;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  if (paths && [paths count] > 0)
  {
    NSString *documentsDirectory = [paths objectAtIndex:0];
    returnVal = [documentsDirectory stringByAppendingPathComponent:filename];
  }
  return returnVal;
}


/**
 * Takes a single filename and returns a full path pointing at that filename in the current app's library directory
 */
+ (NSString*) createLibraryPathWithFilename:(NSString*)filename
{
  NSString *returnVal = nil;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  if (paths && [paths count] > 0)
  {
    NSString *documentsDirectory = [paths objectAtIndex:0];
    returnVal = [documentsDirectory stringByAppendingPathComponent:filename];
  }
  return returnVal;
}

/**
 * Takes a single filename and returns a full path pointing at that filename in the current app's library/Caches directory
 */
+ (NSString*) createCachesPathWithFilename:(NSString*)filename
{
  NSString *returnVal = nil;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  if (paths && [paths count] > 0)
  {
    NSString *documentsDirectory = [paths objectAtIndex:0];
    returnVal = [documentsDirectory stringByAppendingPathComponent:filename];
  }
  return returnVal;
}

/**
 * Creates a temporary path with a filename
 */
+ (NSString*) createTemporaryPathWithFilename:(NSString*) filename
{
  NSString *returnVal = nil;
  NSString *tmpDir = NSTemporaryDirectory();
  if (tmpDir)
  {
    returnVal = [NSString stringWithFormat:@"%@%@",tmpDir,filename];
  }
  return returnVal;
}


/**
 * Returns the app's base directory
 */
+ (NSString*) applicationDirectory
{
  NSString *returnVal = nil;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
  if (paths && [paths count] > 0)
  {
    returnVal = [paths objectAtIndex:0];
  }
  return returnVal;
}

/**
 * Just delete the damn thing.
 */
+ (BOOL)deleteFile:(NSString *)filename
{
  return [self deleteFile:filename error:nil];
}

/**
 * Delete the damn thing with an option to know what is the error.
 */
+ (BOOL)deleteFile:(NSString *)filename error:(NSError **)error
{
  // Sanity check
  if (filename == nil)
  {
    return NO;
  }
  
  NSError *localError = nil;
  NSFileManager *fm = [NSFileManager defaultManager];
  if ([fm removeItemAtPath:filename error:&localError])
  {
    return YES;
  }
  else
  {
    // If there is a pointer to a NSError provided, assign it to the local error object.
    LWE_LOG(@"Could not delete file at specified location: %@ (error: %@)", filename, localError);
    if (error)
    {
      *error = localError;
    }
    return NO;
  }
}


/**
 * Check to see if a file exists or not
 */
+ (BOOL) fileExists:(NSString*)filename
{
  // Sanity check
  if (filename == nil)
  {
    return NO;
  }

  NSFileManager *fm = [NSFileManager defaultManager];
  return [fm fileExistsAtPath:filename];
}

/**
 * Creates a directory at the path if it doesn't already exist
 */
+ (BOOL) createDirectoryIfNotExisting:(NSString*)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError **)error
{
  if ([LWEFile fileExists:path] == NO)
  {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm createDirectoryAtPath:path withIntermediateDirectories:createIntermediates attributes:attributes error:error];
  }
  return YES;
}

/**
 * Prints the Files in the a Directory for Debugging Purposes
 */
#if defined (LWE_DEBUG)
+ (void) printFilesInDirectory:(NSString*)dir
{
  NSError *error = nil;
  id directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
  if (error == nil)
  {
    for (NSString *file in directoryContent)
    {
      LWE_LOG(@"file named: %@", file);
    }
  }
  else
  {
    LWE_LOG(@"error printing files in directory %@ -- error: %@",dir,error);
  }
}
#endif

/**
 *  \brief    Copy a file from a certain path to another path. 
 *  \details  Note that both paths has to be a full path, not a relative.
 */
+ (BOOL) copyFromBundleWithFilename:(NSString *)source toDocumentsWithFilename:(NSString *)dest shouldOverwrite:(BOOL)overwrite
{
  NSString *destPath = [LWEFile createDocumentPathWithFilename:dest];
  if ([LWEFile fileExists:destPath])
  {
    if (overwrite)
    {
      if ([LWEFile deleteFile:destPath] == NO)
      {
        LWE_LOG(@"Could not delete file in overwrite mode on copy: %@",destPath);
        return NO;
      }
    }
    else
    {
      LWE_LOG(@"Not overwriting file: %@",destPath);
      return NO;  
    }
  }
  
  // Now do the actual copy
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:source];
  LWE_LOG(@"Copying file from: %@ to: %@", bundlePath, destPath);
  NSError *error = nil;
	BOOL result = [fileManager copyItemAtPath:bundlePath toPath:destPath error:&error];
  if (result)
  {
    return YES;
  }
  else
  {
    LWE_LOG(@"Error copying file: %@", error);
    return NO;
  }
}

/**
 * Helper function to copy files from the main bundle to the docs directory
 */
+ (BOOL) copyFromMainBundleToDocuments:(NSString *)filename shouldOverwrite:(BOOL)overwrite
{
  NSString *destPath = [LWEFile createDocumentPathWithFilename:filename];
  if ([LWEFile fileExists:destPath])
  {
    if (overwrite)
    {
      if (![LWEFile deleteFile:destPath])
      {
        LWE_LOG(@"Could not delete file in overwrite mode on copy: %@",destPath);
        return NO;
      }
    }
    else
    {
      LWE_LOG(@"Not overwriting file: %@",destPath);
      return NO;  
    }
  }
  
  // Now do the actual copy
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *explodedString = [filename componentsSeparatedByString:@"."];
  NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[explodedString objectAtIndex:0] ofType:[explodedString objectAtIndex:1]];
//  NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];

  LWE_LOG(@"Copying file from :%@",bundlePath);
  NSError *error = nil;
	BOOL result = [fileManager copyItemAtPath:bundlePath toPath:destPath error:&error];
  if (result)
  {
    return YES;
  }
  else
  {
    LWE_LOG(@"Error copying file: %@",error);
    return NO;
  }

}

//! Method to make a given file not backed up (also prevents it's deletion)
// See https://developer.apple.com/library/ios/#qa/qa1719/_index.html for more info
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
  return [LWEFile addSkipBackupAttributeToItemAtPath:[URL path]];
}

//! Sets the Skip Backup Extended Attribute for a file at a given path
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path
{
  const char* filePath = [path fileSystemRepresentation];
  const char* attrName = "com.apple.MobileBackup";
  u_int8_t attrValue = 1;
  
  int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
  return result == 0;
}


//! Returns total disk space available to the app
+ (NSInteger) getTotalDiskSpaceInBytes
{
  NSInteger totalSpace = 0;
//  NSError *error = nil;
//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//  NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
//  LWE_LOG(@"Last object was: %@",[paths lastObject]);
//  if (dictionary)
//  {
//    NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];
//    totalSpace = [fileSystemSizeInBytes intValue];
//    LWE_LOG(@"File system size: %d",[fileSystemSizeInBytes intValue])
//  }
//  else
//  {
//    LWE_LOG(@"Error Obtaining File System Info: Domain = %@, Code = %@", [error domain], [error code]);
//  }
  // TODO: this code doesn't work on iPod Touch and maybe other devices.  So I'm assuming it's all good for now
  totalSpace = 100000000;
  return totalSpace;
}

@end
