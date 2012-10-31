//
//  UIBezierPath+EPAdditions.h
//
//  Created by Simone Manganelli on July 6, 2011.
//

#import <UIKit/UIBezierPath.h>

typedef enum EPLinearGradientDirectionEnum {
    EPNoGradient,
	EPLeftToRight,
	EPRightToLeft,
	EPTopToBottom,
    EPBottomToTop,
} EPLinearGradientDirectionEnum;

@interface UIBezierPath (EPAdditions)

- (void)fillWithInnerShadowUsingShadowOffset:(CGSize)shadowOffset
								  shadowBlur:(CGFloat)shadowBlurRadius
								 shadowColor:(UIColor *)shadowColor
							 transformOffset:(CGSize)transformOffset;

- (void)fillWithSimpleLinearGradientWithStartingColor:(UIColor *)startColor
                                          endingColor:(UIColor *)endColor
                                    gradientDirection:(EPLinearGradientDirectionEnum)gradientDirection;

@end
