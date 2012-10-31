//
//  EPViewController.m
//  Generated Text Buttons
//
//  Created by Simone Manganelli on 20/10/12.
//

#import "EPViewController.h"
#import "EPGeneratedTextButtons.h"

@interface EPViewController ()

@end

@implementation EPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage *firstImage = [EPGeneratedTextButtons tileBackgroundImage:[UIImage imageNamed:@"Shapes.jpg"]
                                                          toImageSize:[[self imageViewOne] frame].size
                                                    andMaskWithString:@"Shapes"
                                                             fontName:@"Optima-ExtraBlack"
                                                             fontSize:36.0];
    [[self imageViewOne] setImage:firstImage];
    
    UIImage *secondImage = [EPGeneratedTextButtons drawString:@"No descenders"
                                             withTiledTexture:[UIImage imageNamed:@"Shapes.jpg"]
                                                     fontName:@"Zapfino"
                                                     fontSize:24.0];
    [[self imageViewTwo] setImage:secondImage];
    
    UIImage *thirdImage = [EPGeneratedTextButtons woodenButtonImageWithBackground:[UIImage imageNamed:@"Shapes.jpg"]
                                                              typicalSunkenString:@"Iñtërnâtiônàlizætiøn"
                                                                         fontName:@"Helvetica"
                                                                         fontSize:36.0 backgroundImageCenter:CGPointMake(0.5,0.5)];
    
    [[self imageViewThree] setImage:thirdImage];
    
    UIImage *fourthImage = [EPGeneratedTextButtons woodenButtonImageWithBackground:[UIImage imageNamed:@"Shapes.jpg"]
                                                               glowingSunkenString:@"不十分なテキストを翻訳した。"
                                                                          fontName:@"Futura-Medium"
                                                                          fontSize:36.0 backgroundImageCenter:CGPointMake(0.5,0.65)];
    
    [[self imageViewFour] setImage:fourthImage];
    
    UIImage *fifthImage = [EPGeneratedTextButtons woodenImageWithFloatingString:@"ترجمة سيئة النص."];
    
    [[self imageViewFive] setImage:fifthImage];
    
    UIImage *sixthImage = [EPGeneratedTextButtons imageWithWhiteFloatingString:@"Слабо преведен текст."
                                                                   backgroundImage:[UIImage imageNamed:@"Shapes.jpg"]];
    
    [[self imageViewSix] setImage:sixthImage];
    
   
    UIImage *seventhImage = [EPGeneratedTextButtons recessedImageFromString:@"♪⌘㎡🔫😲🚧" font: [UIFont fontWithName:@"TrebuchetMS-Bold" size:48.0] textColor:[UIColor blackColor] innerShadowOffset:CGSizeMake(0.0,-1.0) innerShadowBlurRadius:2.0 innerShadowColor:[UIColor blackColor] outerShadowOffset:CGSizeMake(-3.0,5.0) outerShadowBlurRadius:4.0 outerShadowColor:[UIColor greenColor] gradientFillStartingColor:[UIColor purpleColor] gradientFillEndingColor:[UIColor orangeColor] gradientFillDirection:EPRightToLeft backgroundImage:nil backgroundImageCenter:CGPointMake(0.1,0.9)];
    
    [[self imageViewSeven] setImage:seventhImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
