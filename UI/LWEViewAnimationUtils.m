// LWEViewAnimationUtils.m
//
// Copyright (c) 2010, 2011 Long Weekend LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "LWEViewAnimationUtils.h"

// TODO: make this a string constant instead of a #define MMA
#define kAnimationKey @"transitionViewAnimation"

//! Helper class to take some of the heavy lifting out of animating views
@implementation LWEViewAnimationUtils


//! Translation animate a view from current location to new location by adding the values contained in point
+ (void) translateView:(UIView*)view byPoint:(CGPoint)point withInterval:(float)delay
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:delay];
  CGAffineTransform transform = CGAffineTransformMakeTranslation(point.x, point.y);
  view.transform = transform;
  [UIView commitAnimations];
}

// Transition between cards after a button has been pressed
+ (void) doViewTransition:(NSString *)transition direction:(NSString *)direction duration:(float)duration objectToTransition:(UIViewController *)controllerToTransition
{
	UIView *theWindow = [controllerToTransition.view superview];
	[UIView beginAnimations:nil context:NULL];
  
	// set up an animation for the transition between the views
	CATransition *animation = [CATransition animation];
	[animation setDelegate:controllerToTransition];
	[animation setDuration:duration];
	[animation setType:transition];
	[animation setSubtype:direction];
	[animation setRemovedOnCompletion:YES];
  [[theWindow layer] addAnimation:animation forKey:kAnimationKey ];
	[UIView commitAnimations];
}

//! Fades in a given view over a given duration.  The view ends up with an alpha of 1 and IS added to the superview
+ (void) fadeInView:(UIView*)theView intoView:(UIView*)superview fadeDuration:(CGFloat)duration
{
  [superview addSubview:theView];
  [theView setAlpha:0];
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [theView setAlpha:1];
  [UIView commitAnimations];
}

//! Fades out a given view over a given duration.  The view ends up with an alpha of 0 but is NOT removed from the superview
+ (void) fadeOutView:(UIView*)theView fadeDuration:(CGFloat)duration
{
  // fade the view out to alpha 0 over a duration
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [theView setAlpha:0];
  [UIView commitAnimations];
}




@end
