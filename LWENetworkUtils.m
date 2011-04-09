//
//  LWENetworkUtils.m
//  Rikai
//
//  Created by Ross on 7/1/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "LWENetworkUtils.h"
#import "LWEUIAlertView.h"


@implementation LWENetworkUtils

@synthesize iTunesURL;

/**
 * Opens a iTunes URL after following Linkshare affiliate redirect
 */
- (void)followLinkshareURL:(NSString*)linkShareUrlString
{
  self.iTunesURL = [NSURL URLWithString:linkShareUrlString]; 
  NSURLRequest *referralRequest = [NSURLRequest requestWithURL:self.iTunesURL];
  NSURLConnection *referralConnection = [[NSURLConnection alloc] initWithRequest:referralRequest delegate:self startImmediately:YES];
  [referralConnection release];
}

#pragma mark -
#pragma mark NSURLRequest Delegate Methods

// DO not call these directly
// Save the most recent URL in case multiple redirects occur
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response 
{
  self.iTunesURL = [response URL];
  LWE_LOG(@"connection %@", [self.iTunesURL absoluteString]);
  return request;
}

// No more redirects; use the last URL saved
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
  LWE_LOG(@"connectionDidFinishLoading");
  [[UIApplication sharedApplication] openURL:self.iTunesURL];
}

#pragma mark -
#pragma mark Class Methods

// From: http://www.cocoadev.com/index.pl?BaseSixtyFour
+ (NSString*) base64forData:(NSData*)theData
{
  const uint8_t* input = (const uint8_t*)[theData bytes];
  NSInteger length = [theData length];
  
  static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  
  NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
  uint8_t* output = (uint8_t*)data.mutableBytes;
  
  NSInteger i;
  for (i=0; i < length; i += 3)
  {
    NSInteger value = 0;
    NSInteger j;
    for (j = i; j < (i + 3); j++)
    {
      value <<= 8;
      
      if (j < length)
      {
        value |= (0xFF & input[j]);
      }
    }
    
    NSInteger theIndex = (i / 3) * 4;
    output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
    output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
    output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
    output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
  }  
  return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}


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
  
+ (BOOL) networkReachableForHost:(NSString*)hostURLOrNil showAlert:(BOOL) showAlert
{  
  NSString* alertMessage;
  if ([LWENetworkUtils networkAvailable] == NO) // first check it we have any connection at all
  {
    alertMessage = NSLocalizedString(@"Cannot open the page because it is not connected to the internet.", @"LWENetworkUtils.No Internet");
  }
  else if(hostURLOrNil != nil && [LWENetworkUtils networkAvailableFor:hostURLOrNil] == NO)
  {
    alertMessage = NSLocalizedString(@"Could not open the page you requested. The server is not responding.", @"LWENetworkUtils.No Page");
  }
  else // no problems, just return
  {
    return YES;
  }

  if (showAlert)
  {
    UIAlertView *networkUnavailableAlert = [[UIAlertView alloc]
                                            initWithTitle: NSLocalizedString(@"Cannot Open Page", @"LWENetworkUtils.AlertView Title")
                                            message: alertMessage
                                            delegate:nil
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil];
    [networkUnavailableAlert show];
    [networkUnavailableAlert release];
  }
  
  return NO;
}

@end
