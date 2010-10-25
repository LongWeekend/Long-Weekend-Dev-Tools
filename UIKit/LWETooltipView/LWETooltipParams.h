//
//  LWETooltipParams.h
//  LocationBasedMessaging
//
//  Created by Rendy Pranata on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWETooltipConstants.h"

//! This structure is used in a callout properties. Callout can be thought of a triangle which has 3 points, the first base, midpoin, and the pointOnBase. (The term used here MAY not be correct) but just to give the idea, it also has a height of the triangle (callout).
struct LWECalloutBases
{
  CGFloat firstBase;
  CGFloat pointOnBase;
	CGFloat midpointOnBase;
	CGFloat height;
};

typedef struct LWECalloutBases LWECalloutBases;

//Avoid the circular dependencies between tooltip view, and its params. 
@class LWETooltipView;

//! Protocol that can be conformed by a class which going to have an LWETooltip, and acts as a delegate for all the action in the LWETooltip. Currently it only supports touch up inside event, but this opens to a future implementation.
@protocol LWETooltipViewDelegate <NSObject>
@optional
- (void)tooltipView:(LWETooltipView *)tooltipView closeButtonDidReceiveAction:(UIControlEvents)action;
@end

/**
 * \class   LWETooltipParams 
 * \brief   Object that represents the customizable parameters in the LWETooltip
 * \details This object acts like a helper to host all of the cutomizable parameters that can be set in order to draw an LWETooltip. 
 */
@interface LWETooltipParams : NSObject 
{
	//Tooltip close button related parameter
	LWETooltipCloseButtonPosition closeButtonPosition;	//! Determines in which corner the close button should appear inside the tooltip
  UIImage *closeBtnImage;															//! Reference to the UIButton close button for the tooltip
	
	//Tooltip view look and feel related parameter
  BOOL showDropShadow;			//! If YES, draw a dropshadow
	CGSize shadowOffset;			//! Size of the drop shadow - should be positive values (negative not yet supported)
	CGFloat shadowBlur;				//! Non negative number, specifiying the amount of the blur
	CGFloat alpha;						//! opacity of the tooltip
	BOOL shouldResize;				//! boolean to indicate that the tolltip will resize based on the content view provided. 
	
	//Background colour, and stroke related properties (Color, and width of the lines)
	UIColor *rectColor;				//! Color to fill path with
	UIColor *backgroundColor;	//! Background color (The rest of the view)
	UIColor *strokeColor;			//! Color to stroke with
  CGFloat strokeWidth;			//! Width of the path stroke
	
	//Round rectangle parameter
	CGFloat cornerRadius;			//! radius of the rounded rectangle
	
	//Callout related parameters (The speech buble guy that is going to attached with the tooltip.
	BOOL showCallout;															//! If YES, the view will show a callout (like a speech bubble)
	CGFloat calloutSize;													//! Value between 0-1 indicating how big/long the callout should be
  LWETooltipCalloutPosition calloutPosition;		//! Determines where the callout is displayed in reference to the tooltip (left, right, top, bottom)
  LWETooltipCalloutDirection calloutDirection;	//! Determines the angle of the callout graphic
  LWETooltipCalloutOffset calloutOffset;				//! Sets the callout graphic to be slightly offset from the standard position		
}

//Tooltip close buttont related parameter
@property LWETooltipCloseButtonPosition closeButtonPosition;
@property (nonatomic, retain) UIImage *closeButtonImage;

////Tooltip view look and feel related parameter
@property BOOL showDropShadow;
@property CGSize shadowOffset;
@property CGFloat shadowBlur;
@property CGFloat alpha;
@property BOOL shouldResize;

//Strokes properties with background colour
@property (nonatomic, retain) UIColor *rectColor;
// user does not really want to change our view's bg color - then the alpha won't work.
@property (nonatomic, retain, readonly) UIColor *backgroundColor;
@property (nonatomic, retain) UIColor *strokeColor;
@property CGFloat strokeWidth;

//Round rectangle parameter
@property CGFloat cornerRadius;

//Callout properties
@property LWETooltipCalloutPosition calloutPosition;
@property LWETooltipCalloutDirection calloutDirection;
@property LWETooltipCalloutOffset calloutOffset;
@property CGFloat calloutSize;
@property BOOL showCallout;

// TODO: RENDY, please doc these ;)
/**
 * \brief   <#(brief description)#>
 * \return   <#(description)#>
 * \details   <#(comprehensive description)#>
 */
- (id)initWithDefaultValue;

@end
