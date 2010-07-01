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
+ (void) launchAlertIfNotReachableForHost:(NSString*)hostURL;

@end
