//
//  LWETooltipView.m
//  LocationBasedMessaging
//
//  Created by Rendy Pranata on 26/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LWETooltipView.h"
#import "LWEDebug.h"

@implementation LWETooltipView

@synthesize params, delegate, contentView;

- (id)initWithFrame:(CGRect)frame 
{
	LWE_LOG(@"Please be advised, this is not the designated initialiser");
	if ((self = [super initWithFrame:frame])) 
	{
			//Future implementation
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame toolTipParameters:(LWETooltipParams *)toolTipParameters delegate:(id<LWETooltipViewDelegate>)aDelegate contentView:(UIView *)aContentView
{
	if (self = [super initWithFrame:frame])
	{
		if (toolTipParameters)
		{
			[self setParams:toolTipParameters];
		}
		else
		{
			LWETooltipParams *tempParams = [[LWETooltipParams alloc] initWithDefaultValue];
			[self setParams:tempParams];
			[tempParams release];
		}
		
		if (self.params.showCallout)
		{
			_roundRectFrame = [self _makeNewRoundRectFrame];
			_calloutRectFrame = [self _makeCalloutRectFrame];
		}
		else 
		{
			_calloutRectFrame = CGRectZero;
			_roundRectFrame = [self bounds];
		}
		
		[self setBackgroundColor:self.params.backgroundColor]; 
		[self setOpaque:NO];
		[self setDelegate:aDelegate];
		
		_closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[self _setCloseButtonImage:self.params.closeButtonImage];
		[_closeButton addTarget:self action:@selector(_closeButtonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		
		[self setContentView:aContentView];
		self.contentView.backgroundColor = [UIColor clearColor];
		//self.contentView = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	}
	return self;
}

#pragma mark -
#pragma mark Close Button Event Handling

- (void)_closeButtonDidTouchUpInside:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(tooltipView:closeButtonDidReceiveAction:)])
	{
		LWE_LOG(@"Close button did touch up inside in the LWETooptip class");
		[self.delegate tooltipView:self closeButtonDidReceiveAction:UIControlEventTouchUpInside];
	}
}

#pragma mark -
#pragma mark Privates

- (void)_setCloseButtonImage:(UIImage*)image
{
  [_closeButton setImage:image forState:UIControlStateNormal];
  CGRect imageRect = CGRectZero;
  imageRect.size = image.size;
  [_closeButton setFrame:imageRect];
}


#pragma mark -
#pragma mark Drawing Code

- (void)drawRect:(CGRect)rect 
{	
	[self setAlpha:self.params.alpha];
	//get the current context to draw the UI
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//set up all of the parameter with the drawing instrument
	CGContextSetLineWidth(context, self.params.strokeWidth);
  CGContextSetStrokeColorWithColor(context, self.params.strokeColor.CGColor);
  CGContextSetFillColorWithColor(context, self.params.rectColor.CGColor);
	
	//draw the tooltip with the callout as well if needed
	[self _drawRoundRectWithContext:context];
	
	CGContextSaveGState(context);
	if (self.params.showDropShadow)
	{
		CGFloat shadowX = self.params.shadowOffset.width;
		CGFloat shadowY = self.params.shadowOffset.height;
		CGContextSetShadow(context, CGSizeMake(shadowX, shadowY), kDefaultShadowBlur); 		
	}
	
  CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
  CGContextRestoreGState(context);
	
	//Set up the content view frame, and then add to self for subview
	self.contentView.frame = [self _makeContentViewRect];
	[self addSubview:self.contentView];		
	
	//Add the subview for the close button after setting up the frame based on the position of the close button in the param.
	_closeButton.frame = [self _makeCloseButtonRectFrame];
	[self addSubview:_closeButton];
}

- (void)_drawRoundRectWithContext:(CGContextRef)context
{
  CGRect rrect = _roundRectFrame;
  
  // TODO: find out why this matters when we have a stroke?
	//  rrect.origin.x = rrect.origin.x + 1;
	//  rrect.origin.y = rrect.origin.y + 1;
	//  rrect.size.height = rrect.size.height - 1;
	//  rrect.size.width = rrect.size.width - 1;
  
  // If we have a shadow other than zero, offset either the size or the origin (move the box)
  /*if (shadowX > 0)
	 {
	 rrect.size.width = rrect.size.width - (2 * shadowX);
	 }
	 else if (shadowX < 0)
	 {
	 rrect.origin.x = rrect.origin.x - (2 * shadowX);
	 rrect.size.width = rrect.size.width - (2 * shadowX);
	 }
	 
	 if (shadowY > 0)
	 {
	 rrect.size.height = rrect.size.height - ( 2 * shadowY);
	 }
	 else if (shadowY < 0)
	 {
	 rrect.origin.y = rrect.origin.y - ( 2 * shadowY);
	 rrect.size.height = rrect.size.height - ( 2 * shadowY);
	 }*/
  
  
  CGFloat radius = self.params.cornerRadius;
  CGFloat width = CGRectGetWidth(rrect);
  CGFloat height = CGRectGetHeight(rrect);
  
  // Make sure corner radius isn't larger than half the shorter side
  if (radius > width/2.0)
    radius = width/2.0;
  if (radius > height/2.0)
    radius = height/2.0;
  
  CGFloat minx = CGRectGetMinX(rrect);
  CGFloat midx = CGRectGetMidX(rrect);
  CGFloat maxx = CGRectGetMaxX(rrect);
  CGFloat miny = CGRectGetMinY(rrect);
  CGFloat midy = CGRectGetMidY(rrect);
  CGFloat maxy = CGRectGetMaxY(rrect);
  
  CGContextMoveToPoint(context, minx, midy);
	if (!self.params.showCallout)
	{
		CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
		CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
		CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
		CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	}
	else 
	{
		LWECalloutBases calloutBase = [self _calculateCalloutBases];
		switch (self.params.calloutPosition)
		{
			case LWETooltipCalloutPositionTop:
				CGContextAddArcToPoint(context, minx, miny, calloutBase.firstBase, miny, radius);
				[self _drawCalloutWithContext:context andBases:calloutBase];
				CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
				CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
				CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
				break;
			case LWETooltipCalloutPositionBottom:
				CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
				CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
				CGContextAddArcToPoint(context, maxx, maxy, calloutBase.pointOnBase, maxy, radius);
				[self _drawCalloutWithContext:context andBases:calloutBase];
				CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
				break;
			case LWETooltipCalloutPositionLeft:
				CGContextMoveToPoint(context, midx, miny);
				CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
				CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
				CGContextAddArcToPoint(context, minx, maxy, minx, calloutBase.pointOnBase, radius);
				[self _drawCalloutWithContext:context andBases:calloutBase];
				CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
				break;
			case LWETooltipCalloutPositionRight:
				CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
				CGContextAddArcToPoint(context, maxx, miny, maxx, calloutBase.firstBase, radius);
				[self _drawCalloutWithContext:context andBases:calloutBase];
				CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
				CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
				break;
		}
	}  
}


- (void)_drawCalloutWithContext:(CGContextRef)context andBases:(LWECalloutBases)calloutBases
{
  switch (self.params.calloutPosition)
  {
    case LWETooltipCalloutPositionTop:
      CGContextAddLineToPoint(context, calloutBases.firstBase, calloutBases.height);
      CGContextAddLineToPoint(context, calloutBases.midpointOnBase, 0);
			CGContextAddLineToPoint(context, calloutBases.pointOnBase, calloutBases.height);
      break;
    case LWETooltipCalloutPositionBottom:
			//offset from the rounded rectable, thats why it has to be added with the rounded rectangle height
      CGContextAddLineToPoint(context, calloutBases.pointOnBase, _roundRectFrame.size.height);
      CGContextAddLineToPoint(context, calloutBases.midpointOnBase, (calloutBases.height + _roundRectFrame.size.height));
      CGContextAddLineToPoint(context, calloutBases.firstBase, _roundRectFrame.size.height);
      break;
    case LWETooltipCalloutPositionLeft:
      CGContextAddLineToPoint(context, calloutBases.height, calloutBases.pointOnBase);
      CGContextAddLineToPoint(context, 0, calloutBases.midpointOnBase);
      CGContextAddLineToPoint(context, calloutBases.height, calloutBases.firstBase);
      break;
    case LWETooltipCalloutPositionRight:
      CGContextAddLineToPoint(context, _roundRectFrame.size.width, calloutBases.firstBase);
			//Added with the height and round rectangle frame width cause the tool tip will be on the right, and the x and y of 
			//the mid point of the tool tip has to be added with the offset from the rounded rectangle
      CGContextAddLineToPoint(context, (_roundRectFrame.size.width + calloutBases.height), calloutBases.midpointOnBase);
      CGContextAddLineToPoint(context, _roundRectFrame.size.width, calloutBases.pointOnBase);
      break;
  }
}

#pragma mark -
#pragma mark Drawing Calculation

- (LWECalloutBases)_calculateCalloutBases
{
	LWECalloutBases calloutBases;
	CGRect calloutRect = _calloutRectFrame;
  CGFloat base;
	
  // Since height/width don't apply (we could be left orientation, bottom orientation, etc)
  // use base/length instead
  if (self.params.calloutPosition == LWETooltipCalloutPositionTop || self.params.calloutPosition == LWETooltipCalloutPositionBottom)
  {
    base = CGRectGetWidth(calloutRect);
    calloutBases.height = CGRectGetHeight(calloutRect);
  }
  else
  {
    base = CGRectGetHeight(calloutRect);
    calloutBases.height = CGRectGetWidth(calloutRect);
  }
	
  // Do we have any offset?
  CGFloat offset = 1.0f;
  if (self.params.calloutOffset == LWETooltipCalloutOffsetLeft)
  {
    offset = 0.65f;
  }
  else if (self.params.calloutOffset == LWETooltipCalloutOffsetRight)
  {
    offset = 1.3f;
  }	
  
  // Now determine where the points are
  if (self.params.calloutDirection == LWETooltipCalloutDirectionLeftToRight)
  {
    // 1/45 of the way down the base
    calloutBases.firstBase = (base / 4.5f) * offset;
    calloutBases.pointOnBase = (base / 2) * offset;
    calloutBases.midpointOnBase = (base / 4.5f) * 3.0f * offset;
  }
  else if (self.params.calloutDirection == LWETooltipCalloutDirectionRightToLeft)
  {
    // Use the big end, 3/45 of the way down the base
    calloutBases.pointOnBase = (base / 4.5f) * 3.0f * offset;
    calloutBases.firstBase = (base / 2) * offset;
    calloutBases.midpointOnBase = (base / 4.5f * offset);
  }
  else
  {
    // Straight up!
    calloutBases.firstBase = (base * 2) / 5 * offset;
    calloutBases.pointOnBase = (base * 3) / 5 * offset;
    calloutBases.midpointOnBase = (base / 2) * offset;
  }
	return calloutBases;
}


// Makes the CGRect for the callout graphic
- (CGRect) _makeCalloutRectFrame
{
  CGRect tmpCalloutRectFrame = CGRectZero;
	CGRect tmpRoundRectFrame = _roundRectFrame;
	if ((!CGRectIsEmpty(tmpRoundRectFrame)) && (!CGRectIsNull(tmpRoundRectFrame)))
	{
		switch (self.params.calloutPosition)
		{
			case LWETooltipCalloutPositionTop:
				tmpCalloutRectFrame = CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height - tmpRoundRectFrame.size.height));
				break;
			case LWETooltipCalloutPositionBottom:
				tmpCalloutRectFrame = CGRectMake(0, tmpRoundRectFrame.size.height, self.frame.size.width, (self.frame.size.height - tmpRoundRectFrame.size.height));
				break;
			case LWETooltipCalloutPositionLeft:
				tmpCalloutRectFrame = CGRectMake(0, 0, (self.frame.size.width - tmpRoundRectFrame.size.width), self.frame.size.height);
				break;
			case LWETooltipCalloutPositionRight:
				tmpCalloutRectFrame = CGRectMake(tmpRoundRectFrame.size.width, 0, (self.frame.size.width - tmpRoundRectFrame.size.width), self.frame.size.height);
				break;
		}
	}
  return tmpCalloutRectFrame;
}


