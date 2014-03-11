//
//  RoundedRectView.m
//
//  Created by Jeff LaMarche on 11/13/08.

#import "LWERoundedRectView.h"

@implementation LWERoundedRectView
@synthesize strokeColor;
@synthesize rectColor;
@synthesize strokeWidth;
@synthesize cornerRadius;
@synthesize shadowOffset;

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super initWithCoder:decoder];
  if (self)
  {
    [self commonInit_];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame 
{
  self = [super initWithFrame:frame];
  if (self)
  {
    [self commonInit_];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  // Get the rectangle where we are drawing it to
  CGFloat shadowX = self.shadowOffset.width;
  CGFloat shadowY = self.shadowOffset.height;
  CGRect contentRect = self.bounds;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // Stroke the border!
  [self strokeWithContext_:context];
  
  // Inset the rect based on the strokeWidth so that the stroke
  // does not get clipped.
  contentRect = CGRectInset(contentRect, self.strokeWidth, self.strokeWidth);
  
  // If we have a shadow other than zero, offset either the size or the origin (move the box)
  if (shadowX > 0)
  {
    contentRect.size.width = contentRect.size.width - (2 * shadowX);
  }
  else if (shadowX < 0)
  {
    contentRect.origin.x = contentRect.origin.x - (2 * shadowX);
    contentRect.size.width = contentRect.size.width - (2 * shadowX);
  }

  if (shadowY > 0)
  {
    contentRect.size.height = contentRect.size.height - ( 2 * shadowY);
  }
  else if (shadowY < 0)
  {
    contentRect.origin.y = contentRect.origin.y - ( 2 * shadowY);
    contentRect.size.height = contentRect.size.height - ( 2 * shadowY);
  }
  
  
  CGFloat radius = cornerRadius;
  CGFloat width = CGRectGetWidth(contentRect);
  CGFloat height = CGRectGetHeight(contentRect);
  
  // Make sure corner radius isn't larger than half the shorter side
  if (radius > width/2.0)
    radius = width/2.0;
  if (radius > height/2.0)
    radius = height/2.0;
  
  CGFloat minx = CGRectGetMinX(contentRect);
  CGFloat midx = CGRectGetMidX(contentRect);
  CGFloat maxx = CGRectGetMaxX(contentRect);
  CGFloat miny = CGRectGetMinY(contentRect);
  CGFloat midy = CGRectGetMidY(contentRect);
  CGFloat maxy = CGRectGetMaxY(contentRect);
  
  CGContextSaveGState(context);
  CGContextSetShadow(context, CGSizeMake(shadowX, shadowY), kDefaultShadowBlur);  
  
  CGContextMoveToPoint(context, minx, midy);
  CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
  CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
  CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
  CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
  CGContextClosePath(context);
  CGContextDrawPath(context, kCGPathFillStroke);
  
  CGContextRestoreGState(context);
}

- (void)dealloc
{
  [strokeColor release];
  [rectColor release];
  
  [super dealloc];
}

#pragma mark - Private

/** Initialize the parameters with the default value. */
- (void)commonInit_
{
  // Initialization code
  self.opaque = NO;
  self.shadowOffset = CGSizeZero;
  self.strokeColor = kDefaultStrokeColor;
  self.backgroundColor = [UIColor clearColor];
  self.rectColor = kDefaultRectColor;
  self.strokeWidth = kDefaultStrokeWidth;
  self.cornerRadius = kDefaultCornerRadius;
  
  // Make the dashes pattern nil as the default stroke type is solid.
  self.strokeType = LWEStrokeTypeSolidStroke;
  self.dashesPattern = nil;
}

/** Stroke this view with the current context. */
- (void)strokeWithContext_:(CGContextRef)context
{
  CGContextSetLineWidth(context, self.strokeWidth);
  CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
  CGContextSetFillColorWithColor(context, self.rectColor.CGColor);
  
  // If the stroke typed dotted line
  // draw the dotted line according to the parameter.
  if (self.strokeType == LWEStrokeTypeDottedLine)
  {
    // Make sure dashes pattern is not nil.
    LWE_ASSERT_EXC(self.dashesPattern, @"Stroke typed LWEStrokeTypeDottedLine has to specify the dashes pattern.");
    
    // Sets up the required parameter to the dotted line
    NSUInteger dashesElementCount = sizeof(self.dashesPattern)/sizeof(CGFloat);
    CGContextSetLineDash(context, 0, self.dashesPattern, dashesElementCount);
  }
}

@end
