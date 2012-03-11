//
//  LWETUser.m
//  TweetSimulationWithLWE
//
//  Created by Rendy Pranata on 16/07/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import "LWETUser.h"

#import "OAToken.h"

@implementation LWETUser

@synthesize key;
@synthesize secret;
@synthesize userID;
@synthesize userAccessToken;
@synthesize isAuthenticated;

#pragma mark - Constructors & Deconstructors

- (id)init
{
  self = [super init];
	if (self)
	{
		/*place for future customazation*/
	}
	return self; 
}

- (id)initFromManagedObject:(NSManagedObject *)managedObject keyforKey:(NSString *)aKeyKey keyForSecret:(NSString *)aSecretKey
{
  return [self initWithKey:[managedObject valueForKey:aKeyKey] secret:[managedObject valueForKey:aSecretKey]];
}

- (id)initWithKey:(NSString *)aKey secret:(NSString *)aSecret
{
  self = [self init];
	if (self)
	{
		self.key = aKey;
		self.secret = aSecret;
		self.userAccessToken = [self OAuthToken];
		self.isAuthenticated = YES;
	}
	return self; 
}

- (id)initWithUserID:(NSString *)aUserID key:(NSString *)aKey secret:(NSString *)aSecret
{
  self = [self initWithKey:aKey secret:aSecret];
	if (self)
	{
		self.userID = aUserID;
	}
	return self;
}

+ (LWETUser *)userWithID:(NSString *)aUserID
{
	LWETUser *user = [[[LWETUser alloc] init] autorelease];
	user.userID = aUserID;
	user.isAuthenticated = NO;
	return user;
}

- (void)dealloc
{
	[userID release];
	[key release];
	[secret release];
	[super dealloc];
}

#pragma mark - Core Method

- (OAToken *)OAuthToken
{
	return [[[OAToken alloc] initWithKey:self.key secret:self.secret] autorelease];
}

@end
