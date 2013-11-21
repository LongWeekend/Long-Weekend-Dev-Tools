// LWEUIAlertView.m
//
// Copyright (c) 2011 Long Weekend LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "LWEUIAlertView.h"

@implementation LWEUIAlertView

#pragma mark - Class Instantiation Support

static Class _alertViewClassType;

+ (Class)alertViewClassType
{
  if (_alertViewClassType == nil)
  {
    [self setAlertViewClassType:[UIAlertView class]];
  }
  return _alertViewClassType;
}

+ (void)setAlertViewClassType:(Class)alertViewClassType
{
  _alertViewClassType = [[alertViewClassType retain] autorelease];
}

#pragma mark Object Instantiation

/**
 * Shows standard no-network alert view w/o delegate setting
 * Note that this method just calls noNetworkAlertWithDelegate:nil
 */
+ (UIAlertView *)noNetworkAlert
{
  return [LWEUIAlertView noNetworkAlertWithDelegate:nil];
}

/**
 * \param delegate the delegate of the alert view, if any
 * Note that this method just calls notificationAlertWithTitle:message:delegate with a custom title & message
 */
+ (UIAlertView *)noNetworkAlertWithDelegate:(id)delegate
{
  return [LWEUIAlertView notificationAlertWithTitle:NSLocalizedString(@"No Network Access",@"Network.UnableToConnect_AlertViewTitle")
                                     message:NSLocalizedString(@"Please check your network connection and try again.",@"Network.UnableToConnect_AlertViewMessage")
                                    delegate:delegate];
}

/**
 * Shows a default "OK" button alert with no delegate
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 */
+ (UIAlertView *)notificationAlertWithTitle:(NSString*)title message:(NSString*)message
{
  return [LWEUIAlertView notificationAlertWithTitle:title message:message delegate:nil];
}

/**
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 * \param delegate Delegate of the UIAlertView, if any
 */
+ (UIAlertView *)notificationAlertWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate
{
  return [LWEUIAlertView confirmationAlertWithTitle:title message:message ok:nil cancel:NSLocalizedString(@"OK",@"Global.OK") delegate:delegate];
}

/**
 * Note that this just calls confirmationAlertWithTitle:message:ok:cancel:delegate with default parameters for ok and cancel.
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 * \param delegate Delegate of the UIAlertView, if any
 */
+ (UIAlertView *)confirmationAlertWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate
{
  return [LWEUIAlertView confirmationAlertWithTitle:title message:message ok:NSLocalizedString(@"OK",@"Global.OK") cancel:NSLocalizedString(@"Cancel",@"Global.Cancel") delegate:delegate];
}

/**
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 * \param ok Text for the "OK" action 
 * \param cancel Text for the "Cancel" action
 * \param delegate Delegate of the UIAlertView, if any
 */
+ (UIAlertView *)confirmationAlertWithTitle:(NSString*)title message:(NSString*)message ok:(NSString*)ok cancel:(NSString*)cancel delegate:(id)delegate
{
  return [LWEUIAlertView confirmationAlertWithTitle:title message:message ok:ok cancel:cancel delegate:delegate tag:0];
}

/**
 * \param title Title of the UIAlertView
 * \param message Message content of the UIAlertView
 * \param ok Text for the "OK" action 
 * \param cancel Text for the "Cancel" action
 * \param delegate Delegate of the UIAlertView, if any
 * \param tag Tag for the alert view to use in delegate, if any
*/
+ (UIAlertView *)confirmationAlertWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok cancel:(NSString *)cancel delegate:(id)delegate tag:(int)tag
{
  return [self confirmationAlertWithTitle:title
                                  message:message
                                       ok:ok
                                   cancel:cancel
                                 delegate:delegate
                       customizationBlock:nil
                                      tag:tag];
}

+ (UIAlertView *)confirmationAlertWithTitle:(NSString *)title
                                    message:(NSString *)message
                                         ok:(NSString *)ok
                                     cancel:(NSString *)cancel
                                   delegate:(id)delegate
                         customizationBlock:(void(^)(UIAlertView *))customisationBlock
                                        tag:(int)tag
{
  Class alertViewClass = [self alertViewClassType];
  UIAlertView *alert = [[alertViewClass alloc] initWithTitle:title
                                                     message:message
                                                    delegate:delegate
                                           cancelButtonTitle:cancel
                                           otherButtonTitles:ok,nil];
  
  // Make sure even if its decided to instantiate another type, that type
  // has to inherit from the UIAlertView.
  LWE_ASSERT_TYPE(alert, [UIAlertView class]);
  alert.tag = tag;
  
  // If there is a customisationBlock before the alertView gets displayed, call it first.
  if (customisationBlock)
  {
    customisationBlock(alert);
  }
  
  // Show and return the alertView created
  [alert show];
  return [alert autorelease];
}

@end