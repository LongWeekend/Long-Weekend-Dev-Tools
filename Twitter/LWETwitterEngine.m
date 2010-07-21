//
//  LWETwitterEngine.m
//  TrialConsumerOAuthforIPhone
//
//  Created by Rendy Pranata on 16/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import "LWETwitterEngine.h"
#import "LWETDelegates.h"
#import "LWETRequestDelegate.h"

#import "OAConsumer.h"
#import "OAToken.h"
#import "OARequestParameter.h"
#import "OAMutableURLRequest.h"
#import "OAServiceTicket.h"
#import "OADataFetcher.h"
#import "LWEDebug.h"
#import "LWETUser.h"
#import "LWETUserDB.h"
#import "LWETXAuthViewProtocol.h"
#import "JSON.h"

@implementation LWETwitterEngine

@synthesize parentForUserAuthenticationView;
@synthesize authObj;
@synthesize delegate;
@synthesize consumer; 
@synthesize db;
@synthesize context;
@synthesize tmpForUserID;
@synthesize authenticationView;
@synthesize loggedUser;

#pragma mark -
#pragma mark Setters for loggedUser

- (void)setLoggedUser:(LWETUser *)aUser
			 authMode:(LWETAuthMode)authMode
{
	//TODO: CHECK IF THE USER IS THE SAME
	
	LWETUser *user = nil;
	//check the user id from the database first
	NSError *error = nil;
	NSEntityDescription *description = [NSEntityDescription entityForName:@"userProfile" 
												   inManagedObjectContext:self.context];
	LWE_LOG(@"CHANGE USER WITH : %@", aUser.userID); 
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"profileID=%@", 
							  aUser.userID];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setPredicate:predicate];
	[request setEntity:description];
	
	NSArray *arrayOfManagedObject = [[self context] executeFetchRequest:request 
																  error:&error];
	if (arrayOfManagedObject == nil)
	{
		LWE_LOG(@"ERROR : %@", [error userInfo]);
	}
	else if([arrayOfManagedObject count] <= 0)
	{
		LWE_LOG(@"AUTHENTICATION PROCCESS");
		if (![self authObj])
		{
			tmpForUserID = [[NSString alloc]
							initWithString:aUser.userID];
			authObj = [[LWETwitterOAuth alloc]
					   initWithConsumer:self.consumer
					   delegate:self];
			
			//XAUTH MODE
			if ((authMode == LWET_AUTH_XAUTH) && (self.authenticationView) && 
				([self.authenticationView conformsToProtocol:@protocol(LWETXAuthViewProtocol)]))
			{
				UIViewController<LWETXAuthViewProtocol> *viewController =
					(UIViewController<LWETXAuthViewProtocol> *)	self.authenticationView;
				
				[viewController setAuthEngine:self.authObj];
				UINavigationController *controller = [[UINavigationController alloc]
													  initWithRootViewController:viewController];
				
				[self.parentForUserAuthenticationView presentModalViewController:controller 
																		animated:YES];
				[controller release];
			}
			//OAUTH MODE
			else if (authMode == LWET_AUTH_OAUTH)
			{
				
				if ((self.authenticationView) && ([self.authenticationView 
												   conformsToProtocol:
												   @protocol(LWETAuthenticationViewProtocol)]))
				{
					authObj.authenticationView = self.authenticationView;
				}
				[self.authObj startAuthProccess];
			}
		}
		else 
			LWE_LOG(@"TOO BAD, AUTH IS IN PROCESS");
	}
	else 
	{
		LWE_LOG(@"FROM DATABASE");
		NSManagedObject *object = [arrayOfManagedObject objectAtIndex:0];
		NSManagedObject *relationship = [object valueForKey:@"userProfileToToken"];
		user = [[LWETUser alloc]
				initFromManagedObject:relationship
				keyforKey:kTokenKey 
				keyForSecret:kTokenSecret];
		loggedUser = [user retain];
		[user release];
	}
	[request release];
}

#pragma mark -
#pragma mark Twitter Core Methods

