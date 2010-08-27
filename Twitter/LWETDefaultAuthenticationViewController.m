//
//  LWETDefaultAuthenticationViewController.m
//  TrialConsumerOAuthforIPhone
//
//  Created by Rendy Pranata on 15/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import "LWETDefaultAuthenticationViewController.h"
#import "LWEDebug.h"

@implementation LWETDefaultAuthenticationViewController

#pragma mark -
#pragma mark LWETAuthenticationView

@synthesize webView;
@synthesize delegate;

#pragma mark -
#pragma mark UIWebViewDelegate

- (void) webView:(UIWebView *)webView 
didFailLoadWithError:(NSError *)error
{
	LWE_LOG(@"ERROR");
	LWE_LOG(@"%@", [error userInfo]);
}

- (void) webViewDidFinishLoad:(UIWebView *)aWebView
{
	
	NSString *script;
    script = @"(function() { return document.getElementById(\"oauth_pin\").firstChild.textContent; } ())";
    
    NSString *pin = [self.webView stringByEvaluatingJavaScriptFromString:script];
	
    if ([pin length] > 0) {
        NSLog(@"pin %@", pin);
        
        if ([delegate respondsToSelector:@selector(didFinishAuthorizationWithPin:)])
            [delegate didFinishAuthorizationWithPin:pin];
        
		[self dismissModalViewControllerAnimated:NO];	
    }
	else 
	{
		[aWebView stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0,350);"];
	}
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
	LWE_LOG(@"Start Load");
}



#pragma mark -
#pragma mark UIViewController life cycle


// The designated initializer.  
// Override if you create the controller programmatically and 
// want to perform customization 
// that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil 
								bundle:nibBundleOrNil])) 
	{
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after 
// loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	_doneBtn = [[UIBarButtonItem alloc]
				initWithTitle:@"Done" 
				style:UIBarButtonItemStyleDone 
				target:self 
				action:@selector(doneButtonTouchedUp:)];
	
	_cancelBtn = [[UIBarButtonItem alloc]
				initWithTitle:@"Cancel" 
				style:UIBarButtonItemStylePlain 
				target:self 
				action:@selector(cancelBtnTouchedUp:)];
	
	self.title = @"Authentication";
	self.navigationItem.leftBarButtonItem = _cancelBtn;
}


// Override to allow orientations other than 
// the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	self.webView = nil;
}


- (void)dealloc 
{
	[webView release];
	[_doneBtn release];
	[_cancelBtn release];
    [super dealloc];
}

#pragma mark -
#pragma mark Header File Implementation

- (void)doneButtonTouchedUp:(id)sender
{	
	NSString *script;
    script = @"(function() { return document.getElementById(\"oauth_pin\").firstChild.textContent; } ())";
    
    NSString *pin = [self.webView stringByEvaluatingJavaScriptFromString:script];
	
    if ([pin length] > 0) {
        NSLog(@"pin %@", pin);
        
        if ([delegate respondsToSelector:@selector(didFinishAuthorizationWithPin:)])
            [delegate didFinishAuthorizationWithPin:pin];
        
    }
    else {
        NSLog(@"no pin");
        if ([delegate respondsToSelector:@selector(didFailedAuthorization)])
            [delegate didFailedAuthorization];
    }
	
    [self dismissModalViewControllerAnimated:NO];	
}

- (void)cancelBtnTouchedUp:(id)sender
{
	if ([delegate respondsToSelector:@selector(didFailedAuthorization)])
		[delegate didFailedAuthorization];
	[self dismissModalViewControllerAnimated:NO];
}

#pragma mark -


@end
