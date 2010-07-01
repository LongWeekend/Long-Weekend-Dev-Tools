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

+(BOOL) networkAvailableFor:(NSString*)hostURL
{
  // Check reachability once
  Reachability *reachability = [Reachability reachabilityWithHostName:hostURL];
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

  UIAlertView *networkUnavailableAlert = [[UIAlertView alloc]
                                          initWithTitle: NSLocalizedString(@"Cannot Open Page", @"LWENetworkUtils.AlertView Title")
                                          message: alertMessage
                                          delegate:nil
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
  [networkUnavailableAlert show];
  [networkUnavailableAlert release];    
}
@end
