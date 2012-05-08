// LWEPackage.h
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

@interface LWEPackage : NSObject

/**
 * Designated instance initializer.  Pass it a URL and a local filename.
 * This method will automatically infer a value for unpackagePath,
 * the same directory as the local filepath.
 */
- (id) initWithUrl:(NSURL*)url destinationFilepath:(NSString*)filepath;

/**
 * Designated class initializer.  Pass it a URL and a local filename.
 * This method will automatically infer a value for unpackagePath,
 * the same directory as the local filepath.
 */
+ (id) packageWithUrl:(NSURL*)url destinationFilepath:(NSString*)filepath;

//! The filename of the package, no path.  This is the final part of the URL.
- (NSString *) packageFilename;

//! The name of the package.  This is the final part of the URL, stripping the extension.
- (NSString *) packageName;

//! LWEPackageDownloader sets this to YES if this package has already been unwrapped (downloaded & decompressed).
@property BOOL isUnwrapped;

//! The URL of the content before downloading
@property (retain) NSURL *packageUrl;

//! The local filepath where the content will be downloaded to (e.g. this is a local .zip file)
@property (retain) NSString *destinationFilepath;

//! The local path where the content will be decompressed to (e.g. this is a folder)
@property (retain) NSString *unpackagePath;

//! A userinfo dictionary, put anything you want in here.
@property (retain) NSDictionary *userInfo;

@end
