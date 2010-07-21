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
 * \brief   Set the numeric badge to show for the application
 * \param   badgeNumber The new badge number for the application
 * \details   <#(comprehensive description)#>
 */
+ (void)setApplicationBadgeNumber:(NSInteger)badgeNumber;

/**
 * \brief   Schedules a notification on the user's phone
 * \param   message The text to be displayed
 * \param   buttonTitleOrNil A title for the action button.  If nil, no action button is displayed
 * \param   interval How long to wait before displaying, or nil for immediately
 */
+ (void) scheduleLocalNotificationWithMessage:(NSString *)message buttonTitle:(NSString*)buttonTitleOrNil inTimeIntervalSinceNow:(NSTimeInterval)interval;
+ (void) presentLocalNotificationWithMessage:(NSString*)message buttonTitle:(NSString*)buttonTitleOrNil;

//! Private
+ (UILocalNotification*) _prepareNotificationWithMessage:(NSString*)message buttonTitle:(NSString*)buttonTitleOrNil;

@end