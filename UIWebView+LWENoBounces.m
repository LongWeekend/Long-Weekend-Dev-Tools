//
//  UIWebView+LWENoBounces.m
//  jFlash
//
//  Created by シャロット ロス on 6/24/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "UIWebView+LWENoBounces.h"


@implementation UIWebView (LWENoBounces)

/*!
    @method     
    @abstract   Turns off bouncing on UIWebViews
*/

-(void)shutOffBouncing
{
  UIScrollView *scrollView = [self.subviews objectAtIndex:0];

  SEL aSelector = NSSelectorFromString(@"setAllowsRubberBanding:");
  if([scrollView respondsToSelector:aSelector])
  {
    [scrollView performSelector:aSelector withObject:NO];
  }
  else if ([scrollView respondsToSelector:@selector(setBounces:)])
  {
    [scrollView setBounces:NO];
  }
}

@end
