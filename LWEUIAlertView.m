//
//  LWEUIAlertView.m
//  jFlash
//
//  Created by Mark Makdad on 8/9/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import "LWEUIAlertView.h"


@implementation LWEUIAlertView

/**
 * Shows standard no-network alert view w/o delegate setting
 * Note that this method just calls noNetworkAlertWithDelegate:nil
 */
+ (void) noNetworkAlert
{
  [LWEUIAlertView noNetworkAlertWithDelegate:nil];
}

/**
 * \param delegate the delegate of the alert view, if any
 * Note that this method just calls notificationAlertWithTitle:message:delegate with a custom title & message
 */
+ (void) noNetworkAlertWithDelegate:(id)delegate
{
  [LWEUIAlertView notificationAlertWithTitle:NSLocalizedString(@"No Network Access",@"Network.UnableToConnect_AlertViewTitle")
                                     message:NSLocalizedString(@"Please check your network connection and try again.",@"Network.UnableToConnect_AlertViewMessage")
                                    delegate:delegate];
}

/**
 * Shows a default "OK" button alert with no delegate
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 */
+ (void) notificationAlertWithTitle:(NSString*)title message:(NSString*)message
{
  [LWEUIAlertView notificationAlertWithTitle:title message:message delegate:nil];
}

/**
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 * \param delegate Delegate of the UIAlertView, if any
 */
+ (void) notificationAlertWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate
{
  [LWEUIAlertView confirmationAlertWithTitle:title message:message ok:nil cancel:NSLocalizedString(@"OK",@"Global.OK") delegate:delegate];
}

/**
 * Note that this just calls confirmationAlertWithTitle:message:ok:cancel:delegate with default parameters for ok and cancel.
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 * \param delegate Delegate of the UIAlertView, if any
 */
+ (void) confirmationAlertWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate
{
  [LWEUIAlertView confirmationAlertWithTitle:title message:message ok:NSLocalizedString(@"OK",@"Global.OK") cancel:NSLocalizedString(@"Cancel",@"Global.Cancel") delegate:delegate];
}

/**
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 * \param ok Text for the "OK" action 
 * \param cancel Text for the "Cancel" action
 * \param delegate Delegate of the UIAlertView, if any
 */
+ (void) confirmationAlertWithTitle:(NSString*)title message:(NSString*)message ok:(NSString*)ok cancel:(NSString*)cancel delegate:(id)delegate
{
  [LWEUIAlertView confirmationAlertWithTitle:title message:message ok:ok cancel:cancel delegate:delegate tag:0];
}

/**
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 * \param ok Text for the "OK" action 
 * \param cancel Text for the "Cancel" action
 * \param delegate Delegate of the UIAlertView, if any
 * \param tag Tag for the alert view to use in delegate, if any
*/
+ (void) confirmationAlertWithTitle:(NSString*)title message:(NSString*)message ok:(NSString*)ok cancel:(NSString*)cancel delegate:(id)delegate tag:(int)tag
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate
                                        cancelButtonTitle:cancel
                                        otherButtonTitles:ok,nil];
  alert.tag = tag;
  [alert show];
  [alert release];
}

@end