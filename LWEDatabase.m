// LWEDatabase.m
//
// Copyright (c) 2011 Long Weekend LLC
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

#import "LWEDatabase.h"
#import "LWEDebug.h"
#import "SynthesizeSingleton.h"

NSString * const LWEDatabaseTempAttachName          = @"LWEDATABASETMP";

@interface LWEDatabase()
- (BOOL) _databaseIsOpen;
@end

@implementation LWEDatabase

@synthesize dao = _dao;

SYNTHESIZE_SINGLETON_FOR_CLASS(LWEDatabase);

/**
 * Returns a string suitable for inserting into a sqlite db
 */
+ (NSString*) sqliteEscapedString:(NSString*)string
{
  return [string stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:NSLiteralSearch range:NSMakeRange(0, string.length)]; 
}

- (void) asynchCopyDatabaseFromBundle:(NSString *)filename completionBlock:(dispatch_block_t)completionBlock;
{
  dispatch_queue_t queue = dispatch_queue_create("com.longweekendmobile.databasecopy",NULL);
  dispatch_queue_t main = dispatch_get_main_queue();
  dispatch_async(queue,^
  {
    [LWEFile copyFromMainBundleToDocuments:filename shouldOverwrite:YES];
    dispatch_async(main,completionBlock);
  });
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
    _dao = [[FMDatabase databaseWithPath:pathToDatabase] retain];
    
    // only allow error tracing in a non-release versions.  APP Store version should never have these on
    #if defined(LWE_RELEASE_AD_HOC) || defined(LWE_RELEASE_APP_STORE)
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
    [self.dao close];
    [_dao release];
    _dao = nil;
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
  LWE_ASSERT_EXC([self _databaseIsOpen], @"Database could not be opened");
  BOOL returnVal = NO;
  
  NSString *sql = [[NSString alloc] initWithFormat:@"ATTACH DATABASE \"%@\" AS %@;",pathToDatabase,name];
  LWE_LOG(@"Debug: Trying to attach %@ as %@", pathToDatabase, name);
  [self executeUpdate:sql];
  if (![[self dao] hadError])
  {
    returnVal = YES;
  }
  [sql release];
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
  return [self.dao executeQuery:sql];
}

/**
 * Passthru for dao - executeUpdate
 */
- (BOOL) executeUpdate:(NSString*)sql
{
  return [self.dao executeUpdate:sql];
}

/**
 * Checks for the existence of a table name in the sqlite_master table
 * If database is not open, throws an exception
 */
- (BOOL) tableExists:(NSString *)tableName
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
  if ([self.dao respondsToSelector:@selector(goodConnection)] && [self.dao goodConnection])
  {
    return YES;
  }
  else
  {
    return NO;
  }
}

@end

