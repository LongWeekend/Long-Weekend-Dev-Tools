//
//  LWECoreData.m
//
//  Created by シャロット ロス on 6/13/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "LWECoreData.h"
#import "LWEDebug.h"

// Used by user info dictionaries as a key in notifications about object changes
NSString * const LWECoreDataObjectId = @"LWECoreDataObjectId";

/*!
    @class       LWECoreData
    @discussion
    Implements common data actions as static methods to reduce the amount of Core Data-related code
    that needs to be in the actual source code files.
*/
@implementation LWECoreData

#pragma mark -
#pragma mark Persistent Store Methods

/**
 * Creates an autoreleased managed object context and associates a persistent store coordinator
 * \param coordinator the persistent store coordinator to use with the managed object context
 * \return A managed object context
 */

+ (NSManagedObjectContext*) managedObjectContextWithStoreCoordinator:(NSPersistentStoreCoordinator*)coordinator
{
  NSManagedObjectContext *managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
  [managedObjectContext setPersistentStoreCoordinator:coordinator];
  return managedObjectContext;
}

/**
 * \param storePath The full file path of the persistent store to be associated with the store coordinator
 * \param shouldCopy if YES, the method will attempt to copy the filename from the bundle if it is not found
 * \return An initialized, autoreleased NSPersistentStoreCoordinator object, associated with the provided store
 * This method assumes the store path is a SQLite database.
 */
+ (NSPersistentStoreCoordinator*) persistentStoreCoordinatorFromPath:(NSString*)storePath
{
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
  
  NSPersistentStoreCoordinator *psc = nil;
  NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
  psc = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] autorelease];

  NSError *error = nil;
  if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
  {
		/*
		 * Replace this implementation with code to handle the error appropriately.
		 * example: The schema for the persistent store is incompatible with current managed object model
		 */
		LWE_LOG(@"Unresolved error %@, %@", error, [error userInfo]);
    return nil;
  }
  return psc;
}

#pragma mark -
#pragma mark retrieval methods

/**
 * Gets all entities for a given entity & context ("SELECT * FROM foo" in SQL)
 * \param entityName Name of the Core Data entity to fetch
 * \param managedObjectContext Which ObjectContext to use
 */
+ (NSArray *) fetchAll:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
  return [LWECoreData fetch:entityName managedObjectContext:managedObjectContext withSortDescriptors:nil predicate:nil];
}

/**
 * Gets all entities for a given entity & context ("SELECT * FROM foo WHERE x ORDER BY y" in SQL)
 * \param entityName Name of the Core Data entity to fetch
 * \param managedObjectContext Which ObjectContext to use
 * \param sortDescriptorsOrNil Sort descriptor, or use nil if you don't want to sort
 * \param predicate the "where clause" of the query
 */
+ (NSArray *) fetch:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptorsOrNil predicate:(id)stringOrPredicate, ...
{
  return [LWECoreData fetch:entityName managedObjectContext:managedObjectContext withSortDescriptors:sortDescriptorsOrNil withLimit:0 predicate:stringOrPredicate];
}

/**
 * Gets all entities for a given entity & context ("SELECT * FROM foo WHERE x ORDER BY y LIMIT z" in SQL)
 * \param entityName Name of the Core Data entity to fetch
 * \param managedObjectContext Which ObjectContext to use
 * \param sortDescriptorsOrNil Sort descriptor, or use nil if you don't want to sort
 * \param limitOrNil Integer number to limit by.  0 for no limit clause
 * \param predicate the "where clause" of the query
 */
+ (NSArray *) fetch:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptorsOrNil withLimit:(int)limitOrNil predicate:(id)stringOrPredicate, ...
{
  NSFetchRequest *fetchRequest;
  fetchRequest = [self fetchRequest: managedObjectContext entityName: entityName limitOrNil: limitOrNil sortDescriptorsOrNil: sortDescriptorsOrNil stringOrPredicate: stringOrPredicate];
  
  NSError *error;
  NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  return results;
}

/**
 * Returns a count of all entities for a given entity & context ("SELECT * FROM foo WHERE x ORDER BY y LIMIT z" in SQL)
 * \param entityName Name of the Core Data entity to fetch
 * \param managedObjectContext Which ObjectContext to use
 * \param sortDescriptorsOrNil Sort descriptor, or use nil if you don't want to sort
 * \param limitOrNil Integer number to limit by.  0 for no limit clause
 * \param predicate the "where clause" of the query
 */
+ (NSUInteger) count:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptors predicate:(id)stringOrPredicate, ...
{
  NSFetchRequest *fetchRequest = [self fetchRequest: managedObjectContext entityName: entityName limitOrNil:0 sortDescriptorsOrNil: sortDescriptors stringOrPredicate: stringOrPredicate];
  
  NSError *error = nil;
  NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
  
  if (!error)
  {
    return count;
  }
  else
  {
    return 0;
  }
}

/**
 * Returns an autoreleased NSFetchRequest with the given parameters for use in fetch or count operations
 * \param entityName Name of the Core Data entity
 * \param managedObjectContext Which ObjectContext to use
 * \param sortDescriptorsOrNil Sort descriptor, or use nil if you don't want to sort
 * \param limitOrNil Integer number to limit by.  0 for no limit clause
 * \param predicate the "where clause" of the query
 */
