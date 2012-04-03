// LWELocalNotifications.m
//
// Copyright (c) 2010 Long Weekend LLC
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

#import "LWELocalNotifications.h"

//! Private
@interface LWELocalNotifications ()
+ (UILocalNotification*) _prepareNotificationWithMessage:(NSString*)message buttonTitle:(NSString*)buttonTitleOrNil;
@end

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
