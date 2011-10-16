//
//  AnimationSprite.m
//  phone
//
//  Created by Mark Makdad on 1/7/11.
//  Copyright 2011 Long Weekend LLC. All rights reserved.
//

#import "AnimationSprite.h"
#import "AnimationConstants.h"
#import "LWEUniversalAppHelpers.h"
#import "LWEDebug.h"
#import "LWERetinaUtils.h"
#import "LWEFile.h"

@interface AnimationSprite ()
- (NSDictionary*) _zwoptexHashFromFilename:(NSString*)sourceFilename;
- (NSDictionary*) _resolveSprite:(NSDictionary*)spriteDict toAbsolutePath:(NSString*)absolutePath withSourceName:(NSString*)aSourceName;
- (NSDictionary*) _resolveDictionary:(NSDictionary*)dict keys:(NSArray*)keys toAbsolutePath:(NSString*)absolutePath;
- (NSString*) _resolveFilename:(NSString*)filename toAbsolutePath:(NSString*)absolutePath;
- (NSDictionary *) _createHotspotsWithDictionary:(NSDictionary *)hotspotDict;
- (NSString*) _textureFilenameForSource:(NSString*)sourceFilename;
- (void) _asyncTextureLoadDone:(CCTexture2D*)texture;
- (NSArray*) _ccSpriteFrames:(NSArray*)aFrameSequence reverse:(BOOL)shouldReverse;
- (CCSprite*) _ccSprite;
@end

@implementation AnimationSprite

// Properties from PLIST
@synthesize sourceName, sourceSubspriteName, sourceFilename, frameSequence, frameDelay, properties;
@synthesize sprite, hotspots, isDebug, isAnimating, shouldPreload, hideOnFinish;

#pragma mark -
#pragma mark initializers

/**
 * Init a new AnimationSprite allowing you to pass in a source, frame string and existing sprite object
 */
- (id) initWithSourceName:(NSString*)source andSprite:(CCSprite*)lSprite
{
  return [self initWithSourceName:source andFrameString:nil andSprite:lSprite andDelay:0.05 andZIndex:1];
}

/**
 * Init a new AnimationSprite allowing you to pass in a source, frame string and existing sprite object
 */
- (id) initWithSourceName:(NSString*)source andFrameString:(NSString*)frames andSprite:(CCSprite*)lSprite
{
  return [self initWithSourceName:source andFrameString:frames andSprite:lSprite andDelay:0.05 andZIndex:1];
}

/**
 * Init a new AnimationSprite allowing you to pass in a source, frame string and existing sprite object
 */
- (id) initWithSourceName:(NSString*)source andFrameString:(NSString*)frames andSprite:(CCSprite*)lSprite andDelay:(NSTimeInterval)delay
{
  return [self initWithSourceName:source andFrameString:frames andSprite:lSprite andDelay:delay andZIndex:1];
}

/**
 * Init a new AnimationSprite allowing you to pass in source, frame string, frame delay, existing sprite object and zindex
 */
- (id) initWithSourceName:(NSString*)source andFrameString:(NSString*)frames andSprite:(CCSprite*)lSprite andDelay:(NSTimeInterval)delay andZIndex:(NSInteger)zindex
{
  // create a properties dictionary
  NSDictionary *propsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%d", zindex], kLWEAnimationSpritePropertiesZindexKey,
                             nil];
  
  // create a sprite dictionary
  NSDictionary *spriteDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              source, kLWEAnimationSpriteSourceNameKey, 
                              frames, kLWEAnimationSpriteFrameOrderKey,
                              [NSNumber numberWithDouble:delay], kLWEAnimationSpriteDelayKey,
                              propsDict, kLWEAnimationSpritePropertiesKey,
                              nil];
  
  // set instance sprite property if not nil
  if(!lSprite)
  {
    // if sprite is nil you should be using a different init method
    LWE_LOG(@"You called -iniWithSourceName:andFrameString:andSprite: with a nil sprite. This is not wrong but make sure you want AnimSprite to create your sprite for you!");
  }
  else
  {
    // sprite should already exist, however we'll load its animation textures shortly
    self.sprite = lSprite; // retains
  }
  
  // returns self
  return [self initWithDictionary:spriteDict forceTextureLoad:YES];
}

