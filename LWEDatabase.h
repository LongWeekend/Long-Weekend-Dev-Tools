// LWEDatabase.h
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

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "LWEFile.h"
#import "Constants.h"

extern NSString * const LWEDatabaseTempAttachName;

//! LWE Database singleton, maintains active connections
@interface LWEDatabase : NSObject

+ (LWEDatabase *)sharedLWEDatabase;
+ (NSString*) sqliteEscapedString:(NSString*)string;
- (void) asynchCopyDatabaseFromBundle:(NSString *)filename completionBlock:(dispatch_block_t)completionBlock;
- (BOOL) openDatabase:(NSString*) pathToDatabase;
- (BOOL) closeDatabase;
- (NSString*) databaseVersion;
- (NSString*) databaseVersionForDatabase:(NSString*)dbName;
- (BOOL) attachDatabase:(NSString*) pathToDatabase withName:(NSString*) name;
- (BOOL) detachDatabase:(NSString*) name;
- (BOOL) tableExists:(NSString*) tableName;

// For passthru to FMDatabase object
- (FMResultSet*) executeQuery:(NSString*)sql;
- (BOOL) executeUpdate:(NSString*)sql;

@property (nonatomic, readonly, retain) FMDatabase *dao;

@end
