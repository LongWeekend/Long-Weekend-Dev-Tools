//
//  AnimationSprite.h
//  phone
//
//  Created by Mark Makdad on 1/7/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class AnimationSprite;

/**
 * \class AnimationSprite A wrapper on CCSprite with additional properties and methods to handle frame animation
 * \details Note that this is a wrapper, not a subclass, of CCSprite or any CCNode.
 */
@interface AnimationSprite : NSObject <NSCopying>
{
  //! Used when lazy loading textures
  id _callback;
  SEL _selector;
  NSString *_textureFilename;
  CCAction* animateActionObj;
}


/** Designated initializers **/

//! Initializes using texture source name and sprite only (default frames seq created from frames array)
- (id) initWithSourceName:(NSString*)source andSprite:(CCSprite*)lSprite;

//! Initializes using parameters passed, including an existing sprite object
- (id) initWithSourceName:(NSString*)source andFrameString:(NSString*)frames andSprite:(CCSprite*)lSprite andDelay:(NSTimeInterval)delay andZIndex:(NSInteger)zindex;
- (id) initWithSourceName:(NSString*)source andFrameString:(NSString*)frames andSprite:(CCSprite*)lSprite andDelay:(NSTimeInterval)delay;
- (id) initWithSourceName:(NSString*)source andFrameString:(NSString*)frames andSprite:(CCSprite*)lSprite;

//! Initializes using a sprite PLIST hash - loads the texture immediately
- (id) initWithDictionary:(NSDictionary*)spriteDict;

//! Initializes using a sprite PLIST hash - optionally loads the texture immediately
- (id) initWithDictionary:(NSDictionary*)spriteDict forceTextureLoad:(BOOL)forceTexLoad;

//! Initializes using lazy loading on the texture, allows us to callback to somewhere when done
- (id) initWithDictionary:(NSDictionary*)spriteDict callback:(id)callback selector:(SEL)selector;

//! The other initializers use this one - if you specify a callback AND force texture load, you get an exception
- (id) initWithDictionary:(NSDictionary*)spriteDict callback:(id)callback selector:(SEL)selector forceTextureLoad:(BOOL)forceTexLoad;

/** Properties of the animated sprite **/

//! Returns the CCSpriteFrame objects associated with this sprite using the default frame sequence associated with this sprite
- (NSArray*) ccSpriteFrames;

//! An array of CCSpriteFrames based on a custom frame sequence - optionally reversing the order of the returned
- (NSArray*) ccSpriteFramesWithCustomSequence:(NSArray*)sequence reverse:(BOOL)shouldReverse;

//! An array of CCSpriteFrames based on a custom frame sequence - optionally reversed and/or repeated
- (NSArray*) ccSpriteFramesWithCustomSequence:(NSArray*)sequence loops:(NSInteger)loops reverse:(BOOL)shouldReverse;

//! The z-index of the sprite in Cocos terms
- (NSInteger) zIndex;

//! The underlying CCSprite object that will animate
- (CCSprite*) CCSprite;

//! The underlying CCTexture object that this sprite uses
- (CCTexture2D*) ccTexture;

//! The filename of the texture file used by this sprite
- (NSString*) textureFilename;


/** Touch related methods **/

//! Returns the key of the rect that touchedPoint is inside - if none, returns nil
- (NSString*) triggerKeyForTouchedPoint:(CGPoint)touchedPoint;


//! Returns a CCAnimation object based on the instance's propertiues
-(id) ccAnimation;

//! Returns a CCAction comprising the animation frames which can run on the sprite
-(id) animateAction;

// Returns a CCAction comprising the already loaded frames in a specified order
-(id) animateActionWithFrameString:(NSString*)frames;
-(id) animateActionWithFrameString:(NSString*)frames withFrameDelay:(NSTimeInterval)delay;

//! Make the sprite animate
-(void) animate;

//! Make the sprite animate a number of times
-(void) animateRepeated:(NSInteger)times;

//! Make the sprite animate repeating forever (or until stopped)
-(void) animateRepeatedForever;

/** Cocos related methods **/

//! Sets the CCSprite's visibility to hidden
- (void) hide;

//! Sets the CCSprite's visibility to showing
- (void) show;


/** Static Class Helpers **/

//! Takes a string like "1-6" and returns an NSArray of 1,2,3,4,5,6 as NSNumbers.
+ (NSMutableArray*) arrayForNumericalStringSequence:(NSMutableString*)seqStr;

+ (NSString*) sourceNameFromSpriteDict:(NSDictionary*)spriteDict;
+ (NSString*) subSourceNameFromSpriteDict:(NSDictionary*)spriteDict;

//! If YES, a red box will be drawn around the sprite and any of its hotspots
@property BOOL isDebug;

//! If YES, this sprite should hide after animating.  Default YES.
@property BOOL hideOnFinish;

//! If YES, the texture associated with this sprite will be loaded before Cocos starts
@property BOOL shouldPreload;

//! The name of the sprite
@property (retain) NSString *sourceName;

//! The name of the subsprite (ie. subdirectory name from the source texture directory)
@property (retain) NSString *sourceSubspriteName;

//! The name of the sprite filename
@property (retain) NSString *sourceFilename;

//! By default, how many seconds Cocos will wait between animating each frame (1/frame delay would be FPS)
@property NSTimeInterval frameDelay;

//! PLIST properties: Z-Index, etc
@property (retain) NSDictionary *properties;

//! "Hotspot" rects associated with this sprite
@property (retain) NSDictionary *hotspots;

//! Array of NSNumbers representing the order of the animation (by frame number)
@property (retain) NSArray *frameSequence;

//! The underlying CCSprite object that will run the animation
@property (retain) CCSprite *sprite;

@end
