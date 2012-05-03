// NSString+LWETextValidator.m
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

#import "NSString+LWETextValidator.h"

@implementation NSString (LWETextValidator)

#pragma mark - Validation

- (BOOL) containsOnlyCharactersInString:(NSString*)characterString
{
  NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:characterString] invertedSet];
  NSString *filtered = [[self componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
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