/**
 * Inits a new AnimationSprite object, blocking the calling thread while assets load
 */
- (id) initWithDictionary:(NSDictionary*)spriteDict
{
  return [self initWithDictionary:spriteDict forceTextureLoad:YES];
}

/**
 * Inits a new AnimationSprite object, optionally blocking the calling thread while assets load
 * If forceTextureLoad is NO, the texture will be loaded inline when the sprite is used for the first time!
 */
- (id) initWithDictionary:(NSDictionary *)spriteDict forceTextureLoad:(BOOL)forceTexLoad
{
  return [self initWithDictionary:spriteDict callback:nil selector:NULL forceTextureLoad:forceTexLoad];
}

/**
 * Inits a new AnimationSprite object, returning immediately but scheduling an asynch image load
 */
- (id) initWithDictionary:(NSDictionary *)spriteDict callback:(id)callback selector:(SEL)selector
{
  return [self initWithDictionary:spriteDict callback:callback selector:selector forceTextureLoad:NO];
}

/**
 * Main initializer
 */
- (id) initWithDictionary:(NSDictionary*)spriteDict callback:(id)callback selector:(SEL)selector forceTextureLoad:(BOOL)forceTexLoad
{
  if ((self = [super init]))
  {
    _textureFilename = nil;
    
#if TARGET_IPHONE_SIMULATOR
    // Enable hotspots in simulator for authoring
    self.isDebug = YES;
#else
    self.isDebug = NO;
#endif

    self.sourceName = [[self class] sourceNameFromSpriteDict:spriteDict];
    self.sourceSubspriteName = [[self class] subSourceNameFromSpriteDict:spriteDict];
    self.sourceFilename = [spriteDict objectForKey:kLWEAnimationSpriteSourceFilenameKey];

    if(!self.sourceFilename)
    {
      // resolve paths in spriteDict
      NSString *plistPath = [[[NSBundle mainBundle] pathForResource:self.sourceName ofType:@"plist"] stringByDeletingLastPathComponent];
      spriteDict = [self _resolveSprite:spriteDict toAbsolutePath:plistPath withSourceName:self.sourceName];
      self.sourceFilename = [spriteDict objectForKey:kLWEAnimationSpriteSourceFilenameKey];
    }
    
    // if frame seq is blank/nil, introspect a default frame sequence from plist frames array
    if(![spriteDict objectForKey:kLWEAnimationSpriteFrameOrderKey])
    {
      NSDictionary *tmpTextureDict = [self _zwoptexHashFromFilename:self.sourceFilename];
      NSString* frameOrderString = [NSMutableString string];
      NSInteger frameCount = [[tmpTextureDict objectForKey:kLWEAnimationSpriteZwoptexFramesKey] count];
      for(int i=1; i <= frameCount; i++)
      {
        frameOrderString = [NSString stringWithFormat:@"%@%d",frameOrderString,i];
        if(i!=frameCount)
        {
          frameOrderString = [NSString stringWithFormat:@"%@,",frameOrderString];

        }
      }
      [spriteDict setValue:frameOrderString forKey:kLWEAnimationSpriteFrameOrderKey];
    }

    // NOTE 2011-10-06
    // These properties are not used directly in AnimationSprite class 
    // They are for use within the AnimationTimelineItem class (not yet published... still have to work out how, sorry!)
    NSNumber *shouldHideOnFinish = [spriteDict objectForKey:kLWEAnimationSpriteHideOnFinishKey];
    self.hideOnFinish = (shouldHideOnFinish == nil) ? YES : [shouldHideOnFinish boolValue];
    self.shouldPreload = [[spriteDict objectForKey:kLWEAnimationSpritePreloadKey] boolValue];
    self.frameDelay = [[spriteDict objectForKey:kLWEAnimationSpriteDelayKey] doubleValue];
    self.properties = [spriteDict objectForKey:kLWEAnimationSpritePropertiesKey];
    self.hotspots = [self _createHotspotsWithDictionary:[spriteDict objectForKey:kLWEAnimationSpriteHotspotsKey]];
    
    // Sanity checks
    LWE_ASSERT_EXC(([self.sourceName isEqualToString:@""] == NO && self.sourceName != nil),@"You can't pass a nil/blank value to sourceName.");
    LWE_ASSERT_EXC((self.sourceFilename != nil),@"This dictionary hasn't been converted to full pathnames!");
    
    // Lazy load texture
    CCTextureCache *cache = [CCTextureCache sharedTextureCache];
    if (callback && (selector != NULL))
    {
      LWE_ASSERT_EXC(forceTexLoad == NO,@"You can't provide a callback for async loading and force texture loading at the same time!");
      
      // We have to retain this because there is a chance it could be dealloc'ed before we
      // finish loading on the other thread
      _callback = [callback retain];
      _selector = selector;
      [cache addImageAsync:self.textureFilename target:self selector:@selector(_asyncTextureLoadDone:)];
    }
    else
    {
      // Only load assets on init if we were asked to - otherwise they will be loaded the first 
      // time -(CCSprite*)CCSprite is called
      if (forceTexLoad)
      {
        NSDictionary *dict = [self _zwoptexHashFromFilename:self.sourceFilename];
        CCTexture2D *texture = [cache addImage:self.textureFilename];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithDictionary:dict texture:texture];
      }
    }

    // Create the frame sequence array from the PLIST string
    NSMutableString *frameStr = [[spriteDict objectForKey:kLWEAnimationSpriteFrameOrderKey] mutableCopy];
    LWE_ASSERT_EXC(frameStr,@"Sprite: %@ - MUST have a frame sequence, you passed dict: '%@'",self.sourceName,spriteDict);
    self.frameSequence = [[self class] arrayForNumericalStringSequence:[frameStr mutableCopy]];
    [frameStr release];
  }
  return self;
}

