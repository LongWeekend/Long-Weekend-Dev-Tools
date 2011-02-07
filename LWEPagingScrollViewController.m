//
//  PagingScrollViewController.m
//  PagingScrollView
//
//  Created by Matt Gallagher on 24/01/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
//  Modified By Ross Sharrott, Long Weekend LLC.

#import "LWEPagingScrollViewController.h"

@implementation LWEPagingScrollViewController

@synthesize datasource, delegate, currentPage, nextPage;

- (void)applyNewIndex:(NSInteger)newIndex pageController:(LWEPageViewController *)pageController
{
	NSInteger pageCount = [self.datasource numDataPages];
	BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;

	if (!outOfBounds)
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = 0;
		pageFrame.origin.x = scrollView.frame.size.width * newIndex;
		pageController.view.frame = pageFrame;
	}
	else
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = scrollView.frame.size.height;
		pageController.view.frame = pageFrame;
	}

	pageController.pageIndex = newIndex;
}

- (void)viewDidLoad
{
	self.currentPage = [self setupCurrentPage];
	self.nextPage = [self setupNextPage];
	[scrollView addSubview:self.currentPage.view];
	[scrollView addSubview:self.nextPage.view];

	NSInteger widthCount = [self.datasource numDataPages];
	if (widthCount == 0)
	{
		widthCount = 1;
	}
	
  LWE_LOG(@"height: %f", scrollView.frame.size.height);
  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * widthCount, scrollView.frame.size.height);
	scrollView.contentOffset = CGPointMake(0, 0);

	pageControl.numberOfPages = [self.datasource numDataPages];
	pageControl.currentPage = 0;
	
	[self applyNewIndex:0 pageController:self.currentPage];
	[self applyNewIndex:1 pageController:self.nextPage];
}

#pragma mark -
#pragma mark Delegate Implementation

- (LWEPageViewController*) setupCurrentPage
{
  if (self.delegate && ([self.delegate respondsToSelector:@selector(setupCurrentPage:)]))
  {
    LWEPageViewController* tmpVC = [self.delegate performSelector:@selector(setupCurrentPage:) withObject:self];
    tmpVC.datasource = self;
    return tmpVC;
  }
  else // just return a blank page
  {
    return [[[LWEPageViewController alloc] init] autorelease];
  }
}

- (LWEPageViewController*) setupNextPage
{
  if (self.delegate && ([self.delegate respondsToSelector:@selector(setupNextPage:)]))
  {
    LWEPageViewController* tmpVC = [self.delegate performSelector:@selector(setupNextPage:) withObject:self];
    tmpVC.datasource = self;
    return tmpVC;
  }
  else // just return a blank page
  {
    return [[[LWEPageViewController alloc] init] autorelease];
  }
}

#pragma mark -
#pragma mark LWEPageViewControllerDatasource Implementation

//! A page will ask for it's data, and this is the default implementation. Override to do something different
- (id) dataForPage:(NSInteger)pageIndex
{
  if (pageIndex > [[self datasource] numDataPages] - 1) // ignore out of range requests. The pages are dumb
  {
    return nil;
  }
  else
  {
    return [[[self datasource] dataPages] objectAtIndex:pageIndex];
  }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Support

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
  CGFloat pageWidth = scrollView.frame.size.width;
  float fractionalPage = scrollView.contentOffset.x / pageWidth;
	
	NSInteger lowerNumber = floor(fractionalPage);
	NSInteger upperNumber = lowerNumber + 1;
	
	if (lowerNumber == self.currentPage.pageIndex)
	{
		if (upperNumber != self.nextPage.pageIndex)
		{
			[self applyNewIndex:upperNumber pageController:self.nextPage];
		}
	}
	else if (upperNumber == self.currentPage.pageIndex)
	{
		if (lowerNumber != self.nextPage.pageIndex)
		{
			[self applyNewIndex:lowerNumber pageController:self.nextPage];
		}
	}
	else
	{
		if (lowerNumber == self.nextPage.pageIndex)
		{
			[self applyNewIndex:upperNumber pageController:self.currentPage];
		}
		else if (upperNumber == self.nextPage.pageIndex)
		{
			[self applyNewIndex:lowerNumber pageController:self.currentPage];
		}
		else
		{
			[self applyNewIndex:lowerNumber pageController:self.currentPage];
			[self applyNewIndex:upperNumber pageController:self.nextPage];
		}
	}
	
	[self.currentPage updateViews:NO];
	[self.nextPage updateViews:NO];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
  CGFloat pageWidth = scrollView.frame.size.width;
  float fractionalPage = scrollView.contentOffset.x / pageWidth;
	NSInteger nearestNumber = lround(fractionalPage);

	if (currentPage.pageIndex != nearestNumber)
	{
		LWEPageViewController *swapController = [self.currentPage retain];
		self.currentPage = self.nextPage;
		self.nextPage = swapController;
    [swapController release];
	}

	[self.currentPage updateViews:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
	[self scrollViewDidEndScrollingAnimation:newScrollView];
	pageControl.currentPage = self.currentPage.pageIndex;
}

- (IBAction)changePage:(id)sender
{
	NSInteger pageIndex = pageControl.currentPage;

	// update the scroll view to the appropriate page
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * pageIndex;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:YES];
}

- (void)dealloc
{
  self.datasource = nil;
	self.currentPage = nil;
	self.nextPage = nil;
	
	[super dealloc];
}

@end
