//
//  LWELocalNotifications.m
//  LocationBasedMessaging
//
//  Created by Mark Makdad on 7/16/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import "LWELocalNotifications.h"


@implementation LWELocalNotifications

+ (void)setApplicationBadgeNumber:(NSInteger)badgeNumber
{
	if(badgeNumber < 0)
	{
		[NSException raise:@"ApplicationBadgeNumberCannotBeZero" format:@""];
	}
	
	//Set badge number
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}

+ (UILocalNotification*) _prepareNotificationWithMessage:(NSString*)message buttonTitle:(NSString*)buttonTitleOrNil
{
  UILocalNotification *note = [[[UILocalNotification alloc] init] autorelease];
  note.alertBody = message;
  note.soundName = UILocalNotificationDefaultSoundName;
  // Show action button if we have a title
  if (buttonTitleOrNil)
  {
    note.hasAction = YES;	
    note.alertAction = buttonTitleOrNil;
  }
  else
  {
    note.hasAction = NO;
  }
  return note;
}

+ (void) scheduleLocalNotificationWithMessage:(NSString *)message buttonTitle:(NSString*)buttonTitleOrNil inTimeIntervalSinceNow:(NSTimeInterval)interval
{
  UILocalNotification *note = [LWELocalNotifications _prepareNotificationWithMessage:message buttonTitle:buttonTitleOrNil];
  note.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
  [[UIApplication sharedApplication] scheduleLocalNotification:note];
}


+ (void) presentLocalNotificationWithMessage:(NSString*)message buttonTitle:(NSString*)buttonTitleOrNil
{
  UILocalNotification *note = [LWELocalNotifications _prepareNotificationWithMessage:message buttonTitle:buttonTitleOrNil];
  [[UIApplication sharedApplication] presentLocalNotificationNow:note];
}

@end
