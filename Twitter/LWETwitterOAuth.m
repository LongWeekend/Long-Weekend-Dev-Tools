//
//  LWETwitterOAuth.m
//  TrialConsumerOAuthforIPhone
//
//  Created by Rendy Pranata on 16/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import "LWETwitterOAuth.h"
#import "LWETDefaultAuthenticationViewController.h"
#import "LWEDebug.h"
#import "OAToken.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OAServiceTicket.h"
#import "OADataFetcher.h"

@implementation LWETwitterOAuth

@synthesize delegate;
@synthesize consumer;
@synthesize accessToken;
@synthesize authenticationView;

#pragma mark -
#pragma mark Initialization

- (id)init
{
	if ([super init])
	{
		//custom initialization
	}
	return self;
}

- (id)initWithConsumer:(OAConsumer *)aConsumer 
			  delegate:(id <LWETAuthProccessDelegate>)aDelegate
{
	if ([self init])
	{
		self.consumer = aConsumer;
		self.delegate = aDelegate;
	}
	return self;
}

#pragma mark -
#pragma mark Start Authentication for the application key

- (void)startXAuthProcessWithUsername:(NSString *)uname 
							 password:(NSString *)password
{
	self.accessToken = nil;
    OAMutableURLRequest *request = [self prepareURLForAuthType:LWET_ACCESS_TOKEN 
													withTicket:nil 
												  responseData:nil];
    
    [request setHTTPMethod:@"POST"];
    
    OARequestParameter *param1 = [[OARequestParameter alloc] 
								  initWithName:@"x_auth_username" value:uname];
	OARequestParameter *param2 = [[OARequestParameter alloc] 
								  initWithName:@"x_auth_password" value:password];
	OARequestParameter *param3 = [[OARequestParameter alloc] 
								  initWithName:@"x_auth_mode" value:kClientAuth];
	
    NSArray *params = [NSArray arrayWithObjects:param1, param2, param3, nil];
    [request setParameters:params];
	
	OADataFetcher *fetcher = [[[OADataFetcher alloc] 
							   init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(didFinishXAuthWithTicket:data:)
                  didFailSelector:@selector(didFailXAuthWithTicket:error:)];
	
	[param1 release];
	[param2 release];
	[param3 release];
}

- (void)startAuthProccess
{	
	self.accessToken = nil;
    OAMutableURLRequest *request = [self prepareURLForAuthType:LWET_REQUEST 
													withTicket:nil 
												  responseData:nil];
    
    [request setHTTPMethod:@"POST"];
    
    OARequestParameter *param1 = [[OARequestParameter alloc] 
								  initWithName:@"oauth_callback" value:@"oob"];
    NSArray *params = [NSArray arrayWithObject:param1];
    [request setParameters:params];
	
	OADataFetcher *fetcher = [[[OADataFetcher alloc] 
							   init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(didFinishRequestTokenWithTicket:data:)
                  didFailSelector:@selector(didFinishRequestTokenWithTicket:error:)];
	[param1 release];
}

#pragma mark -
#pragma mark FinishRequestToken

- (void)didFinishRequestTokenWithTicket:(OAServiceTicket *)ticket 
								   data:(NSData *)data
{
	OAMutableURLRequest *request = [self prepareURLForAuthType:LWET_AUTHORIZE 
													withTicket:ticket 
												  responseData:data];
	NSArray *params = nil;
	//set the parameter required for requesting 
	//a user authentication
	OARequestParameter *requestParam = [[OARequestParameter alloc]
										initWithName:@"oauth_token" 
										value:self.accessToken.key];
	params = [NSArray arrayWithObject:requestParam];
	[request setParameters:params];
	
	//default user authentication view
	if (authenticationView == nil)
	{
		LWETDefaultAuthenticationViewController *controller = 
		[[LWETDefaultAuthenticationViewController alloc]
		 initWithNibName:@"LWETDefaultAuthenticationViewController" 
		 bundle:nil];
		
		self.authenticationView = controller;
		[controller release];
	}
	
	//clean all the cookies
	NSHTTPCookie *cookie;
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	LWE_LOG(@"DELETING ALL COOKIES.");
	for (cookie in [storage cookies]) 
	{
		[storage deleteCookie:cookie];
	}
	
	//set the user authentication view initialization
	//then show the authentication view to the user
	[authenticationView setDelegate:self];
	if ([self.delegate parentForUserAuthenticationView])
	{
		UINavigationController *navCon = [[UINavigationController alloc]
										  initWithRootViewController:self.authenticationView];
		LWE_LOG(@"PRESENTING THE AUTH VIEW TO THE PARENT");
		[[self.delegate parentForUserAuthenticationView] 
		 presentModalViewController:navCon
		 animated:YES];
		[navCon release];
	}
	
	LWE_LOG(@"LOAD THE REQUEST");
	[[authenticationView webView] loadRequest:request];
	
	//clean memory
	[requestParam release];	
}

- (void)didFinishRequestTokenWithTicket:(OAServiceTicket *)ticket 
								  error:(NSError *)error
{
	//TODO: Have Proper Error Handling
	LWE_LOG(@"%@", [error userInfo]);
}

#pragma mark -
#pragma mark FinishAuthorization
#pragma mark LWETAuthenticationViewDelegate

- (void)didFinishAuthorizationWithPin:(NSString *)pin
{
	LWE_LOG(@"FINISHED THE USER AUTH");
	OAMutableURLRequest *request = [self prepareURLForAuthType:LWET_ACCESS_TOKEN 
													withTicket:nil 
												  responseData:nil];
	//give additional parameter to the request with 
	//token that we got from the first request token
	//and the new pin
	OARequestParameter *param1 = [[OARequestParameter alloc]
								  initWithName:@"oauth_token" 
								  value:self.accessToken.key];
	OARequestParameter *param2 = [[OARequestParameter alloc]
								  initWithName:@"oauth_verifier" 
								  value:pin];
	NSArray *params = [[NSArray alloc]
					   initWithObjects:param1, param2, nil];
	[request setParameters:params];
	
	//request made to server to get the token for certain user
	OADataFetcher *fetcher = [[[OADataFetcher alloc]
							   init] autorelease];
	[fetcher fetchDataWithRequest:request 
						 delegate:self 
				didFinishSelector:
	 @selector(didFinishAccessTokenWithTicket:data:) 
				  didFailSelector:
	 @selector(didFailAccessTokenWithTicket:error:)];
	
	[params release];
	[param1 release];
	[param2 release];
}

- (void)didFailedAuthorization
{
	//TODO: Have Proper Error Handling
	LWE_LOG(@"Failed Authentication");
	//TODO: Need to report back to the delegate??
	[self.delegate didFailAuthProcessWithError:nil];
}

#pragma mark -
#pragma mark FinishAccessToken

- (void)didFinishAccessTokenWithTicket:(OAServiceTicket *)ticket 
								  data:(NSData *)data
{
	LWE_LOG(@"FINISHED ALL OF THE AUTH, RETURN BACK TO THE DELEGATE");
	[self updateAccessTokenWithTicket:ticket 
								 data:data];
	if (ticket.didSucceed)
		[self.delegate 
		 didFinishAuthProcessWithAccessToken:[self accessToken]];
	else 
		[self.delegate
		 didFailAuthProcessWithError:[[[NSError alloc] init] 
										autorelease]];
}

- (void)didFailAccessTokenWithTicket:(OAServiceTicket *)ticket 
							   error:(NSError *)error
{
	//TODO: Have Proper Error Handling
	LWE_LOG(@"%@", [error userInfo]);
	[self.delegate didFailAuthProcessWithError:error];
}

#pragma mark FinishXAuthProcess

- (void)didFinishXAuthWithTicket:(OAServiceTicket *)ticket 
								  data:(NSData *)data
{
	LWE_LOG(@"FINISHED XAUTH, RETURN BACK TO THE DELEGATE");
	[self updateAccessTokenWithTicket:ticket 
								 data:data];
	if (ticket.didSucceed)
		[self.delegate 
		 didFinishXAuthProcessWithAccessToken:[self accessToken]];
	else 
		[self.delegate
		 didFailXAuthProcessWithError:[[[NSError alloc] init] 
										autorelease]];
}

- (void)didFailXAuthWithTicket:(OAServiceTicket *)ticket 
						 error:(NSError *)error
{
	//TODO: Have Proper Error Handling
	LWE_LOG(@"%@", [error userInfo]);
	[self.delegate didFailXAuthProcessWithError:error];
}

#pragma mark -
#pragma mark Core Method

- (void)updateAccessTokenWithTicket:(OAServiceTicket *)ticket 
							   data:(NSData *)data
{
	LWE_LOG(@"Updating Token with Ticket, success : %@", ((ticket != nil) && (ticket.didSucceed) ? @"YES" : @"NO"));
	//Response body is the response from twitter server
	
	if ((ticket != nil) && (ticket.didSucceed))
	{
		//Response body is the response from twitter server
		NSString *responseBody = [[NSString alloc]
								  initWithData:data 
								  encoding:NSUTF8StringEncoding];
		//clean the previous access token available
		if (accessToken != nil)
		{
			[accessToken release];
			self.accessToken = nil;
		}
		
		//allocate the token object with the one just retreived from the server
		self.accessToken = [[OAToken alloc]
							initWithHTTPResponseBody:responseBody];
		LWE_LOG(@"RESPONSE : %@", responseBody);
		LWE_LOG(@"action token success with key %@ and secret %@", self.accessToken.key, 
				self.accessToken.secret);
		[responseBody release];
	}
	else if ((ticket != nil) && (!ticket.didSucceed))
	{
		NSString *responseBody = [[NSString alloc]
								  initWithData:data 
								  encoding:NSUTF8StringEncoding];
		//TODO: PLEASE DOUBLE CHECK THIS!!
		LWE_LOG(@"Twitter Server Error?");
		LWE_LOG(@"RESPONSE : %@", responseBody);
		[responseBody release];
	}
}

- (OAMutableURLRequest *)prepareURLForAuthType:(LWETwitterAuthType)lwet 
									withTicket:(OAServiceTicket *)ticket 
								  responseData:(NSData *)data
{
	[self updateAccessTokenWithTicket:ticket data:data];
	//request back for user authentication
	NSURL *url = [NSURL URLWithString:
				  [NSString stringWithFormat:@"%@/%@", kServerNameSecure, 
				   [self methodNameForAuthType:lwet]]];
	
	OAMutableURLRequest *request = [[[OAMutableURLRequest alloc]
									 initWithURL:url 
									 consumer:self.consumer 
									 token:self.accessToken 
									 realm:nil
									 signatureProvider:nil]
									autorelease];	
	return request;
}

- (NSString *)methodNameForAuthType:(LWETwitterAuthType)lwet
{
	NSString *result = nil;
	switch (lwet) 
	{
		case LWET_REQUEST:
			result = [NSString stringWithString:kRequestTokenMethod];
			break;
		case LWET_AUTHORIZE:
			result = [NSString stringWithString:kAuthenticationMethod];
			break;
		case LWET_ACCESS_TOKEN:
			result = [NSString stringWithString:kAccessTokenMethod];
			break;
		default:
			[NSException raise:NSGenericException 
						format:@"Unrecognised LWE Twitter Auth Type"];
	}
	return result;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc
{
	if (authenticationView)
		[authenticationView release];
	if (accessToken)
		[accessToken release];
	[consumer release];
	
	[super dealloc];
}

#pragma mark -

@end
