//
//  NSArray+Blocks.h
//  FlashOnIPhone
//
//  Created by Rendy Pranata on 12/03/11.
//  Copyright 2011 Long Weeekend, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Category of NSArray to extend the capabilities
 *  to do some commonly used task in a functional way.
 *
 *  It adds some method to use or utilise block to do
 *  day-to-day NSArray operation.
 *
 */
@interface NSArray (Blocks)

- (void)each:(void (^)(id))block;

- (void)eachWithIdx:(void (^)(id, NSUInteger))block;

- (void)reversedEach:(void (^)(id))block;

@end