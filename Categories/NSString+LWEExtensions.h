// NSString+LWEExtensions.h

#import <Foundation/Foundation.h>


@interface NSString (LWEExtensions)

//! Returns YES if the receiver is not nil and is not only whitespace
- (BOOL) isNotBlank;
- (NSString*) MD5;
- (NSString *) urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end
