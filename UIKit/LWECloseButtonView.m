//
//  LWECloseButtonView.m
//  jFlash
//
//  Created by Mark Makdad on 12/12/11.
//  Copyright (c) 2011 Long Weekend LLC. All rights reserved.
//

#import "LWECloseButtonView.h"

@interface LWECloseButtonView ()
//! Is YES when the user is tapping the button
@property BOOL isSelected;
@end

@implementation LWECloseButtonView
@synthesize isSelected;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  // Set a bit so we re-draw the button in a selected state
  self.isSelected = YES;
  [self setNeedsDisplay];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  // Clear the bit
  self.isSelected = NO;
  [self setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  // Call -dismiss on the responder chain -- the parent should respond to this (Progress Bar)
  [[UIApplication sharedApplication] sendAction:@selector(dismiss) to:nil from:self forEvent:event];
  self.isSelected = NO;
  [self setNeedsDisplay];
}

#pragma mark - Drawing Code

- (void)drawRect:(CGRect)rect
{
  // Change the color of the button to give it that "pressed" feel when tapped
  CGColorRef lightColor = NULL;
  if (self.isSelected)
  {
    lightColor = [[UIColor grayColor] CGColor];
  }
  else
  {
    lightColor = [[UIColor whiteColor] CGColor];
  }
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  // Because we are stroking, we need a slightly smaller rect so our full border fits
  CGRect newRect = CGRectMake(rect.origin.x + CLOSE_BUTTON_VIEW_BORDER_WIDTH,
                              rect.origin.y + CLOSE_BUTTON_VIEW_BORDER_WIDTH,
                              rect.size.width - (CLOSE_BUTTON_VIEW_BORDER_WIDTH * 2),
                              rect.size.height - (CLOSE_BUTTON_VIEW_BORDER_WIDTH * 2));
  
  // Set a shadow so our round button has a shadow
  CGContextSetShadow(ctx, CLOSE_BUTTON_SHADOW_OFFSET, CLOSE_BUTTON_SHADOW_BLUR);

  // Paint the background black color
  CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
  CGContextFillEllipseInRect(ctx, newRect);
  
  // Now add an ellipse path in the rect for the border
  CGContextBeginPath(ctx);
  CGContextAddEllipseInRect(ctx, newRect);
  CGContextClosePath(ctx);
  
  // Stroke the path with a white border
  CGContextSetLineWidth(ctx, CLOSE_BUTTON_VIEW_BORDER_WIDTH);
  CGContextSetStrokeColorWithColor(ctx, lightColor);
  CGContextStrokePath(ctx);
  
  // Set the shadow color to clear so it doesn't show on the text
  CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 0, [[UIColor clearColor] CGColor]);
  
  // Figure out where to draw the text - we want it to occupy the center x % of the area
  CGFloat yOffset = rect.size.height * CLOSE_BUTTON_VIEW_X_SIZE;
  CGFloat xOffset = rect.size.width * CLOSE_BUTTON_VIEW_X_SIZE;
  CGRect xRect = CGRectMake(rect.origin.x + xOffset,
                               rect.origin.y + yOffset,
                               rect.size.width - (xOffset * 2),
                               rect.size.height - (yOffset * 2));


  // Now draw the X path
  CGContextBeginPath(ctx);
  CGContextMoveToPoint(ctx, xRect.origin.x, xRect.origin.y);
  CGContextAddLineToPoint(ctx, xRect.origin.x+xRect.size.width, xRect.origin.y+xRect.size.height);
  CGContextMoveToPoint(ctx, xRect.origin.x, xRect.origin.y+xRect.size.height);
  CGContextAddLineToPoint(ctx, xRect.origin.x+xRect.size.width, xRect.origin.y);
  
  // Stroke it with rounded corners
  CGContextSetLineCap(ctx, kCGLineCapRound);
  CGContextSetLineWidth(ctx, CLOSE_BUTTON_X_WIDTH);
  CGContextStrokePath(ctx);
  
}

@end
