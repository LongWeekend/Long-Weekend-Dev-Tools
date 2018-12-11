//
//  LWEFormView.m
//  phone
//
//  Created by Mark Makdad on 7/19/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "LWEFormView.h"

// Private Methods
@interface LWEFormView()

/** Keep reference to the keyboard height when it will appear. */
@property (assign, nonatomic) CGRect keyboardFrame;

@property (assign) BOOL formIsDirty;

- (void)addFormObject_:(id<LWEFormViewFieldProtocol>)controlObject;
- (void)removeFormObject_:(id<LWEFormViewFieldProtocol>)controlObject;

- (UIResponder *)nextFieldAfterField_:(UIResponder*)field;
- (UIResponder *)currentResponder_;
- (BOOL)isLastField_:(UIResponder*)field;
- (void)handleFocusAfterField_:(UIResponder*)field;
- (void)handleEnteringFocus_:(UIResponder*)field;
- (BOOL)formIsBeingEdited_;

- (void)hideKeyboardResettingScroll_:(BOOL)resetScroll;

- (LWETextValidationTypes)validationTypesForField_:(UIControl *)field;
- (NSInteger)maximumLengthForField_:(UIControl*)field;

- (void)scrollToView_:(UIView*)control;
@end

@implementation LWEFormView

@dynamic delegate;

#pragma mark - Class Plumbing (init/dealloc)

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  [self commonInit_];

  // Because when `didAddSubview` is called,
  // `self` is not fully initialized yet. Readd anything that
  // might be an interest.
  for (UIView<LWEFormViewFieldProtocol> *view in self.subviews)
  {
    [self addFormObject_:view];
  }

  return self;
}

- (instancetype)initWithFrame:(CGRect)aFrame
{
  self = [super initWithFrame:aFrame];
  [self commonInit_];
  return self;
}

- (void)dealloc
{
  // Need to set this to nil; if we don't, the willRemoveSubview: call in the superclass
  // will call us again in the [super dealloc] call and make us crash!
  self.fieldsSortedByTag = nil;
  
  // Stop listening to notifications.
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  [super dealloc];
}

- (void)commonInit_
{
  self.userInteractionEnabled = YES;
  self.animationInterval = 0.5;
  self.fieldsSortedByTag = [NSArray array];

  [self startListeningToKeyboardNotification_];
}

#pragma mark - Subview work

- (void)didAddSubview:(UIView<LWEFormViewFieldProtocol> *)subview
{
  [super didAddSubview:subview];
  [self addFormObject_:subview];
}

- (void)willRemoveSubview:(UIView<LWEFormViewFieldProtocol> *)subview
{
  [super willRemoveSubview:subview];

  // Only respond to this if it's an object we care about!
  if ([self.fieldsSortedByTag containsObject:subview])
  {
    [self removeFormObject_:subview];
  }
}

#pragma mark - Manual Form Management

- (void)addFormField:(UIResponder <LWEFormViewFieldProtocol>*)formField
{
  [self addFormObject_:formField];
}

- (void)removeFormField:(UIResponder<LWEFormViewFieldProtocol> *)formField
{
  // If we don't have this field, don't do anything.
  if ([self.fieldsSortedByTag containsObject:formField] == NO)
  {
    return;
  }

  if ([self currentResponder_] == formField)
  {
    // OK, we are removing the active field.
    // If it's last field, be done, otherwise move to the next
    if ([self isLastField_:formField])
    {
      [self hideKeyboardAndResetScroll];
    }
    else
    {
      [self handleFocusAfterField_:formField];
    }
  }
  [self removeFormObject_:formField];
}

#pragma mark - Methods - Hit Testing & Keyboard

/**
 * Cycles through all the forms on this 
 * view and makes sure none of them are the
 * first responder.
 */
- (void)hideKeyboardAndResetScroll
{
  [self hideKeyboardResettingScroll_:YES];
}

- (void)hideKeyboard
{
  [self hideKeyboardResettingScroll_:NO];
}

