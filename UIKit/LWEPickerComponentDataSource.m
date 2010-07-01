//
//  LWEPickerComponentDataSource.m
//  LocationBasedMessaging
//
//  Created by Mark Makdad on 7/1/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import "LWEPickerComponentDataSource.h"

/*!
    @class LWEPickerComponentDataSource
    @discussion  
    LWEPickerComponentDataSource helps keep UIPickerDelegate source files from 
    becoming overly complex by abstracting the implementation details of each 
    component of the picker into a single class.
*/
@implementation LWEPickerComponentDataSource

@synthesize componentTitles, componentInvocations;
@synthesize width,rowHeight;

//! Default initializer, creates array instances
- (id) init
{
  if (self = [super init])
  {
    self->componentTitles = [[NSMutableArray alloc] init];
    self->componentInvocations = [[NSMutableArray alloc] init];
  }
  return self;
}

/**
 * Adds a title (item) to the picker's componentTitles array, specifying callback
 * \param str String to show in the UIPicker
 * \param anInvocation NSInvocation to use when that item is selected
 */
- (void) addTitle:(NSString*)str withInvocation:(NSInvocation*)anInvocation
{
  [self->componentTitles addObject:str];
  [self->componentInvocations addObject:anInvocation];
}


//! Returns the number of items in componentTitles
- (NSInteger) count
{
  return [componentTitles count];
}

#pragma mark -
#pragma mark Class Plumbing

//! Standard dealloc
- (void) dealloc
{
  [self->componentTitles release];
  [self->componentInvocations release];
  [super dealloc];
}

@end