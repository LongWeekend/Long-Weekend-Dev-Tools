//
//  AnimationSound.h
//  phone
//
//  Created by paul on 28/12/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AnimationSound : NSObject

-(void)unloadFX:(NSString*)fxName;
-(void)preloadFX:(NSString*)fxName;
-(void)stopAllFX;

-(BOOL)fxIsPlaying:(NSString*)fxName;

-(BOOL)stopFX:(NSString*)fxName;

-(NSInteger)playFX:(NSString*)fxName;
-(NSInteger)playFX:(NSString*)fxName pitch:(Float32)pitch gain:(Float32)gain;
-(void) playFX:(NSString*)fxName pitch:(Float32)pitch gain:(Float32)gain withDelay:(NSTimeInterval)delay;

@property (retain) NSMutableDictionary *soundsPlaying;
@property (retain) NSMutableDictionary *delayedSounds;

@end
