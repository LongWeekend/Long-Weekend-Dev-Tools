//
//  LWENotificationToolbar.m
//  LocationBasedMessaging
//
//  Created by Allan Jones on 17/07/10.
//  Copyright 2010 Swinburne University. All rights reserved.
//

#import "LWENotificationToolbar.h"


@implementation LWENotificationToolbar

@synthesize closeButton, notificationButton;

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		// Set the tint color
		self.tintColor = kDefaultToolbarTintColor;
		
		// Create the close and notification buttons with custom style
		self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.notificationButton = [LWENotificationButton buttonWithType:UIButtonTypeCustom];
		
		// TODO: Need to fix left inset issues with close button
		// Create the close buttons frame
		self.closeButton.frame = CGRectMake(0, 0, 44, 44);
		
		[self.closeButton setTitle:kDefaultCloseButtonTitleLabelText forState:UIControlStateNormal];
		// Add insets and align horizontally left
		self.closeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
		self.closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		
		// Set the notification button's frame
		self.notificationButton.frame = CGRectMake(0, 0, 300, 44);
		// Align the notification button in the center of the toolbar
		self.notificationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		// Create the bar buttons from our buttons and add them as the toolbar's items in a new array
		UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
		UIBarButtonItem *notificationsBarButton = [[UIBarButtonItem alloc] initWithCustomView:notificationButton];
		self.items = [NSArray arrayWithObjects:closeBarButton, notificationsBarButton, nil];
		
		// Release the bar button items
		[closeBarButton release];
		[notificationsBarButton release];
	}
	return self;
}

- (void)setCloseButtonTarget:(id)sender action:(SEL)action
{
	[closeButton addTarget:sender action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNotificationsButtonTarget:(id)sender action:(SEL)action
{
	[notificationButton addTarget:sender action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNotification:(NSString *)notification
{
	self.notificationButton.titleLabel.text = notification;
}

- (void)setRelevantItemsCount:(NSInteger)relevantItemsCount
{
	self.notificationButton.notificationCount = relevantItemsCount;
	[self.notificationButton setNeedsDisplay];
}

- (void)dealloc
{
	[self setCloseButton:nil];
	[self setNotificationButton:nil];
	[super dealloc];
}


@end
