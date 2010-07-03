//
//  LWECoreData.m
//  Rikai
//
//  Created by シャロット ロス on 6/13/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "LWECoreData.h"

/*!
    @class       LWECoreData
    @discussion
    Implements common data actions as static methods to reduce the amount of Core Data-related code
    that needs to be in the actual source code files.
*/
@implementation LWECoreData

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
//TODO: make this reuse the fetch below.  I don't know how to pass the variadic arguments
+ (NSArray *) fetch:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptorsOrNil predicate:(id)stringOrPredicate, ...
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  
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
  
  NSError *error;
  NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  [fetchRequest release]; 
  
  return results;
}

//! Same as the other fetch but takes a limit parameter
+ (NSArray *) fetch:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptorsOrNil withLimit:(int)limitOrNil predicate:(id)stringOrPredicate, ...
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
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
  
  NSError *error;
  NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  [fetchRequest release]; 
  
  return results;
}

/**
 * Saves the current objectContext
 * \param managedObjectContext The context to save
 */
+ (void) save:(NSManagedObjectContext *)managedObjectContext
{
  //persist this
  NSError *error;
  if (![managedObjectContext save:&error]) 
  {
    NSLog(@"This is embarrassing. We failed to save because: %@", [error localizedDescription]);
  }  
}

@end
