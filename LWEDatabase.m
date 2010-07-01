//
//  LWEDatabase.m
//  jFlash
//
//  Created by Mark Makdad on 3/7/10.
//  Copyright 2010 LONG WEEKEND INC.. All rights reserved.
//

#import "LWEDatabase.h"
#import "SynthesizeSingleton.h"

@implementation LWEDatabase

@synthesize dao,databaseOpenFinished;

SYNTHESIZE_SINGLETON_FOR_CLASS(LWEDatabase);

/**
 * Returns YES if file was able to be copied from the bundle - overwrites file!
 * Intended to be run in the background
 * TODO: as Ross pointed out, this should be separated out into a category
 * or a subclass due to its linkage to NSUserDefaults
 */
- (BOOL) copyDatabaseFromBundle:(NSString*)filename
{
  BOOL returnVal;
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  if (![LWEFile copyFromMainBundleToDocuments:filename shouldOverwrite:YES])
  {
    LWE_LOG(@"Unable to copy database from bundle: %@",filename);
    returnVal = NO;
  }
  else
  {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:YES forKey:@"db_did_finish_copying"];
    returnVal = YES;
    
    NSNotification *aNotification = [NSNotification notificationWithName:@"DatabaseCopyFinished" object:self];
    [self performSelectorOnMainThread:@selector(_postNotification:) withObject:aNotification waitUntilDone:NO];
  }
  [pool release];
  return returnVal;
}


/** 
 * Returns the name of the active USER database
 * TODO: as Ross pointed out, this is JFlash-specific and should
 * not be in LWEDatabase, but a subclass or a category
 */
+ (NSString*) userDatabaseFilename
{
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  NSString *version = [settings objectForKey:APP_DATA_VERSION];
  if ([version isEqualToString:JFLASH_VERSION_1_0])
  {
    // Return the JFlash 1.0 dictionary name
    return JFLASH_10_USER_DATABASE;
  }
  else
  {
    // Return the latest version
    return JFLASH_CURRENT_USER_DATABASE;
  }
}


/** 
 * Returns true if the database file specified by 'pathToDatabase' was successfully opened
 * Also posts a 'databaseIsOpen' notification on success
 */
- (BOOL) openDatabase:(NSString*)pathToDatabase
{
  BOOL success = NO;
  BOOL fileExists = [LWEFile fileExists:pathToDatabase];
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  if (fileExists && [settings boolForKey:@"db_did_finish_copying"])
  {
    self.databaseOpenFinished = NO;
    self.dao = [FMDatabase databaseWithPath:pathToDatabase];
    self.dao.logsErrors = YES;
#if defined(APP_STORE_FINAL)
    self.dao.traceExecution = NO;
#else
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
    }

    // So other threads can query whether we are done or not
    self.databaseOpenFinished = YES;
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
    self.databaseOpenFinished = NO;
  }
  return YES;
}


/**
 * Gets open database's version - proprietary to LWE databases (uses version table)
 * TODO: as Ross mentioned, move this to a subclass or a category
 */
- (NSString*) databaseVersion
{
  // If no version, return version 1.0
  NSString *version = [NSString stringWithString:JFLASH_VERSION_1_0];
  if ([self _databaseIsOpen])
  {
    NSString* sql = [[NSString alloc] initWithFormat:@"SELECT * FROM main.version LIMIT 1"];
    FMResultSet *rs = [self executeQuery:sql];
    while ([rs next])
    {
      // Get rid of the old one and replace w/ the current version
      version = [rs stringForColumn:@"version"];
    }
    [rs close];
  }
  else
  {
    // When called with no DB, throw exception
    [NSException raise:@"Invalid database object in 'dao'" format:@"dao object is: %@",[self dao]];
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
    LWE_LOG(@"%@",sql);
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
    if ([rs next]) returnVal = YES;
    [rs close];
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
