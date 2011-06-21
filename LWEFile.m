//
//  LWEFile.m
//  jFlash
//
//  Created by Mark Makdad on 3/13/10.
//  Copyright 2010 LONG WEEKEND INC.. All rights reserved.
//

#import "LWEFile.h"
#import "LWEDebug.h"


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
+ (BOOL) deleteFile:(NSString*)filename
{
  // Sanity checks
  if (filename == nil) return NO;
  
  NSError *error;
  NSFileManager *fm = [NSFileManager defaultManager];
  if (![fm removeItemAtPath:filename error:&error])
  {
    LWE_LOG(@"Could not delete file at specified location: %@",filename);
    return NO;
  }
  else
  {
    LWE_LOG(@"File at specified location deleted: %@",filename);
    return YES;
  }
}


/**
 * Check to see if a file exists or not
 */
+ (BOOL) fileExists:(NSString*)filename
{
  // Sanity checks
  if (filename == nil) return NO;

  NSFileManager *fm = [NSFileManager defaultManager];
  if ([fm fileExistsAtPath:filename])
  {
//    LWE_LOG(@"File found at specified location: %@",filename);
    return YES;
  }
  else
  {
    LWE_LOG(@"File not found at specified location: %@",filename);
    return NO;
  }
}

/**
 * Creates a directory at the path if it doesn't already exist
 */
+ (BOOL) createDirectoryIfNotExisting:(NSString*)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError **)error
{
  if (![LWEFile fileExists:path])
  {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm createDirectoryAtPath:path withIntermediateDirectories:createIntermediates attributes:attributes error:error];
  }
  return YES;
}

/**
 * Prints the Files in the a Directory for Debugging Purposes
 */
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
  
  // TODO: MMA - why does this exist??!
  NSArray *explodedString = [filename componentsSeparatedByString:@"."];
  LWE_LOG(@"Exploded string reconstituted: '%@.%@'",[explodedString objectAtIndex:0],[explodedString objectAtIndex:1]);
#pragma unused(explodedString)
  
  NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[explodedString objectAtIndex:0] ofType:[explodedString objectAtIndex:1]];
//  NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
//  NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Phone" ofType:@"sqlite"];
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
