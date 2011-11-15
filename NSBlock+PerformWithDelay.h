//
//  NSBlock+PerformWithDelay.h
//  julietteRedBalloon
//
//  Created by ポール チャップマン on 28/10/11.
//  Copyright (c) 2011 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * Adds method for using blocks as a delayed selector
 */
@interface NSObject (PerformAfterDelay)
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
@end
