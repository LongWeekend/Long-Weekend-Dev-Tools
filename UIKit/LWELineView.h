//
//  LWELine.h
//  LocationBasedMessaging
//
//  Created by Rendy Pranata on 2/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//! This enumeration is used with one of the designated initializer. The line can be either horizontal, or vertical. 
typedef enum
{
	LWELineOrientationHorizontal,
	LWELineOrientationVertical
}LWELineOrientation;

/**
 * This handy UIView Class LWE Utility can be used to draw a line in a view. Will have thickness (line weight), color as basic property of this Class.
 * Currently only supporting either vertical, or horizontal line. But in the next version it is expected to have some other initializer as well.
 *
 */
@interface LWELineView : UIView 
{
	CGFloat thickness;
	CGPoint endPoint;
	UIColor *color;
}

@property CGFloat thickness;
@property CGPoint endPoint;
@property (nonatomic, retain) UIColor *color;

//- (id)initWithOrigin:(CGPoint)startCoordinate endPoint:(CGPoint)endCoordinate weight:(CGFloat)aThickness;
- (id)initWithOrigin:(CGPoint)startCoordinate length:(CGFloat)length weight:(CGFloat)aThickness color:(UIColor *)aColor orientation:(LWELineOrientation)anOrientation;

@end
