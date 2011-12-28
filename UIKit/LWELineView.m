//
//  LWELine.m
//  LocationBasedMessaging
//
//  Created by Rendy Pranata on 2/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LWELineView.h"
#import "LWEDebug.h"

@implementation LWELineView

@synthesize thickness, endPoint, color;


//! This is not a designated initializer, will result in an exception if used.
- (id)initWithFrame:(CGRect)frame
{
	LWE_LOG(@"Please be advised, this is not the designated initializer for LWELine");
	[NSException raise:NSGenericException format:@"Do not initialize LWELine without line properties"];
	return nil;
}


//! Designated initializer
/**
 *  \brief		This method will gets the line properties, do some calculation to get the line the end point and set the background color to clear as well.
 *	\param		Start coordinate will be passed in as the starting or beginning of the line. as well as the endpoint, and the weight or thickness of the line itself
 *	\details	This initializer is intended to be used to get "free-style" line, not in the orientation provided in the LWELineOrientation.
 *
 */
/*- (id)initWithOrigin:(CGPoint)startCoordinate endPoint:(CGPoint)endCoordinate weight:(CGFloat)aThickness
{
	if (self = [self initWithFrame:frame]) 
	{
		self.thickness = aThickness;
	}
	return self;
}*/

//! Designated initializer
/**
 *  \brief		This method will gets the line properties, do some calculation to get the line the end point and set the background color to clear as well.
 *	\param		Start coordinate will be passed in as the starting or beginning of the line. Length of the line, as well as the weight. Color will determine 
 *						in what color the line will be. As well as the orientation. The orientation will be given in form of LWELineOrientation enumeration declared
 *						in the header file.
 *	\details	Currently, in this initializer, only vertical or horizontal line will be supported. For the "free-style" line style please refer to the other
 *						initializer.
 *
 */
- (id)initWithOrigin:(CGPoint)startCoordinate length:(CGFloat)length weight:(CGFloat)aThickness color:(UIColor *)aColor orientation:(LWELineOrientation)anOrientation
{
	CGRect newFrame = CGRectZero;
	CGPoint newEndPoint;
	if (anOrientation == LWELineOrientationHorizontal)
	{
		newFrame = CGRectMake(startCoordinate.x, startCoordinate.y, startCoordinate.x + length, aThickness);
		newEndPoint = CGPointMake(length, 0.0f);
	}
	else if (anOrientation == LWELineOrientationVertical)
	{
		newFrame = CGRectMake(startCoordinate.x, startCoordinate.y, aThickness, startCoordinate.y + length);
		newEndPoint = CGPointMake(0.0f, length);
	}
	
  self = [super initWithFrame:newFrame];
	if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		self.thickness = aThickness;
		self.endPoint = newEndPoint;
		self.color = aColor;
	}
	return self;
}

//! This is the draw method, overriden from the super class. This method will draw the line, starting from the origin 0.0, to the end point.
- (void)drawRect:(CGRect)rect 
{
	//get the current context to draw the UI
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, self.color.CGColor);

	CGContextSetLineWidth(context, self.thickness);
	//LWE_LOG(@"End Point %f, %f", self.endPoint.x, self.endPoint.y);
	//LWE_LOG(@"Frame %f, %f, %f, %f", self.frame.size.height, self.frame.size.width, self.frame.origin.x, self.frame.origin.y);
	
	CGContextMoveToPoint(context, 0.0f, 0.0f);
	CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
	
	CGContextStrokePath(context);	
}


- (void)dealloc 
{
	[color release];
	[super dealloc];
}


@end
