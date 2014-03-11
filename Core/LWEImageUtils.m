// LWEImageUtils.m
//
// Copyright (c) 2011 Long Weekend LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "LWEImageUtils.h"

@implementation LWEImageUtils

+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height
{
  return [LWEImageUtils resizeImage:image width:width height:height withQuality:kCGInterpolationMedium];
}

// Return the passed in image as a resized version
+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height withQuality:(int)quality
{
  CGSize originalSize = image.size;
  if (CGSizeEqualToSize(originalSize, CGSizeMake(width, height)) == YES)
  {
    // it's already the right size
    return image;
  }
  
  CGImageRef imageRef = [image CGImage];

  // Strips the alpha info out of the image
  //CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
  CGImageAlphaInfo alphaInfo = kCGImageAlphaNoneSkipLast;
  
  CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
  
  // make it faster but crappier
  // quality = kCGInterpolationHigh, kCGInterpolationMedium, kCGInterpolationLow
  CGContextSetInterpolationQuality(bitmap, quality);
  
  // Now resize it!
  CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
  CGImageRef ref = CGBitmapContextCreateImage(bitmap);
  UIImage *result = [UIImage imageWithCGImage:ref];
  
  CGContextRelease(bitmap);
  CGImageRelease(ref);
  
  return result;
}

+ (UIImage*)resizeImage:(UIImage*)image byScalingAndCroppingForSize:(CGSize)targetSize
{
  UIImage *sourceImage = image;
  UIImage *newImage = nil;        
  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  CGPoint thumbnailPoint = CGPointMake(0.0f,0.0f);
  
  if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
  {
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    
    if (widthFactor > heightFactor) 
      scaleFactor = widthFactor; // scale to fit height
    else
      scaleFactor = heightFactor; // scale to fit width
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    // center the image
    if (widthFactor > heightFactor)
    {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
    }
    else 
      if (widthFactor < heightFactor)
      {
        thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
      }
  }       
  
  UIGraphicsBeginImageContext(targetSize); // this will crop
  
  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width  = scaledWidth;
  thumbnailRect.size.height = scaledHeight;
  
  [sourceImage drawInRect:thumbnailRect];
  
  newImage = UIGraphicsGetImageFromCurrentImageContext();
  if(newImage == nil) 
    NSLog(@"could not scale image");
  
  //pop the context to get back to the default
  UIGraphicsEndImageContext();
  return newImage;
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
  CGFloat scale = (bounds.size.width)/width;

  LWEOrientationTransform orientTransform = [LWEImageUtils orientationTransformForImage:image];
  CGAffineTransform transform = orientTransform.transform;
  CGSize size = orientTransform.size;
  
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