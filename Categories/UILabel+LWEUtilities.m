// LWEUILabelUtils.m
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

#import "UILabel+LWEUtilities.h"

//! Contains static convenience methods for dealing with UILabels
@implementation UILabel (LWEUtilities)

//! Resize font within constraints, works with multi-line labels.
- (void) resizeWithMinFontSize:(NSInteger)minFontSize maxFontSize:(NSInteger)maxFontSize
{
  LWE_ASSERT_EXC(minFontSize <= maxFontSize, @"Min font size must be less or equal to max font size.");
  UIFont *newFont = self.font;
  CGRect newFrame = self.frame;
  CGSize expectedLabelSize = CGSizeZero;
  CGSize parentViewSize = self.superview.frame.size;
  
  // Initialize
  expectedLabelSize.height = 0;
  
  // Loop from Max Font to Min Font Size until one fits, or scrolling is inevitable
  for (NSInteger i = maxFontSize; i > minFontSize; i=i-2)
  {
    // Set next font size - constraining the width & passing unlimited height is the way to get good values
    newFont = [newFont fontWithSize:i];
    CGSize constraintSize = self.frame.size;
    constraintSize.width = constraintSize.width;
    constraintSize.height = CGFLOAT_MAX;
    expectedLabelSize = [self.text sizeWithFont:newFont constrainedToSize:constraintSize lineBreakMode:self.lineBreakMode];
    
    // Break if this fontsize fits within the available scrollable height?
    if (expectedLabelSize.height < parentViewSize.height)
    {
      break;
    }
  }
  newFrame.size.height = expectedLabelSize.height;
  self.frame = newFrame;
  self.font = newFont;
  [self setNeedsDisplay];
}

//! Makes a frame for a text based on provided width, margin, and font size
- (void) adjustFrameWithFontSize:(NSInteger)fontSize cellWidth:(NSInteger)width cellMargin:(NSInteger)margin
{
  CGSize constraint = CGSizeMake(width - (margin * 2), CGFLOAT_MAX);
  CGSize size = [self.text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
  self.frame = CGRectMake(margin, margin, width - (margin * 2), MAX(size.height, 44.0f));
  [self setNeedsDisplay];
}

@end