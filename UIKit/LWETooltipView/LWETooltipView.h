//
//  LWETooltipView.h
//  LocationBasedMessaging
//
//  Created by Mark Makdad on 7/15/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWETooltipConstants.h"
#import "LWERoundedRectView.h"
#import "LWECalloutView.h"

/**
 * \class   LWETooltipView 
 * \brief   Creates a tooltip-like view with a close button and an optional callout graphic
 * \details This view is most similar to the callout view used (privately) in the Maps application.
 It is more customizable and extendable, and allows for a custom content view.
*/
@interface LWETooltipViewOLD : UIView
{
  //! If YES, the view will show a callout (like a speech bubble)
  BOOL showCallout;
  
  //! If YES, draw a dropshadow
  BOOL showDropShadow;
  
  //! Determines where the callout is displayed in reference to the tooltip (left, right, top, bottom)
  LWETooltipCalloutPosition calloutPosition;
  
  //! Determines the angle of the callout graphic
  LWETooltipCalloutDirection calloutDirection;
  
  //! Determines in which corner the close button should appear inside the tooltip
  LWETooltipCloseButtonPosition closeButtonPosition;
  
  //! Sets the callout graphic to be slightly offset from the standard position
  LWETooltipCalloutOffset calloutOffset;
  
  //! Value between 0-1 indicating how big/long the callout should be
  CGFloat calloutSize;
  
  //! Size of the drop shadow - should be positive values (negative not yet supported)
  CGSize shadowOffset;
  
  //! Reference to the UIButton close button for the tooltip
  UIButton *closeButton;
  
  //! Reference to the tooltip content UIView
  UIView *tooltipView;

  @private
  LWERoundedRectView *roundedRectView;
  LWECalloutView *calloutView;
}

/**
 * \brief   Sets the image for the close button
 * \param   image A standard UIImage
 * \details Also resets the frame for the button based on the image size
 */
- (void) setCloseButtonImage:(UIImage*)image;

/**
 * \brief   Sets the action target when the close button is clicked
 * \param   sender Who will receive the action
 * \param   action What action is to be sent
 * \details Use this method to specify the callback that will dismiss the tooltip
 */
- (void) setCloseButtonTarget:(id)sender action:(SEL)action;

/**
 * \brief   Sets the location of the close button inside the tooltip
 * \details Set to one of the values of enum LWETooltipCloseButtonPosition
 */
- (void) setCloseButtonPosition:(LWETooltipCloseButtonPosition)position;

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
 * \brief   Sets the size of the callout, relative to the total frame (percentage).
 * \param   size Value between 0 and 1
 * \details For example, if set to 0.15f, the callout will occupy 15% of the frame, giving
 the tooltip the remaining 85% to draw itself.
 */
- (void) setCalloutSize:(CGFloat)size;


/**
 * \brief   Sets the shadow offset size for the subviews
 * \param   size Should be a positive-valued CGSize struct
 * \details Blurring is set in LWETooltipConstants.h
 */
- (void) setShadowOffset:(CGSize)size;

- (void) layoutTooltip;

// Private helper methods
- (CGRect) _makeNewRoundRectFrame;
- (CGRect) _makeCloseButtonRectFrame;
- (CGRect) _makeCalloutRectFrame;
- (CGRect) _makeContentViewRect;

@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIView *contentView;
@property BOOL showCallout;
@property BOOL showDropShadow;

@property (nonatomic, retain) LWERoundedRectView *roundedRectView;
@property (nonatomic, retain) LWECalloutView *calloutView;

@end
