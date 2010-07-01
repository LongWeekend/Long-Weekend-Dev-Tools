//
//  LWEUITableUtils.h
//  jFlash
//
//  Created by Mark Makdad on 2/21/10.
//  Copyright 2010 LONG WEEKEND INC.. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LWE_UITABLE_CELL_FONT_SIZE 14.0f
#define LWE_UITABLE_CELL_CONTENT_WIDTH 300.0f
#define LWE_UITABLE_CELL_CONTENT_MARGIN 10.0f

@interface LWEUITableUtils : NSObject
{
}

+ (UITableViewCell*) reuseCellForIdentifier: (NSString*) identifier onTable:(UITableView*) lclTableView usingStyle:(UITableViewCellStyle)style;
+ (CGFloat) autosizeHeightForCellWithText:(NSString *)text;
+ (CGFloat) autosizeHeightForCellWithText:(NSString *)text fontSize:(NSInteger)fontSize;
+ (CGFloat) autosizeHeightForCellWithText:(NSString*)text fontSize:(NSInteger)fontSize cellWidth:(NSInteger)width cellMargin:(NSInteger)margin;

@end
