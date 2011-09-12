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

#import "LWEUILabelUtils.h"
#import "LWEDebug.h"

//! Contains static convenience methods for dealing with UILabels
@implementation LWEUILabelUtils

//! Shorter Convenience Method: Resize without parentViewSize option
+ (void) resizeLabelWithConstraints: (UILabel *)theLabel minFontSize:(NSInteger)minFontSize maxFontSize:(NSInteger)maxFontSize
{
  [LWEUILabelUtils resizeLabelWithConstraints:theLabel minFontSize:minFontSize maxFontSize:maxFontSize forParentViewSize:CGSizeMake(0, 0)];
}

//! Resize UIScrollView.contentSize based on expected label size and reset scroll pos!
+ (void) autosizeLabelText: (UILabel *)theLabel forScrollView:(UIScrollView *)scrollViewContainer withText:(NSString *)theText minFontSize:(NSInteger)minFontSize maxFontSize:(NSInteger)maxFontSize
{
  // Use our snazzy font resizer (works with multiple lines!)
  [LWEUILabelUtils resizeLabelWithConstraints:theLabel minFontSize:minFontSize maxFontSize:maxFontSize forParentViewSize:scrollViewContainer.frame.size];
  CGSize expectedLabelSize = theLabel.frame.size;
  
  // Resize label according to expected label text size
  CGRect newLabelFrame = theLabel.frame;
  newLabelFrame.size.height = expectedLabelSize.height;
  theLabel.frame = newLabelFrame;
  
  // Update the contentSize attrib
  scrollViewContainer.contentSize = CGSizeMake(theLabel.frame.size.width, theLabel.frame.size.height);
  
  // Vertically align the reading label
  CGSize labelSize = theLabel.frame.size;
  if(labelSize.height < scrollViewContainer.frame.size.height)
  {
    CGRect labelFrame = theLabel.frame;
    int yOffset = (int) ((scrollViewContainer.frame.size.height - labelSize.height)/2);
    labelFrame.origin.y = yOffset;
    theLabel.frame = labelFrame;
  }
  
  // Scroll to 0,0
  [scrollViewContainer setContentOffset:CGPointMake(0, 0) animated: YES];
  
}

//! Makes a frame for a text based on provided width, margin, and font size
+ (CGRect) makeFrameForText:(NSString*)text fontSize:(NSInteger)fontSize cellWidth:(NSInteger)width cellMargin:(NSInteger)margin
{
  CGSize constraint = CGSizeMake(width - (margin * 2), 20000.0f);
  CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
  return CGRectMake(margin, margin, width - (margin * 2), MAX(size.height, 44.0f));
}

//! Shorter Convenience Method: AutoSize without specifying font sizes!
+ (void) autosizeLabelText: (UILabel *)theLabel forScrollView:(UIScrollView *)scrollViewContainer withText:(NSString *)theText 
{
  [LWEUILabelUtils autosizeLabelText:theLabel forScrollView:scrollViewContainer withText:theText minFontSize:READING_MIN_FONTSIZE maxFontSize:READING_MAX_FONTSIZE];
}

//! Resize font within constraints, works with multi-line labels.
+ (void) resizeLabelWithConstraints: (UILabel *)theLabel minFontSize:(NSInteger)minFontSize maxFontSize:(NSInteger)maxFontSize forParentViewSize:(CGSize)parentViewSize
{
  UIFont *newFont = theLabel.font;
  CGRect newFrame = theLabel.frame;
  CGSize expectedLabelSize;
  
  // Initialize
  expectedLabelSize.height = 0;
  
  // Loop from Max Font to Min Font Size until one fits, or scrolling is inevitable
  for (int i = maxFontSize; i > minFontSize; i=i-2)
  {
    // Set next font size.
    newFont = [newFont fontWithSize:i];
    CGSize constraintSize = theLabel.frame.size;
    constraintSize.width = constraintSize.width-5;
    constraintSize.height = 6000.0f;
    
    // WARNING: this uses "word wrap" (not good for very long JPN strings!)
    expectedLabelSize = [theLabel.text sizeWithFont:newFont constrainedToSize:constraintSize lineBreakMode:theLabel.lineBreakMode];
    LWE_LOG(@"Label Size w:%f h: %f",expectedLabelSize.width,expectedLabelSize.height);
    
    // Break if this fontsize fits within the available scrollable height?
    if(parentViewSize.height != 0 && expectedLabelSize.height < parentViewSize.height)
      break;
  }
  newFrame.size.height = expectedLabelSize.height;
  theLabel.frame = newFrame;
  theLabel.font = newFont;
}

@end