//
//  LWECoreData.m
//  Rikai
//
//  Created by シャロット ロス on 6/13/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import "LWECoreData.h"

@implementation LWECoreData
  
+ (NSArray *) fetchAll:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
  return [LWECoreData fetch:entityName managedObjectContext:managedObjectContext withSortDescriptors:nil predicate:nil];
}

+ (NSArray *) fetch:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptorsOrNil predicate:(id)stringOrPredicate, ...
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  
  if(sortDescriptorsOrNil != nil)
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
      NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]], @"Second parameter passed to %s is of unexpected class %@", sel_getName(_cmd), [stringOrPredicate className]);
      predicate = (NSPredicate *)stringOrPredicate;
    }
    [fetchRequest setPredicate:predicate];
  }

  NSError *error;
  NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  

  [fetchRequest release]; 
  
  return results;
}

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
