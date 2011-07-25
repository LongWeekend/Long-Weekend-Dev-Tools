// LWEFormView.h
//
// Copyright (c) 2011 Long Weekend LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "NSString+LWETextValidator.h"

@class LWEFormView;

/**
 * Any object that you try to add as a "field" must conform to
 * this protocol (specifically, it has a delegate)
 */
@protocol LWEFormViewFieldProtocol <NSObject, NSCoding>
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
@protocol LWEFormViewDelegate <NSObject>
@optional
- (UIView*) scrollingViewForFormView:(LWEFormView*)formView;
- (void) formWillBeginEditing:(LWEFormView*)formView;
- (void) formDidFinishEditing:(LWEFormView*)formView;
- (void) formDidChangeFirstResponder:(LWEFormView*)formView;

- (LWETextValidationTypes) validationTypesForField:(UIControl*)field;
- (NSInteger) maximumLengthForField:(UIControl*)field;
@end

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
@interface LWEFormView : UIView <UITextViewDelegate, UITextFieldDelegate>
{
  BOOL _formIsDirty;
}

- (void) hideKeyboard;
- (void) hideKeyboardAndResetScroll;
- (void) scrollToOrigin;

//! Delegate for asking about which view to scroll
@property (assign) IBOutlet id<LWEFormViewDelegate> delegate;

//! Returns YES if any of the form items have been edited - even if they've been restored
@property (readonly) BOOL formIsDirty;

//! Order of the form elements, sorted by tag and/or the order the subview was added.
@property (retain) NSArray *formOrder;

//! How long the animation should last.  The default is 0.5 seconds.
@property CGFloat animationInterval;

//! How many points the view should pad at the top of the scrolling (more = active form field is down farther)
@property CGFloat topPadding;

@end

#define kLWEMaxCharacters 255
//#define kLWEMaxDescriptionCharacters 500