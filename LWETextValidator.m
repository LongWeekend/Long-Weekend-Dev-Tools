//
//  LWETextValidator.m
//
//  Created by Mark Makdad on 7/22/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "LWETextValidator.h"

@implementation LWETextValidator

#pragma mark - Private Helper

+ (BOOL) _string:(NSString*)text containsOnlyCharactersInString:(NSString*)characterString
{
  NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:characterString] invertedSet];
  NSString *filtered = [[text componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
  return [text isEqualToString:filtered];
}


#pragma mark - Validation

+ (BOOL) text:(NSString*)aString isWithinCharacterCount:(NSInteger)maxLen
{
  return (maxLen >= aString.length);
}

+ (BOOL) text:(NSString*)text passesValidationType:(LWETextValidationTypes)validationTypes
{
  return [[self class] text:text passesValidationType:validationTypes maxLength:kLWETextValidatorDefaultMaxLength];
}

+ (BOOL) text:(NSString*)text passesValidationType:(LWETextValidationTypes)validationTypes maxLength:(NSInteger)charCount
{
  LWE_ASSERT_EXC([text isKindOfClass:[NSString class]],@"If you don't pass a string, I fail");
  
  BOOL result = YES;
  if ((validationTypes & LWETextValidationTypeAlphaOnly))
  {
    // TODO: MMA - this should be localized for languages other than English
    BOOL newResult = [[self class] _string:text containsOnlyCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    result = (result && newResult);
  }
  
  if ((validationTypes & LWETextValidationTypeNumericOnly))
  {
    BOOL newResult = [[self class] _string:text containsOnlyCharactersInString:@"0123456789"];
    result = (result && newResult);
  }
  
  if ((validationTypes & LWETextValidationTypeEmail))
  {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"; 
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex]; 
    result = (result && [regexTest evaluateWithObject:text]);
  }
  
  if ((validationTypes & LWETextValidationTypePhone))
  {
    BOOL newResult = [[self class] _string:text containsOnlyCharactersInString:@".+()-0123456789"];
    result = (result && newResult);
  }
  
  if ((validationTypes & LWETextValidationTypeLength))
  {
    BOOL newResult = [[self class] text:text isWithinCharacterCount:charCount];
    result = (result && newResult);
  }
  
  return result;
}

@end
