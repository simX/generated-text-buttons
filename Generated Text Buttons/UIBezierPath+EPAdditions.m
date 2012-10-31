//
//  UIBezierPath+EPAdditions.m
//
//  Created by Simone Manganelli on July 6, 2011.
//

#import "UIBezierPath+EPAdditions.h"


@implementation UIBezierPath (EPAdditions)

- (void)fillWithInnerShadowUsingShadowOffset:(CGSize)shadowOffset
								  shadowBlur:(CGFloat)shadowBlurRadius
								 shadowColor:(UIColor *)shadowColor
							 transformOffset:(CGSize)transformOffset;
{
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
	
	CGSize calculatedShadowOffset = shadowOffset;
	CGFloat radius = shadowBlurRadius;
    // the extra 2.0 pixels in both directions is to make sure that the shadows aren't cut off
	CGRect bounds = CGRectInset(self.bounds, -(ABS(calculatedShadowOffset.width) + radius + 2.0), -(ABS(calculatedShadowOffset.height) + radius + 2.0));
	
	
	// transforms to text (applied outside this method)are not applied to shadows,
    // so we have to manually apply translation transforms to the shadow as well;
    // other transforms on the text are unsupported with shadows, because this
    // code can't accommodate for that
	calculatedShadowOffset.width += transformOffset.width;
	calculatedShadowOffset.height += transformOffset.height;
	
	CGContextSetShadowWithColor(currentContext, calculatedShadowOffset, shadowBlurRadius, [shadowColor CGColor]);
	
	UIBezierPath *drawingPath = [UIBezierPath bezierPathWithRect:bounds];
	[drawingPath setUsesEvenOddFillRule:YES];
	[drawingPath appendPath:self];
	
	[self addClip];
	[[UIColor whiteColor] set];
	[drawingPath fill];
	
    CGContextRestoreGState(currentContext);
}

- (void)fillWithSimpleLinearGradientWithStartingColor:(UIColor *)startColor
                                          endingColor:(UIColor *)endColor
                                    gradientDirection:(EPLinearGradientDirectionEnum)gradientDirection;
{
    if (gradientDirection != EPNoGradient) {
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSaveGState(currentContext);
        
        UIBezierPath *drawingPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [drawingPath setUsesEvenOddFillRule:YES];
        [drawingPath appendPath:self];
        
        [self addClip];
        
        CGColorRef colorRef[] = { [startColor CGColor], [endColor CGColor] };
        CFArrayRef colors = CFArrayCreate(NULL, (const void**)colorRef, sizeof(colorRef) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
        
        CGPoint gradStartPoint = CGPointZero;
        CGPoint gradEndPoint = CGPointZero;
        
        switch (gradientDirection) {
            case EPLeftToRight:
                gradStartPoint = CGPointMake(self.bounds.origin.x, 0.0);
                gradEndPoint = CGPointMake(self.bounds.size.width + self.bounds.origin.x, 0.0);
                break;
                
            case EPRightToLeft:
                gradStartPoint = CGPointMake(self.bounds.size.width + self.bounds.origin.x, 0.0);
                gradEndPoint = CGPointMake(self.bounds.origin.x, 0.0);
                break;
                
            case EPTopToBottom:
                gradStartPoint = CGPointMake(0.0, self.bounds.size.height + self.bounds.origin.y);
                gradEndPoint = CGPointMake(0.0, self.bounds.origin.y);
                break;
                
            case EPBottomToTop:
            default:
                gradStartPoint = CGPointMake(0.0, self.bounds.origin.y);
                gradEndPoint = CGPointMake(0.0, self.bounds.size.height + self.bounds.origin.y);
                break;
        }
        
        CGContextDrawLinearGradient(currentContext, gradient, gradStartPoint, gradEndPoint, 0);
        
        CGColorSpaceRelease(colorSpace);
        CFRelease(colors);
        CFRelease(gradient);
        CGContextRestoreGState(currentContext);
    }
}

@end
