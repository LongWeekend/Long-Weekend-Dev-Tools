//
//  LWEFormView.h
//  phone
//
//  Created by Mark Makdad on 7/19/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+LWETextValidator.h"

@class LWEFormView;

/**
 * Any object that you try to add as a "field" must conform to
 * this protocol (specifically, it has a delegate)
 */
@protocol LWEFormViewFieldProtocol <NSObject, NSCoding, UIAppearance, UIAppearanceContainer>
- (id) delegate;
- (void) setDelegate:(id)aDelegate;
@end

/**
 * Any client of the LWEFormView needs to implement this protocol
 * to tell the form view what view it should be adjusting.  We could
 * theoretically get this data through the view hierarchy, but there 
 * are way too many permutations -- table views, scroll views, et al -
 * let the end customer decide.
 *
 * If the client does not implement this protocol, the LWEFormView itself is scrolled.
 */
@protocol LWEFormViewDelegate <UIScrollViewDelegate>
@optional
- (UIView*)scrollingViewForFormView:(LWEFormView *)formView;
- (BOOL)formShouldBeginEditing:(LWEFormView *)formView;
- (void)formWillBeginEditing:(LWEFormView *)formView;
- (void)formDidFinishEditing:(LWEFormView *)formView;
- (void)formDidChangeFirstResponder:(LWEFormView *)formView;
- (BOOL)formField:(id)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text;

/**
 * This programmatically sets the return key type for the last field on the form.
 * 
 * If you set the return type manually, it will be overridden if you implement this method.
 */
- (UIReturnKeyType)returnKeyForLastFormField:(LWEFormView *)formView;

/**
 * When there is any field, is about to get focus.
 * @param formView  An instance of `LWEFormView`, from where the control comes from.
 * @param responder An instance of `UIResponder` indicating what control or responder becoming a first responder.
 */
- (void)form:(LWEFormView *)formView didEnterFocusOn:(UIResponder *)responder;

/**
 * When there is any field, is about to lost focus.
 * @param formView  An instance of `LWEFormView`, from where the control comes from.
 * @param responder An instance of `UIResponder` indicating what control or responder resigning a first responder.
 */
- (void)form:(LWEFormView *)formView didLoseFocusOn:(UIResponder *)responder;

/**
 * When there is any field which "return" button is tapped. Just a different handler
 * for textFieldShouldReturn: 
 *
 * @param formView    The form view where the field is at.
 * @param responder   An instance of `UITextField` where the "return" button is tapped.
 * @param A boolean whether the current textField is resigning its first responder or not.
 */
- (BOOL)form:(LWEFormView *)formView textFieldShouldReturn:(UITextField *)textField;

/**
 * Allows the delegate to override the value determines by `componentDistanceFromKeyboard`
 * for an individual responder. 
 */
- (CGFloat)form:(LWEFormView *)formView distanceFromKeyboardForResponder:(UIResponder *)responder;

- (LWETextValidationTypes)validationTypesForField:(UIControl *)field;
- (NSInteger)maximumLengthForField:(UIControl *)field;
@end

/**
 * A block which takes one parameter, which is the `UIControl` instance
 * and expecting a boolean return value indicating that a control
 * has a valid value or not.
 */
typedef BOOL(^LWEFormFieldValidationChecks)(UIControl *);

/**
 * View container that holds 1 or more UITextView or UITextField views.
 * If you put those text views inside of the LWEFormView, this class will 
 * automatically scroll the superview to make sure that the form controls
 * are always visible above the keyboard.
 *
 * To set the "tab stops" (form order), either (a) set the .tag property
 * of each field in numeric order, or (b) add the fields as subviews
 * in the order that you want to "tab" through them.
 */
@interface LWEFormView : UIScrollView <UITextViewDelegate, UITextFieldDelegate>

- (void) hideKeyboard;
- (void) hideKeyboardAndResetScroll;
- (void) scrollToOrigin;

/**
 * Adds a form field to the form.  Adding the view to the subview
 * is the caller's responsibility.
 * 
 * Set the form field's tag to control its tab position in the form.
 */
- (void)addFormField:(id<LWEFormViewFieldProtocol>)formField;

/**
 * Removes a form field from the form.  Removing the view from the subview
 * is the caller's responsibility.
 *
 * If the form is currently editing this field, this method will resign the responder.
 */
- (void)removeFormField:(id<LWEFormViewFieldProtocol>)formField;

/**
 * Get all of the invalid fields on this form by checking each fields
 * against the supplied block.
 *
 * @param block   A `LWEFormFieldValidationChecks` block which takes the control
 *                as ann argument and return a `BOOL` indicating that the field
 *                is valid or not.
 * @return  A `NSArray` instance containing all of the invalid fields in this form.
 *
 */
- (NSArray *)invalidFieldsWithValidationBlock:(LWEFormFieldValidationChecks)block;

//! Delegate for asking about which view to scroll
@property (nonatomic, assign) IBOutlet id<LWEFormViewDelegate> delegate;

//! Returns YES if any of the form items have been edited - even if they've been restored
@property (readonly) BOOL formIsDirty;

//! Order of the form elements, sorted by tag and/or the order the subview was added.
@property (retain) NSArray *fieldsSortedByTag;

//! How long the animation should last.  The default is 0.5 seconds.
@property CGFloat animationInterval;

@end

#define kLWEMaxCharacters 255
//#define kLWEMaxDescriptionCharacters 500