//
//  LWENetworkUtils.h
//  Rikai
//
//  Created by Ross on 7/1/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "Reachability.h"


@interface LWENetworkUtils : NSObject {

}

+ (BOOL) networkAvailable;
+ (BOOL) networkAvailableFor:(NSString*)hostURL;
+ (BOOL) networkReachableForHost:(NSString*)hostURLOrNil showAlert:(BOOL) showAlert;

@end
