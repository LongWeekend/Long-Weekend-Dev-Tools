//
//  LWELocalNotifications.m
//  LocationBasedMessaging
//
//  Created by Mark Makdad on 7/16/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import "LWELocalNotifications.h"


@implementation LWELocalNotifications

+ (void) scheduleLocalNotificationMessage:(NSString *)notificationBody withTitle:(NSString*)title inTimeIntervalSinceNow:(NSTimeInterval)interval
{
  UILocalNotification *note = [[UILocalNotification alloc] init];
  if (title)
  {
    note.hasAction = YES;
  }
  else
  {
    note.hasAction = NO;
  }
  note.alertAction = title;
  note.alertBody = notificationBody;
  note.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
  
  UIApplication *thisApp = [UIApplication sharedApplication];
  [thisApp scheduleLocalNotification:note];
  [note release];
}

@end
