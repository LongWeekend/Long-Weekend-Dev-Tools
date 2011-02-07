//
//  LWEPagingScrollViewDatasource.m
//  phone
//
//  Created by Ross on 2/4/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "LWEPagingScrollViewDatasource.h"

@implementation LWEPagingScrollViewDatasource

@synthesize dataPages;

- (id) init
{
  [NSException raise:@"Invalid Initializer" format:@"Use initWithDataPages instead"];
  
  return self;
}

- (id) initWithDataPages:(NSArray*)data
{
  if((self == [super init]))
  {
    self.dataPages = data;
  }
  
  return self;
}

//! returns the number of pages in the datasource
- (NSInteger)numDataPages
{
	return [dataPages count];
}

//! Returns the dictionary of data for a given page
- (NSDictionary *)dataForPage:(NSInteger)pageIndex
{
	return [dataPages objectAtIndex:pageIndex];
}

@end
