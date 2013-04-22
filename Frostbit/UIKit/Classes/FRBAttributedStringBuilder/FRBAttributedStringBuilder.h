//
//  FRBAttributedStringBuilder.h
//  Frostbit
//
//  Created by Egor Chiglintsev on 22/04/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark FRBAttributedStringBuilder interface

/*! This class is used to parse the provided NSString and generate
    and attributed string instance with the proper attributes without
    needing to specify these in code.
 */
@interface FRBAttributedStringBuilder : NSObject


/*! This method is used to construct an attributed string instance
   with attributes specified either inline in the string parameter,
   or using the styles registered in code.
 
   For registered styles refer the 'styles' section of the file.
 
   Styles can be defined inline with the parameter string.
 
   Style definition syntax is the following: 
   [name: attribute1=value1, attribute2=value2, ...]Text[/name]
 
   Style is defined for the whole string so the same name could
   be used later: [name]Other text[/name] with the same resulting
   style.
 
   Note that if you redefine the style:
   [name: attribute=value][/name] ... [name: attribute=other][/name]
 
   with the same name, ALL of the occurrences of this style in the
   string would be redefined, i.e. the last style definition is 
   applied to all occurrences of style [name] within the string.
 

   The following attributes are supported:
    'font' - denotes the name of the font to use
        Example: font=Marker Felt Wide
        
        Note that for the best performance you should use PostScript
        font names suitable for creating CTFont instances.
 
    'size' - denotes the font size
        Example: size=16
 
    'color' - denotes the text color (RGB hex value)
        Example: color=FF0000 - red color
 
    'underline' - underline style
        Example: underline=single
 
        Supported styles are: none, single, double, thick
 
    'underlineColor' - color of the underline (RGB hex)
        Example: underlineColor=00FF00 - green color
 
 
    Styles could be contained within each other:
    [outer][inner][/inner][/outer], 
    
    but cannot intersect, so this will generate an exception:
    [outer][inner][/outer][/inner]
 
   
   Error handling:
    This method throws an NSInvalidArgumentException when the
    provided string could not be parsed. Note that the inline
    style parsing tries to silently restore from the possible
    errors, ignoring any unknown styles or malformed key/value
    pairs.
 
 
   Note: to use square brackets in the resulting string, these
         should be escaped with a slash character. Keep in mind
         that NSString literals also require slash character to
         be escaped itself, so you use strings like this in code:
         @"\\[square brackets\\]".
        
         \[ and \] escapes do not work in context of style definition,
         so this string will generate an error: @"[\\[brackets\\]]"
 
   Returns NSAttributedString instance, return type is set to id
   for comatibility with NSString's selector with the same name.
 */
+ (id) stringWithString: (NSString *) string;


#pragma mark styles

/*! You can either specify the attributes directly in the string, or
   register these attributes as styles and use them instead.
 
   For example, if you want to create a style with the 'Arial' font
   of size 16 with red color, and name this style 'MyStyle', you
   call the following two methods:

   [FRBAttributedStringBuilder setFontName: @"Arial"
                              size: 16
                      forStyleName: @"MyStyle"];
 
   [FRBAttributedStringBuilder setFontColor: [UIColor redColor]
                       forStyleName: @"MyStyle"];
 
    Then you use this style in the format string as following: 
      @"[MyStyle]some Arial 16 red text[/MyStyle]"
 */

+ (void) setFontName: (NSString *) fontName 
                size: (CGFloat) size 
        forStyleName: (NSString *) style;

+ (void) setFontColor: (UIColor  *) color
         forStyleName: (NSString *) style;

+ (void) setUnderlineColor: (UIColor  *) color
              forStyleName: (NSString *) style;

+ (void) setUnderlineStyle: (CTUnderlineStyle) underlineStyle
              forStyleName: (NSString *) style;


/*! This method copies all attributes specified in the dictionary
   to the style with specified name.
 */
+ (void) setAttributes: (NSDictionary *) attributes
          forStyleName: (NSString *) style;


/*! This method applies a style with the given name to the
   provided mutable attributed string instance.
 */
+ (void) addStyleWithName: (NSString *) style 
                    range: (NSRange) range
                 toString: (NSMutableAttributedString *) string;


/*! Removes all registered styles
 */
+ (void) clearRegisteredStyles; 

@end
