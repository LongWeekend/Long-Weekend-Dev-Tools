//
//  LWEFormView.m
//  phone
//
//  Created by Mark Makdad on 7/19/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "LWEFormView.h"
#import "LWEFormDatePickerField.h"
#import "LWEViewAnimationUtils.h"

// Private Methods
@interface LWEFormView ()
- (void) _addFormObject:(id<LWEFormViewFieldProtocol>)controlObject;
- (void) _removeFormObject:(id<LWEFormViewFieldProtocol>)controlObject;

- (UIResponder*) _nextFieldAfterField:(UIResponder*)field;
- (UIResponder*) _currentResponder;
- (BOOL) _isLastField:(UIResponder*)field;
- (void) _handleFocusAfterField:(UIResponder*)field;
- (void) _handleEnteringFocus:(UIResponder*)field;
- (BOOL) _formIsBeingEdited;

- (void) _hideKeyboardResettingScroll:(BOOL)resetScroll;

- (LWETextValidationTypes) _validationTypesForField:(UIControl*)field;
- (NSInteger) _maximumLengthForField:(UIControl*)field;

- (void) _scrollToPoint:(CGPoint)relPoint;
- (void) _scrollToView:(UIView*)control;
- (UIView*) _viewToScroll;
@end

@implementation LWEFormView

@synthesize delegate;
@synthesize fieldsSortedByTag, formIsDirty = _formIsDirty, animationInterval, topPadding;

#pragma mark - Class Plumbing (init/dealloc)

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    // default topPadding
    self.topPadding = 20.0f;
    self.userInteractionEnabled = YES;
    self.fieldsSortedByTag = [NSArray array];
    self.animationInterval = 0.5;    
  }
  return self;
}

- (id) initWithFrame:(CGRect)frame
{
  return [self initWithCoder:nil];
}

- (id) init
{
  return [self initWithCoder:nil];
}

- (void)dealloc
{
  // Need to set this to nil; if we don't, the willRemoveSubview: call in the superclass
  // will call us again in the [super dealloc] call and make us crash!
  self.fieldsSortedByTag = nil;
  [super dealloc];
}

#pragma mark - Subview work

- (void) didAddSubview:(id<LWEFormViewFieldProtocol>)theSubview
{
  // TODO: MMA this is starting to get hacky.  Time for a better solution?
  BOOL isTextField = [theSubview isKindOfClass:[UITextField class]];
  BOOL isTextView = [theSubview isKindOfClass:[UITextView class]];
  if (isTextView || isTextField)
  {
    [self _addFormObject:theSubview];
  }
}

- (void) willRemoveSubview:(id<LWEFormViewFieldProtocol>)theSubview
{
  // Only respond to this if it's an object we care about!
  if ([self.fieldsSortedByTag containsObject:theSubview])
  {
    [self _removeFormObject:theSubview];
  }
}

#pragma mark - Methods - Hit Testing & Keyboard

/**
 * Cycles through all the forms on this 
 * view and makes sure none of them are the
 * first responder.
 */
- (void) hideKeyboardAndResetScroll
{
  [self _hideKeyboardResettingScroll:YES];
}

- (void) hideKeyboard
{
  [self _hideKeyboardResettingScroll:NO];
}

- (void) _hideKeyboardResettingScroll:(BOOL)resetScroll
{
  UIResponder *responder = [self _currentResponder];
  if (responder)
  {
    [responder resignFirstResponder];
    if (resetScroll)
    {
      [self scrollToOrigin];
    }

    // Tell the delegate we finished editing, in case they want to do something
    LWE_DELEGATE_CALL(@selector(formDidFinishEditing:),self);
  }
}

/**
 * If the user touches anywhere in this view's background,
 * hide the keyboard
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self hideKeyboardAndResetScroll];
}

#pragma mark - Private Methods - Form Logic

- (void) _removeFormObject:(id<LWEFormViewFieldProtocol>)controlObject
{
  NSMutableArray *newArray = [self.fieldsSortedByTag mutableCopy];
  [newArray removeObject:controlObject];
  self.fieldsSortedByTag = (NSArray*)[newArray autorelease];
  
  [controlObject setDelegate:nil];
}

- (void) _addFormObject:(id<LWEFormViewFieldProtocol>)controlObject
{
  NSMutableArray *newArray = [[self.fieldsSortedByTag mutableCopy] autorelease];
  [newArray addObject:controlObject];
  
  // Now sort it by the tag value
  NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
  self.fieldsSortedByTag = [newArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
  
  [controlObject setDelegate:self];
  
  // In addition to becoming the delegate, in the case of a picker form, also set up the button
  if ([controlObject isKindOfClass:[LWEFormDatePickerField class]])
  {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", @"Next")
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(_doneButtonPressed:)];
    LWEFormDatePickerField *pickerField = (LWEFormDatePickerField*)controlObject;
    pickerField.doneButton = barButton;
    [barButton release];
  }
}

/**
 * Returns the next field in the array.  If you pass the last element
 * of the field array, it will start back at the beginning.
 */
