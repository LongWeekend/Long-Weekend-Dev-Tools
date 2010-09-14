//
//  LWETooltipView.h
//  LocationBasedMessaging
//
//  Created by Rendy Pranata on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWETooltipConstants.h"
#import "LWETooltipParams.h"

/**
 * \class   LWETooltipView 
 * \brief   Creates a tooltip-like view with a close button and an optional callout graphic
 * \details This view is most similar to the callout view used (privately) in the Maps application.
						It is more customizable and extendable, and allows for a custom content view.
 */
//! LWE implementation of the tooltip view. It is cofigurable with the LWETooltipParams object which is passed in the init method. It also consist of the content view which can be constructed with the method calling, and instantiating this class.
@interface LWETooltipView : UIView 
{	
	LWETooltipParams *params;							//! Object which hold of all the parameter needed in the tool tip, like shadow, stroke width, etc.
	UIView *contentView;									//! Reference to the tooltip content UIView
	id <LWETooltipViewDelegate> delegate;	//! Delegate of this tooltip view, when event in this view fires, it will continue the event through this delegate. 

@private
	UIButton *_closeButton;								//! Memory representation of the close button in this tooltip view
	CGRect _roundRectFrame;								//! The rectangle frame of the rounded rectangle of a tooltip
	CGRect _calloutRectFrame;							//! The rectangle frame of the callout
}

@property (nonatomic, retain) LWETooltipParams *params;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, assign) id<LWETooltipViewDelegate> delegate;

/**
 * \brief		Initialize this tooltip with some parameters required to draw this tooltip, delegate, and its content view
 */
- (id)initWithFrame:(CGRect)frame toolTipParameters:(LWETooltipParams *)toolTipParameters delegate:(id<LWETooltipViewDelegate>) aDelegate contentView:(UIView *)aContentView;

/**
 * \brief   Sets the image for the close button
 * \param   image A standard UIImage
 * \details Also resets the frame for the button based on the image size
 */
- (void)_setCloseButtonImage:(UIImage*)image;

/**
 * \brief		Draw the callout in the view with the contecxt ref provided
 * \details	Takes two parameter which are the context needed to draw the callout
						and the callout bases which is the points of the callout.
 */
- (void)_drawCalloutWithContext:(CGContextRef)context andBases:(LWECalloutBases)calloutBases;

/**
 * \brief		Draw the rounded rectangle part of a tooltip
 * \details	Takes the context for drawing as a parameter
 */
- (void)_drawRoundRectWithContext:(CGContextRef)context;

// Private helper methods
- (LWECalloutBases)_calculateCalloutBases;
- (CGRect)_makeCalloutRectFrame;
- (CGRect)_makeNewRoundRectFrame;
- (CGRect)_makeCloseButtonRectFrame;
- (CGRect)_makeContentViewRect;
- (CGRect)_calibrateRoundedRectBasedOnShadow;

@end
