//
//  RoundedRectView.h
//
//  Created by Jeff LaMarche on 11/13/08.

#import <UIKit/UIKit.h>
#import "LWETooltipConstants.h"

/**
 * Available stroking type for the view.
 * Defaulted to solid stroke.
 */
typedef enum LWEStrokeType
{
  LWEStrokeTypeSolidStroke,
  LWEStrokeTypeDottedLine
} LWEStrokeType;

/** 
 * Draws a rounded-rect view and could be customised
 * with the different stroking and fill parameters.
 */
@interface LWERoundedRectView : UIView


/** @name Rounded Rect Customisation */

/** Background color for inside of the rounded rect. */
@property (retain, nonatomic) UIColor *rectColor;

/** Corner radius for the rounded corner. */
@property (assign, nonatomic) CGFloat cornerRadius;

/** Shadow offset for the whole view. */
@property (assign, nonatomic) CGSize shadowOffset;


/** @name Stroke Customisation */

/** Stroke type for the border. */
@property (assign, nonatomic) LWEStrokeType strokeType;

/** Stroke color for the border. */
@property (retain, nonatomic) UIColor *strokeColor;

/** Thickness of the stroke. */
@property (assign, nonatomic) CGFloat strokeWidth;

/**
 * Dashes to specify the pattern. An array containing CGFloat(s).
 *
 * Default to nil, has to be specified if strokeType is `LWEStrokeTypeDottedLine`
 * An example could be {1.0f, 2.0f, 3.0f, 4.0f},
 * which means 1px filled line, followed by 2px free-space, followed by 3px line, then 4px free-space.
 */
@property (assign, nonatomic) CGFloat *dashesPattern;

@end
