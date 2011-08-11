// LWERetinaUtils.h
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
 * \brief   Utilities for helping work with HD/Retina resolution (iPhone4)
 * \details   Abstracts a lot of the hard work - so our apps can just use correct images
 * depending on their device.
 */
@interface LWERetinaUtils : NSObject

/**
 * \brief   Tells you whether or not the device has a retina display
 * \return   YES if iPhone 4
 */
+ (BOOL) isRetinaDisplay;

/**
 * \brief Returns a retina filename for any file name provided.
 * \details Note this method does NO checking for files or retina devices, it is a string processing method ONLY.
 * \name Filename to retina-icize
 * \return Filename in retina terms -- e.g. image.png => image@2x.png
 */
+ (NSString*) retinaFilenameForName: (NSString *) name;

/**
 * \brief   Returns a filename with the retina naming convention if we have iPhone 4
 * \param   name Filename of an image
 * \return   Filename of retina-ready image (if not iPhone 4, returns same as param)
 */
+ (NSString*) retinaSafeImageName:(NSString*)name;

@end
