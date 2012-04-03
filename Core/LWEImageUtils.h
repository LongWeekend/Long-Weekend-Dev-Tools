// LWEImageUtils.h
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

#import <Foundation/Foundation.h>

/**
 * \brief Simple struct to hold a size and a transform matrix
 * \field transform CGAffineTransform matrix that should be applied
 * \field size New CGSIze of the image after orientation transformation
 */
typedef struct LWEOrientationTransform
{
  CGAffineTransform transform;
  CGSize size;
} LWEOrientationTransform;

@interface LWEImageUtils : NSObject

/**
 * \brief   Resizes a UIImage to the given dimensions
 * \param   image A UIImage to resize
 * \param   width New width of the image
 * \param   height New height of the image
 * \param   quality integer/constant defining resize quality
 * \return   A new UIImage object at the new dimensons
 * \details   Uses a very low quality interpolation to resize quickly
 */
+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height withQuality:(int)quality;


/**
 * \brief   Alias to resizer that does not require a quality setting (defaults to medium)
 * \param   image A UIImage to resize
 * \param   width New width of the image
 * \param   height New height of the image
 * \return   A new UIImage object at the new dimensons
 * \details   Uses a very low quality interpolation to resize quickly
 */
+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;


/**
 * \brief   Alias to resizer that crops if the image scale doesn't match
 */
+ (UIImage*)resizeImage:(UIImage*)image byScalingAndCroppingForSize:(CGSize)targetSize;

/**
 * \brief   Detects the orientation of an image and returns a transformation struct that will rotate/scale it to "up" (normal orientation)
 * \param   image A UIImage
 * \return   A struct containing the CGAffineTransform matrix struct and the new CGSize struct
 */
+ (LWEOrientationTransform) orientationTransformForImage:(UIImage *)image;


/**
 * \brief   Rotates a UIImage
 * \param   image An image to rotate
 * \return   Another UIImage, rotated
 */
+ (UIImage *) rotateImage:(UIImage *)image;


@end
