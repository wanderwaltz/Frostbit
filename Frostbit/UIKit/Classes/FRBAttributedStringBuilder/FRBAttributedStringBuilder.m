//
//  FRBAttributedStringBuilder.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 22/04/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBAttributedStringBuilder.h"

#pragma mark -
#pragma mark Private typedefs

// Used internally by the parser
typedef void (^FRBAttributedStringParserCompletion)
              (NSString *plainText, NSArray *parsedStyles, NSDictionary *inlineStyles);


#pragma mark -
#pragma mark Static constants

// Used internally by the parser
static NSString * const kParsedStyleRangeKey = @"range";
static NSString * const kParsedStyleNameKey  = @"name";


#pragma mark -
#pragma mark FRBAttributedStringBuilder private

@interface FRBAttributedStringBuilder()
{
@private
    NSMutableDictionary *_allStyles;
}

@end


#pragma mark -
#pragma mark FRBAttributedStringBuilder implementation

@implementation FRBAttributedStringBuilder

+ (id) defaultBuilder
{
    static dispatch_once_t predicate = 0;
    __strong static id instance = nil;
    
    dispatch_once(&predicate,
                  ^{
                      instance = [self new];
                  });
    
    return instance;
}


- (id) stringWithString: (NSString *) string
{
    __block NSMutableAttributedString *attributed = nil;
    
    [self parseString: string 
      completionBlock:
     ^(NSString *plainText, NSArray *parsedStyles, NSDictionary *inlineStyles) 
    {
        attributed = [[NSMutableAttributedString alloc] initWithString: plainText];
        
        for (NSDictionary *style in parsedStyles)
        {
            [self addStyleWithName:  style[ kParsedStyleNameKey]
                             range: [style[kParsedStyleRangeKey] rangeValue]
                          toString: attributed
                      inlineStyles: inlineStyles];
        }
    }];
        
    return attributed;
}


#pragma mark -
#pragma mark styles

- (void) clearRegisteredStyles
{
    [[self allStyles] removeAllObjects];
}


- (void) setFontName: (NSString *) fontName
                size: (CGFloat) size 
        forStyleName: (NSString *) style
{
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)fontName, size, NULL);
    
    if (font != nil)
    {
        NSMutableDictionary *attributes = [self styleForName: style];
        [attributes setObject: (__bridge id)font 
                       forKey: (__bridge id)kCTFontAttributeName];
        
        CFRelease(font);
    }
}


- (void) setFontColor: (UIColor  *) color
         forStyleName: (NSString *) style
{
    [self setColor: color 
      forAttribute: kCTForegroundColorAttributeName 
             style: style];
}


- (void) setUnderlineColor: (UIColor  *) color
              forStyleName: (NSString *) style
{
    [self setColor: color 
      forAttribute: kCTUnderlineColorAttributeName 
             style: style];
}


- (void) setUnderlineStyle: (CTUnderlineStyle) underlineStyle
              forStyleName: (NSString *) style
{
    NSMutableDictionary *attributes = [self styleForName: style];
    [attributes setObject: @(underlineStyle)
                   forKey: (__bridge id)kCTUnderlineStyleAttributeName];
}


- (void) setAttributes: (NSDictionary *) newAttributes
          forStyleName: (NSString *) style
{
    if (newAttributes.count > 0)
    {
        NSMutableDictionary *attributes = [self styleForName: style];
        [attributes addEntriesFromDictionary: newAttributes];
    }
}


- (void) addStyleWithName: (NSString *) style
                    range: (NSRange) range
                 toString: (NSMutableAttributedString *) string
{
    [self addStyleWithName: style 
                     range: range 
                  toString: string
              inlineStyles: nil];
}


#pragma mark -
#pragma mark private: registering styles

- (void) setColor: (UIColor *) color
     forAttribute: (CFStringRef) attribute
            style: (NSString *) style
{
    if (color != nil)
    {
        CGColorRef cgColor = CGColorCreateCopy(color.CGColor);
        
        NSMutableDictionary *attributes = [self styleForName: style];
        [attributes setObject: (__bridge id)cgColor
                       forKey: (__bridge id)attribute];
        CGColorRelease(cgColor);
    }
}


#pragma mark -
#pragma mark private: styles