- (void)tweet:(NSString *)words
{
	if (loggedUser != nil) 
	{
		LWE_LOG(@"TWEET USING THIS WORD : %@", words);
        OADataFetcher *fetcher;
                
		OAMutableURLRequest *request = [self prepareURLForRequestType:LWET_STATUS_UPDATE 
															relatedID:nil
														   returnType:kJSONreturnType];
        [request setHTTPMethod:@"POST"];
        
        OARequestParameter *param1 = [[OARequestParameter alloc] 
									 initWithName:@"status" value:words];
        
        NSArray *params = [NSArray arrayWithObject:param1];
        [request setParameters:params];
        
        
        fetcher = [[[OADataFetcher alloc] init] autorelease];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(statusRequestTokenTicket:didFinishWithData:)
                      didFailSelector:@selector(statusRequestTokenTicket:didFailWithError:)];
        
        [param1 release];
    }
}

- (void)search:(NSString *)people
{
	if (loggedUser != nil) 
	{
		LWE_LOG(@"LOOK FOR ID : %@", people);
        OADataFetcher *fetcher;
		
		OAMutableURLRequest *request = [self prepareURLForRequestType:LWET_USER_SEARCH
															relatedID:nil
														   returnType:kJSONreturnType];
        [request setHTTPMethod:@"GET"];
        
        OARequestParameter *param1 = [[OARequestParameter alloc] 
									  initWithName:@"q" value:people];
        
        NSArray *params = [NSArray arrayWithObject:param1];
        [request setParameters:params];
        
        
        fetcher = [[[OADataFetcher alloc] init] autorelease];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(searchRequestTokenTicket:didFinishWithData:)
                      didFailSelector:@selector(searchRequestTokenTicket:didFailWithError:)];
        
        [param1 release];
    }
}

- (void)follow:(NSString *)people
{
	if (loggedUser != nil) 
	{
		LWE_LOG(@"FOLLOW FOR ID : %@", people);
        OADataFetcher *fetcher;
		
		OAMutableURLRequest *request = [self prepareURLForRequestType:LWET_FRIENDSHIP_MAKE
															relatedID:people
														   returnType:kJSONreturnType];
        [request setHTTPMethod:@"POST"];
        
        OARequestParameter *param1 = [[OARequestParameter alloc] 
									  initWithName:@"follow" value:@"true"];
        
        NSArray *params = [NSArray arrayWithObject:param1];
        [request setParameters:params];
        
        
        fetcher = [[[OADataFetcher alloc] init] autorelease];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(followRequestTokenTicket:didFinishWithData:)
                      didFailSelector:@selector(followRequestTokenTicket:didFailWithError:)];
        
        [param1 release];
    }
}

#pragma mark -
#pragma mark Tweet Finish Delegate

- (void)statusRequestTokenTicket:(OAServiceTicket *)ticket 
			   didFinishWithData:(NSData *)data 
{
	NSString *responseBody = [[NSString alloc] 
							  initWithData:data
							  encoding:NSUTF8StringEncoding];
	LWE_LOG(@"RESPONSE REQUEST %@", responseBody);
	[responseBody release];
    if (ticket.didSucceed) 
	{
		if ([self.delegate conformsToProtocol:@protocol(LWETRequestDelegate)] &&
			[self.delegate respondsToSelector:@selector(didFinishProcessWithData:)])
		{
			id<LWETRequestDelegate> parent = (id <LWETRequestDelegate>) self.delegate;
			[parent didFinishProcessWithData:data];
		}
    } 
	else 
	{
		LWE_LOG(@"FAILED TWEET!!");
		[self statusRequestTokenTicket:ticket
					  didFailWithError:[NSError errorWithDomain:@"LWETwitterEngine" 
														   code:1 
													   userInfo:nil]];
	}
}


- (void)statusRequestTokenTicket:(OAServiceTicket *)ticket 
				didFailWithError:(NSError *)error 
{
	LWE_LOG(@"ERROR AFTER REQUEST : %@", [error userInfo]);
	if ([self.delegate conformsToProtocol:@protocol(LWETRequestDelegate)] && 
		[self.delegate respondsToSelector:@selector(didFailedWithError:)])
	{
		id<LWETRequestDelegate> parent = (id <LWETRequestDelegate>) self.delegate;
		[parent didFailedWithError:error];
	}
}

#pragma mark -
#pragma mark Search Finish Delegate

