//
//  LWECloseButtonView.h
//  jFlash
//
//  Created by Mark Makdad on 12/12/11.
//  Copyright (c) 2011 Long Weekend LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// The width in points of the border around the view
#define CLOSE_BUTTON_VIEW_BORDER_WIDTH 1.5f

// The % (between 0-1, where 1 = 100%) of the view that is a margin around the X at the center
// This value seems to be very sensitive between .25-.4
#define CLOSE_BUTTON_VIEW_X_SIZE 0.315f

// A CGSize saying how far the shadow should go
#define CLOSE_BUTTON_SHADOW_OFFSET CGSizeMake(2.0f, 2.0f)

// Blur value for the shadow.
#define CLOSE_BUTTON_SHADOW_BLUR 0.5f

// Stroke width of the "X"
#define CLOSE_BUTTON_X_WIDTH 3.0f

@interface LWECloseButtonView : UIView

@end