- (void)hideKeyboardResettingScroll_:(BOOL)resetScroll
{
  UIResponder *responder = [self currentResponder_];
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

#pragma mark - Validation Stufff

- (NSArray *)invalidFieldsWithValidationBlock:(LWEFormFieldValidationChecks)block
{
  NSMutableArray *invalidFields = [[NSMutableArray alloc] init];
  for (UIControl *control in [self fieldsSortedByTag])
  {
    // For each control we have on this form, we call the block with that field as a parameter,
    // and let the receiver decide how to check for validation for that control, if that control is not
    // valid, it is added into an array of invalid fields.
    LWE_ASSERT_EXC(([control isKindOfClass:[UIControl class]]), @"All fields should be inheritting from the UIControl class.\n%@ is not.", control);
    if (block(control) == NO)
    {
      [invalidFields addObject:control];
    }
  }
  
  // Prepare for a returned array
  NSArray *returnedArray = [NSArray arrayWithArray:invalidFields];
  [invalidFields release];
  return returnedArray;
}

#pragma mark - Private Methods - Form Logic

- (void)removeFormObject_:(id<LWEFormViewFieldProtocol>)controlObject
{
  NSMutableArray *newArray = [self.fieldsSortedByTag mutableCopy];
  [newArray removeObject:controlObject];
  self.fieldsSortedByTag = (NSArray*)[newArray autorelease];
  
  [controlObject setDelegate:nil];
}

- (void)addFormObject_:(id<LWEFormViewFieldProtocol>)controlObject
{
  // Dont allow for readding.
  if ([self.fieldsSortedByTag containsObject:controlObject])
  {
    return;
  }

  // TODO: MMA this is starting to get hacky.  Time for a better solution?
  BOOL isTextField = [controlObject isKindOfClass:[UITextField class]];
  BOOL isTextView = [controlObject isKindOfClass:[UITextView class]];
  if (isTextField == NO && isTextView == NO)
  {
    return;
  }


  NSMutableArray *newArray = [[self.fieldsSortedByTag mutableCopy] autorelease];
  [newArray addObject:controlObject];
  
  // Now sort it by the tag value
  NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
  self.fieldsSortedByTag = [newArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
  
  [controlObject setDelegate:self];
}

/**
 * Returns the next field in the array.  If you pass the last element
 * of the field array, it will start back at the beginning.
 */
- (UIResponder *)nextFieldAfterField_:(UIResponder *)field
{
  NSInteger currIndex = [self.fieldsSortedByTag indexOfObject:field];
  NSInteger maxIndex = ([self.fieldsSortedByTag count] - 1);
  NSInteger nextIndex = 0;
  if (currIndex < maxIndex)
  {
    nextIndex = currIndex + 1;
  }

  if (nextIndex >= self.fieldsSortedByTag.count)
  {
    return nil;
  }

  return [self.fieldsSortedByTag objectAtIndex:nextIndex];
}

/**
 * Returns YES if the \param controlObject is the last field in the form.
 */
- (BOOL)isLastField_:(UIResponder *)field
{
  NSInteger currIndex = [self.fieldsSortedByTag indexOfObject:field];
  return (currIndex == ([self.fieldsSortedByTag count] - 1));
}


/**
 * Tells us who the current responder is
 */
- (UIResponder *)currentResponder_
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
- (BOOL)formIsBeingEdited_
{
  return ([self currentResponder_] != nil);
}

#pragma mark - Private Methods - validation

/**
 * Get the max number of characters for a field
 */
- (NSInteger)maximumLengthForField_:(UIControl*)field
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
- (LWETextValidationTypes)validationTypesForField_:(UIControl*)field
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
- (void)handleFocusAfterField_:(UIResponder*)field
{
  if ([self isLastField_:field])
  {
    [self hideKeyboardAndResetScroll];
  }
  else
  {
    UIResponder *nextField = [self nextFieldAfterField_:field];
    [nextField becomeFirstResponder];
    
    // Tell the delegate something changed, in case they want to do something.
    LWE_DELEGATE_CALL(@selector(formDidChangeFirstResponder:),self);
  }  
}

/**
 * This method is called any time a field gets focus; if we need to, we can notify
 * the delegate or lazy-load any non-standard input views (pickers et al)
 */
- (void)handleEnteringFocus_:(UIResponder*)field
{
  // Notify the delegate if we're going to start editing a form
  if ([self formIsBeingEdited_] == NO)
  {
    if ([self.delegate respondsToSelector:@selector(formWillBeginEditing:)])
    {
      [self.delegate formWillBeginEditing:self];
    }
  }
}

#pragma mark - Date Picker Helpers

- (void)doneButtonPressed_:(id)sender
{
  UIResponder *responder = [self currentResponder_];
  [self handleFocusAfterField_:responder];
}

#pragma mark - Keyboard Helpers

/** Start listening to any keyboard appearing notification. */
- (void)startListeningToKeyboardNotification_
{
  // When the keyboard appear, try to get the keyboard height.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveKeyboardFrame_:)
                                               name:UIKeyboardWillShowNotification object:nil];
  
  // When the keyboard disappears, put the scrollView offset back to its original position
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeDismissed_:)
                                               name:UIKeyboardWillHideNotification object:nil];
}

