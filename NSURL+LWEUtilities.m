//
//  NSURL+LWEUtilities.m
//  jFlash
//
//  Created by Rendy Pranata on 23/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

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
