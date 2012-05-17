//
//  NSString+LWEResolutionHelpers.h
//  Journal
//
//  Created by Mark Makdad on 5/17/12.
//  Copyright (c) 2012 Moneytree. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 In some environments, it is useful to manually create retina & HD filenames on your 
 own.  This is a category of helpers on NSString that will take regular filenames and 
 create their associated HD and @2x components.
 
 TODO: Does not yet support the new iPad 3 (@HD@2x?).
 */
@interface NSString (LWEResolutionHelpers)
/**
 Creates a filename for the iPad 1/2 by appending `@-hd` before the file extension.
 */
- (NSString*)stringByAddingHDSpecifier;

/**
 Creates a filename for a Retina device by appending `@2x` before the file extension.
 */
- (NSString*)stringByAddingRetinaSpecifier;
@end
