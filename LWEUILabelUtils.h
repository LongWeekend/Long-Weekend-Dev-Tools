//
//  LWEUILabelUtils.h
//  jFlash
//
//  Created by シャロット ロス on 2/13/10.
//  Copyright 2010 LONG WEEKEND INC.. All rights reserved.
//

#import <Foundation/Foundation.h>

#define READING_MIN_FONTSIZE  14.0
#define READING_MAX_FONTSIZE  20.0
#define READING_DEF_FONTSIZE  14.0

#define HEADWORD_MIN_FONTSIZE 20.0
#define HEADWORD_MAX_FONTSIZE 38.0
#define HEADWORD_DEF_FONTSIZE 14.0

@interface LWEUILabelUtils : NSObject
{
}
+ (CGRect) makeFrameForText:(NSString*)text fontSize:(NSInteger)fontSize cellWidth:(NSInteger)width cellMargin:(NSInteger)margin;
+ (void)resizeLabelWithConstraints: (UILabel *)theLabel minFontSize:(NSInteger)minFontSize maxFontSize:(NSInteger)maxFontSize forParentViewSize:(CGSize)parentViewSize;
+ (void)resizeLabelWithConstraints: (UILabel *)theLabel minFontSize:(NSInteger)minFontSize maxFontSize:(NSInteger)maxFontSize;
+ (void)autosizeLabelText: (UILabel *)theLabel forScrollView:(UIScrollView *)scrollViewContainer withText:(NSString *)theText minFontSize:(NSInteger)minFontSize maxFontSize:(NSInteger)maxFontSize;
+ (void)autosizeLabelText: (UILabel *)theLabel forScrollView:(UIScrollView *)scrollViewContainer withText:(NSString *)theText;

@end
