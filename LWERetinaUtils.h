//
//  LWEHDUtils.h
//  jFlash
//
//  Created by Mark Makdad on 8/10/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

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
