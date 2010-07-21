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

#define kServerName				@"http://api.twitter.com"
#define kStatusUpdateMethod		@"statuses/update"
#define kSearchMethod			@"users/search"
#define kFollowMethod			@"friendships/create/"

#define kJSONreturnType			@"json"
#define kXMLreturnType			@"xml"
#define	kTwitterVersion			@"1"

#define kOAUTH					@"OAUTH"
#define kXAUTH					@"XAUTH"

@class OAConsumer;
@class OAToken;
@class OAServiceTicket;
@class OAMutableURLRequest;
@class LWETUser;
@class LWETUserDB;

// RENDY: doc
typedef enum
{
	LWET_STATUS_UPDATE,
	LWET_USER_SEARCH,
	LWET_FRIENDSHIP_MAKE
} LWETwitterRequestType;

// RENDY: doc
typedef enum
{
	LWET_AUTH_OAUTH,
	LWET_AUTH_XAUTH
}LWETAuthMode;

// RENDY: doc
@interface LWETwitterEngine : NSObject <LWETAuthProccessDelegate> 
{
	LWETUser *loggedUser;
	LWETwitterOAuth *authObj;
	OAConsumer *consumer;
	LWETUserDB *db;
	NSManagedObjectContext *context;
	
	UIViewController *parentForUserAuthenticationView;
	UIViewController *authenticationView;
	id delegate;
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

- (void)setLoggedUser:(LWETUser *)aUser
			 authMode:(LWETAuthMode)authMode;

- (id)init;

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

//Twitter Core Method
- (void)tweet:(NSString *)words;

- (void)search:(NSString *)people;

- (void)follow:(NSString *)people;

@end
