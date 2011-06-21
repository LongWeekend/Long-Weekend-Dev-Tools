//
//  NSArray+Blocks.m
//  FlashOnIPhone
//
//  Created by Rendy Pranata on 12/03/11.
//  Copyright 2011 Long Weekend, LLC. All rights reserved.
//

#import "NSArray+LWEBlocks.h"


@implementation NSArray (Blocks)

- (void)each:(void (^)(id))block 
{
  for (id obj in self) 
  {
    block(obj);
  }
}

- (void)eachWithIdx:(void (^)(id, NSUInteger))block
{
  NSUInteger max = [self count];
  for (NSUInteger i=0; i<max; i++)
  {
    id obj = [self objectAtIndex:i];
    block(obj, i);
  }
}

- (void)reversedEach:(void (^)(id))block
{
  for (NSInteger i=[self count]-1; i>=0; i--)
  {
    id obj = [self objectAtIndex:i];
    block(obj);
  }
}

@end