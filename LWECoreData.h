//
//  LWECoreData.h
//  Rikai
//
//  Created by シャロット ロス on 6/13/10.
//  Copyright 2010 LONG WEEKEND INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LWECoreData : NSObject {
  
}

+ (NSArray *) fetchAll:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSArray *) fetch:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)managedObjectContext withSortDescriptors:(NSArray *)sortDescriptors predicate:(id)stringOrPredicate, ...;
+ (void) save:(NSManagedObjectContext *)managedObjectContext;

@end
