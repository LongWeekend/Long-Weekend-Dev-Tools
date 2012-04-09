// NSString+LWEExtensions.m


#import "NSString+LWEExtensions.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (LWEExtensions)

- (BOOL) isNotBlank
{
  if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
  {
    return NO;
  }
  else
  {
    return YES;
  }
}

/**
 * This code first found on: 
 * http://iphonedevelopertips.com/core-services/create-md5-hash-from-nsstring-nsdata-or-file.html
 */
- (NSString*) MD5
{
  // Create pointer to the string as UTF8
  const char *ptr = [self UTF8String];
  
  // Create byte array of unsigned chars
  unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
  
  // Create 16 byte MD5 hash value, store in buffer
  CC_MD5(ptr, strlen(ptr), md5Buffer);
  
  // Convert MD5 value in the buffer to NSString of hex values
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
    [output appendFormat:@"%02x",md5Buffer[i]];
  
  return output;
}

/**
 * This code found on:
 * http://simonwoodside.com/weblog/2009/4/22/how_to_really_url_encode/
 * Example call [mystring urlEncodeUsingEncoding:kCFStringEncodingUTF8];
 */
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding 
{
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end
