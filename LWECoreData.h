//
//  LWECoreData.h
//  Rikai
//
//  Created by シャロット ロス on 6/13/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//! Abstracts common Core Data static method calls
@interface LWECoreData : NSObject
{  
}

//! Returns all entities of a given type from a given context (SELECT * FROM x)
+ (NSArray *) fetchAll:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

//! Returns entities of a given type from a given context with predicate (SELECT * FROM x WHERE y)
+ (NSArray *) fetch:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptors predicate:(id)stringOrPredicate, ...;

//! Returns entities of a given type from a given context with predicate & limit (SELECT * FROM x WHERE y LIMIT z)
+ (NSArray *) fetch:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptorsOrNil withLimit:(int)limitOrNil predicate:(id)stringOrPredicate, ...;

//! Returns the count of entities of a given type from a given context with predicate (SELECT * FROM x WHERE y)
+ (NSUInteger) count:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptors predicate:(id)stringOrPredicate, ...;

//! Returns a NSFetchRequest for entities of a given type from a given context with predicate & limit (SELECT * FROM x WHERE y LIMIT z)
+ (NSFetchRequest *) fetchRequest: (NSManagedObjectContext *) managedObjectContext entityName: (NSString *) entityName limitOrNil: (int) limitOrNil sortDescriptorsOrNil: (NSArray *) sortDescriptorsOrNil stringOrPredicate: (id) stringOrPredicate, ...;

//! Creates or overwrites the attributes of an entity from a plist, returns the saved entity.
+(id) addPlist:(NSString*)path toEntity:(NSString *)entityName identifiedByAttribute:(NSString *)attributeName inManagedContext:(NSManagedObjectContext *)managedObjectContext save:(BOOL)shouldSave;

//! Saves the current context
+ (BOOL) save:(NSManagedObjectContext *)managedObjectContext;

//! Deletes the provided entity from the provided context
+ (BOOL) delete:(id)entity fromContext:(NSManagedObjectContext *)context;

@end
