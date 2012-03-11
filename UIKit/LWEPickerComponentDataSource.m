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
 
    You should subclass this and specify behavior for the didSelectRow:
*/
@implementation LWEPickerComponentDataSource

@synthesize componentTitles;
@synthesize width,rowHeight;

//! Default initializer, creates array instances
- (id) init
{
  if (self = [super init])
  {
    self.componentTitles = [NSMutableArray array];
  }
  return self;
}

//! Returns the number of items in componentTitles
- (NSInteger) count
{
  return [componentTitles count];
}

//! Really should be subclassed to do anything useful
- (void) didSelectRow:(NSInteger)row
{
  return;
}

#pragma mark -
#pragma mark Class Plumbing

//! Standard dealloc
- (void) dealloc
{
  [self setComponentTitles:nil];
  [super dealloc];
}

@end