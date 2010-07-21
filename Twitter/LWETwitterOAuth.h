//
//  LWETwitterOAuth.h
//  TrialConsumerOAuthforIPhone
//
//  Created by Rendy Pranata on 16/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LWETDelegates.h"
#import "LWETAuthenticationViewProtocol.h"
#import "LWETXAuthViewProtocol.h"

#define kServerNameSecure		@"https://api.twitter.com/oauth"
#define kRequestTokenMethod		@"request_token"
#define kAuthenticationMethod	@"authorize"
#define kAccessTokenMethod		@"access_token"

#define kClientAuth				@"client_auth"

@class OAConsumer;
@class OAToken;
@class OAMutableURLRequest;
@class OAServiceTicket;

typedef enum
{
	LWET_REQUEST,
	LWET_AUTHORIZE,
	LWET_ACCESS_TOKEN
} LWETwitterAuthType;

@interface LWETwitterOAuth : NSObject 
<LWETAuthenticationViewDelegate>
{
	BOOL isAuthenticated;
	id<LWETAuthProccessDelegate> delegate;
	UIViewController<LWETAuthenticationViewProtocol> *authentiactionView;
	
	OAConsumer *consumer;
	OAToken *accessToken;
}

@property (nonatomic, assign) id<LWETAuthProccessDelegate> delegate;
@property (nonatomic, retain) OAConsumer *consumer;
@property (nonatomic, retain) OAToken *accessToken;
@property (nonatomic, retain) UIViewController<LWETAuthenticationViewProtocol> *authenticationView;

- (id)init;

- (id)initWithConsumer:(OAConsumer *)aConsumer 
			  delegate:(id <LWETAuthProccessDelegate>)aDelegate;

- (void)startXAuthProcessWithUsername:(NSString *)uname 
							 password:(NSString *)password;

- (void)startAuthProccess;

- (NSString *)methodNameForAuthType:(LWETwitterAuthType)lwet;

- (OAMutableURLRequest *)prepareURLForAuthType:(LWETwitterAuthType)lwet 
									withTicket:(OAServiceTicket *)ticket 
								  responseData:(NSData *)data;

- (void)updateAccessTokenWithTicket:(OAServiceTicket *)ticket 
							   data:(NSData *)data;

@end
