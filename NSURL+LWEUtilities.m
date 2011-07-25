// NSURL+LWEUtilities.m
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

#import "NSURL+LWEUtilities.h"


@implementation NSURL (LWEUtilities)

- (NSDictionary *)queryStrings
{
	NSString *q = self.query;
	LWE_LOG(@"Query String : %@", q);
	if ((q != nil)&&([q rangeOfString:@"="].location != NSNotFound))
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		BOOL more;
		do
		{
			NSRange section = [q rangeOfString:@"&"];
			more = !(section.location == NSNotFound);
			NSString *sectionStr;
			if (more)
			{
				
				sectionStr = [q substringToIndex:section.location];
				q = [q substringFromIndex:section.location + 1];
			}
			else 
				sectionStr = q;
			
			NSRange range = [sectionStr rangeOfString:@"="];
			NSString *key = [[NSString alloc]
							 initWithString:[sectionStr substringToIndex:range.location]];
			NSString *value = [[NSString alloc]
							   initWithString:[sectionStr substringFromIndex:range.location + 1]];
			
			//LWE_LOG(@"key = %@, value = %@", key, value);
			[dict setValue:value forKey:key];
			[value release];
			[key release];
		} while (more);
		
		NSDictionary *result = [NSDictionary dictionaryWithDictionary:dict];
		[dict release];
		return result;
	}
	return nil;
}

@end
