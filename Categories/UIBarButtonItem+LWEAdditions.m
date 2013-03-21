// UIBarButtonItem+LWEAdditions.m
//
// Copyright (c) 2012 Long Weekend LLC
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


#import "UIBarButtonItem+LWEAdditions.h"

@implementation UIBarButtonItem (LWEAdditions)

+ (UIBarButtonItem *) barButtonWithImage:(UIImage *)buttonImage target:(id)target action:(SEL)action
{
  UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  menuBtn.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
  [menuBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [menuBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  
  // It's ridiculous that we have to bury the UIButton inside a UIView to get it to work, but.
  UIView *customView = [[UIView alloc] initWithFrame:menuBtn.frame];
  [customView addSubview:menuBtn];
 
  // Finally create the button w/ the custom view
  UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:customView];
  [customView release];
  return [barBtn autorelease];
}

@end
