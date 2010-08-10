//
//  LWENetworkUtils.m
//  Rikai
//
//  Created by Ross on 7/1/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "LWENetworkUtils.h"


@implementation LWENetworkUtils

+(BOOL) networkAvailable
{
  Reachability *reachability = [Reachability reachabilityForInternetConnection];
  NetworkStatus status = [reachability currentReachabilityStatus];
  if(status == NotReachable)
  {
    return NO;
  }
  return YES;
}

/**
 * Checks network access for a given URL
 */
+(BOOL) networkAvailableFor:(NSString*)hostURL
{
  // Note: reachability only accepts host names, not fully qualified URLs
  NSURL *url = [NSURL URLWithString:hostURL];
  Reachability *reachability = [Reachability reachabilityWithHostName:[url host]];
  NetworkStatus status = [reachability currentReachabilityStatus];
  if ((status != ReachableViaWiFi) && (status != ReachableViaWWAN))
  {
    return NO;
  }
  else 
  {
    return YES;
  }
}
  
//! TODO: this class is RIKAI SPECIFIC
+ (void) launchAlertIfNotReachableForHost:(NSString*)hostURLOrNil
{  
  NSString* alertMessage;
  if ([LWENetworkUtils networkAvailable] == NO) // first check it we have any connection at all
  {
    alertMessage = NSLocalizedString(@"Rikai cannot open the page because it is not connected to the internet.", @"LWENetworkUtils.No Internet");
  }
  else if(hostURLOrNil != nil && [LWENetworkUtils networkAvailableFor:hostURLOrNil] == NO)
  {
    alertMessage = NSLocalizedString(@"Rikai could not open the page you requested. The server is not responding.", @"LWENetworkUtils.No Page");
  }
  else // no problems, just return
  {
    return;
  }

  [LWEUIAlertView notificationAlertWithTitle:NSLocalizedString(@"Cannot Open Page", @"LWENetworkUtils.AlertView Title")
                                     message:alertMessage];
}
@end
