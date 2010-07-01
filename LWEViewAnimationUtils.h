//
//  LWEViewAnimationUtils.h
//  jFlash
//
//  Created by Mark Makdad on 6/2/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface LWEViewAnimationUtils : NSObject {

}

+ (void) translateView:(UIView*)view byPoint:(CGPoint)point withInterval:(float)delay;
+ (void) doViewTransition:(NSString *)transition direction:(NSString *)direction duration:(float)duration objectToTransition:(UIViewController *)controllerToTransition;


@end
