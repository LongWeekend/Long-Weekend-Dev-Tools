//
//  LWENetworkUtils.h
//  Rikai
//
//  Created by Ross on 7/1/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "Reachability.h"


@interface LWENetworkUtils : NSObject 

/**
 * Given some NSData object, returns a string of Base64-encoded data for that NSData.
 * This was ripped off from: http://www.cocoadev.com/index.pl?BaseSixtyFour
 */
+ (NSString*) base64forData:(NSData*)theData;

+ (BOOL) networkAvailable;
+ (BOOL) networkAvailableFor:(NSString*)hostURL;
+ (BOOL) networkReachableForHost:(NSString*)hostURLOrNil showAlert:(BOOL) showAlert;
- (void) followLinkshareURL:(NSString*)linkShareUrlString;

@property (nonatomic, retain) NSURL* iTunesURL;

@end