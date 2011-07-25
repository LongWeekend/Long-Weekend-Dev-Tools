//  NSString+LWETextValidator.m
//
//  Created by Mark Makdad on 7/22/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "NSString+LWETextValidator.h"

@implementation NSString (LWETextValidator)

#pragma mark - Validation

- (BOOL) containsOnlyCharactersInString:(NSString*)characterString
{
  NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:characterString] invertedSet];
  NSString *filtered = [[text componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
  return [self isEqualToString:filtered];
}

- (BOOL) isWithinCharacterCount:(NSInteger)maxLen
{
  return (maxLen >= self.length);
}

- (BOOL) passesValidationType:(LWETextValidationTypes)validationTypes
{
  return [self passesValidationType:validationTypes maxLength:kLWETextValidatorDefaultMaxLength];
}

- (BOOL) passesValidationType:(LWETextValidationTypes)validationTypes maxLength:(NSInteger)charCount
{
  BOOL result = YES;
  if ((validationTypes & LWETextValidationTypeAlphaOnly))
  {
    // TODO: MMA - this should be localized for languages other than English
    BOOL newResult = [self containsOnlyCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz- "];
    result = (result && newResult);
  }
  
  if ((validationTypes & LWETextValidationTypeNumericOnly))
  {
    BOOL newResult = [self containsOnlyCharactersInString:@"0123456789"];
    result = (result && newResult);
  }
  
  if ((validationTypes & LWETextValidationTypeEmail))
  {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"; 
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex]; 
    result = (result && [regexTest evaluateWithObject:self]);
  }
  
  if ((validationTypes & LWETextValidationTypePhone))
  {
    BOOL newResult = [self containsOnlyCharactersInString:@".+()-0123456789 "];
    result = (result && newResult);
  }
  
  if ((validationTypes & LWETextValidationTypeLength))
  {
    BOOL newResult = [self isWithinCharacterCount:charCount];
    result = (result && newResult);
  }
  
  return result;
}

@end