#pragma mark -
#pragma mark Public Methods

/**
 * Returns the texture filename publicly
 */
- (NSString*) textureFilename
{
  if (_textureFilename == nil)
  {
    _textureFilename = [[self _textureFilenameForSource:self.sourceFilename] retain]; // released in -dealloc
  }
  return _textureFilename;
}


/**
 * Returns the CCSpriteFrame objects associated with this sprite using a custom frame sequence
 * If you pass "nil" to sequence the default sequence will be used
 * Optionally specify the number of loops if the animation is to be looped
 */
- (NSArray*) ccSpriteFramesWithCustomSequence:(NSArray*)sequence loops:(NSInteger)loops reverse:(BOOL)shouldReverse
{
  // Create a new sprite frame sequence (looping)
  NSMutableArray *ccSpriteFrames = [NSMutableArray array];
  for (NSInteger i = 0; i < loops; i++)
  {
    [ccSpriteFrames addObjectsFromArray:[self ccSpriteFramesWithCustomSequence:sequence reverse:shouldReverse]];
  }
  return (NSArray*)ccSpriteFrames;
}


/**
 * Returns the CCSpriteFrame objects associated with this sprite using a custom frame sequence
 * If you pass "nil" to sequence the default sequence will be used
 */
- (NSArray*) ccSpriteFramesWithCustomSequence:(NSArray*)sequence reverse:(BOOL)shouldReverse
{
  if (sequence)
  {
    return [self _ccSpriteFrames:sequence reverse:shouldReverse];
  }
  else
  {
    return [self _ccSpriteFrames:self.frameSequence reverse:shouldReverse];
  }
}


/**
 * Returns the CCSpriteFrame objects associated with this sprite using the default frame sequence associated with this sprite
 */
- (NSArray*) ccSpriteFrames
{
  // TODO: Deprecation target - doesn't include reverse
  return [self ccSpriteFramesWithCustomSequence:nil reverse:NO];
}


/**
 * Returns the zIndex of the sprite
 */
- (NSInteger) zIndex
{
  return [[self.properties objectForKey:kLWEAnimationSpritePropertiesZindexKey] integerValue];
}


