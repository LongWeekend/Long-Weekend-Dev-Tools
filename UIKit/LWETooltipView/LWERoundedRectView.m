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

- (id)initWithCoder:(NSCoder *)decoder
{
  if (self = [super initWithCoder:decoder])
  {
    self.strokeColor = kDefaultStrokeColor;
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
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, strokeWidth);
  CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
  CGContextSetFillColorWithColor(context, self.rectColor.CGColor);
  
  CGRect rrect = self.bounds;
  
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
  CGContextMoveToPoint(context, minx, midy);
  CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
  CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
  CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
  CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
  CGContextClosePath(context);
  CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)dealloc
{
  [strokeColor release];
  [rectColor release];
  [super dealloc];
}

@end
