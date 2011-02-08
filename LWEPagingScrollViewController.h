//
//  PagingScrollViewController.h
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

#import <UIKit/UIKit.h>
#import "LWEPagingScrollViewDatasource.h"
#import "LWEPageViewController.h"

@interface LWEPagingScrollViewController : UIViewController <LWEPageViewControllerDatasource>
{
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	
	LWEPageViewController *currentPage;
	LWEPageViewController *nextPage;
}

@property (nonatomic, retain) LWEPagingScrollViewDatasource *datasource;
@property (assign) id delegate;
@property (nonatomic, retain) LWEPageViewController *currentPage;
@property (nonatomic, retain) LWEPageViewController *nextPage;

- (LWEPageViewController*) setupNextPage;
- (LWEPageViewController*) setupCurrentPage;
- (IBAction)changePage:(id)sender;
- (id)dataForPage:(NSInteger)pageIndex;

@end

/**
 * This protocol allows a delegate of the LWEAudioRecorder to update
 * the view when the power levels change, etc.
 */
@protocol LWEPagingScrollViewControllerDelegate <NSObject>
@required

/**
 * Called when the paging will setup the currentPage
 */
- (LWEPageViewController*)setupCurrentPage:(LWEPagingScrollViewController*)svcontroller;

/**
 * Called when the paging will setup the nextPage
 */
- (LWEPageViewController*)setupNextPage:(LWEPagingScrollViewController*)svcontroller;

@end
