//
//  LWENotificationToolbar.h
//  LocationBasedMessaging
//
//  Created by Allan Jones on 17/07/10.
//  Copyright 2010 Swinburne University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWENotificationButton.h"


/**
 * \class       LWENotificationToolbar 
    @superclass  UIToolbar
 * \brief   UIToolbar subclass that displays a notification message
						and a badge indicating the number of items that are relevant
						to the notification
 * \details		Responsible for displaying notifications and an associated
							count for relevant items. The toolbar contains two buttons:
							closeButton for closing the toolbar and notificationButton,
							which should provide an action associated with the notifications.
							
*/
@interface LWENotificationToolbar : UIToolbar
{
	UIButton *closeButton;
	LWENotificationButton *notificationButton;
}

@property(nonatomic, retain) UIButton *closeButton;
@property(nonatomic, retain) LWENotificationButton *notificationButton;

/**
 * \brief   Sets the action for the close button
 * \param   sender The object that sent the message
 * \param   action The selector to be performed when the close button is clicked
 * \details   <#(comprehensive description)#>
 */
- (void)setCloseButtonTarget:(id)sender action:(SEL)action;

/**
 * \brief   Sets the action for the notification button
 * \param   sender The object that sent the message
 * \param   action The selector to be performed when the notification button is clicked
 * \details   <#(comprehensive description)#>
 */
- (void)setNotificationsButtonTarget:(id)sender action:(SEL)action;

/**
 * \brief   Sets the notification to be displayed in the toolbar
 * \param   notification The notification to be displayed
 * \details   Sets the title label text of the notification button
 */
- (void)setNotification:(NSString *)notification;

/**
 * \brief   Sets the relevant items count associated with the notification
 * \param   relevantItemsCount The number of relevant items assiociated with the notification
 * \details   Sets the text of the label within the notification bubble to the relevant items count
 */
- (void)setRelevantItemsCount:(NSInteger)relevantItemsCount;

@end