/**
 * Lazy loads a CCSprite object, then always returns it, so we don't re-create the same sprite over and over again
 */
- (CCSprite*) CCSprite
{
  if (self.sprite == nil)
  {
    // Call this once again - shouldn't hurt if we've already done it up front, but this will add sprite frames when we used a lazily loaded texture
    NSDictionary *dict = [self _zwoptexHashFromFilename:self.sourceFilename];
    NSString *textureFilename = [self _textureFilenameForSource:self.sourceFilename];
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:textureFilename];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithDictionary:dict texture:texture];

    self.sprite = [self _ccSprite];
  }
  return self.sprite;
}

/**
 * Returns the CCTexture2D object underneath this sprite.  This is useful for making a new
 * CCSpriteBatchNode based on that texture.
 */
- (CCTexture2D*) ccTexture
{
  return [[self CCSprite] texture];
}


/**
 * Returns a CCAnimation object based on the instance's properties
 */
-(id) ccAnimation
{
  return [CCAnimation animationWithFrames:[self ccSpriteFrames] delay:frameDelay];
}

/**
 * Returns a CCAction comprising the animation frames which can run on the sprite
 */
-(id) animateAction
{
  return [CCAnimate actionWithAnimation:[self ccAnimation] restoreOriginalFrame:NO];
}

/**
 * Returns a CCAction comprising the animation frames which can run on the sprite
 */
-(id) animateActionWithFrameString:(NSString*)frames withFrameDelay:(NSTimeInterval)delay
{
  // trun frames into array
  NSArray *aFrameSequence = [[self class] arrayForNumericalStringSequence:[frames mutableCopy]];
  NSArray *framesArray = [self _ccSpriteFrames:aFrameSequence reverse:NO];
  CCAnimation *framesAnimated = [CCAnimation animationWithFrames:framesArray delay:delay];
  return [CCAnimate actionWithAnimation:framesAnimated restoreOriginalFrame:NO];
}

/**
 * Returns a CCAction comprising the animation frames which can run on the sprite
 */
-(id) animateActionWithFrameString:(NSString*)frames
{
  return [self animateActionWithFrameString:frames withFrameDelay:frameDelay];
}

/**
 * Make the sprite animate
 */
-(void) animate
{
  self.isAnimating = YES;
  animateActionObj = [self.sprite runAction:[self animateAction]];
}

/**
 * Make the sprite animate a number of times
 */
-(void) animateRepeated:(NSInteger)times
{
  self.isAnimating = YES;
  animateActionObj = [self.sprite runAction:[CCRepeat actionWithAction:(CCFiniteTimeAction*)[self animateAction] times:times]];
}

/**
 * Make the sprite animate repeating forever (or until stopped)
 */
-(void) animateRepeatedForever
{
  self.isAnimating = YES;
  animateActionObj = [self.sprite runAction:[CCRepeatForever actionWithAction:[self animateAction]]];
}

/**
 * Stop the sprite animating
 */
-(void) stopAnimating
{
  // tell just that action to stop
  self.isAnimating = NO;
  [animateActionObj stop];
}

/**
 * Hides the CCSprite in the layer
 */
- (void) hide
{
  self.CCSprite.visible = NO;
}

/**
 * Makes the CCSprite visible in the layer
 */
- (void) show
{
  self.CCSprite.visible = YES;
}

#pragma mark -
#pragma mark Touch Helper

/**
 * Helper function for touches.  If the point is contained in any of the
 * hotspots associated with this sprite, then the function will return the
 * name of the matched trigger key.  Otherwise, it returns nil.
 */
- (NSString*) triggerKeyForTouchedPoint:(CGPoint)touchedPoint
{
  NSString *returnKey = nil;
  for (NSString *key in self.hotspots)
  {
    NSValue *tmpValue = [self.hotspots objectForKey:key];
    CGRect theRect = [tmpValue CGRectValue];
    if (CGRectContainsPoint(theRect, touchedPoint))
    {
      // Quick return -- will return the first matching rect only
      returnKey = key;
      break;
    }
  }
  return returnKey;
}

