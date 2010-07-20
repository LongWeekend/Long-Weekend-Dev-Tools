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

- (id)initWithCoder:(NSCoder *)decoder
{
  if (self = [super initWithCoder:decoder])
  {
    self.strokeColor = kDefaultStrokeColor;
    self.shadowOffset = CGSizeZero;
    self.backgroundColor = [UIColor clearColor];
    self.strokeWidth = kDefaultStrokeWidth;
    self.rectColor = kDefaultRectColor;
    self.cornerRadius = kDefaultCornerRadius;
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame 
{
  if (self = [super initWithFrame:frame]) 
  {
    // Initialization code
    self.opaque = NO;
    self.shadowOffset = CGSizeZero;
    self.strokeColor = kDefaultStrokeColor;
    self.backgroundColor = [UIColor clearColor];
    self.rectColor = kDefaultRectColor;
    self.strokeWidth = kDefaultStrokeWidth;
    self.cornerRadius = kDefaultCornerRadius;
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGFloat shadowX = self.shadowOffset.width;
  CGFloat shadowY = self.shadowOffset.height;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, strokeWidth);
  CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
  CGContextSetFillColorWithColor(context, self.rectColor.CGColor);
  
  CGRect rrect = self.bounds;
  
  // TODO: find out why this matters when we have a stroke?
//  rrect.origin.x = rrect.origin.x + 1;
//  rrect.origin.y = rrect.origin.y + 1;
//  rrect.size.height = rrect.size.height - 1;
//  rrect.size.width = rrect.size.width - 1;
  
  // If we have a shadow other than zero, offset either the size or the origin (move the box)
  if (shadowX > 0)
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
  }
  
  
  CGFloat radius = cornerRadius;
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

@end
