// LWEUIAlertView.h
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


#import <Foundation/Foundation.h>

#define LWE_ALERT_CANCEL_BTN 0
#define LWE_ALERT_OK_BTN 1

/**
 * \brief   Helper functions for making standard types of UIAlertViews
 * \details Use the static methods in this class to create and then
 * immediately show/release different types of UIAlertViews.  Also,
 * you can use the LWE_ALERT_CANCEL_BTN and LWE_ALERT_OK_BTN constants
 * to avoid hard-coding integers into your delegate methods for UIAlertView
 */
@interface LWEUIAlertView : NSObject

/**
 * Allow the ability for this class to instantiate another type of 
 * object, as long as `alertViewClassType` inehrits from the `UIAlertView`.
 *
 * Next subsequent call to the factory methods from this class will result
 * in an object of type `alertViewClassType` specified.
 *
 * By default, its going to return `UIAlertView` type instead.
 */
+ (void)setAlertViewClassType:(Class)alertViewClassType;

/** Shows standard no-network alert view */
+ (UIAlertView *)noNetworkAlert;

/** Shows standard no-network alert view with delegate */
+ (UIAlertView *)noNetworkAlertWithDelegate:(id)delegate;

/** Shows an "OK" alert notification */
+ (UIAlertView *)notificationAlertWithTitle:(NSString *)title message:(NSString *)message;

/** Shows an "OK" alert notification (with delegate) */
+ (UIAlertView *)notificationAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

/** Shows a Cancel/OK confirmation alert with standard OK/Cancel */
+ (UIAlertView *)confirmationAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

/** Shows a Cancel/OK confirmation alert with customized OK/Cancel */
+ (UIAlertView *)confirmationAlertWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok cancel:(NSString *)cancel delegate:(id)delegate;

/** Shows a Cancel/OK confirmation alert with customized OK/Cancel and takes an optional tag for the alert view */
+ (UIAlertView *)confirmationAlertWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok cancel:(NSString *)cancel delegate:(id)delegate tag:(int)tag;

+ (UIAlertView *)confirmationAlertWithTitle:(NSString *)title
                                    message:(NSString *)message
                                         ok:(NSString *)ok
                                     cancel:(NSString *)cancel
                                   delegate:(id)delegate
                         customizationBlock:(void(^)(UIAlertView *))customisationBlock
                                        tag:(int)tag;

@end
