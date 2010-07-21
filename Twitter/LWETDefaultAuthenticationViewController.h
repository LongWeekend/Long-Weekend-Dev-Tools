//
//  LWETDefaultAuthenticationViewController.h
//  TrialConsumerOAuthforIPhone
//
//  Created by Rendy Pranata on 15/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWETAuthenticationViewProtocol.h"

@interface LWETDefaultAuthenticationViewController : UIViewController 
<LWETAuthenticationViewProtocol>
{
	id <LWETAuthenticationViewDelegate> delegate;
	UIWebView *webView;
	UIBarButtonItem *_doneBtn;
	UIBarButtonItem *_cancelBtn;
}

@property (nonatomic, retain) 
id<LWETAuthenticationViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

-(IBAction) doneButtonTouchedUp:(id)sender;

@end
