//
//  LWEFormDatePickerField.h
//  Swinburne
//
//  Created by Mark Makdad on 7/26/11.
//  Copyright 2011 th. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Custom subclass that replaces the standard keyboard of 
 * a UITextField and replaces it with a UIDatePicker
 */
@interface LWEFormDatePickerField : UITextField

- (void) setDate:(NSDate*)date animated:(BOOL)animated;

@property (retain) NSDate *maximumDate;
@property (retain) NSDate *minimumDate;
@property (retain) NSDate *date;

@property (retain) UIBarButtonItem *doneButton;

// We need to re-define these as read-write (they are readonly properties on UIResponder)
@property (readwrite, retain) UIView *inputView;
@property (readwrite, retain) UIView *inputAccessoryView;

@end