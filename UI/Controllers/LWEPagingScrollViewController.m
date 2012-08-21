// LWEPagingScrollViewController.m
//
// Based on Original Version
// Created by Matt Gallagher on 24/01/09.
// Copyright 2009 Matt Gallagher. All rights reserved.
//
// Original License Terms:
// Permission is given to use this source code file, free of charge, in any
// project, commercial or otherwise, entirely at your risk, with the condition
// that any redistribution (in part or whole) of source code must retain
// this copyright and permission notice. Attribution in compiled projects is
// appreciated but not required.
// 
// Updates & Additions
// Copyright (c) 2010, 2011, 2012 Long Weekend LLC
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

#import "LWEPagingScrollViewController.h"

@interface LWEPagingScrollViewController ()
//! These methods call out to the delegate if set, otherwise they have default implementation
- (id<LWEPageViewControllerProtocol>) setupCurrentPage;
- (id<LWEPageViewControllerProtocol>) setupNextPage;
@end

@implementation LWEPagingScrollViewController
@synthesize dataSource, delegate, currentPage, nextPage, scrollView;
@synthesize usesPageControl, pageControl;

- (void)applyNewIndex:(NSInteger)newIndex pageController:(id<LWEPageViewControllerProtocol>)pageController
{
	NSInteger pageCount = [self.dataSource numDataPages];
	BOOL outOfPageBounds = newIndex >= pageCount || newIndex < 0;

	if(outOfPageBounds)
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = self.scrollView.frame.size.height;
		pageController.view.frame = pageFrame;
	}
  else
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = 0.0f;
    // we subtract old offset to prevent creeping
    CGFloat oldOffset = (self.scrollView.frame.size.width * pageController.pageIndex);
    // add pageFrame.origin.x back to allow for defined centering offsets
		pageFrame.origin.x = (self.scrollView.frame.size.width * newIndex) + pageFrame.origin.x - oldOffset;
		pageController.view.frame = pageFrame;
	}


	pageController.pageIndex = newIndex;
  
  // Tell the page controller it needs an update now
  pageController.pageNeedsUpdate = YES;
  [pageController updateViews];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
	self.currentPage = [self setupCurrentPage];
	self.nextPage = [self setupNextPage];
	[self applyNewIndex:0 pageController:self.currentPage];
	[self applyNewIndex:1 pageController:self.nextPage];

	[self.scrollView addSubview:self.currentPage.view];
	[self.scrollView addSubview:self.nextPage.view];
  
  if (self.usesPageControl)
  {
    [self.scrollView bringSubviewToFront:self.pageControl];
    self.pageControl.numberOfPages = [self.dataSource numDataPages];
  }

	NSInteger widthCount = [self.dataSource numDataPages];
	if (widthCount == 0)
	{
		widthCount = 1;
	}
	
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * widthCount, self.scrollView.frame.size.height);
	self.scrollView.contentOffset = CGPointMake(0.0f, 0.0f);
  
  // Start on page 0
  [self changePageToIndex:0 animated:NO];
}

#pragma mark - Delegate Implementation

- (id<LWEPageViewControllerProtocol>) setupCurrentPage
{
  if (self.delegate && ([self.delegate respondsToSelector:@selector(setupCurrentPage:)]))
  {
    id<LWEPageViewControllerProtocol> tmpVC = [self.delegate setupCurrentPage:self];
    return tmpVC;
  }
  else
  {
    return nil;
  }
}

- (id<LWEPageViewControllerProtocol>) setupNextPage
{
  if (self.delegate && ([self.delegate respondsToSelector:@selector(setupNextPage:)]))
  {
    id<LWEPageViewControllerProtocol> tmpVC = [self.delegate setupNextPage:self];
    return tmpVC;
  }
  else
  {
    return nil;
  }
}

