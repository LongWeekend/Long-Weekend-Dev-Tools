// LWEUITabelUtils.h
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

#import <Foundation/Foundation.h>

#define LWE_UITABLE_CELL_FONT_SIZE 14.0f
#define LWE_UITABLE_CELL_CONTENT_WIDTH 300.0f
#define LWE_UITABLE_CELL_CONTENT_MARGIN 10.0f

@interface LWEUITableUtils : NSObject

+ (UITableViewCell*) reuseCellForIdentifier: (NSString*) identifier onTable:(UITableView*) lclTableView usingStyle:(UITableViewCellStyle)style;
+ (void)autosizeFrameForBlankLabel:(UILabel*)label forText:(NSString*)text;
+ (CGFloat) autosizeHeightForCellWithText:(NSString *)text;
+ (CGFloat) autosizeHeightForCellWithText:(NSString *)text fontSize:(NSInteger)fontSize;
+ (CGFloat) autosizeHeightForCellWithText:(NSString*)text fontSize:(NSInteger)fontSize cellWidth:(NSInteger)width cellMargin:(NSInteger)margin;

@end
