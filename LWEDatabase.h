//
//  LWEDatabase.h
//  jFlash
//
//  Created by Mark Makdad on 3/7/10.
//  Copyright 2010 LONG WEEKEND INC.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "LWEFile.h"

/** LWE Database singleton, maintains active connections */
@interface LWEDatabase : NSObject
{
  BOOL databaseOpenFinished;
  FMDatabase *dao;
}

// TODO: these methods should be subclassed as they are jFlash specific
- (BOOL) copyDatabaseFromBundle:(NSString*)filename;
- (NSString*) databaseVersion;
+ (NSString*) userDatabaseFilename;

+ (LWEDatabase *)sharedLWEDatabase;
- (BOOL) openDatabase:(NSString*) pathToDatabase;
- (BOOL) closeDatabase;
- (BOOL) attachDatabase:(NSString*) pathToDatabase withName:(NSString*) name;
- (BOOL) detachDatabase:(NSString*) name;
- (BOOL) tableExists:(NSString*) tableName;

// For passthru to FMDatabase object
- (FMResultSet*) executeQuery:(NSString*)sql;
- (BOOL) executeUpdate:(NSString*)sql;

// Semiprivate method
- (BOOL) _databaseIsOpen;
- (void) _postNotification:(NSNotification *)aNotification;

@property BOOL databaseOpenFinished;
@property (nonatomic, retain) FMDatabase *dao;

@end
