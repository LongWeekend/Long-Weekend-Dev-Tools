//
//  LWELoadingView.h
//  jFlash
//
//  Created by Rendy Pranata on 29/07/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define DEFAULT_LABEL_WIDTH		280.0
#define DEFAULT_LABEL_HEIGHT	50.0
#define DEFAULT_OFFSET_WIDTH	2.0
#define DEFAULT_OFFSET_HEIGHT 10.0

@interface LWELoadingView : UIView 
{
}

+ (id)loadingView:(UIView *)aSuperview withText:(NSString *)text;
+ (id)loadingView:(UIView *)aSuperview withText:(NSString *)text calculateNavigationBar:(BOOL)calculateNavigationBar;

@end
