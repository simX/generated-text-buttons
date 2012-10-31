/*
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * The names of its contributors may not be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

//
//  EPGeneratedTextButtons.m
//
//  Created by Simone Manganelli on 7/08/11.
//

#import "EPGeneratedTextButtons.h"
#import <CoreText/CoreText.h>
#import "UIBezierPath+EPAdditions.h"
#import "GlyphCache.h"


@interface EPGeneratedTextButtons (Private)

@end



@implementation EPGeneratedTextButtons

// from http://iphonedevelopment.blogspot.com/2011/03/attributed-strings-in-ios.html
CTFontRef CTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    return ctFont;
}

#pragma mark - Support Methods

// modified from CoreAnimationText sample code from Apple here:
// http://developer.apple.com/library/mac/#samplecode/CoreAnimationText/Introduction/Intro.html
// modifications from http://pastie.org/2174023 via @FensterZumH0f on Twitter
+ (UIBezierPath*)pathForCTLine:(CTLineRef)line;
{
    if (line == NULL) return [UIBezierPath bezierPath];
    
    // Create and use a glyph cache to ensure that we reuse paths when we reuse glyphs from a font
    GlyphCache * cache = [[GlyphCache alloc] init];
    
    // Now lets get down to layout.
    CFIndex glyphIndex = 0;
    CFArrayRef glyphRuns = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(glyphRuns);
    CGMutablePathRef returnPath = CGPathCreateMutable();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    for (CFIndex i = 0; i < runCount; ++i) {
        
        // For each run, we need to get the glyphs, their font (to get the path) and their locations.
        CTRunRef run = CFArrayGetValueAtIndex(glyphRuns, i);
        CFIndex runGlyphCount = CTRunGetGlyphCount(run);
        CGPoint positions[runGlyphCount];
        CGGlyph glyphs[runGlyphCount];
        
        // Grab the glyphs, positions, and font
        CTRunGetPositions(run, CFRangeMake(0, 0), positions);
        CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs);
        CFDictionaryRef attributes = CTRunGetAttributes(run);
        CTFontRef runFont = CFDictionaryGetValue(attributes, kCTFontAttributeName);
        
        for (CFIndex j = 0; j < runGlyphCount; ++j, ++glyphIndex) {
            // Layout each of the shape layers to place them at the correct position with the correct path.
            CGPoint position = positions[j];
            transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, position.x, position.y);
            CGPathAddPath(returnPath, &transform, [cache pathForGlyph:glyphs[j] fromFont:runFont]);
        }
    }
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithCGPath:returnPath];
    CFRelease(returnPath);
    return bezierPath;
}


+ (NSMutableAttributedString *)mutableAttributedStringWithString:(NSString *)string
                                                            font:(UIFont *)font
                                                           color:(UIColor *)theColor;
{
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    if (string != nil) {
        CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef)string);
    }
    
    CFRange wholeStringRange = CFRangeMake(0, CFAttributedStringGetLength(attrString));
    
    if (theColor) {
        CGColorRef theColorRef = [theColor CGColor];
        CFAttributedStringSetAttribute(attrString, wholeStringRange, kCTForegroundColorAttributeName, theColorRef);
    }
    
    CTFontRef theFont = CTFontCreateFromUIFont(font);
    CFAttributedStringSetAttribute(attrString, wholeStringRange, kCTFontAttributeName, theFont);
    CFRelease(theFont);
    
    
    NSMutableAttributedString *returnAttrString = (NSMutableAttributedString *)CFBridgingRelease(attrString);
    return returnAttrString;
}


+ (UIImage *)tiledImageUsingTilingImage:(UIImage *)tilingImage
                                   size:(CGSize)desiredSize;
{
    NSParameterAssert(tilingImage);
    UIImage *imageToReturn = nil;
    if (! CGSizeEqualToSize([tilingImage size], desiredSize)) {
        
        UIGraphicsBeginImageContextWithOptions(desiredSize,NO,0.0);
        
        
        NSInteger currentX = 0;
        NSInteger currentY = 0;
        
        for (currentX = 0; currentX < desiredSize.width; currentX += [tilingImage size].width) {
            for (currentY = 0; currentY < desiredSize.height; currentY += [tilingImage size].height) {
                [tilingImage drawAtPoint:CGPointMake(currentX, currentY)];
            }
        }
        
        
        
        imageToReturn = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        imageToReturn = tilingImage;
    }
    
    return imageToReturn;
}


+ (UIImage *)maskBackgroundImage:(UIImage *)backgroundImage
                  usingImageMask:(UIImage *)maskImage;
{
    CGSize backgroundImageSize = [backgroundImage size];
    CGRect drawRect = CGRectMake(0, 0, backgroundImageSize.width, backgroundImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(backgroundImageSize,NO,0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGImageRef clippedImage = CGImageCreateWithImageInRect([maskImage CGImage],drawRect);
    CGContextClipToMask(context, drawRect, clippedImage);
    [backgroundImage drawInRect:drawRect];
    CFRelease(clippedImage);
    CGContextRestoreGState(context);
    
    UIImage *imageToReturn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageToReturn;
}


// unused in any of the other methods, but could be useful anyway
+ (UIImage *)imageFromAttributedString:(NSAttributedString *)attributedText;
{
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) attributedText);
    CGFloat ascent;
    CGFloat descent;
    CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
    
    CGFloat height = ascent+ceil(descent);
    CGFloat realRealHeight = height;
    
    
    
    
    CGSize textSize = CGSizeMake(width,realRealHeight);
    
    
    
    UIGraphicsBeginImageContextWithOptions(textSize,NO,0.0);
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw 1 pixel above bottom and left for reason described above
    CGContextSetTextPosition(context, 1.0, descent + 1.0);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, textSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CTLineDraw(line, context);
    CGContextRestoreGState(context);
    CFRelease(line);
    
    UIImage *imageToReturn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageToReturn;
}



#pragma mark - Example Button Image Creation Methods


+ (UIImage *)woodenImageWithFloatingString:(NSString *)_string;
{
    UIFont *theFont = [UIFont fontWithName:@"HelveticaNeue-Bold"
									  size:72.0];
	
	NSMutableAttributedString *theAttributedString = [self mutableAttributedStringWithString:_string
                                                                                        font:theFont
                                                                                       color:[UIColor colorWithWhite:1.00 alpha:1.00]];
	
	UIImage *woodenStringImage = [self recessedImageFromAttributedString:theAttributedString
                                                       innerShadowOffset:CGSizeMake(0.0,-1.0)
                                                   innerShadowBlurRadius:0.0
                                                        innerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                                                       outerShadowOffset:CGSizeMake(0.0,-5.0)
                                                   outerShadowBlurRadius:5.0
                                                        outerShadowColor:[UIColor colorWithWhite:0.0 alpha:0.8]
                                               gradientFillStartingColor:[UIColor colorWithRed:0.746 green:0.648 blue:0.574 alpha:1.0]
                                                 gradientFillEndingColor:[UIColor colorWithRed:0.605 green:0.523 blue:0.453 alpha:1.0]
                                                   gradientFillDirection:EPTopToBottom
                                                         backgroundImage:nil
												   backgroundImageCenter:CGPointMake(0.5,0.5)
                                  ];
    
    return woodenStringImage;
}

+ (UIImage *)imageWithWhiteFloatingString:(NSString *)_string
                          backgroundImage:(UIImage *)backgroundImage;
{
    UIFont *theFont = [UIFont fontWithName:@"HelveticaNeue-Bold"
									  size:40.0];
	
	NSMutableAttributedString *theAttributedString = [self mutableAttributedStringWithString:_string
                                                                                        font:theFont
                                                                                       color:[UIColor colorWithWhite:1.00 alpha:1.00]];
	
	UIImage *woodenStringImage = [self recessedImageFromAttributedString:theAttributedString
                                                       innerShadowOffset:CGSizeMake(0.0,-1.0)
                                                   innerShadowBlurRadius:0.0
                                                        innerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                                                       outerShadowOffset:CGSizeMake(0.0,-5.0)
                                                   outerShadowBlurRadius:4.0
                                                        outerShadowColor:[UIColor colorWithWhite:0.0 alpha:1.0]
                                               gradientFillStartingColor:nil
                                                 gradientFillEndingColor:nil
                                                   gradientFillDirection:0
                                                         backgroundImage:backgroundImage
												   backgroundImageCenter:CGPointMake(0.5,0.5)
                                  ];
    
    return woodenStringImage;
}




+ (UIImage *)buttonImageWithBackground:(UIImage *)backgroundImage
                   typicalSunkenString:(NSString *)_string
                              fontName:(NSString *)_fontName
                              fontSize:(CGFloat)_fontSize
                             fontColor:(UIColor *)_fontColor
                 backgroundImageCenter:(CGPoint)_backgroundImageCenter;
{
    UIFont *theFont = [UIFont fontWithName:_fontName
									  size:_fontSize];
	
	NSMutableAttributedString *theAttributedString = [self mutableAttributedStringWithString:_string
                                                                                        font:theFont
                                                                                       color:_fontColor];
	
	UIImage *woodenStringImage = [self recessedImageFromAttributedString:theAttributedString
                                                       innerShadowOffset:CGSizeMake(0.0,-1.0)
                                                   innerShadowBlurRadius:0.0
                                                        innerShadowColor:[UIColor colorWithRed:0.35 green:0.58 blue:0.7 alpha:0.4]
                                                       outerShadowOffset:CGSizeMake(0.0,1.0)
                                                   outerShadowBlurRadius:0.0
                                                        outerShadowColor:[UIColor colorWithWhite:0.0 alpha:0.4]
                                                         backgroundImage:backgroundImage
												   backgroundImageCenter:_backgroundImageCenter
                                  ];
    
    return woodenStringImage;
}

+ (UIImage *)buttonImageWithBackground:(UIImage *)backgroundImage
                   glowingSunkenString:(NSString *)_string
                              fontName:(NSString *)_fontName
                              fontSize:(CGFloat)_fontSize
                 backgroundImageCenter:(CGPoint)_backgroundImageCenter;
{
    UIImage *buttonImage = [self woodenButtonImageWithBackground:backgroundImage
                                             glowingSunkenString:_string
                                                        fontName:_fontName
                                                        fontSize:_fontSize
										   backgroundImageCenter:_backgroundImageCenter];
    
    return buttonImage;
}

+ (UIImage *)woodenButtonImageWithBackground:(UIImage *)backgroundImage
                         typicalSunkenString:(NSString *)_string
                                    fontName:(NSString *)_fontName
                                    fontSize:(CGFloat)_fontSize
					   backgroundImageCenter:(CGPoint)_backgroundImageCenter;
{
    UIFont *theFont = [UIFont fontWithName:_fontName
									  size:_fontSize];
	
	NSMutableAttributedString *theAttributedString = [self mutableAttributedStringWithString:_string
                                                                                        font:theFont
                                                                                       color:[UIColor colorWithWhite:0.0 alpha:0.45]];
	
	UIImage *woodenStringImage = [self recessedImageFromAttributedString:theAttributedString
                                                       innerShadowOffset:CGSizeMake(0.0,-1.0)
                                                   innerShadowBlurRadius:0.0
                                                        innerShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.87]
                                                       outerShadowOffset:CGSizeMake(0.0,-1.0)
                                                   outerShadowBlurRadius:0.0
                                                        outerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.33]
                                                         backgroundImage:backgroundImage
												   backgroundImageCenter:_backgroundImageCenter
                                  ];
    
    return woodenStringImage;
}

+ (UIImage *)woodenButtonImageWithBackground:(UIImage *)backgroundImage
                         glowingSunkenString:(NSString *)_string
                                    fontName:(NSString *)_fontName
                                    fontSize:(CGFloat)_fontSize
					   backgroundImageCenter:(CGPoint)_backgroundImageCenter;
{
    UIFont *theFont = [UIFont fontWithName:_fontName
									  size:_fontSize];
	
	NSMutableAttributedString *theAttributedString = [self mutableAttributedStringWithString:_string
                                                                                        font:theFont
                                                                                       color:[UIColor colorWithWhite:1.00 alpha:0.8]];
	
	UIImage *woodenStringImage = [self recessedImageFromAttributedString:theAttributedString
                                                       innerShadowOffset:CGSizeMake(0.0,-1.0)
                                                   innerShadowBlurRadius:1.0
                                                        innerShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]
                                                       outerShadowOffset:CGSizeMake(0.0,0.0)
                                                   outerShadowBlurRadius:8.0
                                                        outerShadowColor:[UIColor colorWithWhite:1.0 alpha:1.0]
                                                         backgroundImage:backgroundImage
												   backgroundImageCenter:_backgroundImageCenter
                                  ];
    
    return woodenStringImage;
}

+ (UIImage *)tileImageWithBackground:(UIImage *)backgroundImage
                 typicalSunkenString:(NSString *)_string
                            fontName:(NSString *)_fontName
                            fontSize:(float)_fontSize
               backgroundImageCenter:(CGPoint)_backgroundImageCenter;
{
    UIFont *theFont = [UIFont fontWithName:_fontName
									  size:_fontSize];
	
	NSMutableAttributedString *theAttributedString = [self mutableAttributedStringWithString:_string
                                                                                        font:theFont
                                                                                       color:[UIColor colorWithWhite:0.0 alpha:0.4]];
	
	UIImage *recessedStringImage = [self recessedImageFromAttributedString:theAttributedString
                                                         innerShadowOffset:CGSizeMake(0.0,-2.0)
                                                     innerShadowBlurRadius:3.0
                                                          innerShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]
                                                         outerShadowOffset:CGSizeMake(0.0,-1.0)
                                                     outerShadowBlurRadius:0.0
                                                          outerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.55]
                                                           backgroundImage:backgroundImage
													 backgroundImageCenter:_backgroundImageCenter
                                    ];
    
    return recessedStringImage;
}



# pragma mark - Convenience Methods

// this tiles the texture to the size of the string, and then "cuts out" the
// text from this tiled texture
+ (UIImage *)drawString:(NSString *)string
       withTiledTexture:(UIImage *)textureImage
               fontName:(NSString *)fontName
               fontSize:(CGFloat)fontSize;
{
    return [self tileBackgroundImage:textureImage
                         toImageSize:CGSizeZero
                   andMaskWithString:string
                            fontName:fontName
                            fontSize:fontSize
                createTexturedString:YES];
}


// this tiles the texture to the size of the string, and then creates a mask
// from the string (basically the opposite of the method above)
+ (UIImage *)tileBackgroundImage:(UIImage *)backgroundImage
                     toImageSize:(CGSize)requestedSize
               andMaskWithString:(NSString *)maskString
                        fontName:(NSString *)maskFont
                        fontSize:(CGFloat)maskFontSize;
{
    return [self tileBackgroundImage:backgroundImage
                         toImageSize:requestedSize
                   andMaskWithString:maskString
                            fontName:maskFont
                            fontSize:maskFontSize
                createTexturedString:NO];
}




// this is pretty much exactly the same as drawing the string directly with the
// desired font and color
+ (UIImage *)imageWithString:(NSString *)string
             fontName:(NSString *)fontName
             fontSize:(CGFloat)fontSize
            fontColor:(UIColor *)fontColor;
{
    return  [self imageWithString:string
                               fontName:fontName
                               fontSize:fontSize
                              fontColor:fontColor
                      innerShadowOffset:CGSizeZero
                  innerShadowBlurRadius:0.0
                       innerShadowColor:nil
                      outerShadowOffset:CGSizeZero
                  outerShadowBlurRadius:0.0
                       outerShadowColor:nil];
}

// this draws the text with the desired font and color, but also allows for an
// inner and outer shadow
+ (UIImage *)imageWithString:(NSString*)_string
                          fontName:(NSString*)_fontName
                          fontSize:(float)_fontSize
                         fontColor:(UIColor *)_fontColor
                 innerShadowOffset:(CGSize)_innerOffset
             innerShadowBlurRadius:(CGFloat)_innerBlurRadius
                  innerShadowColor:(UIColor *)_innerShadowColor
                 outerShadowOffset:(CGSize)_outerOffset
             outerShadowBlurRadius:(CGFloat)_outerBlurRadius
                  outerShadowColor:(UIColor *)_outerShadowColor;
{
	UIFont *theFont = [UIFont fontWithName:_fontName
									  size:_fontSize];
	
	NSMutableAttributedString *theAttributedString = [self mutableAttributedStringWithString:_string
                                                                                        font:theFont
                                                                                       color:_fontColor];
	
	UIImage *image = [self recessedImageFromAttributedString:theAttributedString
                                           innerShadowOffset:_innerOffset
                                       innerShadowBlurRadius:_innerBlurRadius
                                            innerShadowColor:_innerShadowColor
                                           outerShadowOffset:_outerOffset
                                       outerShadowBlurRadius:_outerBlurRadius
                                            outerShadowColor:_outerShadowColor
                                             backgroundImage:nil
									   backgroundImageCenter:CGPointMake(0.5,0.5)];
	
	return image;
}

// method that takes an attributed string and uses no gradient in the text fill,
// but allows for inner and outer shadow adjustment, background image, and a
// customized center on the background image
+ (UIImage *)recessedImageFromAttributedString:(NSAttributedString *)attributedText
                             innerShadowOffset:(CGSize)_innerOffset
                         innerShadowBlurRadius:(CGFloat)_innerBlurRadius
                              innerShadowColor:(UIColor *)_innerShadowColor
                             outerShadowOffset:(CGSize)_outerOffset
                         outerShadowBlurRadius:(CGFloat)_outerBlurRadius
                              outerShadowColor:(UIColor *)_outerShadowColor
                               backgroundImage:(UIImage *)_backgroundImage
						 backgroundImageCenter:(CGPoint)_backgroundImageCenter;
{
    return [self recessedImageFromAttributedString:attributedText
                                 innerShadowOffset:_innerOffset
                             innerShadowBlurRadius:_innerBlurRadius
                                  innerShadowColor:_innerShadowColor
                                 outerShadowOffset:_outerOffset
                             outerShadowBlurRadius:_outerBlurRadius
                                  outerShadowColor:_outerShadowColor
                         gradientFillStartingColor:nil
                           gradientFillEndingColor:nil
                             gradientFillDirection:EPNoGradient
                                   backgroundImage:_backgroundImage
                             backgroundImageCenter:_backgroundImageCenter];
}

// same as above, but allows for a gradient fill of the text
+ (UIImage *)recessedImageFromString:(NSString *)string
                                font:(UIFont *)font
                           textColor:(UIColor *)textColor
                   innerShadowOffset:(CGSize)_innerOffset
               innerShadowBlurRadius:(CGFloat)_innerBlurRadius
                    innerShadowColor:(UIColor *)_innerShadowColor
                   outerShadowOffset:(CGSize)_outerOffset
               outerShadowBlurRadius:(CGFloat)_outerBlurRadius
                    outerShadowColor:(UIColor *)_outerShadowColor
           gradientFillStartingColor:(UIColor *)_gradientFillStartColor
             gradientFillEndingColor:(UIColor *)_gradientFillEndColor
               gradientFillDirection:(EPLinearGradientDirectionEnum)_gradientFillDirection
                     backgroundImage:(UIImage *)_backgroundImage
               backgroundImageCenter:(CGPoint)_backgroundImageCenter;
{
    NSMutableAttributedString *mutAttrString = [self mutableAttributedStringWithString:string
                                                                                  font:font
                                                                                 color:textColor];
    return [self recessedImageFromAttributedString:mutAttrString
                                 innerShadowOffset:_innerOffset
                             innerShadowBlurRadius:_innerBlurRadius
                                  innerShadowColor:_innerShadowColor
                                 outerShadowOffset:_outerOffset
                             outerShadowBlurRadius:_outerBlurRadius
                                  outerShadowColor:_outerShadowColor
                         gradientFillStartingColor:_gradientFillStartColor
                           gradientFillEndingColor:_gradientFillEndColor
                             gradientFillDirection:_gradientFillDirection
                                   backgroundImage:_backgroundImage
                             backgroundImageCenter:_backgroundImageCenter];
}

#pragma mark - Drawing Routine

// modified from http://cocoawithlove.com/2009/09/creating-alpha-masks-from-text-on.html
// and from http://stackoverflow.com/questions/2765537/

// this is the routine to use for creating "cut out" text or for creating
// "masked" text
+ (UIImage *)tileBackgroundImage:(UIImage *)backgroundImage
                     toImageSize:(CGSize)requestedSize
               andMaskWithString:(NSString *)maskString
                        fontName:(NSString *)maskFont
                        fontSize:(CGFloat)maskFontSize
            createTexturedString:(BOOL)shouldCreateTexturedString;
{
    // important note!  this method won't work correctly unless the correct
    // opaque options are set for UIGraphicsBeginImageContextWithOptions.  The
    // beginning of the context for the mask needs to have an opaque option
    // of YES in order for the mask to be applied at all, and the beginning
    // of the context for the masked image needs to have an opaque option
    // of NO in order to preserve transparency (unless you want black where
    // the image is supposed to be transparent)
    
    
    // set the font type and size
    UIFont *textFont = [UIFont fontWithName:maskFont size:maskFontSize];
    CGSize textSize = [maskString sizeWithFont:textFont];
    
    
    // calculate the draw point for the text given the requested size
    CGFloat drawPointX = 0.0;
    CGFloat drawPointY = 0.0;
    
    CGFloat drawWidth = requestedSize.width;
    CGFloat drawHeight = requestedSize.height;
    if (textSize.width > drawWidth) drawWidth = textSize.width;
    if (textSize.height > drawHeight) drawHeight = textSize.height;
    
    drawPointX = (drawWidth - textSize.width)/2.0;
    drawPointY = (drawHeight - textSize.height)/2.0;
    
    CGRect drawRect = CGRectMake(0, 0, drawWidth, drawHeight);
    CGSize drawSize = CGSizeMake(drawWidth,drawHeight);
    CGPoint drawPoint = CGPointMake(drawPointX, drawPointY);
    
    
    // begin the new image context
    UIGraphicsBeginImageContextWithOptions(drawSize,YES,0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    if (shouldCreateTexturedString) {
        [[UIColor blackColor] setFill];
    } else {
        // fill the image with white.  any pixels from the background image that
        // are in the areas with white pixels will not be masked out
        
        [[UIColor whiteColor] setFill];
    }
    CGContextFillRect(context, drawRect);
    
    
    // draw the text upside-down, in black, to use as the mask.  pixels from
    // the background image in these areas (the text) will be rendered as
    // transparent pixels in the final masked image
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, drawRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (shouldCreateTexturedString) {
        [[UIColor whiteColor] setFill];
    } else {
        [[UIColor blackColor] setFill];
    }
    [maskString drawAtPoint:drawPoint withFont:textFont];
    CGContextRestoreGState(context);
    
    
    // create an image mask from what we've drawn so far
    CGImageRef alphaMask = CGBitmapContextCreateImage(context);
    UIImage *alphaMaskImage = [UIImage imageWithCGImage:alphaMask];
    CFRelease(alphaMask);
    UIGraphicsEndImageContext();
    
    
    // tile the background image to the appropriate size.  the mask and the
    // tiled background image are now the same size.
    CGSize tileSize = requestedSize;
    if ((! requestedSize.width) || (! requestedSize.height)) {
        tileSize = drawSize;
    }
    UIImage *tiledBackgroundImage = [self tiledImageUsingTilingImage:backgroundImage
                                                                size:tileSize];
    
    
    UIImage *maskedImage = [self maskBackgroundImage:tiledBackgroundImage
                                      usingImageMask:alphaMaskImage];
    return maskedImage;
}


// most customizable method: takes an attributed string, and every single
// modifiable attribute supported in this codebase (except masking) is available
// as a parameter
+ (UIImage *)recessedImageFromAttributedString:(NSAttributedString *)attributedText
                             innerShadowOffset:(CGSize)_innerOffset
                         innerShadowBlurRadius:(CGFloat)_innerBlurRadius
                              innerShadowColor:(UIColor *)_innerShadowColor
                             outerShadowOffset:(CGSize)_outerOffset
                         outerShadowBlurRadius:(CGFloat)_outerBlurRadius
                              outerShadowColor:(UIColor *)_outerShadowColor
                     gradientFillStartingColor:(UIColor *)_gradientFillStartColor
                       gradientFillEndingColor:(UIColor *)_gradientFillEndColor
                         gradientFillDirection:(EPLinearGradientDirectionEnum)_gradientFillDirection
                               backgroundImage:(UIImage *)_backgroundImage
						 backgroundImageCenter:(CGPoint)_backgroundImageCenter;
{
	CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) attributedText);
    CGFloat ascent;
    CGFloat descent;
    CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
    
    // this actually is accurate and does take descenders into account, but
    // you need to be careful, because the descenders draw *below* the point
    // at which you draw if you draw at a point.
    CGFloat height = ascent+ceil(descent);
    
    CGFloat textWidth = width + (2*abs(_outerOffset.width)) + (2*_outerBlurRadius);
    CGFloat textHeight = height + (2*abs(_outerOffset.height)) + (2*_outerBlurRadius);
    CGSize textSize = CGSizeMake(ceil(textWidth),ceil(textHeight));
	
	UIBezierPath *textBezierPath = [self pathForCTLine:line];
    CFRelease(line);
	
	
	
	
	

    UIGraphicsBeginImageContextWithOptions(textSize,NO,0.0);
	
    // transform bezier path up and right so that the shadow is still visible;
    // we apply this offset manually to shadow in the fillWithInnerShadow…:::
	// method, because shadows don't respect applied transformations
	CGMutablePathRef transformedPath = CGPathCreateMutable();
    CGFloat affineTransformX = abs(_outerOffset.width) + _outerBlurRadius;
    CGFloat affineTransformY = 1.0 + ceil(descent) + abs(_outerOffset.height) + _outerBlurRadius;
	CGAffineTransform pathTransform = CGAffineTransformMakeTranslation(affineTransformX, affineTransformY);
	CGPathAddPath(transformedPath, &pathTransform, [textBezierPath CGPath]);
	UIBezierPath *transformedBezierPath = [UIBezierPath bezierPathWithCGPath:transformedPath];
    CFRelease(transformedPath);
	
	CGContextRef dropShadowContext = UIGraphicsGetCurrentContext();
	CGContextSaveGState(dropShadowContext);
	CGContextBeginTransparencyLayer (dropShadowContext, NULL);
	[[UIColor whiteColor] set];
	
	CGContextSetShadowWithColor(dropShadowContext,
								_outerOffset,
								_outerBlurRadius,
								[_outerShadowColor CGColor]);
	
	
	[transformedBezierPath fill];
	
	CGContextRestoreGState(dropShadowContext);
	CGContextSaveGState(dropShadowContext);
	
	CGContextSetBlendMode(dropShadowContext,kCGBlendModeClear);
	[transformedBezierPath fill];
	
	CGContextEndTransparencyLayer (dropShadowContext);
	
	CGContextRestoreGState(dropShadowContext);
	
	UIImage *dropShadowImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
	
	
	
	
	

    UIGraphicsBeginImageContextWithOptions(textSize,NO,0.0);
	
	[transformedBezierPath applyTransform:CGAffineTransformMakeTranslation(0,0)];
	
    if (_gradientFillStartColor && _gradientFillEndColor && (_gradientFillDirection != EPNoGradient)) {
        [transformedBezierPath fillWithSimpleLinearGradientWithStartingColor:_gradientFillStartColor
                                                                 endingColor:_gradientFillEndColor
                                                           gradientDirection:_gradientFillDirection];
    } else {
        CGColorRef theColorRef = (CGColorRef)CFAttributedStringGetAttribute((CFAttributedStringRef)attributedText, 0, kCTForegroundColorAttributeName, NULL);
        
        if (theColorRef != NULL) {
            [[UIColor colorWithCGColor:theColorRef] set];
            [transformedBezierPath fill];
        }
    }
    
    if (_innerBlurRadius != 0 && (! CGSizeEqualToSize(_innerOffset, CGSizeMake(0,0)))) {
        [transformedBezierPath fillWithInnerShadowUsingShadowOffset:_innerOffset
                                                         shadowBlur:_innerBlurRadius
                                                        shadowColor:_innerShadowColor
                                                    transformOffset:CGSizeMake(0,0)];
    }
	
	
	UIImage *imageToDraw = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
	
	
	
	
	
	
	
	
	

    UIGraphicsBeginImageContextWithOptions(textSize,NO,0.0);
	CGContextRef flippedContext = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(flippedContext, 0, imageToDraw.size.height);
	CGContextScaleCTM(flippedContext, 1.0, -1.0);
	
	[dropShadowImage drawAtPoint:CGPointMake(0,0)];
	[imageToDraw drawAtPoint:CGPointMake(0,0)];
	
    
    UIImage *recessedStringImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext(); 
    
    
    
    UIImage *imageToReturn = nil;
    
    if (_backgroundImage ) {
        CGSize tileSize = [_backgroundImage size];
        CGSize stringImageSize = [recessedStringImage size];
        
        CGSize finalImageSize = tileSize;
        UIImage *finalBackgroundImage = _backgroundImage;
        if ((tileSize.width < stringImageSize.width) || (tileSize.height < stringImageSize.height)) {
            finalBackgroundImage = [self tiledImageUsingTilingImage:_backgroundImage size:stringImageSize];
            finalImageSize = stringImageSize;
        }
        
        UIGraphicsBeginImageContextWithOptions(finalImageSize,NO,0.0);
        
        [finalBackgroundImage drawAtPoint:CGPointMake(0,0)];
        
		// CTFramesetterSuggestFrameSizeWithConstraints seems to way overestimate
		// the vertical height needed to accommodate the text, so it messes up the
		// algorithm to position the text in the center of the background; fix with
		// a constant
        CGFloat stringX = finalImageSize.width*_backgroundImageCenter.x - stringImageSize.width/2.0;
        CGFloat stringY = finalImageSize.height*_backgroundImageCenter.y - stringImageSize.height/2.0;
		[recessedStringImage drawAtPoint:CGPointMake(ceil(stringX),ceil(stringY))];
        
        UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext(); 
        
        imageToReturn = combinedImage;
    } else {
        imageToReturn = recessedStringImage;
    }
    

    return imageToReturn;
}

@end
