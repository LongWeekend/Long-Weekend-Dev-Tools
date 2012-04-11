//
//  LWES3Package.h
//  dtcstyle
//
//  Created by Rendy Pranata on 11/04/12.
//  Copyright (c) 2012 Long Weekend LLC. All rights reserved.
//

#import "LWEPackage.h"

@interface LWES3Package : LWEPackage

//! This secret key is used by ASIS3ObjectRequest for authentication purposes.
@property (nonatomic, retain) NSString *secretKey;

//! This access/public key is used by ASIS3ObjectRequest for authentication purposes.
@property (nonatomic, retain) NSString *accessKey;

//! This bucket is also used by the ASIS3ObjectRequest framework to make request to the Amazon S3 Server.
@property (nonatomic, retain) NSString *bucket;

//! Path-to-object on the server.
@property (nonatomic, retain) NSString *pathToObject;

/**
 * Designated instance initializer.  Pass it a URL and a local filename.
 * This method will automatically call its super implementation of designated
 * initialiser. Also this method will try to unpack the bucket and pathToObject initialisation.
 */
- (id) initWithUrl:(NSURL*)url destinationFilepath:(NSString*)filepath;

/**
 * Designated class initializer.  Pass it a URL and a local filename.
 * This method will automatically call its super implementation of designated
 * initialiser. Also this method will try to unpack the bucket and pathToObject initialisation.
 */
+ (id) packageWithUrl:(NSURL*)url destinationFilepath:(NSString*)filepath;

@end
