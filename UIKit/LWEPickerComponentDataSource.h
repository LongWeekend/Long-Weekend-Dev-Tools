//
//  LWEPickerComponentDataSource.h
//  LocationBasedMessaging
//
//  Created by Mark Makdad on 7/1/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Acts as a data source for an individual component on a UIPickerView
@interface LWEPickerComponentDataSource : NSObject
{
  NSArray *componentTitles;           //! Holds an array of titles (shown in the picker)
  NSArray *componentInvocations;      //! Holds an array of invocations (actions of the picker items)
  CGFloat width;
  CGFloat rowHeight;
}

//! Returns the number of items in this component
- (NSInteger) count;

@property (readonly, retain) NSArray *componentTitles;
@property (readonly, retain) NSArray *componentInvocations;
@property CGFloat width;
@property CGFloat rowHeight;

@end