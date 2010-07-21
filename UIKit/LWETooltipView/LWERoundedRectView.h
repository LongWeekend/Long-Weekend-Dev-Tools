//
//  RoundedRectView.h
//
//  Created by Jeff LaMarche on 11/13/08.

#import <UIKit/UIKit.h>
#import "LWETooltipConstants.h"

@interface LWERoundedRectView : UIView
{
  UIColor     *strokeColor;
  UIColor     *rectColor;
  CGFloat     strokeWidth;
  CGFloat     cornerRadius;
  CGSize shadowOffset;
}
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *rectColor;
@property CGFloat strokeWidth;
@property CGSize shadowOffset;
@property CGFloat cornerRadius;
@end