+ (NSFetchRequest *) fetchRequest: (NSManagedObjectContext *) managedObjectContext entityName: (NSString *) entityName limitOrNil: (int) limitOrNil sortDescriptorsOrNil: (NSArray *) sortDescriptorsOrNil stringOrPredicate: (id) stringOrPredicate, ...  
{
  NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  
  if(limitOrNil > 0)
  {
    [fetchRequest setFetchLimit:limitOrNil];
  }
  
  if (sortDescriptorsOrNil != nil)
  {
    [fetchRequest setSortDescriptors:sortDescriptorsOrNil];
  }
  
  // add the predicate (Apple-speak for where)
  if (stringOrPredicate)
  {
    NSPredicate *predicate;
    if ([stringOrPredicate isKindOfClass:[NSString class]])
    {
      va_list variadicArguments;
      va_start(variadicArguments, stringOrPredicate);
      predicate = [NSPredicate predicateWithFormat:stringOrPredicate
                                         arguments:variadicArguments];
      va_end(variadicArguments);
    }
    else
    {
      NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]], @"Second parameter passed to %s is of unexpected class %@", sel_getName(_cmd), [stringOrPredicate class]);
      predicate = (NSPredicate *)stringOrPredicate;
    }
    [fetchRequest setPredicate:predicate];
  }
  return fetchRequest;
}


#pragma mark -
#pragma mark addLables

/**
 * Adds a plist to a entity, assumes that the plist has same attribute key names. Will update or create an entity
 * based on the identifiedByAttribute.
 * \param path Full path to plist we are working with. Use something like: NSString *path = [[NSBundle mainBundle] pathForResource:@"PLISTNAME" ofType:@"plist"];
 * \param entityName The name of the entity to add data too.
 * \param identifiedByAttribute The name of the identifying attribute. This attribute must be a string.
 * \param managedObjectContext Which ObjectContext to use
 */
+(id) addPlist:(NSString*)path toEntity:(NSString *)entityName identifiedByAttribute:(NSString *)attributeName inManagedContext:(NSManagedObjectContext *)managedObjectContext save:(BOOL)shouldSave
{
  // Build the dictionary from the plist
  NSDictionary *attributeDict = [[NSDictionary alloc] initWithContentsOfFile:path];
  
//  id debugArray = [LWECoreData fetchAll:entityName managedObjectContext:managedObjectContext];
//  for (id item in debugArray) 
//  {
//    LWE_LOG(@"%@", [item contactShortName]);
//  }

  // find an existing instance of this entity
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@", attributeName, [attributeDict valueForKey:attributeName]];
  NSArray* entityArray = [LWECoreData fetch:entityName managedObjectContext:managedObjectContext withSortDescriptors:nil predicate:predicate];
  id entity; // the entity we will populate

  // we require the attribute identifier to be unique so error if we get more than one entity
#if !defined(LWE_RELEASE_APP_STORE)
  NSAssert(([entityArray count] < 2), @"More than one entity of type %@ found for attribute %@. Must be unique.", entityName, attributeName);
#endif
  
  // set entity to the existing one if it exists
  if ([entityArray count] == 1) 
  {
    entity = [entityArray objectAtIndex:0];
  }
  else // make a new one
  {
    entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
  }
  
  // enumerate the attribute dict.  The key will be the attribute in the entity
  NSEnumerator *enumerator = [attributeDict keyEnumerator];
  id key;
  
  // add all the dict attribute values to the entity
  while ((key = [enumerator nextObject])) 
  {
    [entity setValue:[attributeDict valueForKey:key] forKey:key];
  }
  
  if (shouldSave == YES) 
  {
    [LWECoreData save:managedObjectContext];
  }
  
  [attributeDict release];
    
  return entity;
}

#pragma mark -
#pragma mark persiste methods

/**
 * Saves the current objectContext
 * \param managedObjectContext The context to save
 * \return YES if successful
 */
+ (BOOL) save:(NSManagedObjectContext *)managedObjectContext
{
  BOOL returnVal = YES;
  NSError *error;
  if (![managedObjectContext save:&error]) 
  {
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if (detailedErrors != nil && [detailedErrors count] > 0)
    {
      for(NSError* detailedError in detailedErrors)
      {
        LWE_LOG(@"  DetailedError: %@", [detailedError userInfo]);
      }
    }
    // Now fail
    NSAssert2(0, @"This is embarrassing. %s We failed to save because: %@", sel_getName(_cmd), [error localizedDescription]);
    returnVal = NO;
  }
  return returnVal;
}

/**
 * Deletes an entity from the current objectContext
 * \param entity Object to delete
 * \param context managedObjectContext to delete from
 * \return returns YES on success, NO on delete failure (swallows exception)
 */
+ (BOOL) delete:(id)entity fromContext:(NSManagedObjectContext *)context
{
	[context deleteObject:entity];
  @try
  {
    [LWECoreData save:context];
  }
  @catch (NSException * e)
  {
    return NO;
  }
  return YES;
}

@end