/** Record the keyboard frame whenever it appears. */
- (void)saveKeyboardFrame_:(NSNotification *)notification
{
  NSDictionary *keyboardMetadata = notification.userInfo;
  CGRect localKeyboardFrame = [keyboardMetadata[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
  // Watch out for landscape mode! From the Apple docs on UIKeyboardFrameEndUserInfoKey: "The key for an NSValue object containing a CGRect that identifies the end frame of the keyboard in screen coordinates.
  // These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes.
  // Thus, you may need to convert the rectangle to window coordinates (using the convertRect:fromWindow: method) or to view coordinates (using the convertRect:fromView: method) before using it."
  //
  // TODO: In this case, we have to use a view that is in the view hierarchy because something like self.window.rootviewController.view may not be, and therefore will not rotate.
  // We examine self.window.subviews to find a superview of the form view. This should have the correct orientation and dimensions. There may be a faster way of doing this. AWR 14 Jan 2014
  self.keyboardFrame = [[self windowSubviewThatIsASuperview_] convertRect:localKeyboardFrame fromView:nil];
  
  // Try to scroll again, make sure we are scrolling to the right position.
  UIResponder *responder = [self currentResponder_];
  if ([responder isKindOfClass:[UIView class]])
  {
    UIView *currentResponder = (UIView *)responder;
    [self scrollToView_:currentResponder];
  }
}

- (void)keyboardWillBeDismissed_:(NSNotification *)notification
{
  [self scrollToOrigin];
}

// Returns the subview of UIWindow that is a superview of self
- (UIView *)windowSubviewThatIsASuperview_
{
  UIView *viewToReturn = nil;
  for (UIView *windowSubview in self.window.subviews)
  {
    if ([self isDescendantOfView:windowSubview])
    {
      viewToReturn = windowSubview;
      break;
    }
  }
  return viewToReturn;
}

#pragma mark - Methods - View Scrolling Helpers

/** Returns the view to its original transformation/translation */
- (void)scrollToOrigin
{
  CGFloat yZeroOrigin = 0 - self.contentInset.top;
  CGPoint origin = (CGPoint){ 0.0f, yZeroOrigin };
  [self setContentOffset:origin animated:YES];
}

/**
 * This helper scrolls the view to ensure that the UIView parameter
 * is above the level of the keyboard/picker
 */
- (void)scrollToView_:(UIView *)control
{
  // Get some coordinates that we'll need. We need to convert to whole screen coordinates because the form view
  // can be smaller than the entire screen on the iPad. (However the keyboard always covers the entire screen width)
  CGPoint bottomLeftCornerOfControl = CGPointMake(control.frame.origin.x, CGRectGetMaxY(control.frame));
  CGPoint bottomLeftCornerInWholeScreen = [[self windowSubviewThatIsASuperview_] convertPoint:bottomLeftCornerOfControl fromView:self];

  // Find out if the delegate wants a minimum distance above the keyboard. Use it if so.
  CGFloat minimumDistanceAboveKeyboard = 20.0f;
  if ([self.delegate respondsToSelector:@selector(form:minimumDistanceAboveKeyboardForResponder:)])
  {
    minimumDistanceAboveKeyboard = [self.delegate form:self minimumDistanceAboveKeyboardForResponder:control];
  }

  // Find out whether the control is above the required distance. If it is, don't move it.
  if (!CGRectIsEmpty(self.keyboardFrame) && (bottomLeftCornerInWholeScreen.y + minimumDistanceAboveKeyboard) > CGRectGetMinY(self.keyboardFrame))
  {
    // If it isn't, move the control to the minimum distance
    CGFloat wholeScreenYCoordinateOfKeyboardTop = self.keyboardFrame.origin.y;
    CGFloat requiredOffsetY = bottomLeftCornerInWholeScreen.y - wholeScreenYCoordinateOfKeyboardTop + minimumDistanceAboveKeyboard + self.contentOffset.y;
    [self setContentOffset:CGPointMake(0, requiredOffsetY) animated:YES];
  }
}

- (void)scrollToViewAndNotifyDelegate_:(UIView *)control
{
  [self scrollToView_:control];
  if ([self.delegate respondsToSelector:@selector(form:didEnterFocusOn:)])
  {
    [self.delegate form:self didEnterFocusOn:control];
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
    if ([self isLastField_:textField])
    {
      if (self.delegate && [self.delegate respondsToSelector:@selector(returnKeyForLastFormField:)])
      {
        textField.returnKeyType = [self.delegate returnKeyForLastFormField:self];
      }
      else
      {
        // If the delegate doesn't tell us what type to be, be "done", unless the field already has a
        // type associated with it.
        if (textField.returnKeyType == UIReturnKeyDefault)
        {
          textField.returnKeyType = UIReturnKeyDone;
        }
      }
    }
    else
    {
      textField.returnKeyType = UIReturnKeyNext;
    }

    [self handleEnteringFocus_:textField];
  }
  return shouldEdit;
}

/** Uses the delegate hook to scroll the view to the location of the text field  */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self scrollToViewAndNotifyDelegate_:textField];
}

