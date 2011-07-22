//
//  LWETextValidator.h
//
//  Created by Mark Makdad on 7/22/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
  LWETextValidationTypeNone = 0,
  LWETextValidationTypeLength = 1,
  LWETextValidationTypeAlphaOnly = 2,
  LWETextValidationTypeNumericOnly = 4,
  LWETextValidationTypeEmail = 8,
  LWETextValidationTypePhone = 16,
} LWETextValidationType;

typedef NSInteger LWETextValidationTypes;

#define kLWETextValidatorDefaultMaxLength 50

@interface LWETextValidator : NSObject

+ (BOOL) text:(NSString*)aString isWithinCharacterCount:(NSInteger)maxLen;

+ (BOOL) text:(NSString*)text passesValidationType:(LWETextValidationTypes)validationType;

+ (BOOL) text:(NSString*)text passesValidationType:(LWETextValidationTypes)validationType maxLength:(NSInteger)charCount;

@end
