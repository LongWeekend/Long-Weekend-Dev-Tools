//
//  LWETXAuthViewProtocol.h
//  jFlash
//
//  Created by Rendy Pranata on 21/07/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWETwitterOAuth;

/**
 * LWE Twitter XAuth View Protocol (LWETXAuthViewProtocol) is a protocol that has to be conformed with any 
 * of the view controller that hooked with the Twitter Engine, and is designed to work with the XAuth
 * methodology. It has to have LWETwitterOAuth object (assigned is more preferable than retained), and
 * it has to have fail authentication method that is going to be called by whoever instantiate it, 
 * to report back if authentication does not go through. 
 *
 * This View Controller protocol is only intended for XAuth methodology, for OAuth methodology, refer to
 * LWETAuthentication View Protocol
 */
@protocol LWETXAuthViewProtocol

- (void)setAuthEngine:(LWETwitterOAuth *)authEngine;
- (void)didFailAuthentication:(NSError *)error;

@end
