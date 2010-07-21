//
//  LWETUserDB.h
//  TweetSimulationWithLWE
//
//  Created by Rendy Pranata on 18/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#define kUserProfileTable	@"userProfile"
#define kUserTokenTable		@"userToken"
#define kUserProfileID		@"profileID"
#define kTokenKey			@"tokenKey"
#define kTokenSecret		@"tokenSecret"

@interface LWETUserDB : NSObject 
{
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end
