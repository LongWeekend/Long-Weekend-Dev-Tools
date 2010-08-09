//
//  LWEUIAlertView.m
//  jFlash
//
//  Created by Mark Makdad on 8/9/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import "LWEUIAlertView.h"


@implementation LWEUIAlertView

//! Shows standard no-network alert view w/o delegate setting
+ (void) noNetworkAlert
{
  [LWEUIAlertView noNetworkAlertWithDelegate:nil];
}

/**
 *Shows standard no-network alert view 
 * \param delegate the delegate of the alert view, if any
 */
+ (void) noNetworkAlertWithDelegate:(id)delegate
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to Connect",@"Network.UnableToConnect_AlertViewTitle")
                                                      message:NSLocalizedString(@"Please check your network connection and try again.",@"Network.UnableToConnect_AlertViewMessage")
                                                     delegate:delegate
                                            cancelButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"OK",@"Global.OK"),nil];
  [alertView show];
  [alertView release];  
}

@end