- (NSMutableDictionary *) allStyles
{
    if (_allStyles == nil)
    {
        _allStyles = [NSMutableDictionary dictionary];
    }
    
    return _allStyles;
}


/* Creates the dictionary if style key is not present in styles,
   so return value is never nil.
 */
- (NSMutableDictionary *) styleForName: (id) style
{
    if (style == nil) style = [NSNull null];
    
    NSMutableDictionary *allStyles  = [self allStyles];
    NSMutableDictionary *dictionary =  allStyles[style];
    
    if (dictionary == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
        allStyles[style] = dictionary;
    }
    
    return dictionary;
}


- (void) addStyleWithName: (NSString *) style
                    range: (NSRange) range
                 toString: (NSMutableAttributedString *) string
             inlineStyles: (NSDictionary *) inlineStyles
{
    // Inline styles always have precedence 
    NSDictionary *attributes = inlineStyles[style];
    
    if (attributes == nil)
    {
        attributes = [self styleForName: style];
    }
    
    NSAssert(attributes != nil, @"");
    [string addAttributes: attributes range: range];
}


#pragma mark -
#pragma mark private: token translation

/* These two static dictionaries are used to simply
   map some tokens (words) from the format string to 
   the constants used in code.
 */

+ (NSDictionary *) attributeNameTranslation
{
    static dispatch_once_t predicate = 0;
    __strong static NSDictionary *dictionary = nil;
    
    dispatch_once(&predicate, ^{
        dictionary = 
        [NSDictionary dictionaryWithObjectsAndKeys:
         (__bridge id)kCTUnderlineStyleAttributeName, @"underline", nil];
    });
    return dictionary;
}


+ (NSDictionary *) attributeValueTranslation
{
    static dispatch_once_t predicate = 0;
    __strong static NSDictionary *dictionary = nil;
    
    dispatch_once(&predicate, ^{
        
        dictionary =
        @{
          @"single" : @(kCTUnderlineStyleSingle),
           @"thick" : @(kCTUnderlineStyleThick),
          @"double" : @(kCTUnderlineStyleDouble),
            @"none" : @(kCTUnderlineStyleNone)
        };
    });
    return dictionary;
}



#pragma mark -
#pragma mark private: parser

// A simple hex string parser (RGB without alpha)
- (UIColor *) colorFromString: (NSString *) string
{
    NSScanner *scanner = [NSScanner scannerWithString: string];
    
    unsigned hex = 0;
    
    if (![scanner scanHexInt: &hex]) return nil;
    
    int r = (hex >> 16) & 0xFF;
    int g = (hex >>  8) & 0xFF;
    int b = (hex      ) & 0xFF;
    
    return [UIColor colorWithRed: r / 255.0f
                           green: g / 255.0f
                            blue: b / 255.0f
                           alpha: 1.0f];
}


/* This method parses inline style definitions. Does not throw
   exceptions, trying to recover from errors automatically, 
   ignoring malformed attributes.
 */
