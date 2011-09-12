#import <GHUnitIOS/GHUnit.h>
#import "LWETextValidator.h"

@interface LWETextValidatorTest : GHTestCase
@end

@implementation LWETextValidatorTest

- (BOOL)shouldRunOnMainThread
{
  return NO;
}

- (void)setUpClass
{
}

- (void)tearDownClass
{
}

- (void)setUp
{
}

- (void)tearDown
{
}  

#pragma mark - LWE Tests

- (void) testNoValidation
{
  BOOL result;
  result = [LWETextValidator text:@"foobar" passesValidationType:LWETextValidationTypeNone];
  GHAssertEquals(result,YES,@"Text validation should let anything through if no validation");
}

- (void) testProgrammerError
{
  // We EXPECT an exception here
  GHAssertThrows([LWETextValidator text:nil passesValidationType:LWETextValidationTypeNone],@"should throw exception because completely bad input");
}

- (void) testLengthValidationDefault
{
  BOOL result;
  
  // This string is longer than the standard maximum
  NSString *longStr = @"abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde";
  result = [LWETextValidator text:longStr passesValidationType:LWETextValidationTypeLength];
  GHAssertEquals(result,NO,@"Validator should have failed the text because it's too long: %d",longStr.length);

  // This string should be shorter than the standard max!
  NSString *shortStr = @"A";
  result = [LWETextValidator text:shortStr passesValidationType:LWETextValidationTypeLength];
  GHAssertEquals(result,YES,@"Validator should have passed the text because it's should enough: %d",shortStr.length);
}

- (void) testLengthValidation
{
  BOOL result;
  
  // This string is longer than the standard maximum
  NSString *str = @"abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde";
  result = [LWETextValidator text:str passesValidationType:LWETextValidationTypeLength maxLength:100];
  GHAssertEquals(result,NO,@"Validator should have failed the text because it's too long: %d",str.length);

  result = [LWETextValidator text:str passesValidationType:LWETextValidationTypeLength maxLength:1000];
  GHAssertEquals(result,YES,@"Validator should have passed because the text is not too long: %d",str.length);
}

- (void) testAlphaOnly
{
  BOOL result;
  NSString *alpha = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  NSString *nonAlpha = @"32432432jklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
  
  result = [LWETextValidator text:alpha passesValidationType:LWETextValidationTypeAlphaOnly];
  GHAssertEquals(result,YES,@"Validator should have passed because the input is all alphabetical: %@",alpha);
  
  result = [LWETextValidator text:nonAlpha passesValidationType:LWETextValidationTypeAlphaOnly];
  GHAssertEquals(result,NO,@"Validator should have failed because the input is NOT all alphabetical: %@",nonAlpha);
}

- (void) testNumericOnly
{
  BOOL result;
  NSString *nonNumeric = @"432432-!!!?$--";
  NSString *numeric = @"32432432";
  
  result = [LWETextValidator text:nonNumeric passesValidationType:LWETextValidationTypeNumericOnly];
  GHAssertEquals(result,NO,@"Validator should have passed because the input is all numeric: %@",numeric);

  result = [LWETextValidator text:numeric passesValidationType:LWETextValidationTypeNumericOnly];
  GHAssertEquals(result,YES,@"Validator should have failed because the input is NOT numeric: %@",nonNumeric);
}

- (void) testGoodEmail
{
  BOOL result;
  result = [LWETextValidator text:@"mark@longweekendmobile.com" passesValidationType:LWETextValidationTypeEmail];
  GHAssertEquals(result,YES,@"Is a valid email!");

  result = [LWETextValidator text:@"mark...+@longweekendmobile.com" passesValidationType:LWETextValidationTypeEmail];
  GHAssertEquals(result,YES,@"Is a valid email!");
  
  result = [LWETextValidator text:@"mark+makdad@long-.weekend.mobile.co.jp" passesValidationType:LWETextValidationTypeEmail];
  GHAssertEquals(result,YES,@"Is a valid email!");
  
  result = [LWETextValidator text:@"m@m.ne.jp" passesValidationType:LWETextValidationTypeEmail];
  GHAssertEquals(result,YES,@"Is a valid email!");
}

- (void) testBadEmail
{
  BOOL result;
  result = [LWETextValidator text:@"" passesValidationType:LWETextValidationTypeEmail];
  GHAssertEquals(result,NO,@"Is NOT a valid email!");

  result = [LWETextValidator text:@"foobar" passesValidationType:LWETextValidationTypeEmail];
  GHAssertEquals(result,NO,@"Is NOT a valid email!");

  result = [LWETextValidator text:@"foobar@" passesValidationType:LWETextValidationTypeEmail];
  GHAssertEquals(result,NO,@"Is NOT a valid email!");
  
  result = [LWETextValidator text:@"foo@bar." passesValidationType:LWETextValidationTypeEmail];
  GHAssertEquals(result,NO,@"Is NOT a valid email!");
}

- (void) testNumbersAndLength
{
  BOOL result;
  
  NSInteger validation = (LWETextValidationTypeNumericOnly | LWETextValidationTypeLength);

  result = [LWETextValidator text:@"01289" passesValidationType:validation maxLength:10];
  GHAssertEquals(result,YES,@"Should pass, => 10 characters and all numeric");

  result = [LWETextValidator text:@"01234567891231214" passesValidationType:validation maxLength:10];
  GHAssertEquals(result,NO,@"Should pass, => 10 characters and all numeric");
}

@end