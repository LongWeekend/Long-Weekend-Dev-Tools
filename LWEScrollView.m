//
//  LWEScrollView.m
//  Rikai
//
//  Created by シャロット ロス on 6/17/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "LWEScrollView.h"


@implementation LWEScrollView

/*!
 @method     
 @abstract   Sets up a scrollview to scoll horizontally through an array of views
 @discussion Assumes you have provided views that will fit within the scrollview provided.
 */
+ (void)setupScrollView:(UIScrollView*)scrollView withDelegate:(id)theDelegate forViews:(NSArray *)views withTopPadding:(float)topPadding withBottomPadding:(float)bottomPadding withLeftPadding:(float)leftPadding withRightPadding:(float)rightPadding
{
  scrollView.delegate = theDelegate;
  
  [scrollView setCanCancelContentTouches:NO];
  
  scrollView.clipsToBounds = YES;
  scrollView.scrollEnabled = YES;
  
  CGFloat cx = 0.0f;
  
  for (UIView* viewToAddToScrollView in views) 
  {
    CGRect rect = viewToAddToScrollView.frame;
    cx += leftPadding;
    rect.origin.x = cx;
    rect.origin.y = ((scrollView.frame.size.height - viewToAddToScrollView.frame.size.height) / 2);
   	viewToAddToScrollView.frame = rect;
    cx += rect.size.width;
    
    // add the new view as a subview for the scroll view to handle
    [scrollView addSubview:viewToAddToScrollView];
  }
  cx += rightPadding;
  
  [scrollView setContentSize:CGSizeMake(cx, scrollView.bounds.size.height - topPadding - bottomPadding)];
}

@end
