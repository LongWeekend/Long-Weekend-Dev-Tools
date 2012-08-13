//
//  LWEKeychainWrapper.h
//  Journal
//
//  Created by Rendy Pranata on 18/07/12.
//  Copyright (c) 2012 Moneytree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface MTKeychainWrapper : NSObject

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)resetKeychainItem;

- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup;

@end
