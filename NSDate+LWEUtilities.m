//
//  NSDate+LWEUtilities.m
//  jFlash
//
//  Created by Rendy Pranata on 28/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import "NSDate+LWEUtilities.h"


@implementation NSDate (LWEUtilities)

- (NSDate *)addDay
{
	return [self addDays:1];
}

- (NSDate *)addDays:(NSInteger)days
{
	double updatePeriod = days * 3600 * 24;
	double result = [self timeIntervalSince1970] + updatePeriod;
	NSDate *date = nil;
	date = [NSDate dateWithTimeIntervalSince1970:result];
	
	return date;
}

@end
