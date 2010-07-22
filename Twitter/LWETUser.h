//
//  LWETUser.h
//  TweetSimulationWithLWE
//
//  Created by Rendy Pranata on 16/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OAToken;

/**
 * This class symbolize a user, which are intended to be used for logging in
 * with the twitter engine.
 * 
 * There are a lot of way to initialize this class, one of them are using managed object, and init this class
 * Also, this class holds all the information needed to sign the request on behalf of this user
 * to twitter.
 */
@interface LWETUser : NSObject 
{
	NSString *key;
	NSString *secret;
	NSString *userID;
	BOOL isAuthenticated;
	
	OAToken *userAccessToken;
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) OAToken *userAccessToken;
@property (nonatomic, readwrite) BOOL isAuthenticated;

- (id)init;

- (id)initFromManagedObject:(NSManagedObject *)managedObject 
				  keyforKey:(NSString *)aKeyKey 
			   keyForSecret:(NSString *)aSecretKey;

- (id)initWithKey:(NSString *)aKey 
		   secret:(NSString *)aSecret;

- (id)initWithUserID:(NSString *)aUserID 
				 key:(NSString *)aKey 
			  secret:(NSString *)aSecret;

+ (LWETUser *)userWithID:(NSString *)aUserID;

- (OAToken *)OAuthToken;

@end