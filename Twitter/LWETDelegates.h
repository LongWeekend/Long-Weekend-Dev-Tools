//
//  LWETAuthenticationProtocol.h
//  TrialConsumerOAuthforIPhone
//
//  Created by Rendy Pranata on 15/07/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAToken;

/**
 * This LWE Twitter Authentication View Delegate ia a delegate
 * used with the OAuth proccess, as the delegate of the Web-Twitter-Server View Controller
 * and who the view controller reports to after it gets the PIN for user OOB Authentication.
 * (It should be conformed by the LWETwitterOAuth class. 
 */
@protocol LWETAuthenticationViewDelegate <NSObject>
@required
- (void)didFinishAuthorizationWithPin:(NSString *)pin;
- (void)didFailedAuthorization;

@end

/**
 * This LWE Twitter Auth Proccess Delegate protocol, which has to be conformed 
 * by the LWETwitterOAuth class, and used as a callback after each requests process 
 * for OAuth authentication method
 * has finished
 */
@protocol LWETAuthProccessDelegate <NSObject>
@optional
- (void)didFinishAuthProcessWithAccessToken:(OAToken *)userToken;
- (void)didFailAuthProcessWithError:(NSError *)error;
- (void)didFinishXAuthProcessWithAccessToken:(OAToken *)userToken;
- (void)didFailXAuthProcessWithError:(NSError *)error;
@required
- (UIViewController *)parentForUserAuthenticationView;

@end