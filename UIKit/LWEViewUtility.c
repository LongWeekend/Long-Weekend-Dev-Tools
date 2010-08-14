/*
 *  LWEViewUtility.c
 *  jFlash
 *
 *  Created by Rendy Pranata on 29/07/10.
 *  Copyright 2010 Long Weekend LLC. All rights reserved.
 *
 */

#include "LWEViewUtility.h"


//
// NewPathWithRoundRect
//
// Creates a CGPathRect with a round rect of the given radius.
//
CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,
										rect.origin.x,
										rect.origin.y + rect.size.height - cornerRadius);
	
	// Top left corner
	CGPathAddArcToPoint(path, NULL,
											rect.origin.x,
											rect.origin.y,
											rect.origin.x + rect.size.width,
											rect.origin.y,
											cornerRadius);
	
	// Top right corner
	CGPathAddArcToPoint(path, NULL,
											rect.origin.x + rect.size.width,
											rect.origin.y,
											rect.origin.x + rect.size.width,
											rect.origin.y + rect.size.height,
											cornerRadius);
	
	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
											rect.origin.x + rect.size.width,
											rect.origin.y + rect.size.height,
											rect.origin.x,
											rect.origin.y + rect.size.height,
											cornerRadius);
	
	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
											rect.origin.x,
											rect.origin.y + rect.size.height,
											rect.origin.x,
											rect.origin.y,
											cornerRadius);
	
	// Close the path at the rounded rect
	CGPathCloseSubpath(path);
	
	return path;
}
