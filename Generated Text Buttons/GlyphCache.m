//    File: VectorTextLayer.m
//Abstract: A subclass of CALayer that lays out CAShapeLayers containing glyph paths
// Version: 1.0
//
//Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
//Inc. ("Apple") in consideration of your agreement to the following
//terms, and your use, installation, modification or redistribution of
//this Apple software constitutes acceptance of these terms.  If you do
//not agree with these terms, please do not use, install, modify or
//redistribute this Apple software.
//
//In consideration of your agreement to abide by the following terms, and
//subject to these terms, Apple grants you a personal, non-exclusive
//license, under Apple's copyrights in this original Apple software (the
//"Apple Software"), to use, reproduce, modify and redistribute the Apple
//Software, with or without modifications, in source and/or binary forms;
//provided that if you redistribute the Apple Software in its entirety and
//without modifications, you must retain this notice and the following
//text and disclaimers in all such redistributions of the Apple Software.
//Neither the name, trademarks, service marks or logos of Apple Inc. may
//be used to endorse or promote products derived from the Apple Software
//without specific prior written permission from Apple.  Except as
//expressly stated in this notice, no other rights or licenses, express or
//implied, are granted by Apple herein, including but not limited to any
//patent rights that may be infringed by your derivative works or by other
//works in which the Apple Software may be incorporated.
//
//The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
//MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
//THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
//FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
//OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//
//IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
//OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
//MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
//AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
//STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
//POSSIBILITY OF SUCH DAMAGE.
//
//Copyright (C) 2010 Apple Inc. All Rights Reserved.
//



// This implements a very simple glyph cache.
// It maps from CTFontRef to CGGlyph to CGPathRef in order to reuse glyphs.
// It does NOT try to retain the keys that are used (CTFontRef or CGGlyph)
// but that is not an issue with respect to how it is used by this sample.

#import "GlyphCache.h"

@implementation GlyphCache

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        cache = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

-(void)dealloc
{
    CFRelease(cache);
}

-(CGPathRef)pathForGlyph:(CGGlyph)glyph fromFont:(CTFontRef)font
{
    // First we lookup the font to get to its glyph dictionary
    CFMutableDictionaryRef glyphDict = (CFMutableDictionaryRef)CFDictionaryGetValue(cache, font);
    if(glyphDict == NULL)
    {
        // And if this font hasn't been seen before, we'll create and set the dictionary for it
        glyphDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(cache, font, glyphDict);
        CFRelease(glyphDict);
    }
    // Next we try to get a path for the given glyph from the glyph dictionary
    CGPathRef path = (CGPathRef)CFDictionaryGetValue(glyphDict, (const void *)(uintptr_t)glyph);
    if(path == NULL)
    {
        // If the path hasn't been seen before, then we'll create the path from the font & glyph and cache it.
        path = CTFontCreatePathForGlyph(font, glyph, NULL);
        if(path == NULL)
        {
            // If a glyph does not have a path, then we need a placeholder to set in the dictionary
            path = (CGPathRef)kCFNull;
        }
        CFDictionarySetValue(glyphDict, (const void *)(uintptr_t)glyph, path);
        CFRelease(path);
    }
    if(path == (CGPathRef)kCFNull)
    {
        // If we got the placeholder, then set the path to NULL
        // (this will happen either after discovering the glyph path is NULL,
        // or after looking that up in the dictionary).
        path = NULL;
    }
    return path;
}

@end