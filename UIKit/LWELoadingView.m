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
	//STEP 1 - Initialise itself
	CGRect selfFrame = [aSuperview bounds];
	LWELoadingView *loadingView = [[[LWELoadingView alloc] initWithFrame:selfFrame] autorelease];
	LWE_LOG(@"Superview bounds x:%f, y:%f, width:%f, height:%f", aSuperview.bounds.origin.x, aSuperview.bounds.origin.y, aSuperview.bounds.size.width, aSuperview.bounds.size.height);
	if (!loadingView)
	{
		return nil;
	}
	
	//STEP 2 - Define all of the constant
	const CGSize DEFAULT_OFFSET_VIEW = CGSizeMake(DEFAULT_OFFSET_WIDTH, DEFAULT_OFFSET_HEIGHT);
	CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
	UILabel *loadingLabel = [[UILabel alloc] initWithFrame:labelFrame];
	loadingLabel.text = text;
  loadingLabel.numberOfLines = 3;
  loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	//loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | 
	//																UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	//CGSize expectedLabelSize = [loadingLabel.text sizeWithFont:loadingLabel.font constrainedToSize:labelFrame.size lineBreakMode:loadingLabel.lineBreakMode];
	//LWE_LOG(@"exp label size x %f, y %f",expectedLabelSize.width,expectedLabelSize.height);
	[loadingView addSubview:loadingLabel];
	
	//STEP 3 - Create the activity indicator
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] 
																										initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	//activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |	
	//																				 UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[loadingView addSubview:activityIndicatorView];
	[activityIndicatorView startAnimating];
	
	//STEP 4 - Fix the size of itself, x, y, width, and height as well. It is bassed on the total height of the loading label, and activity indicator
	//Width is calculated based on the default width of the label with some addition of the default offset.
	//Height is calculated based on the total height, with some addition of the default offset.
	//X and Y are counted based on the total size of the superview bounds, minus the size of this loading view, divide by 2 (*0.5). 
	_totalHeight = loadingLabel.frame.size.height + activityIndicatorView.frame.size.height;
	
	selfFrame.size.width =  DEFAULT_LABEL_WIDTH + (DEFAULT_OFFSET_VIEW.width*2);
	selfFrame.size.height = _totalHeight + (DEFAULT_OFFSET_VIEW.height*2);
	selfFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - selfFrame.size.width));
	selfFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - selfFrame.size.height));
	loadingView.frame = selfFrame;
	LWE_LOG(@"The new loading view after resize x:%f, y:%f, width:%f, height:%f", aSuperview.bounds.origin.x, aSuperview.bounds.origin.y, aSuperview.bounds.size.width, aSuperview.bounds.size.height);	
	
	//STEP 5 - Fix the position of the label
	labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
	labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - _totalHeight));
	loadingLabel.frame = labelFrame;
	
	//STEP 6 - Fix the position of the activity indicator
	CGRect activityIndicatorRect = activityIndicatorView.frame;
	activityIndicatorRect.origin.x = 0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y = loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
	activityIndicatorView.frame = activityIndicatorRect;
	
	//STEP 7 - Clean up every memory space being used to.
	[activityIndicatorView release];
	[loadingLabel release];
	
	//STEP 8 - Fix itself with some additional set-up property.
	loadingView.opaque = NO;
	//Commented it out cause Rendy is not sure what it is for
	//loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[aSuperview addSubview:loadingView];
	
	//STEP 9 - Apply the fade-in animation.
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
