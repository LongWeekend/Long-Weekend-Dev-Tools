//  LWEUITableUtils.m
//
//  Created by Mark Makdad on 2/21/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "LWEUITableUtils.h"

//! Helper class containing static methods to help manage UITableViews
@implementation LWEUITableUtils

//! Returns a new UITableViewCell - automatically determines whether new or off the queue
+ (UITableViewCell*) reuseCellForIdentifier: (NSString*) identifier onTable:(UITableView*) lclTableView usingStyle:(UITableViewCellStyle)style
{
  UITableViewCell* cell = [lclTableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil)
  {
    cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:identifier] autorelease];
  }
  return cell;
}

//! Returns a new UITableViewCell with a blank tagged label - automatically determines whether new or off the queue
+ (UITableViewCell*) reuseBlankLabelCellForIdentifier: (NSString*) identifier onTable:(UITableView*) lclTableView
{
  UITableViewCell *cell;
  UILabel *label = nil;
  
  cell = [lclTableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil)
  {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
    
    label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setMinimumFontSize:LWE_UITABLE_CELL_FONT_SIZE];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:LWE_UITABLE_CELL_FONT_SIZE]];
    [label setTag:1];
    
    [[cell contentView] addSubview:label];
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
  CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
  CGFloat height = MAX(size.height, 44.0f);
  return height + (margin * 2);
}

@end