#pragma mark -
#pragma mark NSCopying Support

- (id) copyWithZone:(NSZone *)zone
{
  return [self retain];
}

#pragma mark -
#pragma mark Private Parts

/**
 * Even shorter helper to get hash
 */
- (NSDictionary*) _zwoptexHashFromFilename:(NSString*)aSourceFilename
{
  NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:aSourceFilename];
  LWE_ASSERT_EXC(dict,@"No PLIST found: %@.  May not exist in the bundle?  A clean/delete off device may help too.",aSourceFilename);
  return dict;
}

/**
 * Takes a single sprite dictionary and converts the "source" field into an absolute path
 */
- (NSDictionary*) _resolveSprite:(NSDictionary*)spriteDict toAbsolutePath:(NSString*)absolutePath withSourceName:(NSString*)aSourceName
{
  NSString *newSourceName = [NSString stringWithFormat:@"%@.plist", aSourceName]; // sprite texture definition files end in .plist
  NSMutableDictionary *mutableSpriteDict = [[spriteDict mutableCopy] autorelease];
  [mutableSpriteDict setObject:newSourceName forKey:kLWEAnimationSpriteSourceFilenameKey];
  
  return [self _resolveDictionary:mutableSpriteDict keys:[NSArray arrayWithObject:kLWEAnimationSpriteSourceFilenameKey] toAbsolutePath:absolutePath];
}

/**
 * Generalized helper for converting multiple keys in the same dictionary to a resolved version.
 */
- (NSDictionary*) _resolveDictionary:(NSDictionary*)dict keys:(NSArray*)keys toAbsolutePath:(NSString*)absolutePath
{
  NSMutableDictionary *newDict = [dict mutableCopy];
  for (NSString *key in keys)
  {
    NSString *oldFilename = [dict objectForKey:key];
    if (oldFilename)
    {
      [newDict setObject:[self _resolveFilename:oldFilename toAbsolutePath:absolutePath] forKey:key];
    }
  }
  return (NSDictionary*)[newDict autorelease];
}

/**
 * Generalized helper that converts a filename from unpathed to absolute path IF we are 
 * on the main/master mainfest.  If we are on an addon, it first checks whether the file
 * exists, and if not, uses the main manifest regardless of what you tell us here.
 */
- (NSString*) _resolveFilename:(NSString*)filename toAbsolutePath:(NSString*)absolutePath
{
  NSString *resolved = [NSString stringWithFormat:@"%@/%@",absolutePath,filename];
  if ([LWEFile fileExists:resolved] == NO)
  {
    // Resolved couldn't be found
    LWE_ASSERT_EXC(YES,@"Texture file was not found! Very not cool.");
    // PCH 2011109: This causes errors in LLVM 4.2 compiler:
    //    LWE_ASSERT(@"Some comment");
    // but this does not:
    //    NSString *comment =@"Some comment";
    //    LWE_ASSERT(comment);
  }
  return resolved;
}

/**
 * Short helper to get the texture filename
 */
- (NSString*) _textureFilenameForSource:(NSString*)aSourceFilename
{
  // Get texture filename & frame dictionary -- note that this is DEPENDENT on Zwoptex's PLIST file format
  NSDictionary *dict = [self _zwoptexHashFromFilename:aSourceFilename];

  // the source file and the assets are always in the same folder
  NSString *relPathToAssets = [sourceFilename stringByDeletingLastPathComponent];
  return [NSString stringWithFormat:@"%@/%@", relPathToAssets, [dict valueForKeyPath:@"metadata.textureFileName"]];
}

/**
 * Returns the CCSpriteFrame objects associated with this sprite
 */
