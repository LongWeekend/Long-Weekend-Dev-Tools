//
//  LWETAuthenticationViewProtocol.h
//  TweetSimulationWithLWE
//
//  Created by Rendy Pranata on 18/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LWETDelegates.h"

@protocol LWETAuthenticationViewProtocol<UIWebViewDelegate>
@required
- (UIWebView *)webView;
- (void)setDelegate:(id <LWETAuthenticationViewDelegate>)aDelegate;

@end
