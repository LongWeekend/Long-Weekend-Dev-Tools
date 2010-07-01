//
//  LWEFile.m
//  jFlash
//
//  Created by Mark Makdad on 3/13/10.
//  Copyright 2010 LONG WEEKEND INC.. All rights reserved.
//

#import "LWEFile.h"


@implementation LWEFile

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
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
  return path;
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
    LWE_LOG(@"File found at specified location: %@",filename);
    return YES;
  }
  else
  {
    LWE_LOG(@"File not found at specified location: %@",filename);
    return NO;
  }
}


/**
 * Helper function to copy files from the main bundle to the docs directory
 */
+ (BOOL) copyFromMainBundleToDocuments:(NSString*)filename shouldOverwrite:(BOOL)overwrite
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
  NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
  LWE_LOG(@"Copying file from :%@",bundlePath);
	return [fileManager copyItemAtPath:bundlePath toPath:destPath error:NULL];
}


//! Returns total disk space available to the app
+ (NSInteger) getTotalDiskSpaceInBytes
{
  NSInteger totalSpace = 0;
  NSError *error = nil;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
  LWE_LOG(@"Last object was: %@",[paths lastObject]);
  if (dictionary)
  {
    NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];
    totalSpace = [fileSystemSizeInBytes intValue];
    LWE_LOG(@"File system size: %d",[fileSystemSizeInBytes intValue])
  }
  else
  {
    LWE_LOG(@"Error Obtaining File System Info: Domain = %@, Code = %@", [error domain], [error code]);
  }
  // TODO: this code doesn't work on iPod Touch and maybe other devices.  So I'm assuming it's all good for now
  totalSpace = 100000000;
  return totalSpace;
}

@end
