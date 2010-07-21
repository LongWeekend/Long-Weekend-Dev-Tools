//
//  LWETUser.m
//  TweetSimulationWithLWE
//
//  Created by Rendy Pranata on 16/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import "LWETUser.h"

#import "OAToken.h"

@implementation LWETUser

@synthesize key;
@synthesize secret;
@synthesize userID;
@synthesize userAccessToken;
@synthesize isAuthenticated;

#pragma mark -
#pragma mark Initialization phase

// RENDY: no need to implement if no code
- (id)init
{
	if ([super init])
	{
		
	}
	return self; 
}

- (id)initFromManagedObject:(NSManagedObject *)managedObject 
				  keyforKey:(NSString *)aKeyKey 
			   keyForSecret:(NSString *)aSecretKey
{
	NSString *aKey = [[NSString alloc] 
					  initWithString:
					  [managedObject valueForKey:aKeyKey]];
	NSString *aSecret = [[NSString alloc] 
						 initWithString:
						 [managedObject valueForKey:aSecretKey]];
	
	//Initialization with the key and secret given
	//from the managed object
	if ([self initWithKey:aKey 
				   secret:aSecret])
	{
		[aKey release];
		[aSecret release];
	}
	return self; 
}

- (id)initWithKey:(NSString *)aKey 
		   secret:(NSString *)aSecret
{
	if ([self init])
	{
		self.key = aKey;
		self.secret = aSecret;
		self.userAccessToken = [self OAuthToken];
		self.isAuthenticated = YES;
	}
	return self; 
}

- (id)initWithUserID:(NSString *)aUserID 
				 key:(NSString *)aKey 
			  secret:(NSString *)aSecret
{
	if ([self initWithKey:aKey 
				   secret:aSecret])
	{
		self.userID = aUserID;
	}
	return self;
}

+ (LWETUser *)userWithID:(NSString *)aUserID
{
	LWETUser *user = [[LWETUser alloc] autorelease];
	user.userID = aUserID;
	user.isAuthenticated = NO;
	return user;
}

#pragma mark -
#pragma mark Core Method

- (OAToken *)OAuthToken
{
	return [[[OAToken alloc] 
			 initWithKey:self.key 
			 secret:self.secret]autorelease];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc
{
	[userID release];
	[key release];
	[secret release];
	[super dealloc];
}

@end
