//  NSString+LWETextValidator.h
//
//  Created by Mark Makdad on 7/22/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// If no vaidation length is specified by the user, but the class is asked to validate length, it will use this value.
#define kLWETextValidatorDefaultMaxLength 50

/**
 * These enums are meant to be bitwise OR'ed together to achieve the desired validation
 * scheme.  For example, to validate a string as a phone number of less than 20 characters,
 * you can call:
 * LWETextValidationTypes types = (LWETextValidationTypeLength | LWETextValidationTypePhone);
 * [LWETextValidator text:yourText passesValidationTypes:types maxLength:20];
 */
typedef enum LWETextValidationType
{
  LWETextValidationTypeNone = 0,          //! No validation performed, the validator returns YES with any string
  LWETextValidationTypeLength = 1,        //! Validates that the length is equal to or less than a certain count
  LWETextValidationTypeAlphaOnly = 2,     //! Checks that a string ONLY contains A-Za-z, and hyphen (-) and space.
  LWETextValidationTypeNumericOnly = 4,   //! Checks that a string ONLY contains 0-9
  LWETextValidationTypeEmail = 8,         //! Checks the string is a valid email address
  LWETextValidationTypePhone = 16,        //! Checks that the string contains ONLY 0-9, plus ".+-()" and a space
} LWETextValidationType;

// When the enums are OR'ed together, they will make some number (NSInteger) - but instead of using
// NSInteger throughout the code we give it a name to make its use clearer (0 or more enum values)
typedef NSInteger LWETextValidationTypes;

/**
 * Helper category to validate text strings against certain predefined validations.
 * For example, you can use this class to determine if an email address is valid, or if 
 * a string contains non-numeric values.
 */
@interface NSString (LWETextValidator)

/**
 * Returns YES if the -length value of the string is equal or less than the number specified by maxLen .
 */
- (BOOL) isWithinCharacterCount:(NSInteger)maxLen;

/**
 * Returns YES if the string contains only characters inside the string passed as a parameter.
 */
- (BOOL) containsOnlyCharactersInString:(NSString*)characterString;

/**
 * Returns YES if the text passes the validators specified by the types passed in (see enum declaration for details)
 * If you call this method with a length validation type, it will use the default max length value constant.
 */
- (BOOL) passesValidationType:(LWETextValidationTypes)validationType;

/**
 * Returns YES if the text passes the validators specified by the types passed in (see enum declaration for details)
 * If you wish to validate length and specify a max length for the string, use this method.
 */
- (BOOL) passesValidationType:(LWETextValidationTypes)validationType maxLength:(NSInteger)charCount;


@end