- (void)searchRequestTokenTicket:(OAServiceTicket *)ticket 
			   didFinishWithData:(NSData *)data 
{
	NSString *responseBody = [[NSString alloc] 
							  initWithData:data
							  encoding:NSUTF8StringEncoding];
	//LWE_LOG(@"RESPONSE SEARCH REQUEST %@", responseBody);
	
	SBJsonParser *parser = [[SBJsonParser alloc]
						   init];
	NSArray *obj = [parser objectWithString:responseBody];
	NSString *idPerson = [[obj objectAtIndex:0] objectForKey:@"id"];
	LWE_LOG(@"%@", idPerson);
	
	[responseBody release];
	
    /*if (ticket.didSucceed) 
	{
		if ([self.delegate conformsToProtocol:@protocol(LWETRequestDelegate)] &&
			[self.delegate respondsToSelector:@selector(didFinishProcessWithData:)])
		{
			id<LWETRequestDelegate> parent = (id <LWETRequestDelegate>) self.delegate;
			[parent didFinishProcessWithData:data];
		}
    } 
	else 
	{
		LWE_LOG(@"FAILED TWEET!!");
		[self statusRequestTokenTicket:ticket
					  didFailWithError:[NSError errorWithDomain:@"LWETwitterEngine" 
														   code:1 
													   userInfo:nil]];
	}*/
}

- (void)searchRequestTokenTicket:(OAServiceTicket *)ticket 
				didFailWithError:(NSError *)error 
{
	LWE_LOG(@"ERROR AFTER SEARCH REQUEST : %@", [error userInfo]);
	/*if ([self.delegate conformsToProtocol:@protocol(LWETRequestDelegate)] && 
		[self.delegate respondsToSelector:@selector(didFailedWithError:)])
	{
		id<LWETRequestDelegate> parent = (id <LWETRequestDelegate>) self.delegate;
		[parent didFailedWithError:error];
	}*/
}

#pragma mark -
#pragma mark follow finish delegate

- (void)followRequestTokenTicket:(OAServiceTicket *)ticket 
			   didFinishWithData:(NSData *)data 
{
	NSString *responseBody = [[NSString alloc] 
							  initWithData:data
							  encoding:NSUTF8StringEncoding];
	LWE_LOG(@"RESPONSE FOLLOW REQUEST %@", responseBody);
	
	/*SBJsonParser *parser = [[SBJsonParser alloc]
							init];
	NSArray *obj = [parser objectWithString:responseBody];
	NSString *idPerson = [[obj objectAtIndex:0] objectForKey:@"id"];*/
	
	[responseBody release];
	
    /*if (ticket.didSucceed) 
	 {
	 if ([self.delegate conformsToProtocol:@protocol(LWETRequestDelegate)] &&
	 [self.delegate respondsToSelector:@selector(didFinishProcessWithData:)])
	 {
	 id<LWETRequestDelegate> parent = (id <LWETRequestDelegate>) self.delegate;
	 [parent didFinishProcessWithData:data];
	 }
	 } 
	 else 
	 {
	 LWE_LOG(@"FAILED TWEET!!");
	 [self statusRequestTokenTicket:ticket
	 didFailWithError:[NSError errorWithDomain:@"LWETwitterEngine" 
	 code:1 
	 userInfo:nil]];
	 }*/
}

- (void)followRequestTokenTicket:(OAServiceTicket *)ticket 
				didFailWithError:(NSError *)error 
{
	LWE_LOG(@"ERROR AFTER FOLLOW REQUEST : %@", [error userInfo]);
	/*if ([self.delegate conformsToProtocol:@protocol(LWETRequestDelegate)] && 
	 [self.delegate respondsToSelector:@selector(didFailedWithError:)])
	 {
	 id<LWETRequestDelegate> parent = (id <LWETRequestDelegate>) self.delegate;
	 [parent didFailedWithError:error];
	 }*/
}

#pragma mark -
#pragma mark LWETAuthProccessDelegate

- (void)didFinishAuthProcessWithAccessToken:(OAToken *)userToken
{
	if (([self _persistUserToken:userToken]) && ([self.delegate 
												 respondsToSelector:@selector(didFinishAuth)]))
	{
		[self.delegate didFinishAuth];
	}
}

- (void)didFailAuthProcessWithError:(NSError *)error
{
	self.authObj = nil;
	LWE_LOG(@"ERROR AUTH IN THE Delegate - TWITTER ENGINE");
	if ([self.delegate 
		 respondsToSelector:@selector(didFailedAuth:)])
		[self.delegate didFailedAuth:error];
}

