//
//  DebugUIView.m
//  jFlash
//
//  Created by Ross Sharrott on 2/12/10.
//  Copyright 2010 LONG WEEKEND LLC. All rights reserved.
//

#import "DebugUIView.h"


@implementation DebugUIView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  
  UIView *hitView = [super hitTest:point withEvent:event];
  
  
  
  if (hitView == self)
    
    return [[self subviews] lastObject];
  
  else
    
    return hitView;
  
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
