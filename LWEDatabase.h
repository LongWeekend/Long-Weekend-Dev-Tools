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
#import "Constants.h"

//! LWE Database singleton, maintains active connections
@interface LWEDatabase : NSObject
{
  FMDatabase *dao;
}

+ (LWEDatabase *)sharedLWEDatabase;
- (BOOL) copyDatabaseFromBundle:(NSString*)filename;
- (BOOL) openDatabase:(NSString*) pathToDatabase;
- (BOOL) closeDatabase;
- (NSString*) databaseVersion;
- (BOOL) attachDatabase:(NSString*) pathToDatabase withName:(NSString*) name;
- (BOOL) detachDatabase:(NSString*) name;
- (BOOL) tableExists:(NSString*) tableName;

// For passthru to FMDatabase object
- (FMResultSet*) executeQuery:(NSString*)sql;
- (BOOL) executeUpdate:(NSString*)sql;

// Semiprivate method
- (BOOL) _databaseIsOpen;
- (void) _postNotification:(NSNotification *)aNotification;

@property (nonatomic, retain) FMDatabase *dao;

@end

extern NSString * const LWEDatabaseCopyDatabaseDidSucceed;
