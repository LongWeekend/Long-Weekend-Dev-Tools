//
//  LWETooltipView.m
//  LocationBasedMessaging
//
//  Created by Mark Makdad on 7/15/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import "LWETooltipView.h"

@implementation LWETooltipViewOLD

@synthesize roundedRectView, contentView, showCallout, calloutView, closeButton, showDropShadow;

//! Init and set all defaults
- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    // Default options
    calloutOffset = LWETooltipCalloutOffsetNone;
    calloutPosition = LWETooltipCalloutPositionTop;
    calloutDirection = LWETooltipCalloutDirectionStraight;
    closeButtonPosition = LWETooltipCloseButtonPositionTopRight;
    showCallout = YES;
    showDropShadow = YES;
    shadowOffset = CGSizeMake(3,5);
    calloutSize = 0.15f;
    self.alpha = 1.0f;
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setCloseButtonImage:[UIImage imageNamed:@"overlay-btn-close.png"]];
    self.contentView = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.calloutView = [[[LWECalloutView alloc] initWithFrame:CGRectZero] autorelease];
    self.roundedRectView = [[[LWERoundedRectView alloc] initWithFrame:CGRectZero] autorelease];
    self.backgroundColor = [UIColor blackColor];
  }
  return self;
}

# pragma mark -
# pragma mark Setters

- (void) setCalloutSize:(CGFloat)size
{
  calloutSize = size;
}

// Override default implementation as we don't really want the
// user to change our view's bg color - then the alpha won't work.
-(void) setBackgroundColor:(UIColor *)color
{
  self.roundedRectView.rectColor = color;
  self.calloutView.rectColor = color;
//  self.roundedRectView.strokeColor = color;
//  self.calloutView.strokeColor = color;
}

- (void) setCalloutPosition:(LWETooltipCalloutPosition)position
{
  calloutPosition = position;
}

- (void) setCalloutDirection:(LWETooltipCalloutDirection)direction
{
  calloutDirection = direction;
}

- (void) setCalloutOffset:(LWETooltipCalloutOffset)offset
{
  calloutOffset = offset;
}

- (void) setCloseButtonPosition:(LWETooltipCloseButtonPosition)position
{
  closeButtonPosition = position;
}

- (void) setCloseButtonImage:(UIImage*)image
{
  [self.closeButton setImage:image forState:UIControlStateNormal];
  CGRect imageRect = CGRectZero;
  imageRect.size = image.size;
  [self.closeButton setFrame:imageRect];
}

- (void) setCloseButtonTarget:(id)sender action:(SEL)action
{
  [self.closeButton addTarget:sender action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void) setShadowOffset:(CGSize)size
{
  shadowOffset = size;
}

#pragma mark -
#pragma mark View Layout Code

- (void) layoutTooltip
{
  // TODO reduce the duplication in this method
  if (self.showCallout)
  {
    // Resize rounded rect to make room for the callout
    self.calloutView.frame = [self _makeCalloutRectFrame];
    [[self calloutView] setCalloutPosition:calloutPosition];
    [[self calloutView] setCalloutDirection:calloutDirection];
    [[self calloutView] setCalloutOffset:calloutOffset];
    [[self calloutView] setCalloutFillColor:[[self roundedRectView] rectColor]];
    [[self calloutView] setAlpha:[self alpha]];
    [[self calloutView] setShadowOffset:shadowOffset];
    

    self.roundedRectView.frame = [self _makeNewRoundRectFrame];
    self.contentView.frame = [self _makeContentViewRect];
    [[self roundedRectView] addSubview:[self contentView]];
    [[self roundedRectView] setAlpha:[self alpha]];
    [[self roundedRectView] setShadowOffset:shadowOffset];
    
    [self addSubview:[self calloutView]];
    [self addSubview:[self roundedRectView]];

    self.closeButton.frame = [self _makeCloseButtonRectFrame];
    [self addSubview:[self closeButton]];    
  }
  else
  {
    self.roundedRectView.frame = [self _makeNewRoundRectFrame];
    self.contentView.frame = [self _makeContentViewRect];
    [[self roundedRectView] addSubview:[self contentView]];
    [[self roundedRectView] setAlpha:[self alpha]];
    [[self roundedRectView] setShadowOffset:CGSizeMake(4,6)];

    [self addSubview:[self roundedRectView]];

    self.closeButton.frame = [self _makeCloseButtonRectFrame];
    [self addSubview:[self closeButton]];
  }  
}

#pragma mark -
#pragma mark Private Methods for making frames

// Makes the CGRect for the close button
- (CGRect) _makeCloseButtonRectFrame
{
  CGRect closeButtonRectFrame;
  CGRect roundRectFrame = [self _makeNewRoundRectFrame];
  CGSize buttonSize = self.closeButton.frame.size;
  CGFloat offset = roundedRectView.cornerRadius / 4;
  CGFloat dx, dy;
  
  switch (closeButtonPosition)
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

// Makes the CGRect for the callout graphic
- (CGRect) _makeCalloutRectFrame
{
  CGRect calloutRectFrame;
  CGRect roundRectFrame = [self _makeNewRoundRectFrame];
  switch (calloutPosition)
  {
    case LWETooltipCalloutPositionTop:
      calloutRectFrame = CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height - roundRectFrame.size.height));
      break;
    case LWETooltipCalloutPositionBottom:
      calloutRectFrame = CGRectMake(0, roundRectFrame.size.height, self.frame.size.width, (self.frame.size.height - roundRectFrame.size.height));
      break;
    case LWETooltipCalloutPositionLeft:
      calloutRectFrame = CGRectMake(0, 0, (self.frame.size.width - roundRectFrame.size.width), self.frame.size.height);
      break;
    case LWETooltipCalloutPositionRight:
      calloutRectFrame = CGRectMake(roundRectFrame.size.width, 0, (self.frame.size.width - roundRectFrame.size.width), self.frame.size.height);
      break;
  }
  return calloutRectFrame;
}

// Determine the new CGRect for the rounded rect view based on callout size
- (CGRect) _makeNewRoundRectFrame
{
  CGRect newRoundedRectViewRect;
  NSInteger totalSpace; 
  NSInteger numPixelsToShave;
  switch (calloutPosition)
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

// Determine the CGRect for the content
- (CGRect) _makeContentViewRect
{
  CGRect tooltipViewRect = CGRectZero;
  // Multiply by 2 because it's both sides of the rectangle
  NSInteger totalClip = self.roundedRectView.cornerRadius*2;
  NSInteger labelHeight = self.roundedRectView.frame.size.height - totalClip;
  NSInteger labelWidth = self.roundedRectView.frame.size.width - totalClip;
  if (labelWidth > 0 && labelHeight > 0)
  {
    tooltipViewRect = CGRectMake(roundedRectView.cornerRadius/2, roundedRectView.cornerRadius/2, labelWidth+roundedRectView.cornerRadius, labelHeight+roundedRectView.cornerRadius);
  }
  return tooltipViewRect;
}

//! Standard dealloc
- (void)dealloc
{
  [self setCloseButton:nil];
  [self setCalloutView:nil];
  [self setContentView:nil];
  [self setRoundedRectView:nil];
  [super dealloc];
}


@end
