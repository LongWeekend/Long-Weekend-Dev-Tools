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
/**
 * Returns whatever data package for the appropriate page index.
 *
 * It is up to the implementer to determine what type of data the
 * class should return to allow the child page VC display its data.
 */
-(id) dataForPage:(NSInteger)pageIndex;

/**
 * Returns the number of data pages.
 */
- (NSInteger)numDataPages;
@end

/**
 * Any UIViewController that wishes to be a LWEPagingScrollViewController "page"
 * should implement this protocol.
 */
@protocol LWEPageViewControllerProtocol <NSObject>
@required
/**
 * The data source that provides relevant data to the child page VC
 * for a given page index.
 */
@property (assign) id<LWEPageViewControllerDataSource> dataSource;
/**
 * The current page index inside of the parent scroll VC. 
 *
 * This value will be changed by the parent scroll VC as the view is scrolled,
 * so child page VC classes should/can use it in their `updateViews` implementation
 * to determine what content should be shown.
 */
@property (assign) NSInteger pageIndex;
/**
 * The view that the parent VC will add to the scroll view.
 */
@property (strong) UIView *view;
/**
 * This method is called (many times) by the parent scroll VC when a child VC 
 * is being scrolled onscreen.
 *
 * Because it is called many times, you must implement `setNeedsUpdate` method as well, 
 * which will only be called once before a view is scrolled on.
 *
 * This will allow you to not re-draw your page every time.
 *
 * That said, if your VC contains static content, this method need not provide any interesting
 * implementation.
 */
- (void) updateViews;
/**
 * When a child VC's `pageIndex` is changed, this method is called by the 
 * parent scroll VC.
 *
 * When you want to change the page content when the `pageIndex` changes, you must 
 * implement this method to set a "needsUpdate" flag in your child page VC.
 *
 * Later, when `-updateViews` is called, you will know that you need to
 * get new data from the dataSource with the new `pageIndex` and figure out what content
 * to re-display.
 */
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


@interface LWEPagingScrollViewController : UIViewController

@property (nonatomic, retain) id<LWEPageViewControllerDataSource> dataSource;
@property (assign) id <LWEPagingScrollViewControllerDelegate> delegate;
@property (nonatomic, retain) id<LWEPageViewControllerProtocol> currentPage;
@property (nonatomic, retain) id<LWEPageViewControllerProtocol> nextPage;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

/**
 * Designated initializer.
 */
-(id)initWithDataSource:(id<LWEPageViewControllerDataSource>)aDataSource;

/**
 * If `YES`, this class expects the `pageControl` property to be a valid `UIPageControl` or subclass.
 *
 * The default value is `YES` -- you need to specify a pageControl.
 */
@property (nonatomic) BOOL usesPageControl;

/**
 * Use this method to manually change the page index.
 * @param index The index to scroll to.  This will raise an exception if it is out of bounds.
 * @param animated If `YES`, the scroll view will animate to the new position.
 */
- (void)changePageToIndex:(NSInteger)index animated:(BOOL)animated;

/**
 * This is the IBAction that a UIPageControl should call on `valueDidChange`.
 *
 * Note that this will have no effect if the same UIPageControl is not hooked up to
 * the `pageControl` property.
 */
- (IBAction)changePage:(id)sender;

@end