// Determine the new CGRect for the rounded rect view based on callout size
- (CGRect) _makeNewRoundRectFrame
{
  CGRect newRoundedRectViewRect;
  NSInteger totalSpace; 
  NSInteger numPixelsToShave;
	CGFloat calloutSize = self.params.calloutSize;
  switch (self.params.calloutPosition)
  {
    case LWETooltipCalloutPositionTop:
      totalSpace = self.frame.size.height;
      numPixelsToShave = round((float)totalSpace * calloutSize);
      newRoundedRectViewRect = CGRectMake(0, numPixelsToShave, self.frame.size.width, totalSpace - numPixelsToShave);
      break;
    case LWETooltipCalloutPositionBottom:
      totalSpace = self.frame.size.height;
      numPixelsToShave = round((float)totalSpace * calloutSize);
      newRoundedRectViewRect = CGRectMake(0, 0, self.frame.size.width, totalSpace - numPixelsToShave);
      break;
    case LWETooltipCalloutPositionLeft:
      totalSpace = self.frame.size.width;
      numPixelsToShave = round((float)totalSpace * calloutSize);
      newRoundedRectViewRect = CGRectMake(numPixelsToShave, 0, totalSpace - numPixelsToShave,self.frame.size.height);
      break;
    case LWETooltipCalloutPositionRight:
      totalSpace = self.frame.size.width;
      numPixelsToShave = round((float)totalSpace * calloutSize);
      newRoundedRectViewRect = CGRectMake(0, 0, totalSpace - numPixelsToShave,self.frame.size.height);
      break;
  }
  return newRoundedRectViewRect;
}


