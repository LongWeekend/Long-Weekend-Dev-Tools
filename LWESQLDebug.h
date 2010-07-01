//
//  LWESQLDebug.h
//  jFlash
//
//  Created by Ross Sharrott on 2/20/10.
//  Copyright 2010 LONG WEEKEND LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMResultSet.h"

@interface LWESQLDebug : NSObject {

}

+ (void) profileSQLStatements: (NSArray*) statements;
+ (void) runSQL: (NSString*) sql;

@end
