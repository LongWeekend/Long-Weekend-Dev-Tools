//
//  LWEScrollView.h
//  Rikai
//
//  Created by シャロット ロス on 6/17/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWEScrollView : NSObject {

}

+ (void)setupScrollView:(UIScrollView*)scrollView withDelegate:(id)theDelegate forViews:(NSArray *)views withTopPadding:(float)topPadding withBottomPadding:(float)bottomPadding withLeftPadding:(float)leftPadding withRightPadding:(float)rightPadding;

@end