- (NSArray*) _ccSpriteFrames:(NSArray*)aFrameSequence reverse:(BOOL)shouldReverse
{
  // Buffer frames into frame array
  NSMutableArray *actionAnimFrames = [NSMutableArray arrayWithCapacity:[aFrameSequence count]];
  for (NSNumber *idx in aFrameSequence)
  {
    LWE_ASSERT_EXC([idx isKindOfClass:[NSNumber class]],@"Whoa, you can't pass anything other than NSNumber objects to frame sequence");
    NSString *frameName =[NSString stringWithFormat:@"%@-%02i.png",self.sourceName,[idx intValue]];
    
    // add subsprite name support
    if(self.sourceSubspriteName)
    {
      frameName = [NSString stringWithFormat:@"%@/%@", self.sourceSubspriteName,frameName];
    }
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    LWE_ASSERT_EXC(frame,@"Could not find frame '%@' in the frame cache. Does the frame exist?  Is your file named right in the Zwoptex PLIST?",frameName);
    [actionAnimFrames addObject:frame];
  }
  
  // Reverse if we want to
  if (shouldReverse)
  {
    actionAnimFrames = (NSMutableArray*)[
                                         [actionAnimFrames reverseObjectEnumerator] allObjects];
  }
  return (NSArray*)actionAnimFrames;
}


/**
 * Callback from Cocos when a texture has finished loading asynchronously.
 * From here, call back to OUR callback to tell them it's finished after 
 * we cache the sprite frames.
 */
- (void) _asyncTextureLoadDone:(CCTexture2D*)texture
{
  NSDictionary *dict = [self _zwoptexHashFromFilename:self.sourceFilename];

  NSDictionary *frameDict = [dict valueForKeyPath:@"frames"];
  LWE_ASSERT_EXC(frameDict,@"No frame key found in Zwoptex PLIST dictionary: %@",dict);
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithDictionary:frameDict texture:texture];
  
  // Callback
  [_callback performSelector:_selector withObject:texture];
  [_callback release];
}


/**
 * Helper function to create a new CCSprite object
 * Pulls the first frame out of an array of frames as the "main" frame
 * \return Returns a representative sprite, adjusted for screen size
 */
- (CCSprite*) _ccSprite
{
  // TODO: DANGER WILL ROBINSON.  This assumes objectAtIndex:0.  If the sprite hasn't been init'ed yet,
  // and we try to use it in reverse, this will UTTERLY FAIL by showing the first frame anyway..  Capiche?
  NSArray *spriteFrames = [self ccSpriteFrames];
  CCSprite *theSprite = [CCSprite spriteWithSpriteFrame:[spriteFrames objectAtIndex:0]];
  theSprite.scale = 1.00;
  theSprite.visible = NO;
  return theSprite;
}

/**
 * Helper that processes hotspot dictionaries out of the PLIST and puts them
 * in a slightly (but not much more) easy to use format
 */
- (NSDictionary *) _createHotspotsWithDictionary:(NSDictionary *)hotspotDict 
{
  // Read in hotspots, if any - use a dictionary because we want the key name
  NSMutableDictionary *touchableRects = [NSMutableDictionary dictionary];
  for (NSString *key in hotspotDict)
  {
    NSDictionary *hs = [hotspotDict objectForKey:key];
    CGRect tmpRect = CGRectMake([[hs objectForKey:@"x"] floatValue],
                                [[hs objectForKey:@"y"] floatValue],
                                [[hs objectForKey:@"width"] floatValue],
                                [[hs objectForKey:@"height"] floatValue]);
    
    // TODO: MMA Annoying hack to deal with iPad - doubles the size of this if we are an iPad.
    // This SHOULD be taken care of elsewhere, but since we are "hacking" by using the Retina
    // images on the iPad, we really have different content sizes.
    CGFloat scaleFactor = [LWEUniversalAppHelpers isAnIPad] ? 2.0f : 1.0f;
    tmpRect = CGRectApplyAffineTransform(tmpRect,CGAffineTransformMakeScale(scaleFactor,scaleFactor));
    
    [touchableRects setValue:[NSValue valueWithCGRect:tmpRect] forKey:key];
  }
  return (NSDictionary*)touchableRects;
}

#pragma mark - Class Methods
/**
 * Returns an array of NSNumbers depending on the frame string provided
 * The format of this string is CSV numbers 1,2,3,4 and it also allows for
 * runs in both directions: 5-10,9-6,5-10,9-6 would oscillate between frames
 * 5 and 10.  Finally, as shorthand, one can do 4*20 to display frame 4 twenty times
 */