#pragma mark - UIScrollViewDelegate Support

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
  CGFloat pageWidth = self.scrollView.frame.size.width;
  CGFloat fractionalPage = self.scrollView.contentOffset.x / pageWidth;
	
	NSInteger lowerNumber = floor(fractionalPage);
  if (lowerNumber < 0)
  {
    // If the view scrolls beyond the left edge of the 0-index (e.g. leftmost) page
    lowerNumber = 0;
  }
	NSInteger upperNumber = lowerNumber + 1;
  if (upperNumber >= [self.dataSource numDataPages])
  {
    upperNumber = [self.dataSource numDataPages] - 1;
    if (upperNumber > 1)
    {
      // If the view scrolls beyond the right edge of the last page (e.g. rightmost),
      // we need to manually set the lower number.  However, if there is only one page,
      // don't do this, as the numbers would be the same.
      lowerNumber = upperNumber - 1;
    }
  }
	
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
	
  if (self.currentPage.pageNeedsUpdate)
  {
    [self.currentPage updateViews];
    self.currentPage.pageNeedsUpdate = NO;
  }
  
  if (self.nextPage.pageNeedsUpdate)
  {
    [self.nextPage updateViews];
    self.nextPage.pageNeedsUpdate = NO;
  }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
  CGFloat pageWidth = self.scrollView.frame.size.width;
  float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
	NSInteger nearestNumber = lround(fractionalPage);

	if (self.currentPage.pageIndex != nearestNumber)
	{
		id<LWEPageViewControllerProtocol> swapController = [self.currentPage retain];
		self.currentPage = self.nextPage;
		self.nextPage = swapController;
    [swapController release];
	}

  // defeats the race condition where the user can "beat" you to an un updated view
	if (self.currentPage.pageNeedsUpdate)
  {
    [self.currentPage updateViews];
    self.currentPage.pageNeedsUpdate = NO;
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
	[self scrollViewDidEndScrollingAnimation:newScrollView];
	self.pageControl.currentPage = self.currentPage.pageIndex;
}

- (void)changePageToIndex:(NSInteger)index animated:(BOOL)animated;
{
  LWE_ASSERT_EXC((index >= 0 && index < [self.dataSource numDataPages]), @"Out of bounds index: %d (num pages: %d)",index,[self.dataSource numDataPages]);
  
  NSInteger pageIndex = 0;
  pageIndex = index;
  
  // If this method was called manually (e.g. not by the page control),
  // update the page control so it stays in tune
  if (self.usesPageControl && self.pageControl.currentPage != index)
  {
    self.pageControl.currentPage = index;
  }

	// update the scroll view to the appropriate page
  CGRect frame = self.scrollView.frame;
  frame.origin.x = frame.size.width * pageIndex;
  frame.origin.y = 0.0f;
  [self.scrollView scrollRectToVisible:frame animated:animated];
}

- (IBAction)changePage:(id)sender
{
  if (self.usesPageControl)
  {
    [self changePageToIndex:self.pageControl.currentPage animated:YES];
  }
}

- (void) viewDidUnload
{
 	self.currentPage = nil;
	self.nextPage = nil;
  self.scrollView = nil;
  self.pageControl = nil;
  
  [super viewDidUnload];
}

#pragma mark - Class Plumbing

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self)
  {
    [self _commonInit];
  }
  return self;
}

-(id)initWithDataSource:(id<LWEPageViewControllerDataSource>)aDataSource
{
  self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
  if (self)
  {
    [self _commonInit];
    self.dataSource = aDataSource;
  }
  return self;
}

// XIB support
-(id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    [self _commonInit];
  }
  return self;
}

- (id) init
{
  self = [super init];
  if (self)
  {
    [self _commonInit];
  }
  return self;
}

- (void)_commonInit
{
  // Turn on the page control by default.
  self.usesPageControl = YES;
}

- (void)dealloc
{
  self.dataSource = nil;
	self.currentPage = nil;
	self.nextPage = nil;
  self.scrollView = nil;
  self.pageControl = nil;
	
	[super dealloc];
}

@end
