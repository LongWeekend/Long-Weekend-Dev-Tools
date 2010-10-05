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
	LWELoadingView *loadingView = [[[LWELoadingView alloc] initWithFrame:[aSuperview bounds]] autorelease];
	if (!loadingView)
	{
		return nil;
	}
	
	loadingView.opaque = NO;
	loadingView.autoresizingMask =
	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[aSuperview addSubview:loadingView];
	
	const CGFloat DEFAULT_LABEL_WIDTH = 280.0;
	const CGFloat DEFAULT_LABEL_HEIGHT = 50.0;
	CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
	UILabel *loadingLabel = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
	loadingLabel.text = text;
  loadingLabel.numberOfLines = 3;
  loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	loadingLabel.autoresizingMask =
	UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	CGSize expectedLabelSize = [loadingLabel.text sizeWithFont:loadingLabel.font constrainedToSize:labelFrame.size lineBreakMode:loadingLabel.lineBreakMode];

	LWE_LOG(@"exp label size x %f, y %f",expectedLabelSize.width,expectedLabelSize.height);
	[loadingView addSubview:loadingLabel];
	UIActivityIndicatorView *activityIndicatorView =
	[[[UIActivityIndicatorView alloc]
		initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]
	 autorelease];
	[loadingView addSubview:activityIndicatorView];
	activityIndicatorView.autoresizingMask =
	UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
	
	//_totalHeight = loadingLabel.frame.size.height + activityIndicatorView.frame.size.height;
	_totalHeight = loadingLabel.frame.size.height + activityIndicatorView.frame.size.height;
	labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
	labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - _totalHeight));
	loadingLabel.frame = labelFrame;
	
	CGRect activityIndicatorRect = activityIndicatorView.frame;
	activityIndicatorRect.origin.x =
	0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y =
	loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
	activityIndicatorView.frame = activityIndicatorRect;
	
	// Set up the fade-in animation
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

//
// drawRect:
//
// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
	rect.size.height -= 1;
	rect.size.width -= 1;
	LWE_LOG(@"total height : %f, inset height : %f", _totalHeight, _totalHeight*2);
	rect = CGRectInset(rect, 30, _totalHeight*2); //170);
	
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