- (UIResponder*) _nextFieldAfterField:(UIResponder*)field
{
  NSInteger currIndex = [self.fieldsSortedByTag indexOfObject:field];
  NSInteger maxIndex = ([self.fieldsSortedByTag count] - 1);
  NSInteger nextIndex = 0;
  if (currIndex < maxIndex)
  {
    nextIndex = currIndex + 1;
  }
  UIResponder *nextField = [self.fieldsSortedByTag objectAtIndex:nextIndex];
  return nextField;
}

/**
 * Returns YES if the \param controlObject is the last field in the form.
 */
- (BOOL) _isLastField:(UIResponder*)field
{
  NSInteger currIndex = [self.fieldsSortedByTag indexOfObject:field];
  return (currIndex == ([self.fieldsSortedByTag count] - 1));
}


/**
 * Tells us who the current responder is
 */
- (UIResponder*) _currentResponder
{
  UIResponder *currentResponder = nil;
  for (UIResponder *responder in self.fieldsSortedByTag)
  {
    if ([responder isFirstResponder])
    {
      currentResponder = responder;
    }
  }
  return currentResponder;
}

/**
 * Returns YES if the form is actively being edited (e.g. if anyone is first responder)
 */
- (BOOL) _formIsBeingEdited
{
  return ([self _currentResponder] != nil);
}

#pragma mark - Private Methods - validation

/**
 * Get the max number of characters for a field
 */
- (NSInteger) _maximumLengthForField:(UIControl*)field
{
  NSInteger validationLength = kLWEMaxCharacters;
  if (self.delegate && [self.delegate respondsToSelector:@selector(maximumLengthForField:)])
  {
    validationLength = [self.delegate maximumLengthForField:field];
  }
  return validationLength;
}

/**
 * Ask the delegate if it has any validation type rules for this field.
 * If not, don't use any.
 */
- (LWETextValidationTypes) _validationTypesForField:(UIControl*)field
{
  LWETextValidationTypes validationTypes = LWETextValidationTypeNone;
  if (self.delegate && [self.delegate respondsToSelector:@selector(validationTypesForField:)])
  {
    validationTypes = [self.delegate validationTypesForField:field];
  }
  return validationTypes;
}


/**
 * Decides what to do after the \param controlObject is giving up its
 * firstResponder status.  If it's the last responder in the form array,
 * hide the keyboard/picker and reset the scroll.  Otherwise, activate
 * the next field.
 */
- (void) _handleFocusAfterField:(UIResponder*)field
{
  if ([self _isLastField:field])
  {
    [self hideKeyboardAndResetScroll];
  }
  else
  {
    UIResponder *nextField = [self _nextFieldAfterField:field];
    [nextField becomeFirstResponder];
    
    // Tell the delegate something changed, in case they want to do something.
    LWE_DELEGATE_CALL(@selector(formDidChangeFirstResponder:),self);
  }  
}

/**
 * This method is called any time a field gets focus; if we need to, we can notify
 * the delegate or lazy-load any non-standard input views (pickers et al)
 */
- (void) _handleEnteringFocus:(UIResponder*)field
{
  // Notify the delegate if we're going to start editing a form
  if ([self _formIsBeingEdited] == NO)
  {
    LWE_DELEGATE_CALL(@selector(formWillBeginEditing:),self);
  }
}

#pragma mark - Date Picker Helpers

- (void) _doneButtonPressed:(id)sender
{
  UIResponder *responder = [self _currentResponder];
  [self _handleFocusAfterField:responder];
}


#pragma mark - Methods - View Scrolling Helpers

/**
 * Returns the view to its original transformation/translation
 */
- (void) scrollToOrigin
{
  [self _scrollToPoint:CGPointZero];
}

//! Checks with the delegate and returns the UIView that will be scrolled
- (UIView*) _viewToScroll
{
  UIView *viewToScroll = nil;
  if (self.delegate && [self.delegate respondsToSelector:@selector(scrollingViewForFormView:)])
  {
    viewToScroll = [self.delegate scrollingViewForFormView:self];
  }
  else
  {
    // Delegate is nil, so just use the super view
    viewToScroll = self; //self.superview;
  }
  return viewToScroll;
}

/**
 * Scrolls the view by a certain number of points (e.g. pixels in non-retina world)
 */
- (void) _scrollToPoint:(CGPoint)relPoint
{
  UIView *viewToScroll = [self _viewToScroll];
  if ([viewToScroll isKindOfClass:[UIScrollView class]])
  {
    [(UIScrollView *)viewToScroll setContentOffset: relPoint animated:YES];
  }
  else 
  {
    [LWEViewAnimationUtils translateView:[self _viewToScroll] byPoint:relPoint withInterval:self.animationInterval];
  }  
}

/**
 * This helper scrolls the view to ensure that the UIView parameter
 * is above the level of the keyboard/picker
 */
