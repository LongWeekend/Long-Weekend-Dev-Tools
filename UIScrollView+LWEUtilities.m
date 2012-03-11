// LWEScrollView.m
//
// Copyright (c) 2011 Long Weekend LLC
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

#import "UIScrollView+LWEUtilities.h"

@implementation UIScrollView (LWEUtilities)

- (void) resizeScrollViewWithContentView:(UIView *)view
{
  // Sets the scroll view content size to be the same as the content view & reset view
  self.contentSize = view.frame.size;
  self.contentOffset = CGPointZero;

  // Vertically align the view
  if (view.frame.size.height < self.frame.size.height)
  {
    CGFloat yOffset = ((self.frame.size.height - view.frame.size.height) / 2);
    view.frame = CGRectMake(view.frame.origin.x,
                            yOffset,
                            view.frame.size.width,
                            view.frame.size.height);
  }
}



/*!
 @method     
 @abstract   Sets up a scrollview to scoll horizontally through an array of views
 @discussion Assumes you have provided views that will fit within the scrollview provided.
 */
- (void)setupWithDelegate:(id)theDelegate forViews:(NSArray *)views withTopPadding:(float)topPadding withBottomPadding:(float)bottomPadding withLeftPadding:(float)leftPadding withRightPadding:(float)rightPadding;
{
  self.delegate = theDelegate;
  
  [self setCanCancelContentTouches:NO];
  
  self.clipsToBounds = YES;
  self.scrollEnabled = YES;
  
  CGFloat cx = 0.0f;
  
  for (UIView *viewToAddToScrollView in views) 
  {
    CGRect rect = viewToAddToScrollView.frame;
    cx += leftPadding;
    rect.origin.x = cx;
    rect.origin.y = ((self.frame.size.height - viewToAddToScrollView.frame.size.height) / 2);
   	viewToAddToScrollView.frame = rect;
    cx += rect.size.width;
    
    // add the new view as a subview for the scroll view to handle
    [self addSubview:viewToAddToScrollView];
  }
  cx += rightPadding;
  
  [self setContentSize:CGSizeMake(cx, self.bounds.size.height - topPadding - bottomPadding)];
}

@end