+ (NSMutableArray*) arrayForNumericalStringSequence:(NSMutableString*)seqStr
{
  NSMutableArray *outArr = [NSMutableArray array];
  
  // strip spaces
  [seqStr replaceOccurrencesOfString:@" "
                          withString:@""
                             options:0
                               range:NSMakeRange(0, [seqStr length])];
  
  // Chunk strings by commas
  NSArray *chunks = [seqStr componentsSeparatedByString:@","];
  for(NSString *crumb in chunks)
  {
    LWE_ASSERT_EXC(([crumb isEqualToString:@"0"] == NO),@"Frame sequences are **not** zero indexed, number your frames from 1..n");
    LWE_ASSERT_EXC(([crumb isEqualToString:@""] == NO),@"Frame sequence string has a format error!");
    
    // if crumb contains '-'
    NSRange hyphenInString = [crumb rangeOfString:@"-"];
    NSRange asteriskInString = [crumb rangeOfString:@"*"];
    if (hyphenInString.location != NSNotFound)
    {
      // Split string into n1 & n2, fill in series between n1 & n2
      NSArray *numArray = [crumb componentsSeparatedByString: @"-"];
      NSInteger n1 = [[numArray objectAtIndex:0] intValue];
      NSInteger n2 = [[numArray objectAtIndex:1] intValue];
      if(n1 < n2)
      {
        // if ASC: n1 < n2
        for(NSInteger i = n1; i <= n2; i++)
        {
          [outArr addObject:[NSNumber numberWithInt:i]];
        }
      }
      else 
      {
        // if DESC: n1 > n2
        for (NSInteger i = n1; i >= n2; i--)
        {
          [outArr addObject:[NSNumber numberWithInt:i]];
        }
      }
    }
    // If Crumb contains "*"
    else if (asteriskInString.location != NSNotFound)
    {
      NSArray *componentArray = [crumb componentsSeparatedByString:@"*"];
      if ([componentArray count] == 2)
      {
        NSInteger n1 = [[componentArray objectAtIndex:0] intValue];
        NSInteger n2 = [[componentArray objectAtIndex:1] intValue];
        NSNumber *numToRepeat = [NSNumber numberWithInt:n1];
        for (NSInteger i = 0; i < n2; i++)
        {
          [outArr addObject:numToRepeat];
        }
      }
      else
      {
        [NSException raise:NSInternalInconsistencyException format:@"Asterisk must be used in the x*y format!"];
      }
    }
    else
    {
      // if crumb does not have '-'
      [outArr addObject:[NSNumber numberWithInt:[crumb intValue]]];
    }
  }
  return outArr;
}

//! Extract the sprite name (texture) from the source name key
+ (NSString*) sourceNameFromSpriteDict:(NSDictionary*)spriteDict
{
  NSArray *tmpArray = [[spriteDict objectForKey:kLWEAnimationSpriteSourceNameKey] componentsSeparatedByString:@"/"];
  return [tmpArray objectAtIndex:0];
}

//! Extract the sub-sprite name (texture subdirectory) from the source name key
+ (NSString*) subSourceNameFromSpriteDict:(NSDictionary*)spriteDict
{
  NSString *returnVal = nil;
  NSArray *tmpArray = [[spriteDict objectForKey:kLWEAnimationSpriteSourceNameKey] componentsSeparatedByString:@"/"];
  LWE_ASSERT_EXC(([tmpArray count] < 3),@"subSprites only support one level of nesting presently");
  if ([tmpArray count] > 1)
  {
    returnVal = [tmpArray objectAtIndex:1];
  }
  return returnVal;
}

#pragma mark -
#pragma mark Class Plumbing

- (void) dealloc
{
  [_textureFilename release];
  [hotspots release];
  [sourceName release];
  [sourceSubspriteName release];
  [sourceFilename release];
  [frameSequence release];
  [properties release];
  [sprite release];
  
  [super dealloc];
}

@end