- (void)didFinishXAuthProcessWithAccessToken:(OAToken *)userToken
{
	[self.parentForUserAuthenticationView dismissModalViewControllerAnimated:NO];
	if (([self _persistUserToken:userToken]) && ([self.delegate 
												 respondsToSelector:@selector(didFinishAuth)]))
	{
		[self.delegate didFinishAuth];
	}
}

- (void)didFailXAuthProcessWithError:(NSError *)error
{
	
	UIViewController<LWETXAuthViewProtocol> *viewController =
	(UIViewController<LWETXAuthViewProtocol> *)	self.authenticationView;
	
	[viewController didFailAuthentication:error];
}

#pragma mark -
#pragma mark Object Lifecycle

- (id)init
{
	if ([super init])
	{
		self.db = [[LWETUserDB alloc] init];
		self.context = [db managedObjectContext];
	}
	return self;
}

- (id)initWithConsumerKey:(NSString *)consumerKey
			   privateKey:(NSString *)privateKey
{
	if ([self init])
	{
		consumer = [[OAConsumer alloc]
					initWithKey:consumerKey 
					secret:privateKey];		
	}
	return self;
}

- (id)initWithConsumerKey:(NSString *)consumerKey 
			   privateKey:(NSString *)privateKey 
	   authenticationView:(UIViewController *) controller
{
	if ([self initWithConsumerKey:consumerKey privateKey:privateKey])
		self.authenticationView = controller;
	
	return self;
}
																										

- (void) dealloc
{
	//TODO: CHECK THE DEALLOC AGAIN
	[consumer release];
	[db release];
	
	if (self.context)
		[context release];
	if (self.authenticationView)
		[authenticationView release];
	if (loggedUser)
		[loggedUser release];
	if (self.tmpForUserID)
		[tmpForUserID release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Core Methods

- (BOOL)_persistUserToken:(OAToken *)userToken
{
	//saves the authenticated user to database
	NSError *error;
	NSManagedObject *newRow = [NSEntityDescription insertNewObjectForEntityForName:kUserProfileTable
															inManagedObjectContext:self.context];
	
	[newRow setValue:tmpForUserID forKey:kUserProfileID];
	
	NSManagedObject *relationship = [NSEntityDescription insertNewObjectForEntityForName:kUserTokenTable 
																  inManagedObjectContext:self.context];
	[relationship setValue:[userToken key] forKey:kTokenKey];
	[relationship setValue:[userToken secret] forKey:kTokenSecret];
	
	[newRow setValue:relationship forKey:@"userProfileToToken"];
	
	if (![context save:&error])
	{
		LWE_LOG(@"Unresolved error saving it to database %@, %@", 
				error, [error userInfo]);
		return NO;
	}
	else
	{
		//set the current logged user
		LWETUser *user = [[LWETUser alloc]
						  initWithKey:userToken.key 
						  secret:userToken.secret];
		loggedUser = [user retain];
		[user release];
		
		//memory management
		[tmpForUserID release];
		//[authObj release];
		self.authObj = nil;
		
		return YES;
	}
}

- (OAMutableURLRequest *)prepareURLForRequestType:(LWETwitterRequestType)lwet
										relatedID:(NSString *)str
									   returnType:(NSString *)retType
{
	NSURL *url = [NSURL URLWithString:
				  [NSString stringWithFormat:@"%@/%@/%@%@.%@", 
				   kServerName, 
				   kTwitterVersion,
				   [self methodNameForTwitterRequestType:lwet],
				   (str) ? str : @"",
				   retType]];
	
	OAMutableURLRequest *request = [[[OAMutableURLRequest alloc]
									 initWithURL:url
									 consumer:self.consumer 
									 token:loggedUser.userAccessToken
									 realm:nil
									 signatureProvider:nil]
									autorelease];	
	return request;
}

-(NSString *) methodNameForTwitterRequestType:(LWETwitterRequestType)lwet
{
	NSString *result = nil;
	switch (lwet) 
	{
		case LWET_STATUS_UPDATE:
			result = [NSString stringWithString:kStatusUpdateMethod];
			break;
		case LWET_USER_SEARCH:
			result = [NSString stringWithString:kSearchMethod];
			break;
		case LWET_FRIENDSHIP_MAKE:
			result = [NSString stringWithString:kFollowMethod];
			break;
		default:
			[NSException raise:NSGenericException 
						format:@"Unrecognised LWE Twitter Request Type"];
	}
	return result;
}

@end
