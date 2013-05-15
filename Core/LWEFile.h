// LWEFile.h
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


#import <Foundation/Foundation.h>

typedef enum
{
  kLWEFileLocationBundle = 0, // the file is in the bundle
  kLWEFileLocationDocuments = 1 // the file is in the documents directory
} kLWEFileLocation;

@interface LWEFile : NSObject

+ (NSString*) createBundlePathWithFilename:(NSString*) filename;
+ (NSString*) createDocumentPathWithFilename:(NSString*) filename;
+ (NSString*) createLibraryPathWithFilename:(NSString*) filename;
+ (NSString*) createCachesPathWithFilename:(NSString*)filename;
+ (NSString*) createTemporaryPathWithFilename:(NSString*) filename;
+ (NSString*) applicationDirectory;

+ (BOOL) createDirectoryIfNotExisting:(NSString*)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError **)error;
+ (BOOL) createDirectory:(NSString*)pathname error:(NSError**)error;
+ (BOOL) deleteFile:(NSString*)filename;
+ (BOOL) deleteFile:(NSString*)filename error:(NSError**)error;
+ (BOOL) fileExists:(NSString*)filename;
+ (BOOL) copyFromBundleWithFilename:(NSString *)source toDocumentsWithFilename:(NSString *)dest shouldOverwrite:(BOOL)overwrite;
+ (BOOL) copyFromMainBundleToDocuments:(NSString*)filename shouldOverwrite:(BOOL)overwrite;
+ (NSInteger) getTotalDiskSpaceInBytes;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path;

#if defined (LWE_DEBUG)
+ (void) printFilesInDirectory:(NSString*)dir;
#endif
@end
