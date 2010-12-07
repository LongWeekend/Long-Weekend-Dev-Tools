//
//  LWEDateUtils.h
//
//  Created by Mark Makdad on 12/7/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.

#import <Foundation/Foundation.h>

@interface LWEDateUtils : NSObject
{
}

+ (NSString*) localizedStringFromDate:(NSDate*)inputDate dateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
+ (NSString*) localizedStringFromDate:(NSDate*)inputDate dateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle useRelative:(BOOL)relative;

@end
