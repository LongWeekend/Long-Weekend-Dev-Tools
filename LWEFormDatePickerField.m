//
//  LWEFormDatePickerField.m
//  Swinburne
//
//  Created by Mark Makdad on 7/26/11.
//  Copyright 2011 th. All rights reserved.
//

#import "LWEFormDatePickerField.h"

@implementation LWEFormDatePickerField

@synthesize inputView, inputAccessoryView, doneButton, maximumDate, minimumDate, date;

#pragma mark - Class Plumbing (init & dealloc)

- (void) dealloc
{
  // Another case where we HAVE to nil out the pointers
  self.maximumDate = nil;
  self.minimumDate = nil;
  self.date = nil;
  self.inputView = nil;
  self.inputAccessoryView = nil;
  self.doneButton = nil;
  [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    
    self.date = [NSDate date];
    self.doneButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next",@"Next") style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)] autorelease];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.items = [NSArray arrayWithObject:self.doneButton];
    self.inputAccessoryView = toolbar;
    [toolbar release];
    
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    self.inputView = picker;
    [picker release];
  }
  return self;
}

- (void) doneButtonPressed:(id)sender
{
  LWE_ASSERT_EXC([self isFirstResponder],@"There's no way this can get called unless you are first responder?!");
  
  [self canResignFirstResponder];
}

- (void) pickerValueChanged:(UIDatePicker*)sender
{
  // Format the date string
  NSDate *aDate = [sender date];
  
  // IPAD friendly (3.2)
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  [formatter setTimeStyle:NSDateFormatterNoStyle];
  self.text = [formatter stringFromDate:aDate];
  [formatter release];
  // iOS4+
  //  self.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}

- (void) setDate:(NSDate *)aDate animated:(BOOL)animated
{
  self.date = aDate;
  UIDatePicker *picker = (UIDatePicker*)self.inputView;
  [picker setDate:aDate animated:animated];
}

- (BOOL) becomeFirstResponder
{
  // Pass along these attributes before showing the picker
  UIDatePicker *picker = (UIDatePicker*)self.inputView;
  picker.maximumDate = self.maximumDate;
  picker.minimumDate = self.minimumDate;
  picker.date = self.date;
  
  return [super becomeFirstResponder];
}

@end
