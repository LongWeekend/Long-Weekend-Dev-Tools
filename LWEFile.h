//
//  LWEFile.h
//  jFlash
//
//  Created by Mark Makdad on 3/13/10.
//  Copyright 2010 LONG WEEKEND INC.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWEFile : NSObject
{

}

+ (NSString*) createBundlePathWithFilename:(NSString*) filename;
+ (NSString*) createDocumentPathWithFilename:(NSString*) filename;
+ (BOOL) deleteFile:(NSString*)filename;
+ (BOOL) fileExists:(NSString*)filename;
+ (BOOL) copyFromMainBundleToDocuments:(NSString*)filename shouldOverwrite:(BOOL)overwrite;
+ (NSInteger) getTotalDiskSpaceInBytes;
@end