- (NSDictionary *) parseInlineStyle: (NSString *) style
{
    /* These attributes are processed in a special way,
       other are just translated with translation mapping.
     */
    static NSString * const kFontAttribute  =  @"font";
    static NSString * const kSizeAttribute  =  @"size";
    static NSString * const kColorAttribute = @"color";
    static NSString * const kUnderlineColorAttribute = @"underlineColor";
    
    NSString *inlineFontName = nil;
    CGFloat   inlineFontSize = 0;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSCharacterSet      *trimSet    = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    
    /* Processing block for color values. This same code is used multiple
       times, so it could be extracted to a separate method. To avoid passing
       the local variables as parameters to this method, we create a local
       block which has direct access to these variables.
     */
    void (^processColor)(NSString *colorString, CFStringRef attributeName) = 
                       ^(NSString *colorString, CFStringRef attributeName) {
        UIColor *color = [self colorFromString: colorString];
        
        if (color != nil)
        {
            CGColorRef cgColor = CGColorCreateCopy(color.CGColor);
            [attributes setObject: (__bridge id)cgColor 
                           forKey: (__bridge id)attributeName];
            CGColorRelease(cgColor);
        }
    };
    
    
    /* Style components are comma-separated pairs of 'name=value'
     */
    NSArray *styleComponents = [style componentsSeparatedByString: @","];

    for (NSString *definition in styleComponents)
    {
        NSArray *components = [definition componentsSeparatedByString: @"="];
        
        if (components.count == 2)
        {
            NSString *attributeName  = components[0];
            NSString *attributeValue = components[1];
            
            attributeName  = [attributeName  stringByTrimmingCharactersInSet: trimSet];
            attributeValue = [attributeValue stringByTrimmingCharactersInSet: trimSet];
            
            if (attributeName.length == 0) continue;
            
            // 'font' attribute
            if ([attributeName isEqualToString: kFontAttribute])
            {
                inlineFontName = attributeValue;
            }
            
            // 'size' attribute
            else if ([attributeName isEqualToString: kSizeAttribute])
            {
                inlineFontSize = [attributeValue floatValue];
            }
            
            // 'color' attribute
            else if ([attributeName isEqualToString: kColorAttribute])
            {
                processColor(attributeValue, kCTForegroundColorAttributeName);
            }
            
            // 'underlineColor' attribute
            else if ([attributeName isEqualToString: kUnderlineColorAttribute])
            {
                processColor(attributeValue, kCTUnderlineColorAttributeName);
            }
            else
            {
                /* First, check for other known attributes which do not require
                   special interpretation of their values.
                 */
                NSString *translatedName = 
                [[self class] attributeNameTranslation][attributeName];
                
                id translatedValue = 
                [[self class] attributeValueTranslation][attributeValue];
                
                // Support undefined attributes by passing the exact name/value we've received
                if (translatedName  == nil) translatedName  = attributeName;
                if (translatedValue == nil) translatedValue = attributeValue;
                
                attributes[translatedName] = translatedValue;
            }
        }
        else // Assume attributes with no values are bool attributes
        {
            NSString *attributeName = components[0];
            attributeName = [attributeName stringByTrimmingCharactersInSet: trimSet];

            if (attributeName.length > 0)
            {
                attributes[attributeName] = @YES;
            }
        }
    }
    
    /* We have an inline font set, but do not know which exact 
       attributes were set in the format string. Creating a CTFont
       instance requires both name and size, so we apply default
       values for the missing parameters
     */
    if ((inlineFontSize > 0) || (inlineFontName.length > 0))
    {
        if (inlineFontName.length == 0) inlineFontName = @"Helvetica";
        if (inlineFontSize <= 0) inlineFontSize = 12;
        
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)inlineFontName, 
                                              inlineFontSize, NULL);
        
        if (font != nil)
        {
            [attributes setObject: (__bridge id)font 
                           forKey: (__bridge id)kCTFontAttributeName];
            
            CFRelease(font);
        }
    }
    
    return attributes;
}


/*! A low-level per-symbol finite state machine parsing the format string.
   Does throw exceptions if something goes wrong.
 
   Inline style definitions are parsed in the +parseInlineStyle: method
 */
