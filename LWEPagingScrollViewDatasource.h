//
//  LWEPagingScrollViewDatasource.h
//  phone
//
//  Created by Ross on 2/4/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

//! This is basically an interface. You must subclass this to use LWEPagingScrollView
@interface LWEPagingScrollViewDatasource : NSObject 
{
  NSArray* dataPages;
}

@property (nonatomic, retain)	NSArray* dataPages;

- (id) initWithDataPages:(NSArray*)data;
- (NSInteger)numDataPages;
- (NSDictionary *)dataForPage:(NSInteger)pageIndex;

@end
