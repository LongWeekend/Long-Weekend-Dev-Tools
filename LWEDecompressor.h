//
//  LWEDecompressor.h
//  phone
//
//  Created by Mark Makdad on 6/20/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LWEDecompressor;

/**
 * Protocol for any class wanting to use the decompressor.
 * You must implement both methods.
 */
@protocol LWEDecompressorDelegate <NSObject>
@required
- (void)decompressFinished:(LWEDecompressor*)decompressor;
- (void)decompressFailed:(LWEDecompressor*)decompressor error:(NSError*)error;
@end

@interface LWEDecompressor : NSObject
{
  BOOL _isDecompressing;
}

/**
 * Factory initialzier, sets |delegate|, but returns the new object autoreleased.s
 */
+ (id) decompressorWithDelegate:(id<LWEDecompressorDelegate>)aDelegate;

/**
 * Standard initializer, sets |delegate|.
 */
- (id) initWithDelegate:(id<LWEDecompressorDelegate>)delegate;

/**
 * Decompresses (unzips) the zip file located at |zippedPath|, optionally asynchronously
 * The files will be unzipped directly into the |unzippedPath| folder -- so make sure
 * to pass an empty folder name at the end of the path if that's what you want.
 */
- (void)decompressContentAtPath:(NSString*)zippedPath toPath:(NSString*)unzippedPath asynchronously:(BOOL)asynch;

//! User dictionary
@property (retain) NSDictionary *userInfo;

//! If asynchronous, it could be useful to know if this object is busy.
@property (readonly) BOOL isDecompressing;

//! Location of the zipped content
@property (retain) NSString *compressedContentFilepath;

//! Where the content is after being unzipped
@property (retain) NSString *decompressedContentPath;

@property (assign) id<LWEDecompressorDelegate> delegate;

@end
