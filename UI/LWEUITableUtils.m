// LWEUITabelUtils.m
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

#import "LWEUITableUtils.h"

//! Helper class containing static methods to help manage UITableViews
@implementation LWEUITableUtils

//! Returns a new UITableViewCell - automatically determines whether new or off the queue
+ (UITableViewCell*) reuseCellForIdentifier: (NSString*) identifier onTable:(UITableView*) lclTableView usingStyle:(UITableViewCellStyle)style
{
  UITableViewCell *cell = [lclTableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil)
  {
    cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:identifier] autorelease];
  }
  return cell;
}


//! Sets the frame to the hieght needed for a given text size. Used in conjunction with reuseBlankLabelCellForIdentifier
+ (void)autosizeFrameForBlankLabel:(UILabel*)label forText:(NSString*)text
{
  CGFloat height = [LWEUITableUtils autosizeHeightForCellWithText:text] - (LWE_UITABLE_CELL_CONTENT_MARGIN * 2);
  [label setFrame:CGRectMake(LWE_UITABLE_CELL_CONTENT_MARGIN, LWE_UITABLE_CELL_CONTENT_MARGIN, LWE_UITABLE_CELL_CONTENT_WIDTH - (LWE_UITABLE_CELL_CONTENT_MARGIN * 2), MAX(height, 44.0f))];
}

/**
 * Called autosizeHeightForCellWithText:fontSize:cellWidth:cellMargin: with default parameters for everything
 */
+ (CGFloat) autosizeHeightForCellWithText:(NSString *)text
{
  return [LWEUITableUtils autosizeHeightForCellWithText:text fontSize:LWE_UITABLE_CELL_FONT_SIZE cellWidth:LWE_UITABLE_CELL_CONTENT_WIDTH cellMargin:LWE_UITABLE_CELL_CONTENT_MARGIN];
}

/**
 * Called autosizeHeightForCellWithText:fontSize:cellWidth:cellMargin: with default parameters for
 * cellWidth & cellMargin
 */
+ (CGFloat) autosizeHeightForCellWithText:(NSString *)text fontSize:(NSInteger)fontSize
{
  return [LWEUITableUtils autosizeHeightForCellWithText:text fontSize:fontSize cellWidth:LWE_UITABLE_CELL_CONTENT_WIDTH cellMargin:LWE_UITABLE_CELL_CONTENT_MARGIN];
}

/**
 * Returns the assumed proper height for a cell to fit all text at a given size
 * \param text NSString containing the text to be sized
 * \param fontSize Integer with the font size in points
 * \param width Total width of the cell
 * \param margin Margin to use inside the cell (padding)
 */
+ (CGFloat) autosizeHeightForCellWithText:(NSString*)text fontSize:(NSInteger)fontSize cellWidth:(NSInteger)width cellMargin:(NSInteger)margin 
{
  CGSize constraint = CGSizeMake(width - (margin * 2), 20000.0f);
  CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
  CGFloat height = MAX(size.height, 44.0f);
  return height + (margin * 2);
}

@end
