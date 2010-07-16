//
//  LWELocalNotifications.h
//  LocationBasedMessaging
//
//  Created by Mark Makdad on 7/16/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWELocalNotifications : NSObject
{
}

/**
 * \brief   Schedules a notification on the user's phone
 * \param   notificationBody The text to be displayed
 * \param   title A title for the action button.  If nil, no action button is displayed
 * \param   interval How long to wait before displaying
 */
+ (void) scheduleLocalNotificationMessage:(NSString *)notificationBody withTitle:(NSString*)title inTimeIntervalSinceNow:(NSTimeInterval)interval;

@end
