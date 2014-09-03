//  LWEError.h
#import <Foundation/Foundation.h>

extern NSString * const LWEErrorDomain;

@interface NSError (LWEAdditions)

+ (NSError *) errorWithCode:(NSInteger)code localizedDescription:(NSString*)reason;

@end
