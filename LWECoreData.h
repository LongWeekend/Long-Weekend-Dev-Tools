// LWECoreData.h
//
// Copyright (c) 2010, 2011 Long Weekend LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const LWECoreDataObjectId;

//! Abstracts common Core Data static method calls
@interface LWECoreData : NSObject

//! Creates an autoreleased MOC associated with a store coordinator
+ (NSManagedObjectContext*) managedObjectContextWithStoreCoordinator:(NSPersistentStoreCoordinator*)coordinator;

//! Creates an autoreleased persistent store coordinator using the pathname.
+ (NSPersistentStoreCoordinator*) persistentStoreCoordinatorFromPath:(NSString*)storePath;

//! Creates an autoreleased persistent store coordinator using the pathname for a versioned model.
+ (NSPersistentStoreCoordinator*) persistentStoreCoordinatorFromPathForVersionedModel:(NSString*)storePath modelNameOrNil:(NSString*)modelName;

//! Returns 1 object - useful for when you are pulling things out by an ID or something where you are sure there will be one or none.  Returns nil if not found.
+ (NSManagedObject*) fetchOne:(NSString*)entityName managedObjectContext:(NSManagedObjectContext*)managedObjectContext predicate:(id)stringOrPredicate, ...;

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
+ (id) addPlist:(NSString*)path toEntity:(NSString *)entityName identifiedByAttribute:(NSString *)attributeName inManagedContext:(NSManagedObjectContext *)managedObjectContext save:(BOOL)shouldSave;

//! Saves the current context
+ (BOOL) save:(NSManagedObjectContext *)managedObjectContext;

//! Deletes the provided entity from the object's context
+ (BOOL) delete:(NSManagedObject*)entity

//! Deletes the provided entity from the provided context
+ (BOOL) delete:(NSManagedObject*)entity fromContext:(NSManagedObjectContext *)context;

@end