//
//  LWETooltipParams.m
//  LocationBasedMessaging
//
//  Created by Rendy Pranata on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LWETooltipParams.h"
#import "LWEDebug.h"

@implementation LWETooltipParams

@synthesize closeButtonPosition, closeButtonImage;
@synthesize shadowOffset, showDropShadow, alpha, shouldResize;
@synthesize rectColor, backgroundColor, strokeColor, strokeWidth;
@synthesize cornerRadius;
@synthesize calloutPosition, calloutDirection, calloutOffset, calloutSize, showCallout;

- (id)init
{
	LWE_LOG(@"Please be advised, this is not the designated initialiser, please use the default value");
	return nil;
}


- (id)initWithDefaultValue;
{
	if ((self = [super init]))
	{	
		// Default options
		self.closeButtonPosition = LWETooltipCloseButtonPositionTopRight;
		self.closeButtonImage = [UIImage imageNamed:@"overlay-btn-close.png"];
		
		self.shadowOffset = CGSizeMake(3, 5);
		self.showDropShadow = YES;
		self.alpha = 1.0f;
		
		self.rectColor = kDefaultRectColor;
		backgroundColor = kDefaultBackgroundColor;
		self.strokeColor = kDefaultStrokeColor;
		self.strokeWidth = kDefaultStrokeWidth;
		
		self.cornerRadius = kDefaultCornerRadius;
		
		self.calloutPosition = LWETooltipCalloutPositionTop;
		self.calloutDirection = LWETooltipCalloutDirectionStraight;
    self.calloutOffset = LWETooltipCalloutOffsetLeft;
    self.calloutSize = 0.15f;
		self.showCallout = YES;
		self.shouldResize = NO;
	}
	return self;
}


- (void)dealloc
{
	self.closeButtonImage = nil;
	self.rectColor = nil;
	[backgroundColor release];
	self.strokeColor = nil;
	[super dealloc];
}


@end
