//
//  LWENotificationButton.m
//  LocationBasedMessaging
//
//  Created by Allan Jones on 17/07/10.
//  Copyright 2010 Swinburne University. All rights reserved.
//

#import "LWENotificationButton.h"
#import "LWENotificationToolbarConstants.h"

@implementation LWENotificationButton

@synthesize notificationCount, notificationCountRect, countLabel;

// TODO: May want to make this subclass a bit more flexible so that we can choose at runtime where
// we want to place the notification label

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
		{
			// Set the default text and font properties for the button's title label
			self.titleLabel.text = kDefaultNotificationButtonTitleLabelText;
			self.titleLabel.textColor = kDefaultNotificationButtonCountLabelTextColor;
			self.titleLabel.font = kDefaultNotificationButtonTitleLabelFont;
			
			// Create the bounding rectangle for the notfication count label and init with an empty frame
			self.notificationCountRect = [[LWERoundedRectView alloc] initWithFrame:CGRectZero];
			// Set the notification count rectangle's corner radius
			// TODO: Figure out a better way to do rounded counders (looks too choppy using rounded rect)...
			self.notificationCountRect.cornerRadius	= kDefaultNotificationButtonCountLabelCornerRadius;
			
			// Set the stroke attributes for the notification count rectangle
			self.notificationCountRect.strokeColor		= kDefaultNotificationButtonCountLabelStrokeColor;
			self.notificationCountRect.strokeWidth		= kDefaultNotificationButtonCountLabelStrokeWidth;
			// Set the background color for the count label rectangle
			self.notificationCountRect.rectColor	= kDefaultNotificationButtonCountLabelBackgroundColor;
			
			// Create the notification
			self.countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			self.countLabel.font							= kDefaultNotificationButtonCountLabelFont;
			self.countLabel.textColor				= kDefaultNotificationButtonCountLabelTextColor;
			self.countLabel.backgroundColor	= [UIColor clearColor];
			
			// Add the notification count	bounding rectangle as a subview to the button
			[self addSubview:notificationCountRect];
			// Add the the notification count label as a subview to the bounding rectangle
			[self.notificationCountRect addSubview:countLabel];
    }
    return self;
}

//! Redraws the title label, count label and the bounding rectangle for the count label
//	based on the size of their text properties
- (void)drawRect:(CGRect)rect
{
	// Determine the size of the title label string based on it's text and current font
	CGSize titleStringSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
	// Set the color for the title label
	// Draw the title label in a rectangle based on it's calculated width
	[self.titleLabel drawTextInRect:CGRectMake(0, 0, titleStringSize.width, 44)];
	
	// Set the count label string to the notification count
	NSString *countLabelString = [NSString stringWithFormat:@"%d", notificationCount];
	// Get the size of the count label string with it's current font
	CGSize countLabelStringSize = [countLabelString sizeWithFont:kDefaultNotificationButtonCountLabelFont];
	
	// Make and set the frame for the notification count rect
	notificationCountRect.frame = CGRectMake(titleStringSize.width + kDefaultNotificationButtonCountLabelLeftOffset,
																					 kDefaultNotificationButtonCountLabelLeftOffset,
																					 countLabelStringSize.width + kDefaultNotificationButtonCountLabelHorizontalPadding * 2,
																					 countLabelStringSize.height + kDefaultNotificationButtonCountLabelVerticalPadding * 2);
	
	// Make and set the rectangle that the count label is to be drawn into
	countLabel.frame = CGRectMake(kDefaultNotificationButtonCountLabelHorizontalPadding,
																kDefaultNotificationButtonCountLabelVerticalPadding,
																countLabelStringSize.width,
																countLabelStringSize.height);
	
	// Set the text, font and color properties for the notification count label
	countLabel.text = countLabelString;
}

- (void)dealloc
{
	[self setNotificationCountRect:nil];
	[self setCountLabel:nil];
	[super dealloc];
}

@end
