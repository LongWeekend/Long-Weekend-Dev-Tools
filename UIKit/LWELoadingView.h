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
#define DEFAULT_OFFSET_WIDTH	2
#define DEFAULT_OFFSET_HEIGHT 15

@interface LWELoadingView : UIView 
{
}

+ (id)loadingView:(UIView *)aSuperview withText:(NSString *)text;

@end