- (void) _scrollToView:(UIView*)control
{
  UIView *viewToScroll = [self _viewToScroll];
  if ([viewToScroll isKindOfClass:[UIScrollView class]])
  {
    CGFloat yDiff = (control.frame.origin.y) - self.topPadding;
    [self _scrollToPoint:CGPointMake(0,yDiff)];
  }
  else 
  {
    // topPadding is a buffer so we don't scroll the title off the top of the screen
    CGFloat yDiff = (control.frame.origin.y * -1) + self.topPadding;
    [self _scrollToPoint:CGPointMake(0,yDiff)];
  }  
}


#pragma mark - UITextFieldDelegate


// Notify the delegate if we're going to start editing a form
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  BOOL shouldEdit = YES;
  if (self.delegate && [self.delegate respondsToSelector:@selector(formShouldBeginEditing:)])
  {
    shouldEdit = [self.delegate formShouldBeginEditing:self];
  }

  if (shouldEdit)
  {
    // set the next or done return key depending on field order
    if ([self _isLastField:textField])
    {
      textField.returnKeyType = UIReturnKeyGo;
    }
    else 
    {
      textField.returnKeyType = UIReturnKeyNext;
    }
    [self _handleEnteringFocus:textField];
  }
  return shouldEdit;
}

/**
 * Uses the delegate hook to scroll the view to the location of the text field
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self _scrollToView:textField];
}

/**
 * Uses the delegate hook to handle the finding of the next field and selecting it.
 * If this is the last/only field, it scrolls to origin and hides the keyboard.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
  [self _handleFocusAfterField:textField];
  return YES;
}

/**
 * Validates maximum character length text fields
 */
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  _formIsDirty = YES;
  
  // Ask the delegate first, if it's no there, then a no is a no.
  if (self.delegate && [self.delegate respondsToSelector:@selector(formField:shouldChangeCharactersInRange:replacementString:)])
  {
    BOOL delegateResponse = [self.delegate formField:textField shouldChangeCharactersInRange:range replacementString:string];
    if (delegateResponse == NO)
    {
      // If we are yes, trickle down and let the rest of the method deal with it.
      return NO;
    }
  }
  
  // If it's a backspace, basically ignore all validation - quick return
  BOOL isBackspace = ([string isEqualToString:@""] && (range.length == 1));
  if (isBackspace)
  {
    return YES;
  }
  
  // Get the validation types from the delegate and run them against the text.  Don't do the email now.
  NSInteger charCount = kLWEMaxCharacters;
  LWETextValidationTypes validationTypes = [self _validationTypesForField:(UIControl*)textField];
  if (validationTypes & LWETextValidationTypeEmail)
  {
    validationTypes = validationTypes ^ LWETextValidationTypeEmail;
  }

  if (validationTypes & LWETextValidationTypeLength)
  {
    charCount = [self _maximumLengthForField:(UIControl*)textField];
  }
  NSString *newText = [NSString stringWithFormat:@"%@%@",textField.text,string];
  return [newText passesValidationType:validationTypes maxLength:charCount];
}

#pragma mark - UITextViewDelegate


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
  BOOL shouldEdit = YES;
  if (self.delegate && [self.delegate respondsToSelector:@selector(formShouldBeginEditing:)])
  {
    shouldEdit = [self.delegate formShouldBeginEditing:self];
  }
  
  if (shouldEdit)
  {
    [self _handleEnteringFocus:textView];
  }
  return shouldEdit;
}

/**
 * Uses the delegate hook to handle the scrolling to the location of the text view
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
  [self _scrollToView:textView];
}

/**
 * Uses the delegate hook to do 2 things when the characters are typed/tapped:
 * 1) Validates maximum character length, and 2) if a new line is detected,
 * either move to the next field or hide keyboard & restore scroll to origin.
 */ 
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
  _formIsDirty = YES;

  // Ask the delegate first, if it's no there, then a no is a no.
  if (self.delegate && [self.delegate respondsToSelector:@selector(formField:shouldChangeCharactersInRange:replacementString:)])
  {
    BOOL delegateResponse = [self.delegate formField:textView shouldChangeCharactersInRange:range replacementString:text];
    if (delegateResponse == NO)
    {
      // If we are yes, trickle down and let the rest of the method deal with it.
      return NO;
    }
  }

  // else catch 'return' button taps and exit the field - quick return
	if ([text isEqualToString:@"\n"])
  {
    [self _handleFocusAfterField:textView];
    return NO;
	}

  // If backspace, let it by no matter what
  BOOL isBackspace = ([text isEqualToString:@""] && (range.length == 1));
  if (isBackspace)
  {
    return YES;
  }

  // Now worry about text validation - Don't validate email now.
  // it's a regex so it won't validate until they've finished typing it
  NSInteger charCount = kLWEMaxCharacters;
  LWETextValidationTypes validationTypes = [self _validationTypesForField:(UIControl*)textView];
  if (validationTypes & LWETextValidationTypeEmail)
  {
    validationTypes = validationTypes ^ LWETextValidationTypeEmail;
  }

  // Now do the length
  if (validationTypes & LWETextValidationTypeLength)
  {
    charCount = [self _maximumLengthForField:(UIControl*)textView];
  }
  NSString *newText = [NSString stringWithFormat:@"%@%@",textView.text,text];
  return [newText passesValidationType:validationTypes maxLength:charCount];
}

@end