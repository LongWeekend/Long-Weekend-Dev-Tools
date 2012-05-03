//
//  LWECalloutView.m
//  LocationBasedMessaging
//
//  Created by Mark Makdad on 7/15/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import "LWECalloutView.h"
#import "LWETooltipView.h"

@implementation LWECalloutView

@synthesize strokeColor;
@synthesize rectColor;
@synthesize strokeWidth;
@synthesize shadowOffset;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    self.shadowOffset = CGSizeZero;
    self.backgroundColor = [UIColor clearColor];
    self.strokeColor = kDefaultStrokeColor;
    self.rectColor = kDefaultRectColor;
    self.strokeWidth = kDefaultStrokeWidth;
    calloutPosition = LWETooltipCalloutPositionTop;
    calloutDirection = LWETooltipCalloutDirectionStraight;
    calloutOffset = LWETooltipCalloutOffsetRight;
  }
  return self;
}

#pragma mark -
#pragma mark Setters

- (void) setCalloutFillColor:(UIColor*) color
{
  self.rectColor = color;
}

- (void) setCalloutPosition:(LWETooltipCalloutPosition)position
{
  calloutPosition = position;
}

- (void) setCalloutOffset:(LWETooltipCalloutOffset)offset
{
  calloutOffset = offset;
}

- (void) setCalloutDirection:(LWETooltipCalloutDirection)direction
{
  calloutDirection = direction;
}

#pragma mark -
#pragma mark Drawing Code

- (void)drawRect:(CGRect)rect
{
  CGFloat shadowX = self.shadowOffset.width;
  CGFloat shadowY = self.shadowOffset.height;
  
  // Set up fill & stroke colors
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, self.strokeWidth);
  CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
  CGContextSetFillColorWithColor(context, self.rectColor.CGColor);

  CGRect calloutRect = self.bounds;
  CGFloat base;
  CGFloat length;

  // Since height/width don't apply (we could be left orientation, bottom orientation, etc)
  // use base/length instead
  if (calloutPosition == LWETooltipCalloutPositionTop || calloutPosition == LWETooltipCalloutPositionBottom)
  {
    base = CGRectGetWidth(calloutRect);
    length = CGRectGetHeight(calloutRect);
  }
  else
  {
    base = CGRectGetHeight(calloutRect);
    length = CGRectGetWidth(calloutRect);
  }
    
  // Do we have any offset?
  CGFloat offset = 1.0f;
  if (calloutOffset == LWETooltipCalloutOffsetLeft)
  {
    offset = 0.65f;
  }
  else if (calloutOffset == LWETooltipCalloutOffsetRight)
  {
    offset = 1.3f;
  }

  
  // Now determine where the points are
  CGFloat firstBase;
  CGFloat calloutPointOnBase;
  CGFloat midpointOnBase;
  if (calloutDirection == LWETooltipCalloutDirectionLeftToRight)
  {
    // 1/4 of the way down the base
    firstBase = (base / 4.0f) * offset;
    midpointOnBase = (base / 2) * offset;
    calloutPointOnBase = (base / 4.0f) * 3.0f * offset;
  }
  else if (calloutDirection == LWETooltipCalloutDirectionRightToLeft)
  {
    // Use the big end, 3/4 of the way down the base
    firstBase = (base / 4.0f) * 3.0f * offset;
    midpointOnBase = (base / 2) * offset;
    calloutPointOnBase = (base / 4.0f * offset);
  }
  else
  {
    // Straight up!
    firstBase = (base * 2) / 5 * offset;
    midpointOnBase = (base * 3) / 5 * offset;
    calloutPointOnBase = (base / 2) * offset;
  }
  
  CGContextSaveGState(context);
  CGContextSetShadow(context, CGSizeMake(shadowX, shadowY), kDefaultShadowBlur);  
  
  // Shit, now convert back to X and Y
  switch (calloutPosition)
  {
    case LWETooltipCalloutPositionTop:
      CGContextMoveToPoint(context, firstBase, length);
      CGContextAddLineToPoint(context, calloutPointOnBase, 0);
      CGContextAddLineToPoint(context, midpointOnBase, length);
      CGContextAddLineToPoint(context, firstBase, length);
      break;
    case LWETooltipCalloutPositionBottom:
      CGContextMoveToPoint(context, firstBase, 0);
      CGContextAddLineToPoint(context, calloutPointOnBase, length);
      CGContextAddLineToPoint(context, midpointOnBase, 0);
      CGContextAddLineToPoint(context, firstBase, 0);
      break;
    case LWETooltipCalloutPositionLeft:
      CGContextMoveToPoint(context, length, firstBase);
      CGContextAddLineToPoint(context, 0, calloutPointOnBase);
      CGContextAddLineToPoint(context, length, midpointOnBase);
      CGContextAddLineToPoint(context, length, firstBase);
      break;
    case LWETooltipCalloutPositionRight:
      CGContextMoveToPoint(context, 0, firstBase);
      CGContextAddLineToPoint(context, length, calloutPointOnBase);
      CGContextAddLineToPoint(context, 0, midpointOnBase);
      CGContextAddLineToPoint(context, 0, firstBase);
      break;
  }
  
  CGContextClosePath(context);
  CGContextDrawPath(context, kCGPathFillStroke);

  CGContextRestoreGState(context);
}

- (void)dealloc
{
  [self setStrokeColor:nil];
  [self setRectColor:nil];
  [super dealloc];
}


@end
