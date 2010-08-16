//
//  LWEImageUtils.m
//  DiamondsApp
//
//  Created by Mark Makdad on 8/14/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import "LWEImageUtils.h"

@implementation LWEImageUtils

// Return the passed in image as a resized version
+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height 
{
  CGImageRef imageRef = [image CGImage];
  CGSize size = [image size];

  // Strips the alpha info out of the image
  CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
  alphaInfo = kCGImageAlphaNoneSkipLast;
  
  CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
  
  // make it faster but crappier
  CGContextSetInterpolationQuality(bitmap, kCGInterpolationLow);
  
  // Now resize it!
  CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
  CGImageRef ref = CGBitmapContextCreateImage(bitmap);
  UIImage *result = [UIImage imageWithCGImage:ref];
  
  CGContextRelease(bitmap);
  CGImageRelease(ref);
  
  return result;
}

// Transforms image orientation, rotates to 'UIImageOrientationUp'
+ (LWEOrientationTransform) orientationTransformForImage:(UIImage *)image
{
  CGImageRef img = [image CGImage];
  CGFloat width = CGImageGetWidth(img);
  CGFloat height = CGImageGetHeight(img);

  CGSize size = CGSizeMake(width, height);
  CGFloat origHeight = size.height;
  CGAffineTransform transform = CGAffineTransformIdentity;
  UIImageOrientation orient = image.imageOrientation;
  
  
  switch(orient)
  { // EXIF 1 to 8 //
    case UIImageOrientationUp:
      break;
    case UIImageOrientationUpMirrored:
      transform = CGAffineTransformMakeTranslation(width, 0.0f);
      transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
      break;
    case UIImageOrientationDown:
      transform = CGAffineTransformMakeTranslation(width, height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformMakeTranslation(0.0f, height);
      transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
      break;
    case UIImageOrientationLeftMirrored:
      size.height = size.width;
      size.width = origHeight;
      transform = CGAffineTransformMakeTranslation(height, width);
      transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
      transform = CGAffineTransformRotate(transform, 3.0f * M_PI_2);
      break;
    case UIImageOrientationLeft:
      size.height = size.width;
      size.width = origHeight;
      transform = CGAffineTransformMakeTranslation(0.0f, width);
      transform = CGAffineTransformRotate(transform, 3.0f * M_PI_2);
      break;
    case UIImageOrientationRightMirrored:
      size.height = size.width;
      size.width = origHeight;
      transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
    case UIImageOrientationRight:
      size.height = size.width;
      size.width = origHeight;
      transform = CGAffineTransformMakeTranslation(height, 0.0f);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
    default:;
  }
  
  LWEOrientationTransform orientTransform;
  orientTransform.size = size;
  orientTransform.transform = transform;
  return orientTransform;
}

/// Rotate the image
+ (UIImage *) rotateImage:(UIImage *)image
{
  CGImageRef img = [image CGImage];
  CGFloat width = CGImageGetWidth(img);
  CGFloat height = CGImageGetHeight(img);
  
  CGRect bounds = CGRectMake(0, 0, width, height);
  CGSize size = bounds.size;
  CGFloat scale = (bounds.size.width)/width;

  LWEOrientationTransform orientTransform = [LWEImageUtils orientationTransformForImage:image];
  CGAffineTransform transform = orientTransform.transform;
  size = orientTransform.size;
  
  UIGraphicsBeginImageContext(size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // Flip //
  UIImageOrientation orientation = [image imageOrientation];
  if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft)
  {
    CGContextScaleCTM(context, -scale, scale);
    CGContextTranslateCTM(context, -height, 0);
  }
  else
  {
    CGContextScaleCTM(context, scale, -scale);
    CGContextTranslateCTM(context, 0, -height);
  }
  
  CGContextConcatCTM(context, transform);
  CGContextDrawImage(context, bounds, img);
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

@end