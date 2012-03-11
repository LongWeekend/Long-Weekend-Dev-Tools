//
//  AnimationSound.m
//  phone
//
//  Created by paul on 28/12/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import "AnimationSound.h"
#import "SimpleAudioEngine.h"

@implementation AnimationSound
@synthesize soundsPlaying, delayedSounds, loadedSounds;

-(id) init
{
  if ((self = [super init])) 
  {
    self.loadedSounds = [NSMutableArray array];
    self.soundsPlaying = [NSMutableDictionary dictionary];
    self.delayedSounds = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void) unloadAllFX
{
  // We don't want to mutate our array as we're iterating it)
  NSArray *tmpArray = [self.loadedSounds copy];
  for (NSString *fxName in tmpArray)
  {
    [self unloadFX:fxName];
  }
  [tmpArray release];
}

-(void) unloadFX:(NSString *)fxName
{
  [[SimpleAudioEngine sharedEngine] unloadEffect:fxName];
  
  LWE_ASSERT_EXC(([self.loadedSounds indexOfObject:fxName] != NSNotFound), @"Tried to unload FX: '%@' but it doesn't exist in the preloaded array.", fxName);
  [self.loadedSounds removeObject:fxName];
}

//! Loads effect into memory before using it, not required but reduces the delay
-(void) preloadFX:(NSString*)fxName
{
  [[SimpleAudioEngine sharedEngine] preloadEffect:fxName];
  
  // Add our preloaded FX to our array, but only once
  if ([self.loadedSounds containsObject:fxName] == NO)
  {
    [self.loadedSounds addObject:fxName];
  }
}

-(void) stopAllFX
{
  for (NSString *fxName in self.soundsPlaying)
  {
    // if key exists in dict
    if([self.soundsPlaying objectForKey:fxName])
    {
      CDSoundSource *source = [self.soundsPlaying objectForKey:fxName];
      [source stop];
    }
  }
  [self.soundsPlaying removeAllObjects];
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

//! Stop sound using fxName as identifier
-(BOOL) stopFX:(NSString*)fxName
{
  BOOL ableToStop = NO;
  
  // If it hasn't played yet...
  if ([self.delayedSounds objectForKey:fxName])
  {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_playFX:) object:[self.delayedSounds objectForKey:fxName]];
    [self.delayedSounds removeObjectForKey:fxName];
    ableToStop = YES;
  }
  
  // if key exists in dict
  if ([self.soundsPlaying objectForKey:fxName])
  {
    // stop the corresponding effect
    CDSoundSource *source = [self.soundsPlaying objectForKey:fxName];
    [source stop];
    
    // remove from dict
    [self.soundsPlaying removeObjectForKey:fxName];
    
    ableToStop = YES;
  }
  return ableToStop;
}

//! Play a sound
-(NSInteger) playFX:(NSString*)fxName
{
  return [self playFX:fxName pitch:1.0f gain:1.0f];
}

//! Play a sound at a pitch
-(NSInteger) playFX:(NSString*)fxName pitch:(Float32)pitch gain:(Float32)gain
{
  // Is this a callback after delay - take it out of that dictionary
  if ([self.delayedSounds objectForKey:fxName])
  {
    [self.delayedSounds removeObjectForKey:fxName];
  }
  
  NSInteger returnVal = 0;
  if (fxName)
  {
    // add sound identifier to dict
    CDSoundSource *source = [[SimpleAudioEngine sharedEngine] soundSourceForFile:fxName];
//    LWE_ASSERT_EXC(source,@"Sound file '%@' was not able to be turned into a CDSoundSource. Does it exist??",fxName);
    source.pitch = pitch;
    source.gain = gain;
    [source play];
    
//    LWE_LOG(@"Playing FX: %@", fxName);
    if (source)
    {
      [self.soundsPlaying setObject:source forKey:fxName];
    }
  }
  return returnVal;
}

//! Play sound after delay with a different pitch
-(void) playFX:(NSString*)fxName pitch:(Float32)pitch gain:(Float32)gain withDelay:(NSTimeInterval)delay
{
  [self preloadFX:fxName];

  if (delay > 0)
  {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:fxName,@"fxName",[NSNumber numberWithFloat:pitch],@"fxPitch",[NSNumber numberWithFloat:gain],@"fxGain",nil];
    [self.delayedSounds setObject:userInfo forKey:fxName];
    [self performSelector:@selector(_playFX:) withObject:userInfo afterDelay:delay];
  }
  else
  {
    [self playFX:fxName pitch:pitch gain:gain];
  }
}

//! Play a sound using a dictionary - helper for delay
-(NSInteger) _playFX:(NSDictionary*)fx
{
  return [self playFX:[fx objectForKey:@"fxName"] pitch:[[fx objectForKey:@"fxPitch"] floatValue] gain:[[fx objectForKey:@"fxGain"] floatValue]];
}

-(BOOL)fxIsPlaying:(NSString*)fxName
{
  BOOL returnVal = NO;
  if ([self.soundsPlaying objectForKey:fxName])
  {
    CDSoundSource *source = [self.soundsPlaying objectForKey:fxName];
    returnVal = source.isPlaying;
  }
  return returnVal;
}

#pragma mark -
#pragma mark Class Plumbing

- (void)dealloc
{
  // Cancel any delayed starts
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  [loadedSounds release];
  [soundsPlaying release];
  [delayedSounds release];
  [super dealloc];
}

@end