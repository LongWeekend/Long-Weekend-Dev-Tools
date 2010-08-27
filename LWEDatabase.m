//
//  LWEDatabase.m
//  jFlash
//
//  Created by Mark Makdad on 3/7/10.
//  Copyright 2010 LONG WEEKEND INC.. All rights reserved.
//

#import "LWEDatabase.h"
#import "LWEDebug.h"
#import "SynthesizeSingleton.h"

@implementation LWEDatabase

@synthesize dao;

SYNTHESIZE_SINGLETON_FOR_CLASS(LWEDatabase);


/**
 * Returns true if file was able to be copied from the bundle - overwrites
 * Intended to be run in the background
 */
- (BOOL) copyDatabaseFromBundle:(NSString*)filename
{
  BOOL returnVal = NO;
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  if ([LWEFile copyFromMainBundleToDocuments:filename shouldOverwrite:YES])
  {
    // Let everyone know that we are DONE
    NSNotification *aNotification = [NSNotification notificationWithName:LWEDatabaseCopyDatabaseDidSucceed object:self];
    [self performSelectorOnMainThread:@selector(_postNotification:) withObject:aNotification waitUntilDone:NO];
    returnVal = YES;
  }
  else
  {
    LWE_LOG(@"Unable to copy database from bundle: %@",filename);
  }
  [pool release];
  return returnVal;
}


/** 
 * Returns true if the database file specified by 'pathToDatabase' was successfully opened
 * Also posts a 'databaseIsOpen' notification on success
 */
- (BOOL) openDatabase:(NSString*)pathToDatabase
{
  BOOL success = NO;
  BOOL fileExists = [LWEFile fileExists:pathToDatabase];
  if (fileExists)
  {
    self.dao = [FMDatabase databaseWithPath:pathToDatabase];
    
    // only allow error tracing in a non-release versions.  APP Store version should never have these on
    #if defined(APP_STORE_FINAL)
      self.dao.logsErrors = NO;
      self.dao.traceExecution = NO;
    #else
      self.dao.logsErrors = YES;
      self.dao.traceExecution = YES;
    #endif
    
    if ([self.dao open])
    {
      success = YES;
      [[NSNotificationCenter defaultCenter] postNotificationName:@"databaseIsOpen" object:self];
    }
    else
    {
      LWE_LOG(@"FAIL - Could not open DB - error code: %d",[[self dao] lastErrorCode]);
      abort();
    }
  }
  return success;
}


/**
 * Closes an active database connection
 * At the moment it returns YES no matter what
 */
- (BOOL) closeDatabase
{
  // First check that the database is indeed open
  if ([self _databaseIsOpen])
  {
    [[self dao] close];
  }
  return YES;
}


/**
 * Gets open database's version - proprietary to LWE databases (uses version table)
 * \return NSString of the current version, or nil if the database is not open
 */
- (NSString*) databaseVersion
{
  return [self databaseVersionForDatabase:@"main"];
}


/**
 * Gets version of a plugin in the database - proprietary to LWE databases (uses version table)
 * \param dbName name of database (used when attaching db to main)
 * \return NSString of the current version, or nil if the database is not open
 */
- (NSString*) databaseVersionForDatabase:(NSString*)dbName
{
  NSString *version = nil;
  if ([self _databaseIsOpen])
  {
    NSString* sql = [[NSString alloc] initWithFormat:@"SELECT * FROM %@.version LIMIT 1",dbName];
    FMResultSet *rs = [self executeQuery:sql];
    [sql release];
    while ([rs next])
    {
      version = [rs stringForColumn:@"version"];
    }
    [rs close];
  }
  return version;  
}


/**
 * Attaches another database onto the existing open connection
 */
- (BOOL) attachDatabase:(NSString*) pathToDatabase withName:(NSString*) name
{
  BOOL returnVal = NO;
  if ([self _databaseIsOpen])
  {
    NSString *sql = [[NSString alloc] initWithFormat:@"ATTACH DATABASE \"%@\" AS %@;",pathToDatabase,name];
    [self executeUpdate:sql];
    if (![[self dao] hadError])
    {
      returnVal = YES;
    }
    [sql release];
  }
  else
  {
    // When called with no DB, throw exception
    [NSException raise:@"Invalid database object in 'dao'" format:@"dao object is: %@",[self dao]];
  }
  return returnVal;
}


/**
 * detaches a database on the open connection with "name"
 */
- (BOOL) detachDatabase:(NSString*) name
{
  BOOL returnVal = NO;
  if ([self _databaseIsOpen])
  {
    NSString *sql = [[NSString alloc] initWithFormat:@"DETACH DATABASE \"%@\";",name];
    [self executeUpdate:sql];
    if (![[self dao] hadError])
    {
      returnVal = YES;
    }
    [sql release];
  }
  else
  {
    // When called with no DB, throw exception
    [NSException raise:@"Invalid database object in 'dao'" format:@"dao object is: %@",[self dao]];
  }
  return returnVal;
}


/**
 * Passthru for dao - executeQuery
 */
- (FMResultSet*) executeQuery:(NSString*)sql
{
  return [[self dao] executeQuery:sql];
}


/**
 * Passthru for dao - executeUpdate
 */
- (BOOL) executeUpdate:(NSString*)sql
{
  return [[self dao] executeUpdate:sql];
}


/**
 * Checks for the existence of a table name in the sqlite_master table
 * If database is not open, throws an exception
 */
- (BOOL) tableExists:(NSString *) tableName
{
  BOOL returnVal = NO;
  if ([self _databaseIsOpen])
  {
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'", tableName];
    FMResultSet *rs = [self executeQuery:sql];
    [sql release];
    if ([rs next])
    {
      returnVal = YES;
    }
    [rs close];
  }
  else
  {
    // When called with no DB, throw exception
    [NSException raise:@"Invalid database object in 'dao'" format:@"dao object is: %@",[self dao]];
  }
  return returnVal;
}


/**
 * Helper method to determine if database is open
 * This method is private and other method calls in this class rely on it
 */
- (BOOL) _databaseIsOpen
{
  if ([[self dao] isKindOfClass:[FMDatabase class]] && [[self dao] goodConnection])
    return YES;
  else
    return NO;
}


//! Helper method for threading - posts a notification
- (void) _postNotification:(NSNotification *)aNotification
{
  [[NSNotificationCenter defaultCenter] postNotification:aNotification];
}

@end

NSString * const LWEDatabaseCopyDatabaseDidSucceed  = @"LWEDatabaseCopyDatabaseDidSucceed";
NSString * const LWEDatabaseTempAttachName          = @"LWEDATABASETMP";