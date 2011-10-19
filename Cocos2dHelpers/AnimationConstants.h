//
//  AnimationConstants.h
//  phone
//
//  Created by paul on 28/12/10.
//  Copyright 2010 Long Weekend LLC. All rights reserved.
//

////////////////////////////////////////////
/* Physical Interaction Control Constants */
////////////////////////////////////////////

// ENUM - trigger type
typedef enum
{
  INVALID_TRIGGER,
  ON_ANSWER_FIRST_CALL,
  ON_ANSWER_CALL,
  ON_ANSWER_INCOMING_CALL,
  ON_END_CALL,
  ON_INACTIVITY,
  ON_SHAKE,
  ON_CHARACTER_TOUCH,
  ON_CHARACTER_RUB,
  ON_CHARACTER_DBL_TOUCH,
  ON_BACKGROUND_TOUCH,
  ON_BACKGROUND_RUB,
  ON_BACKGROUND_DBL_TOUCH,
  ON_SOUND_DETECTED,
  ON_SILENCE_DETECTED,
  ON_OBJECT_ICON_TOUCH,
  ON_OBJECT_ICON_DBL_TOUCH,
  ON_RECORDER_ICON_TOUCH
} kTriggerType;

// ENUM lookup string array objects
#define kTriggerTypeArray @"invalid", @"onAnswerFirstCall", @"onAnswerCall", @"onAnswerIncomingCall", @"onEndCall", @"onInactivity", @"onShake", @"onCharacterTouch", @"onCharacterRub", @"onCharacterDoubleTouch", @"onBackgroundTouch", @"onBackgroundRub", @"onBackgroundDblTouch", @"onSoundDetected", @"onSilenceDetected", @"onObjectIconTouch", @"onObjectIconDoubleTouch", @"onRecorderIconTouch", nil

/////////////////////////////////////////
/* Voice Interaction Control Constants */
/////////////////////////////////////////

// ENUM - conversation life cycle states
typedef enum
{
  CONVERSATION_NOT_RUNNING,    // a conversation not currently running (e.g. other interactions are blocking conversation from starting)
  CONVERSATION_STARTED,        // start of new conversation, sound heard AFTER SILENCE (5 seconds) OR AFTER GREETING
  CONVERSATION_CONTINUED,      // gap filler, used after first 1-5 
  CONVERSATION_REDIRECTED      // redirect conversation, after fuzzy-x number of continuations
} kConversationState;

/////////////////////////////////////////
/* Animation PLIST  key name constants */
/////////////////////////////////////////

// These are the top 6
extern NSString * const kLWESpritesKey;
extern NSString * const kLWEAnimationsKey;
extern NSString * const kLWEMetadataKey;
extern NSString * const kLWETriggersKey;
extern NSString * const kLWEHotspotsKey;
extern NSString * const kLWEObjectsKey;

// Animation-level keys
extern NSString * const kLWEAnimationRepeatsKey;

// Timelines
extern NSString * const kLWEAnimationTimelineKey;
extern NSString * const kLWEAnimationTimelineItemArrayOffset;
extern NSString * const kLWEAnimationTimelineSpriteKey;
extern NSString * const kLWEAnimationTimelineHideOnFinishKey;
extern NSString * const kLWEAnimationTimelineHideItemsOnFinishKey;
extern NSString * const kLWEAnimationTimelineDurationKey;
extern NSString * const kLWEAnimationTimelineNumLoopsKey;
extern NSString * const kLWEAnimationTimelineStartTimeKey;
extern NSString * const kLWEAnimationTimelineEndTimeKey;
extern NSString * const kLWEAnimationTimelineFollowsKey;
extern NSString * const kLWEAnimationTimelineReverseFramesKey;

// Timeline sounds
extern NSString * const kLWEAnimationTimelineSoundPitchKey;
extern NSString * const kLWEAnimationTimelineSoundGainKey;
extern NSString * const kLWEAnimationTimelineSoundKey;
extern NSString * const kLWEAnimationTimelineSoundDelayKey;

// Sprites
extern NSString * const kLWEAnimationSpritePreloadKey;
extern NSString * const kLWEAnimationSpritesKey;
extern NSString * const kLWEAnimationSpriteHotspotsKey;
extern NSString * const kLWEAnimationSpriteSourceNameKey;
extern NSString * const kLWEAnimationSpriteSourceFilenameKey;
extern NSString * const kLWEAnimationSpriteFrameOrderKey;
extern NSString * const kLWEAnimationSpriteZwoptexFramesKey;
extern NSString * const kLWEAnimationSpriteDelayKey;
extern NSString * const kLWEAnimationSpriteHideOnFinishKey;
extern NSString * const kLWEAnimationSpritePropertiesKey;
extern NSString * const kLWEAnimationSpritePropertiesZindexKey;

// Objects
extern NSString * const kLWETouchableObjectsSourceFilenameKey;
extern NSString * const kLWETouchableObjectsSelectedSourceFilenameKey;
extern NSString * const kLWETouchableObjectsDisabledKey;
