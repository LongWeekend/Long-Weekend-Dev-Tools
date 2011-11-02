//
//  NSBlock+PerformWithDelay.m
//  julietteRedBalloon
//
//  Created by ポール チャップマン on 28/10/11.
//  Copyright (c) 2011 Long Weekend LLC. All rights reserved.
//

#import "NSBlock+PerformWithDelay.h"

@implementation NSObject(PerformAfterDelay)
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
  int64_t delta = (int64_t)(1.0e9 * delay);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}
@end
