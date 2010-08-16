//
//  GTMXcodePreferences.h
//
//  Copyright 2007-2009 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import "PBXPreferencesPaneModule.h"

// Handles the Xcode Perference panel
@interface GTMXcodePreferences : PBXPreferencesPaneModule {
  // controls if they want the menuitem icons
  IBOutlet NSButton *showImageOnMenuItems_;  
  // controls if they want to deal with ws
  IBOutlet NSButton *correctWhiteSpace_; 
}
+ (BOOL)showImageOnMenuItems;
@end

// we use our own notifications so the plugin doesn't have to cache values and
// check for changes since the normal defaults change notification fires off
// like crazy.
extern NSString *GTMXcodePreferencesMenuItemPrefChanged;
extern NSString *GTMXcodeCorrectWhiteSpaceOnSave;