/**
 * Uses the delegate hook to handle the finding of the next field and selecting it.
 * If this is the last/only field, it scrolls to origin and hides the keyboard.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
  [self handleFocusAfterField_:textField];
  
  // If the delegate is implementing it, let the delegate answer.
  if ([self.delegate respondsToSelector:@selector(form:textFieldShouldReturn:)])
  {
    return [self.delegate form:self textFieldShouldReturn:textField];
  }
  return YES;
}

/**
 * Validates maximum character length text fields
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
  LWETextValidationTypes validationTypes = [self validationTypesForField_:(UIControl*)textField];
  if (validationTypes & LWETextValidationTypeEmail)
  {
    validationTypes = validationTypes ^ LWETextValidationTypeEmail;
  }

  if (validationTypes & LWETextValidationTypeLength)
  {
    charCount = [self maximumLengthForField_:(UIControl*)textField];
  }
  NSString *newText = [NSString stringWithFormat:@"%@%@",textField.text,string];
  return [newText passesValidationType:validationTypes maxLength:charCount];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  if ([self.delegate respondsToSelector:@selector(form:didLoseFocusOn:)])
  {
    [self.delegate form:self didLoseFocusOn:textField];
  }
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
    [self handleEnteringFocus_:textView];
  }
  return shouldEdit;
}

/**
 * Uses the delegate hook to handle the scrolling to the location of the text view
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
  [self scrollToViewAndNotifyDelegate_:textView];
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
    [self handleFocusAfterField_:textView];
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
  LWETextValidationTypes validationTypes = [self validationTypesForField_:(UIControl*)textView];
  if (validationTypes & LWETextValidationTypeEmail)
  {
    validationTypes = validationTypes ^ LWETextValidationTypeEmail;
  }

  // Now do the length
  if (validationTypes & LWETextValidationTypeLength)
  {
    charCount = [self maximumLengthForField_:(UIControl*)textView];
  }
  NSString *newText = [NSString stringWithFormat:@"%@%@",textView.text,text];
  return [newText passesValidationType:validationTypes maxLength:charCount];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([self.delegate respondsToSelector:@selector(form:didLoseFocusOn:)])
  {
    [self.delegate form:self didLoseFocusOn:textView];
  }
}

@end
