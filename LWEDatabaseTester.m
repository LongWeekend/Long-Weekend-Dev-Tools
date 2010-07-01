//
//  LWEDatabaseTester.m
//  jFlash
//
//  Created by Mark Makdad on 6/4/10.
//  Copyright 2010 Long Weekend Inc. All rights reserved.
//

#import "LWEDatabaseTester.h"

@implementation LWEDatabaseTester

- (NSMutableArray*) createRandomMergeIds:(NSInteger)numCards
{
  NSMutableArray *testIds = [[NSMutableArray alloc] initWithCapacity:numCards];
  int randomCardId = 0;
  for (int i = 0; i < numCards; i++)
  {
    // Assume cards are random IDs between 1-147000
    randomCardId = [self getRandomIntegerBetweenMin:1 andMax:147000];

    // Output every fifth one to the console so we can double check the randomness
//    if ((i % 5) == 0) LWE_LOG(@"Random id: %d",randomCardId);

    NSNumber *tmpNum = [[NSNumber alloc] initWithInt:randomCardId];
    [testIds addObject:tmpNum];
    [tmpNum release];
  }
  return testIds;
}


- (NSInteger) getRandomIntegerBetweenMin:(NSInteger)min andMax:(NSInteger)max
{
  return ((arc4random() % (max - min)) + min);
}


- (NSMutableArray*) createRandomDictionary:(NSInteger)numStrings
{
  NSArray *alphabet = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
  NSMutableArray *testStrings = [[NSMutableArray alloc] initWithCapacity:numStrings];
  NSString* tmpStr;
  int tmpStrLen = 0;
  int j = 0;
  int alphabetNum = 0;
  for (int i = 0; i < numStrings; i++)
  {
    // Generate random strings with somewhere between 3-10 letters
    tmpStrLen = [self getRandomIntegerBetweenMin:3 andMax:10];
    tmpStr = [[NSString alloc] init];
    for (j = 0; j < tmpStrLen; j++)
    {
      alphabetNum = [self getRandomIntegerBetweenMin:0 andMax:25];
      tmpStr = [tmpStr stringByAppendingString:[alphabet objectAtIndex:alphabetNum]];
    }
    
    // Output every fifth one to the console so we can double check the randomness
//    if ((i % 10) == 0) LWE_LOG(@"Random word of length %d : %@",tmpStrLen,tmpStr);
    
    [testStrings addObject:tmpStr];
    [tmpStr release];
  }
  return testStrings;
}


- (NSMutableArray*) createRandomContent:(NSInteger)numStrings fromDictionary:(NSMutableArray*)dict
{
  NSMutableArray *testStrs = [[NSMutableArray alloc] initWithCapacity:numStrings];
  NSString* tmpStr;
  int dictSize = [dict count];
  int phraseWordCount = 0;
  int j = 0;
  int randomWordIndex = 0;
  for (int i = 0; i < numStrings; i++)
  {
    // Generate random strings with somewhere between 3-10 phrases
    phraseWordCount = [self getRandomIntegerBetweenMin:3 andMax:10];
    tmpStr = [[NSString alloc] init];
    for (j = 0; j < phraseWordCount; j++)
    {
      randomWordIndex = [self getRandomIntegerBetweenMin:0 andMax:dictSize];
      tmpStr = [tmpStr stringByAppendingFormat:@"%@ ",[dict objectAtIndex:randomWordIndex]];
    }
    
    // Now test
//    if ((i % 10) == 0) LWE_LOG(@"Random phase of length %d : %@",phraseWordCount,tmpStr);
    
    [testStrs addObject:tmpStr];
    [tmpStr release];
  }
  return testStrs;
}

- (void) runTest:(int)numToTest
{
  int dictSize = 1000;
  int i = 0;
  NSString *sql;
  
  LWE_LOG(@"PREP - START");
  NSMutableArray* mergeIds = [self createRandomMergeIds:numToTest];
  NSMutableArray* dictionary = [self createRandomDictionary:dictSize];
  NSMutableArray* phrases = [self createRandomContent:numToTest fromDictionary:dictionary];

  int oldId, newId;
  NSMutableArray* mergeSQL = [[NSMutableArray alloc] init];
  while (i < [mergeIds count])
  {
    oldId = [[mergeIds objectAtIndex:i+1] intValue];
    newId = [[mergeIds objectAtIndex:i] intValue];
    // Card link table
    sql = [[NSString alloc] initWithFormat:@"UPDATE card_tag_link SET card_id = '%d' WHERE card_id = '%d'",newId,oldId];
    [mergeSQL addObject:sql];
    [sql release];
    
    // TODO - make it check for dupes User history table
    sql = [[NSString alloc] initWithFormat:@"UPDATE user_history SET card_id = '%d' WHERE card_id = '%d'",newId,oldId];
    [mergeSQL addObject:sql];
    [sql release];
    
    // Update FTS card content
    sql = [[NSString alloc] initWithFormat:@"UPDATE cards_search_content SET content = '%@' WHERE card_id = '%d'",[phrases objectAtIndex:i],oldId];
    [mergeSQL addObject:sql];
    [sql release];    

    // Update FTS card Ids
    sql = [[NSString alloc] initWithFormat:@"UPDATE cards_search_content SET card_id = '%d' WHERE card_id = '%d'",newId,oldId];
    [mergeSQL addObject:sql];
    [sql release];
    
    // Update card_html
    sql = [[NSString alloc] initWithFormat:@"UPDATE cards_html SET card_id = '%d' WHERE card_id = '%d'",newId,oldId];
    [mergeSQL addObject:sql];
    [sql release];
    
    i = i + 2;
  }
  

  NSError *error;
  NSFileManager *fm = [NSFileManager defaultManager];
  [fm removeItemAtPath:[LWEFile createDocumentPathWithFilename:@"jFlash.db"] error:&error];    
  
  LWE_LOG(@"Starting DB copy");
  LWEDatabase *db = [LWEDatabase sharedLWEDatabase];
  NSString *pathToDatabase = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"jFlash.db"];
  if (![db openDatabase:pathToDatabase]) LWE_LOG(@"Cannot open DB");
  [db.dao beginTransaction];
  LWE_LOG(@"Starting DB work");
  for (int z = 0; z < [mergeSQL count]; z++)
  {
    LWE_LOG(@"%@",[mergeSQL objectAtIndex:z]);
    [db.dao executeUpdate:[mergeSQL objectAtIndex:z]];
  }
  [db.dao commit];
  LWE_LOG(@"Finishing DB work");

  
}

@end