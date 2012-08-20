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
- (UIView*) scrollingViewForFormView:(LWEFormView*)formView;
- (BOOL) formShouldBeginEditing:(LWEFormView *)formView;
- (void) formWillBeginEditing:(LWEFormView*)formView;
- (void) formDidFinishEditing:(LWEFormView*)formView;
- (void) formDidChangeFirstResponder:(LWEFormView*)formView;
- (BOOL) formField:(id)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)text;

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
@interface LWEFormView : UIScrollView <UITextViewDelegate, UITextFieldDelegate>
{
  BOOL _formIsDirty;
}

- (void) hideKeyboard;
- (void) hideKeyboardAndResetScroll;
- (void) scrollToOrigin;

//! Delegate for asking about which view to scroll
@property (nonatomic, assign) IBOutlet id<LWEFormViewDelegate> delegate;

//! Returns YES if any of the form items have been edited - even if they've been restored
@property (readonly) BOOL formIsDirty;

//! Order of the form elements, sorted by tag and/or the order the subview was added.
@property (retain) NSArray *fieldsSortedByTag;

//! How long the animation should last.  The default is 0.5 seconds.
@property CGFloat animationInterval;

//! How many points the view should pad at the top of the scrolling (more = active form field is down farther)
@property CGFloat topPadding;

@end

#define kLWEMaxCharacters 255
//#define kLWEMaxDescriptionCharacters 500