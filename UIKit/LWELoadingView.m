//
//  LWELoadingView.m
//  jFlash
//
//  Created by Rendy Pranata on 29/07/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import "LWELoadingView.h"
#import "LWEViewUtility.h"

// Private
@interface LWELoadingView ()
CGFloat _totalHeight;
@end

@implementation LWELoadingView

//@synthesize totalHeight;

+ (id)loadingView:(UIView *)aSuperview withText:(NSString *)text
{
	return [LWELoadingView loadingView:aSuperview withText:text calculateNavigationBar:NO];
}

+ (id)loadingView:(UIView *)aSuperview withText:(NSString *)text calculateNavigationBar:(BOOL)calculateNavigationBar
{	
	CGRect borderFrame = [[UIScreen mainScreen] bounds]; //[aSuperview bounds];
	LWELoadingView *loadingView = [[[LWELoadingView alloc] initWithFrame:borderFrame] autorelease];
	if (!loadingView)
	{
		return nil;
	}
	
	const CGSize DEFAULT_OFFSET_VIEW = CGSizeMake(DEFAULT_OFFSET_WIDTH, DEFAULT_OFFSET_HEIGHT);
  
  // configure the label
	CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
	UILabel *loadingLabel = [[UILabel alloc] initWithFrame:labelFrame];
	loadingLabel.text = text;
  loadingLabel.numberOfLines = 3;
  loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor]; //[UIColor yellowColor];//
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	
	// configure the activity indicator
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityIndicatorView startAnimating];
	[loadingView addSubview:activityIndicatorView];
  
	_totalHeight = loadingLabel.frame.size.height + activityIndicatorView.frame.size.height;
  
	// size and center the loading view
	borderFrame.size.width =  DEFAULT_LABEL_WIDTH + (DEFAULT_OFFSET_VIEW.width*2);
	borderFrame.size.height = _totalHeight + (DEFAULT_OFFSET_VIEW.height*2);
	borderFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - borderFrame.size.width));
	borderFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - borderFrame.size.height));
  //If calculate navigation bar, adjust 44px for nav bar hieght.
  if (calculateNavigationBar)
  {
    borderFrame.origin.y = borderFrame.origin.y - 44.0;
  }
	loadingView.frame = borderFrame;
	
  // position activity indicator
  CGRect activityIndicatorRect = activityIndicatorView.frame;
	activityIndicatorRect.origin.x = 0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y = loadingLabel.frame.origin.y + loadingLabel.frame.size.height-5;
	activityIndicatorView.frame = activityIndicatorRect;
  
  // position the label
	labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
	labelFrame.origin.y = floor((0.5 * (loadingView.frame.size.height - _totalHeight)*0.1));
  [loadingLabel sizeToFit];
	loadingLabel.frame = labelFrame;
  [loadingView addSubview:loadingLabel];
  
	[activityIndicatorView release];
	[loadingLabel release];
	
	loadingView.opaque = NO;
	[aSuperview addSubview:loadingView];
	
	// animate
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
	
	return loadingView;
}

/**
 * Subclass the UIView method to add a fade
 */
- (void) removeFromSuperview
{
  // Run the normal UI removeFromSuperview
	[super removeFromSuperview];
  
	// Set up the animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	
	UIView *aSuperview = [self superview];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

/*
 * Draw the view.
 */
- (void)drawRect:(CGRect)rect
{
	//WE_LOG(@"total height : %f, inset height : %f", _totalHeight, _totalHeight*2);
	//rect = CGRectInset(rect, 30, _totalHeight*2); //170);
	const CGFloat ROUND_RECT_CORNER_RADIUS = 10.0;
	CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	const CGFloat BACKGROUND_OPACITY = 0.65;
	CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextFillPath(context);
	
	const CGFloat STROKE_OPACITY = 0.25;
	CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextStrokePath(context);
	
	CGPathRelease(roundRectPath);
}

@end