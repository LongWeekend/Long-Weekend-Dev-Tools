// LWEPagingScrollViewController.h
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

#import <UIKit/UIKit.h>
#import "LWEPagingScrollViewDataSource.h"

/**
 * This protocol allows a delegate of the LWEAudioRecorder to update
 * the view when the power levels change, etc.
 */
@class LWEPagingScrollViewController;

/**
 * This protocol defines how the page view controller expects to 
 * query data used to populate its views and behave.
 */
@protocol LWEPageViewControllerDataSource <NSObject>

@required
//! Returns whatever data package for the appropriate page index.
-(id) dataForPage:(NSInteger)pageIndex;
@end

@protocol LWEPageViewControllerProtocol <NSObject>
@required
@property (assign) id<LWEPageViewControllerDataSource> dataSource;
@property (assign) NSInteger pageIndex;
@property (strong) UIView *view;
- (void) updateViews:(BOOL)force;
@optional
- (void) setNeedsUpdate;
@end


@protocol LWEPagingScrollViewControllerDelegate <NSObject>
@required

/**
 * Called when the paging will setup the currentPage
 */
- (id<LWEPageViewControllerProtocol>)setupCurrentPage:(LWEPagingScrollViewController*)svcontroller;

/**
 * Called when the paging will setup the nextPage
 */
- (id<LWEPageViewControllerProtocol>)setupNextPage:(LWEPagingScrollViewController*)svcontroller;

@end


@interface LWEPagingScrollViewController : UIViewController <LWEPageViewControllerDataSource>

@property (nonatomic, retain) LWEPagingScrollViewDataSource *dataSource;
@property (assign) id delegate;
@property (nonatomic, retain) id<LWEPageViewControllerProtocol> currentPage;
@property (nonatomic, retain) id<LWEPageViewControllerProtocol> nextPage;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

/**
 If `YES`, this class expects `pageControl` to be a valid `UIPageControl` or subclass.  It will
 set the page of the `UIPageControl` as the view is scrolled.
 
 The default value is `YES`.
 */
@property (nonatomic) BOOL usesPageControl;

- (void)changePageAnimated:(BOOL)animated;
- (IBAction)changePage:(id)sender;
- (id)dataForPage:(NSInteger)pageIndex;

@end

