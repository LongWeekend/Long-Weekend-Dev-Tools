//
//  LWEFile.h
//  jFlash
//
//  Created by Mark Makdad on 3/13/10.
//  Copyright 2010 LONG WEEKEND INC.. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  kLWEFileLocationBundle = 0, // the file is in the bundle
  kLWEFileLocationDocuments = 1 // the file is in the documents directory
} kLWEFileLocation;

@interface LWEFile : NSObject
{

}

+ (NSString*) createBundlePathWithFilename:(NSString*) filename;
+ (NSString*) createDocumentPathWithFilename:(NSString*) filename;
+ (BOOL) createDirectory:(NSString*)pathname error:(NSError**)error;
+ (BOOL) deleteFile:(NSString*)filename;
+ (BOOL) fileExists:(NSString*)filename;
+ (BOOL) copyFromMainBundleToDocuments:(NSString*)filename shouldOverwrite:(BOOL)overwrite;
+ (NSInteger) getTotalDiskSpaceInBytes;
@end
