//
//  AnimationConstants.m
//  phone
//
//  Created by paul on 28/12/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

#import "AnimationConstants.h"

// Nesting indicates correpsonding data structure level
NSString * const kLWESpritesKey = @"sprites";
NSString * const kLWEMetadataKey = @"metadata";
NSString * const kLWETriggersKey = @"triggers";
NSString * const kLWEObjectsKey = @"objects";
NSString * const kLWEHotspotsKey = @"hotspots";
NSString * const kLWEAnimationsKey = @"animations";

  // Touchable Objects
  NSString * const kLWETouchableObjectsSourceFilenameKey = @"file-name";
  NSString * const kLWETouchableObjectsSelectedSourceFilenameKey = @"file-name-selected";
  NSString * const kLWETouchableObjectsDisabledKey = @"disabled";

  // Animation Repeats
  NSString * const kLWEAnimationRepeatsKey = @"repeats";

  // Timeline Array
  NSString * const kLWEAnimationTimelineKey = @"timeline";

    // Timeline dictionary
    NSString * const kLWEAnimationTimelineItemArrayOffset = @"__offset"; // this is added to the hash to pass through the item's offset id in the timeline array
    NSString * const kLWEAnimationTimelineSpriteKey = @"sprite";
    NSString * const kLWEAnimationTimelineHideOnFinishKey = @"hide-on-finish";
    NSString * const kLWEAnimationTimelineHideItemsOnFinishKey = @"hide-items-on-finish";
    NSString * const kLWEAnimationTimelineNumLoopsKey = @"animation-loops";
    NSString * const kLWEAnimationTimelineStartTimeKey = @"start";
    NSString * const kLWEAnimationTimelineEndTimeKey = @"end";
    NSString * const kLWEAnimationTimelineDurationKey = @"duration";
    NSString * const kLWEAnimationTimelineFollowsKey = @"plays-after";

    NSString * const kLWEAnimationTimelineSoundKey = @"sound-file";
    NSString * const kLWEAnimationTimelineSoundDelayKey = @"sound-delay";
    NSString * const kLWEAnimationTimelineSoundPitchKey = @"sound-pitch";
    NSString * const kLWEAnimationTimelineSoundGainKey = @"sound-gain";
    NSString * const kLWEAnimationTimelineReverseFramesKey = @"reverse";

// Sprites Array
  NSString * const kLWEAnimationSpritesKey = @"sprites";

    // Sprite Dictionary
    NSString * const kLWEAnimationSpritePreloadKey = @"should-preload";
    NSString * const kLWEAnimationSpriteHotspotsKey = @"hotspots";
    NSString * const kLWEAnimationSpriteSourceNameKey = @"source";
    NSString * const kLWEAnimationSpriteSourceFilenameKey = @"source-file";

    NSString * const kLWEAnimationSpriteFrameOrderKey = @"frames";
    NSString * const kLWEAnimationSpriteZwoptexFramesKey = @"frames";
    NSString * const kLWEAnimationSpriteDelayKey = @"frame-delay";
    NSString * const kLWEAnimationSpriteHideOnFinishKey = @"hide-on-finish";
    NSString * const kLWEAnimationSpritePropertiesKey = @"properties";

      // Sprite Properties Dictionary
      NSString * const kLWEAnimationSpritePropertiesZindexKey = @"z";

