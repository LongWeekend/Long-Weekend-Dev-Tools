// LWELongRunningTaskProtocol.h
//
// Copyright (c) 2011 Long Weekend LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

/**
 * Any class that implements this protocol can be used as a long running task.
 */
@protocol LWELongRunningTaskProtocol <NSObject>
@required
//! The task should cancel whatever it isi doing when receiving this message.
- (void) cancel;

//! The task should begin executing after receiving this message.
- (void) start;

//! Returns YES if the task is in a successful terminal state.
- (BOOL) isSuccessState;

//! Returns YES if the task is in a failed terminal state.
- (BOOL) isFailureState;

//! Brief description that can be displayed to the user of what the task is currently doing.
- (NSString*) taskMessage;

//! Brief 0-1 reference of how far along the task is to completion.
- (CGFloat) progress;

@optional

//! If YES, it is possible to call -cancel.  May change, and is not thread safe.
- (BOOL) canCancelTask;

//! If YES, it is possible to call -start.  May change, and is not thread safe.
- (BOOL) canStartTask;
@end