- (void) parseString: (NSString *) string
     completionBlock: (FRBAttributedStringParserCompletion) block
{
    static const NSInteger kState_Scan             = 0;
    static const NSInteger kState_PossibleEndStyle = 1;
    static const NSInteger kState_StartStyleName   = 2;
    static const NSInteger kState_EndStyleName     = 3;
    static const NSInteger kState_Scan_Escape      = 4;
    
    
    /* plainText and parsedStyles will contain the result
     */
    NSMutableString     *plainText    = [NSMutableString stringWithCapacity: string.length];
    NSMutableArray      *parsedStyles = [NSMutableArray array];
    NSMutableDictionary *inlineStyles = [NSMutableDictionary dictionary];
    
    
    NSMutableArray *styleNamesStack  = [NSMutableArray array];
    NSMutableArray *styleRangesStack = [NSMutableArray array];
    
    __block NSMutableString *styleName = nil;
    __block NSInteger state = kState_Scan;

    
    [string enumerateSubstringsInRange: NSMakeRange(0, string.length)
                               options: NSStringEnumerationByComposedCharacterSequences 
                            usingBlock:
     ^(NSString *cChar, NSRange cCharRange, NSRange enclosingRange, BOOL *stop) 
     {
         switch (state)
         {
            /* Default state, scans for all characters, and appends
               non-special characters to the plain text string.
             */
             case kState_Scan:
             {
                 if ([cChar isEqualToString: @"["])
                 {
                     /* If we encounter a [, we have two possibilities:
                        start style:  [style] 
                       or end style: [/style]
                      */
                     state = kState_PossibleEndStyle;
                     styleName = [NSMutableString string];
                 }
                 else if ([cChar isEqualToString: @"]"])
                 {
                     [self throwParseException: @"Unexpected ']'"
                                    atPosition: cCharRange.location];
                 }
                 else if ([cChar isEqualToString: @"\\"])
                 {
                     /* If we encounter a slash character \, we
                        check if this was an escape sequence.
                      */
                     state = kState_Scan_Escape;
                 }
                 else [plainText appendString: cChar];
             } break;
                 
                 
             /* Assuming the previous scanned symbol was a slash \ character,
                we check the next one to see if an escape sequence \[ or \] has
                been formed.
              */
             case kState_Scan_Escape:
             {
                 if (![cChar isEqualToString: @"["] &&
                     ![cChar isEqualToString: @"]"])
                 {
                     /* It was neither \[ nor \] case, just add the
                        slash to the plain text (so we do not require
                        the slash character itself to be escaped to
                        show itself in the resulting string)
                      */
                     [plainText appendString: @"\\"];
                 }
                 
                 /* In any case add the current character to the plain text.
                  */
                 [plainText appendString: cChar];
                 state = kState_Scan;                 
             } break;
                 
                 
                 
            /* We know a [ has already been encountered,
               need to check if the next character would be /
             */
             case kState_PossibleEndStyle:
             {
                 if ([cChar isEqualToString: @"/"])
                 {
                     /* The next character was / indeed. 
                        So we are parsing an end style situation: [/style]
                      */
                     state = kState_EndStyleName;
                 }
                 else if ([cChar isEqualToString: @"["] ||
                          [cChar isEqualToString: @"]"])
                 {
                     [self throwParseException: 
                      [NSString stringWithFormat: 
                       @"Expected style specifier, got '%@'", cChar]
                                    atPosition: cCharRange.location];
                 }
                 else
                 {
                     /* The next character was not /, we
                        are parsing a start style situation: [style]
                      */
                     state = kState_StartStyleName;
                     [styleName appendString: cChar];
                 }
             } break;
                 
                 
                 
                 
            /* We are parsing [style] situation, appending style
               name characters to styleName var until we encounter an ]
             */
             case kState_StartStyleName:
             {
                 if ([cChar isEqualToString: @"]"])
                 {
                     state = kState_Scan;
                     
                     /* Parse inline style info 
                      
                        Inline styles syntax is the following:
                      
                        [name:attribute1=value1, attribute2=value2, ...]
                      
                        I.e. the style specifier should contain
                        no more than one colon : character,
                        which divides the style name from the style definition.
                      */
                     NSArray *styleComponents = [styleName componentsSeparatedByString: @":"];
                     
                     if (styleComponents.count > 1)
                     {
                         /* We have a colon character in the style specifier,
                            check that there is only one.
                          */
                         if (styleComponents.count == 2)
                         {
                             /* We'll be ignoring the trailing whitespaces,
                                so store the set in the local var for 
                                trimming both of the components
                              */
                             NSCharacterSet *trimSet = 
                             [NSCharacterSet whitespaceAndNewlineCharacterSet];
                             
                             
                             
                             styleName = [[styleComponents[0]
                                           stringByTrimmingCharactersInSet: trimSet] 
                                          mutableCopy];
                             
                             if (styleName.length == 0)
                             {
                                 [self throwParseException: @"Style name should not be empty"
                                                atPosition: cCharRange.location];
                             }
                             
                             
                             NSString *inlineStyle = 
                             [styleComponents[1]
                              stringByTrimmingCharactersInSet: trimSet];
                             
                             NSDictionary *attributes = [self parseInlineStyle: inlineStyle];
                             
                             /* If attributes have not been properly parsed, do nothing.
                              */
                             if (attributes != nil)
                             {
                                 inlineStyles[styleName] = attributes;
                             }
                         }
                         else
                         {
                             [self throwParseException: @"Multiple ':' in a style specifier"
                                            atPosition: NSNotFound];
                         }
                     }
                     
                     [styleNamesStack addObject: styleName]; styleName = nil;
                     [styleRangesStack addObject: 
                      [NSValue valueWithRange: NSMakeRange(plainText.length, 0)]];
                     
                     styleName = nil;
                 }
                 else if ([cChar isEqualToString: @"["])
                 {
                     [self throwParseException: @"Unexpected '[' in style specifier"
                                    atPosition: cCharRange.location];
                 }
                 else
                 {
                     [styleName appendString: cChar];
                 }
             } break;
                 
                 
                 
                 
            /* We are parsing [/style] situation, appending style
               name characters to styleName var until we encounter an ]
             */
             case kState_EndStyleName:
             {
                 /* When we've encountered a ], assume we've finished parsing
                    the style name. Try to close the style by checking if the
                    closing style name is the same as the last opening style 
                    name.
                  
                    Styles are expected to conform to the bracket-like rules
                    of inclusion, so intersections like that: ([]) are allowed,
                    but intersections like that: ([)] are not.
                  */
                 if ([cChar isEqualToString: @"]"])
                 {
                     state = kState_Scan;
                     
                     NSString *lastStyleName = [styleNamesStack lastObject];
                     
                     /* Everything is fine, the closing style name is the same 
                        as the last opening style name. Store the style to the
                        parsedStyles array. We insert the style to the first
                        position in the array, so the innermost styles would
                        be applied last.
                      */
                     if ([lastStyleName isEqualToString: styleName])
                     {
                         NSRange range = [[styleRangesStack lastObject] rangeValue];
                         range.length  = plainText.length - range.location;
                         
                         [parsedStyles insertObject:
                          @{
                               kParsedStyleNameKey  : styleName,
                               kParsedStyleRangeKey : [NSValue valueWithRange: range]
                          } atIndex: 0];
                         
                         [styleNamesStack  removeLastObject];
                         [styleRangesStack removeLastObject];
                         
                         styleName = nil;
                     }
                     else
                     {
                         /* We have not found the corresponding style name in our
                            open styles stack, so raise an exception.
                          */
                         if (lastStyleName.length > 0)
                         {
                             [self throwParseException: 
                              [NSString stringWithFormat:
                               @"Inconsistent style open/close statements: got [/%@] while last open style was [%@]", styleName, lastStyleName]
                                            atPosition: cCharRange.location];   
                         }
                         else
                         {
                             [self throwParseException: 
                              [NSString stringWithFormat:
                               @"Inconsistent style open/close statements: got [/%@] with no corresponding [%@] statements", styleName, styleName]
                                            atPosition: cCharRange.location];
                         }
                     }
                 }
                 else
                 {
                     /* We have not encounered a ] character, so assume we are
                        still parsing the style name.
                      */
                     [styleName appendString: cChar];
                 }
             } break;
                 
            
             // That obviously should never happen
             default: NSAssert(NO, @"Unknown parser state");
         }
     }];
    
    
    /* We may need to perform some processing after the last character
     */
    switch (state)
    {
        case kState_Scan_Escape:
        {
            /* The last character of the string was a slash \, so
               that was surely not an escape sequence.
             */
            [plainText appendString: @"\\"];
        } break;
            
        default: break;
    }
    
    
    if (styleNamesStack.count > 0)
    {
        plainText    = nil;
        parsedStyles = nil;
        
        NSString *name =  [styleNamesStack lastObject];
        
        [self throwParseException: 
         [NSString stringWithFormat: 
          @"Unexpected end of string found while parsing style [%@]", name]
                       atPosition: string.length];
    }
    
    if (styleName != nil)
    {
        plainText    = nil;
        parsedStyles = nil;
        
        [self throwParseException:  
         [NSString stringWithFormat: 
          @"Unexpected end of string found while parsing style [%@]", styleName]
                       atPosition: string.length];
    }

    
    if (block) block(plainText, parsedStyles, inlineStyles);
}


#pragma mark -
#pragma mark private: error handling

- (void) throwParseException: (NSString *) reason
                  atPosition: (NSUInteger) index
{
    NSString *exceptionReason = nil;
    
    if (index != NSNotFound)
        exceptionReason = [NSString stringWithFormat: 
                           @"Error parsing string at pos [%ld]: %@", (long)index, reason];
    else
        exceptionReason = [NSString stringWithFormat: 
                           @"Error parsing string: %@", reason];
    
    [[NSException exceptionWithName: NSInvalidArgumentException 
                             reason: exceptionReason
                           userInfo: nil] raise];
}

@end
