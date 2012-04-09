// LWEUILabelUtils.h
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

#define READING_MIN_FONTSIZE  14.0
#define READING_MAX_FONTSIZE  20.0
#define READING_DEF_FONTSIZE  14.0

#define HEADWORD_MIN_FONTSIZE 20.0
#define HEADWORD_MAX_FONTSIZE 38.0
#define HEADWORD_DEF_FONTSIZE 14.0

@interface UILabel (LWEUtilities)

- (void) resizeWithMinFontSize:(NSInteger)minFontSize maxFontSize:(NSInteger)maxFontSize;
- (void) adjustFrameWithFontSize:(NSInteger)fontSize cellWidth:(NSInteger)width cellMargin:(NSInteger)margin;

@end
