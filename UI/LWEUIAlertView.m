// LWEUIAlertView.m
//
// Copyright (c) 2011 Long Weekend LLC
// (UIAlertController replacement — UIAlertView is banned for scene-based apps iOS 13+)

#import "LWEUIAlertView.h"

@implementation LWEUIAlertView

// Returns the topmost presented view controller, used to present UIAlertController.
+ (UIViewController *)_topViewController
{
  UIViewController *top = nil;
  for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
    if ([scene isKindOfClass:[UIWindowScene class]]) {
      UIWindowScene *ws = (UIWindowScene *)scene;
      for (UIWindow *w in ws.windows) {
        if (w.isKeyWindow) { top = w.rootViewController; break; }
      }
    }
    if (top) break;
  }
  while (top.presentedViewController) {
    top = top.presentedViewController;
  }
  return top;
}

// All factory methods funnel here. Returns nil (no UIAlertView to hand back).
+ (UIAlertView *)confirmationAlertWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok cancel:(NSString *)cancel delegate:(id)delegate tag:(int)tag
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
  if (cancel) {
    [alert addAction:[UIAlertAction actionWithTitle:cancel
                                             style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *a) {
      if ([delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [delegate alertView:nil clickedButtonAtIndex:LWE_ALERT_CANCEL_BTN];
      }
    }]];
  }
  if (ok) {
    [alert addAction:[UIAlertAction actionWithTitle:ok
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *a) {
      if ([delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [delegate alertView:nil clickedButtonAtIndex:LWE_ALERT_OK_BTN];
      }
    }]];
  }
  [[LWEUIAlertView _topViewController] presentViewController:alert animated:YES completion:nil];
  return nil;
}

+ (UIAlertView *)confirmationAlertWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok cancel:(NSString *)cancel delegate:(id)delegate
{
  return [LWEUIAlertView confirmationAlertWithTitle:title message:message ok:ok cancel:cancel delegate:delegate tag:0];
}

+ (UIAlertView *)confirmationAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
  return [LWEUIAlertView confirmationAlertWithTitle:title message:message
                                                ok:NSLocalizedString(@"OK", @"Global.OK")
                                            cancel:NSLocalizedString(@"Cancel", @"Global.Cancel")
                                          delegate:delegate];
}

+ (UIAlertView *)notificationAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
  return [LWEUIAlertView confirmationAlertWithTitle:title message:message
                                                ok:nil
                                            cancel:NSLocalizedString(@"OK", @"Global.OK")
                                          delegate:delegate];
}

+ (UIAlertView *)notificationAlertWithTitle:(NSString *)title message:(NSString *)message
{
  return [LWEUIAlertView notificationAlertWithTitle:title message:message delegate:nil];
}

+ (UIAlertView *)noNetworkAlertWithDelegate:(id)delegate
{
  return [LWEUIAlertView notificationAlertWithTitle:NSLocalizedString(@"No Network Access", @"Network.UnableToConnect_AlertViewTitle")
                                            message:NSLocalizedString(@"Please check your network connection and try again.", @"Network.UnableToConnect_AlertViewMessage")
                                           delegate:delegate];
}

+ (UIAlertView *)noNetworkAlert
{
  return [LWEUIAlertView noNetworkAlertWithDelegate:nil];
}

@end
