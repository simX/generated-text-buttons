generated-text-buttons
===================

Generated Text Buttons

EPGeneratedTextButtons is a class designed to create images from text, and various attributes on that text.  It supports a massive number of different attributes that you can customize, aimed at removing the need for assets that have text in them.  Assets with text are a pain to tweak, to localize, and to keep track of, and using EPGeneratedTextButtons, you can easily create these assets in code and change them on the fly without having to do a round-trip through a graphics program.  And it's super simple to localize these images, because if you're already using NSLocalizedString macros, then you'll get the proper localized text on the asset automatically.

EPGeneratedTextButtons supports the following attributes:

- font
- font size
- text fill color
- text fill gradient (start and end color, in the four cardinal directions)
- inner shadow (color, offset, blur radius)
- outer shadow (color, offset, blur radius)
- background image
- center point of background image
- stenciled/masked text (opaque everywhere except for text glyphs)
- clipped text (transparent everywhere except for text glyphs)

EPGeneratedTextButtons also works perfectly fine with:

- non-ASCII characters
- Unicode characters
- Japanese, Arabic, and many other non-Roman languages

There are a number of example methods that simplify the number of possible parameters to give you some pre-determined text styles: recessed/sunken strings, floating strings, wooden gradient fill.  Or you can use the two methods with the massive number of parameters to customize your generated images to your liking.

All methods take a number of parameters and simply return a UIImage object.

Some example generated images, which are displayed in the test application:

![Example Image 1](image1.png "Example Image 1")

![Example Image 2](image1.png "Example Image 2")

![Example Image 3](image1.png "Example Image 3")

![Example Image 4](image1.png "Example Image 4")

![Example Image 5](image1.png "Example Image 5")

![Example Image 6](image1.png "Example Image 6")

![Example Image 7](image1.png "Example Image 7")

### Known Issues

1. Inner shadows will generate black areas if font ligatures overlap in the vector paths.  Most fonts don't do this, but some, notably Arabic fonts, will display this behavior.  Simply do not use inner shadows for these fonts, by passing 0 for the inner shadow blur radius and CGSizeZero for the offset.  Or fix the code yourself you lazy bum!

2. Emoji, being bitmap graphics, do not work with these routines.  Emoji will be blank, because they do not provide vector path equivalents.  Sorry. 😥