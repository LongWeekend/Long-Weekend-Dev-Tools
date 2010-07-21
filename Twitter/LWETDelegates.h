//
//  LWETAuthenticationProtocol.h
//  TrialConsumerOAuthforIPhone
//
//  Created by Rendy Pranata on 15/07/10.
//  Copyright 2010 CRUX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAToken;
// RENDY: doc
@protocol LWETAuthenticationViewDelegate <NSObject>
@required
- (void)didFinishAuthorizationWithPin:(NSString *)pin;
- (void)didFailedAuthorization;

@end

// RENDY: doc
@protocol LWETAuthProccessDelegate
@optional
- (void)didFinishAuthProcessWithAccessToken:(OAToken *)userToken;
- (void)didFailAuthProcessWithError:(NSError *)error;
- (void)didFinishXAuthProcessWithAccessToken:(OAToken *)userToken;
- (void)didFailXAuthProcessWithError:(NSError *)error;
@required
- (UIViewController *)parentForUserAuthenticationView;

@end