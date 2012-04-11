//
//  LWES3Package.m
//  dtcstyle
//
//  Created by Rendy Pranata on 11/04/12.
//  Copyright (c) 2012 Long Weekend LLC. All rights reserved.
//

#import "LWES3Package.h"

@interface LWES3Package ()
- (void)setupBucketAndKeyForURL:(NSURL *)url;
@end

@implementation LWES3Package
@synthesize accessKey, secretKey;
@synthesize bucket, pathToObject;

#pragma mark - Privates

- (void)setupBucketAndKeyForURL:(NSURL *)url
{
  static NSString * const kAmazonS3URLPattern = @"s3.amazonaws.com";
  
  //Make sure that the s3.amazonaws.com is there
  NSString *host = [url host];
  LWE_ASSERT_EXC((host), @"host cannot be null. URL passed in as a parameter needs to have http:// in a full path format.");
  
  NSUInteger startIndex = 0;
  NSArray *pathComponents = [url pathComponents];
  NSRange range = [host rangeOfString:kAmazonS3URLPattern];
  NSString *_bucket = nil;
  LWE_ASSERT_EXC((range.location != NSNotFound), @"The url pattern doesnt really mimics the s3.amazonaws.com");
  if (range.location != 0)
  {
    //The bucket is put at front.
    //bucket-name.s3.amazon.com
    _bucket = [host substringWithRange:(NSRange){0, range.location-1}];
    startIndex = 1;
  }
  else 
  {
    //Meaning the bucket is in the part of the url.
    //s3.amazonaws.com/bucket-name/
    _bucket = [pathComponents objectAtIndex:1];
    startIndex = 2;
  }  
  
  NSArray *keys = [pathComponents subarrayWithRange:(NSRange){startIndex, pathComponents.count-startIndex}];
  self.pathToObject = [keys componentsJoinedByString:@"/"];  
  self.bucket = _bucket;
}

#pragma mark - Class Plumbing

//! Instance method initialiser
- (id) initWithUrl:(NSURL*)url destinationFilepath:(NSString*)filepath
{
  self = [super initWithUrl:url destinationFilepath:filepath];
  {
    [self setupBucketAndKeyForURL:url];
  }
  return self;
}

//! Initializer, conveninence method autoreleased
+ (id) packageWithUrl:(NSURL*)url destinationFilepath:(NSString*)filepath
{
  return [[[self alloc] initWithUrl:url destinationFilepath:filepath] autorelease];
}

- (void)dealloc
{
  self.accessKey = nil;
  self.secretKey = nil;
  self.bucket = nil;
  self.pathToObject = nil;
  
  [super dealloc];
}

@end
