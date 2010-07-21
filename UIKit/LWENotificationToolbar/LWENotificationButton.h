//
//  LWENotificationButton.h
//  LocationBasedMessaging
//
//  Created by Allan Jones on 17/07/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWERoundedRectView.h"
#import "LWENotificationToolbarConstants.h"

/**
 * \class       LWENotificationButton 
 @superclass  UIButton
 * \brief   <#(brief description)#>
 * \details   <#(comprehensive description)#>
 */
@interface LWENotificationButton : UIButton
{
	NSInteger notificationCount;
	LWERoundedRectView *notificationCountRect;
@private
	UILabel *countLabel;
}

@property NSInteger notificationCount;
@property(nonatomic, retain) LWERoundedRectView *notificationCountRect;
@property(nonatomic, retain) UILabel *countLabel;

@end
