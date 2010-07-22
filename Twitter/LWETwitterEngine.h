//
//  LWETwitterEngine.h
//  TrialConsumerOAuthforIPhone
//
//  Created by Rendy Pranata on 16/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "LWETDelegates.h"
#import "LWETwitterOAuth.h"
#import "LWETAuthenticationViewProtocol.h"
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

#define kServerName				@"http://api.twitter.com"
#define kStatusUpdateMethod		@"statuses/update"
#define kSearchMethod			@"users/search"
#define kFollowMethod			@"friendships/create/"

#define kJSONreturnType			@"json"
#define kXMLreturnType			@"xml"
#define	kTwitterVersion			@"1"

#define kOAUTH					@"OAUTH"
#define kXAUTH					@"XAUTH"

#define kErrorDomain			@"LWETwitterEngine"

@class OAConsumer;
@class OAToken;
@class OAServiceTicket;
@class OAMutableURLRequest;
@class LWETUser;
@class LWETUserDB;

//! Twitter request enum type for preparing the request object.
typedef enum
{
	LWET_STATUS_UPDATE,
	LWET_USER_SEARCH,
	LWET_FRIENDSHIP_MAKE
} LWETwitterRequestType;

//! Possible authentication method. XAuth, or OAuth
typedef enum
{
	LWET_AUTH_OAUTH,
	LWET_AUTH_XAUTH
}LWETAuthMode;

/**
 * This is the twitter agent class, which is going to be instantiated with the user consumer key, and its
 * secret key. It has most of the required twitter capability, like status udate (tweet), search for people, 
 * or following people. It will gets updated in the near future with heaps of other twitter capability.
 *
 * It also conforms with the LWETAuthProcessDelegate as the protocol of being the Auth engine delegate, and
 * it will gets report from the auth engine whether the auth has finishes, or failed. 
 */
@interface LWETwitterEngine : NSObject <LWETAuthProccessDelegate> 
{
	LWETUser *loggedUser;
	LWETwitterOAuth *authObj;
	OAConsumer *consumer;
	LWETUserDB *db;
	NSManagedObjectContext *context;
	
	UIViewController *parentForUserAuthenticationView;
	UIViewController *authenticationView;
	id<LWETRequestDelegate> delegate;
	NSString *tmpForUserID;
}

@property (nonatomic, retain) LWETwitterOAuth *authObj;
@property (nonatomic, readonly) LWETUser *loggedUser;
@property (nonatomic, retain) OAConsumer *consumer;
@property (nonatomic, retain) LWETUserDB *db;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSString *tmpForUserID;
@property (nonatomic, retain) UIViewController *authenticationView;
@property (nonatomic, assign) UIViewController *parentForUserAuthenticationView;
@property (nonatomic, assign) id delegate;

/**
 * Set the user, and logged them on. Check with the core data, wether they have been 
 * logged in, and has their credential on it, or the engine has to authenticate them by having
 * preferred auth mode as the OAuth, or XAuth. 
 */
- (void)setLoggedUser:(LWETUser *)aUser
			 authMode:(LWETAuthMode)authMode;

- (id)initWithConsumerKey:(NSString *)consumerKey 
			   privateKey:(NSString *)privateKey;

- (id)initWithConsumerKey:(NSString *)consumerKey 
			   privateKey:(NSString *)privateKey 
	   authenticationView:(UIViewController *) controller;

- (NSString *)methodNameForTwitterRequestType:(LWETwitterRequestType)lwet;

- (OAMutableURLRequest *)prepareURLForRequestType:(LWETwitterRequestType)lwet 
										relatedID:(NSString *)str
									   returnType:(NSString *)retType;

- (void)statusRequestTokenTicket:(OAServiceTicket *)ticket 
				didFailWithError:(NSError *)error;

- (BOOL)_persistUserToken:(OAToken *)userToken;

//Twitter Core Methods

- (void)tweet:(NSString *)words;

- (void)search:(NSString *)people;

- (void)follow:(NSString *)people;

- (void)signOutForTheCurrentUser;

@end