// Makes the CGRect for the close button
- (CGRect)_makeCloseButtonRectFrame
{
  CGRect closeButtonRectFrame;
  CGRect roundRectFrame = _roundRectFrame;
  CGSize buttonSize = _closeButton.frame.size;
  CGFloat offset = self.params.cornerRadius / 4;
  CGFloat dx, dy;
  
  switch (self.params.closeButtonPosition)
  {
    case LWETooltipCloseButtonPositionTopLeft:
      dx = roundRectFrame.origin.x + offset;
      dy = roundRectFrame.origin.y + offset;
      break;
    case LWETooltipCloseButtonPositionTopRight:
      dx = roundRectFrame.origin.x + roundRectFrame.size.width - buttonSize.width - offset;
      dy = roundRectFrame.origin.y + offset;
      break;
    case LWETooltipCloseButtonPositionBottomLeft:
      dx = roundRectFrame.origin.x + offset;
      dy = roundRectFrame.origin.y + roundRectFrame.size.height - buttonSize.height - offset;
      break;
    case LWETooltipCloseButtonPositionBottomRight:
      dx = roundRectFrame.origin.x + roundRectFrame.size.width - buttonSize.width - offset;
      dy = roundRectFrame.origin.y + roundRectFrame.size.height - buttonSize.height - offset;
      break;
  }
  closeButtonRectFrame = CGRectMake(dx, dy, 0, 0);
  closeButtonRectFrame.size = buttonSize;
  return closeButtonRectFrame;
}


// Determine the CGRect for the content
- (CGRect)_makeContentViewRect
{
  CGRect tooltipViewRect = CGRectZero;
  // Multiply by 2 because it's both sides of the rectangle
  NSInteger totalClip = self.params.cornerRadius*2;
  NSInteger labelHeight = _roundRectFrame.size.height - totalClip;
  NSInteger labelWidth = _roundRectFrame.size.width - totalClip;
  if (labelWidth > 0 && labelHeight > 0)
  {
    tooltipViewRect = CGRectMake(self.params.cornerRadius/2, self.params.cornerRadius/2, labelWidth+self.params.cornerRadius, labelHeight+self.params.cornerRadius);
  }
  return tooltipViewRect;
}

#pragma mark -
#pragma mark Class plumbing

- (void)dealloc 
{	
	[params release];
	[contentView release];
	[_closeButton release];
	[super dealloc];
}

@end
