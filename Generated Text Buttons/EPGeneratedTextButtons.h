//
//  EPGeneratedTextButtons.h
//
//  Created by Simone Manganelli on 7/08/11.
//

#import <Foundation/Foundation.h>
#import "UIBezierPath+EPAdditions.h"

@interface EPGeneratedTextButtons : NSObject {
	
}

#pragma mark - Support Methods

+ (NSMutableAttributedString *)mutableAttributedStringWithString:(NSString *)string
                                                            font:(UIFont *)font
                                                           color:(UIColor *)theColor;

+ (UIImage *)tiledImageUsingTilingImage:(UIImage *)tilingImage
                                   size:(CGSize)desiredSize;

+ (UIImage *)maskBackgroundImage:(UIImage *)backgroundImage
                  usingImageMask:(UIImage *)maskImage;

// unused in any of the other methods, but could be useful anyway
+ (UIImage *)imageFromAttributedString:(NSAttributedString *)attributedText;





#pragma mark - Example Button Image Creation Methods

+ (UIImage *)woodenImageWithFloatingString:(NSString *)_string;

+ (UIImage *)imageWithWhiteFloatingString:(NSString *)_string
                          backgroundImage:(UIImage *)backgroundImage;

+ (UIImage *)buttonImageWithBackground:(UIImage *)backgroundImage
                   typicalSunkenString:(NSString *)_string
                              fontName:(NSString *)_fontName
                              fontSize:(CGFloat)_fontSize
                             fontColor:(UIColor *)_fontColor
                 backgroundImageCenter:(CGPoint)_backgroundImageCenter;

+ (UIImage *)buttonImageWithBackground:(UIImage *)backgroundImage
                   glowingSunkenString:(NSString *)_string
                              fontName:(NSString *)_fontName
                              fontSize:(CGFloat)_fontSize
                 backgroundImageCenter:(CGPoint)_backgroundImageCenter;

+ (UIImage *)woodenButtonImageWithBackground:(UIImage *)backgroundImage
                         typicalSunkenString:(NSString *)_string
                                    fontName:(NSString *)_fontName
                                    fontSize:(CGFloat)_fontSize
					   backgroundImageCenter:(CGPoint)_backgroundImageCenter;

+ (UIImage *)woodenButtonImageWithBackground:(UIImage *)backgroundImage
                         glowingSunkenString:(NSString *)_string
                                    fontName:(NSString *)_fontName
                                    fontSize:(CGFloat)_fontSize
					   backgroundImageCenter:(CGPoint)_backgroundImageCenter;

+ (UIImage *)tileImageWithBackground:(UIImage *)backgroundImage
                 typicalSunkenString:(NSString *)_string
                            fontName:(NSString *)_fontName
                            fontSize:(float)_fontSize
               backgroundImageCenter:(CGPoint)_backgroundImageCenter;





# pragma mark - Convenience Methods

// this tiles the texture to the size of the string, and then "cuts out" the
// text from this tiled texture
+ (UIImage *)drawString:(NSString *)string
       withTiledTexture:(UIImage *)textureImage
               fontName:(NSString *)fontName
               fontSize:(CGFloat)fontSize;



// this tiles the texture to the size of the string, and then creates a mask
// from the string (basically the opposite of the method above)
+ (UIImage *)tileBackgroundImage:(UIImage *)backgroundImage
                     toImageSize:(CGSize)requestedSize
               andMaskWithString:(NSString *)maskString
                        fontName:(NSString *)maskFont
                        fontSize:(CGFloat)maskFontSize;



// this is pretty much exactly the same as drawing the string directly with the
// desired font and color
+ (UIImage *)imageWithString:(NSString *)string
             fontName:(NSString *)fontName
             fontSize:(CGFloat)fontSize
            fontColor:(UIColor *)fontColor;



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





#pragma mark - Drawing Routine

// this is the routine to use for creating "cut out" text or for creating
// "masked" text
+ (UIImage *)tileBackgroundImage:(UIImage *)backgroundImage
                     toImageSize:(CGSize)requestedSize
               andMaskWithString:(NSString *)maskString
                        fontName:(NSString *)maskFont
                        fontSize:(CGFloat)maskFontSize
            createTexturedString:(BOOL)shouldCreateTexturedString;



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

@end
