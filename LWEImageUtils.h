//
//  LWEImageUtils.h
//  DiamondsApp
//
//  Created by Mark Makdad on 8/14/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWEImageUtils : NSObject {

}

// TODO: doc these
+(UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height;
+ (CGAffineTransform) orientationTransformForImage:(UIImage *)image newSize:(CGSize)newSize;
+ (UIImage *) rotateImage:(UIImage *)image;


@end
