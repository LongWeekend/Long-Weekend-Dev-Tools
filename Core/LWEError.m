#import "LWEError.h"

NSString * const LWEErrorDomain = @"LWEErrorDomain";

@implementation NSError (LWEAdditions)

+ (NSError *) errorWithCode:(NSInteger)code localizedDescription:(NSString*)reason
{
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:reason forKey:NSLocalizedDescriptionKey];
  return [NSError errorWithDomain:LWEErrorDomain code:code userInfo:userInfo];
}

@end
