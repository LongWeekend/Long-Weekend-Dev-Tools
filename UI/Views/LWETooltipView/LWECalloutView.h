//
//  LWECalloutView.h
//  LocationBasedMessaging
//
//  Created by Mark Makdad on 7/15/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWETooltipConstants.h"

/**
 * \class   LWECalloutView 
 * \brief   Draws a callout view (a triangle), intended to be used by LWETooltipView
 * \details This class should not be instantiated directly, but used as part of LWETooltipView
*/
@interface LWECalloutView : UIView
{
  //! Color to stroke with
  UIColor *strokeColor;
  
  //! Color to fill path with
  UIColor *rectColor;
  
  //! Width of the path stroke
  CGFloat strokeWidth;
  
  //! Width & height offset of the shadow (should be positive values, negative doesn't seem to work yet)
  CGSize shadowOffset;

  @private
  LWETooltipCalloutDirection calloutDirection;
  LWETooltipCalloutPosition calloutPosition;
  LWETooltipCalloutOffset calloutOffset;
}

/**
 * \brief   Sets the position of the callout in reference to the tooltip
 * \param   position Enum value in LWETooltipCalloutPosition
 * \details Sets the direction that the callout "points" in/from.  If you want
 the tooltip to appear above the content you're referring to, set this to "bottom" for example.
 */
- (void) setCalloutPosition:(LWETooltipCalloutPosition)position;

/**
 * \brief   Sets an arbitrary offset for the callout's location
 * \param   offset Enum value in LWETooltipCalloutOffset
 * \details By default, the callout will be drawn coming from the
 1/4 length, 1/2 length, and/or 3/4 length points on the relevant edge of the tooltip.
 If you specify an offset, these points will be shifted left or right
 to slightly change where the callout "pointer" points to.
 */
- (void) setCalloutOffset:(LWETooltipCalloutOffset)offset;

/**
 * \brief   Sets the angle of the callout graphic
 * \param   direction Enum value in LWETooltipCalloutDirection
 * \details If straight, the callout will be an isoceles triangle pointing straight up.
 If one of the other settings, it will be scalene, appearing to
 point to the left or the right.
 */
- (void) setCalloutDirection:(LWETooltipCalloutDirection)direction;

/**
 * \brief   Sets the fill color
 * \param   color Any UIColor
 */
- (void) setCalloutFillColor:(UIColor*) color;

/**
 * \brief   Sets the shadow's offset from the callout
 * \param   size Should be a CGSize with positive height/width values
 * \details For some reason, we are not yet friendly with negative values (we haven't done it yet)
 */
- (void) setShadowOffset:(CGSize)size;

@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *rectColor;
@property CGFloat strokeWidth;
@property CGSize shadowOffset;

@end
