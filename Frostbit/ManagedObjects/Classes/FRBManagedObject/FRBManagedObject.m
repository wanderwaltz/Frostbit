//
//  FRBManagedObject.m
//  Frostbit
//
//  Created by Egor Chiglintsev on 02.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "FRBManagedObject.h"
#import <objc/runtime.h>


#pragma mark -
#pragma mark Private typedefs

typedef enum : NSInteger
{
    FRBManagedObjectPropertyTypeUnsupported,
    FRBManagedObjectPropertyTypeId,
    
    FRBManagedObjectPropertyTypeChar,
    FRBManagedObjectPropertyTypeInt,
    FRBManagedObjectPropertyTypeShort,
    FRBManagedObjectPropertyTypeLong,
    FRBManagedObjectPropertyTypeLongLong,
    
    FRBManagedObjectPropertyTypeUnsignedChar,
    FRBManagedObjectPropertyTypeUnsignedInt,
    FRBManagedObjectPropertyTypeUnsignedShort,
    FRBManagedObjectPropertyTypeUnsignedLong,
    FRBManagedObjectPropertyTypeUnsignedLongLong,
    
    FRBManagedObjectPropertyTypeBool,
    
    FRBManagedObjectPropertyTypeFloat,
    FRBManagedObjectPropertyTypeDouble,
    
    FRBManagedObjectPropertyTypeNSRange
    
    
} FRBManagedObjectPropertyType;


#pragma mark -
#pragma mark Getter/Setter implementation forward declarations

static id   objectGetter(__strong id self, SEL _cmd);
static void objectSetter(__strong id self, SEL _cmd, id value);

static NSRange rangeGetter(__strong id self, SEL _cmd);
static void    rangeSetter(__strong id self, SEL _cmd, NSRange value);


static bool boolGetter(__strong id self, SEL _cmd);
static void boolSetter(__strong id self, SEL _cmd, bool value);

static double doubleGetter(__strong id self, SEL _cmd);
static void   doubleSetter(__strong id self, SEL _cmd, double value);

static float floatGetter(__strong id self, SEL _cmd);
static void  floatSetter(__strong id self, SEL _cmd, float value);


static char charGetter(__strong id self, SEL _cmd);
static void charSetter(__strong id self, SEL _cmd, char value);

static short shortGetter(__strong id self, SEL _cmd);
static void  shortSetter(__strong id self, SEL _cmd, short value);

static int  intGetter(__strong id self, SEL _cmd);
static void intSetter(__strong id self, SEL _cmd, int value);

static long longGetter(__strong id self, SEL _cmd);
static void longSetter(__strong id self, SEL _cmd, long value);

static long long longLongGetter(__strong id self, SEL _cmd);
static void      longLongSetter(__strong id self, SEL _cmd, long long value);


static unsigned char unsignedCharGetter(__strong id self, SEL _cmd);
static void          unsignedCharSetter(__strong id self, SEL _cmd, unsigned char value);

static unsigned short unsignedShortGetter(__strong id self, SEL _cmd);
static void           unsignedShortSetter(__strong id self, SEL _cmd, unsigned short value);

static unsigned int unsignedIntGetter(__strong id self, SEL _cmd);
static void         unsignedIntSetter(__strong id self, SEL _cmd, unsigned int value);

static unsigned long unsignedLongGetter(__strong id self, SEL _cmd);
static void          unsignedLongSetter(__strong id self, SEL _cmd, unsigned long value);

static unsigned long long unsignedLongLongGetter(__strong id self, SEL _cmd);
static void               unsignedLongLongSetter(__strong id self, SEL _cmd, unsigned long long value);



#pragma mark -
#pragma mark Static constants

static NSString * const kPropertyAttributeDynamic = @"D";

static const void * const kKeyPropertyNameForSelector = &kKeyPropertyNameForSelector;
static const void * const kKeyPropertyTypeForSelector = &kKeyPropertyTypeForSelector;

#pragma mark -
#pragma mark FRBManagedObject private

@interface FRBManagedObject()
{
    NSMutableDictionary *_managedObjectRawData;
}

@end


#pragma mark -
#pragma mark FRBManagedObject implementation

@implementation FRBManagedObject

#pragma mark -
#pragma mark properties

- (NSMutableDictionary *) managedObjectRawData
{
    if (_managedObjectRawData == nil)
    {
        _managedObjectRawData = [NSMutableDictionary dictionary];
    }
    
    return _managedObjectRawData;
}


#pragma mark -
#pragma mark NSObject

+ (void) initialize
{
    // Iterate the list of properties of the class and add implementations
    // for @dynamic properties.
    unsigned int propertiesCount = 0;
    objc_property_t  *properties = class_copyPropertyList(self, &propertiesCount);
    
    for (unsigned int i = 0; i < propertiesCount; ++i)
    {
        // Converting runtime attributes to NSString and NSArray instances
        // instead of working directly with C strings does provide some
        // overhead, but this whole procedure will be called once per class
        // so it should not be so much of a problem.
        const char *charAttributes = property_getAttributes(properties[i]);
        NSString *stringAttributes = [NSString stringWithCString: charAttributes
                                                        encoding: NSASCIIStringEncoding];
        
        // Attributes are comma-separated, so we divide them to a NSArray for easier
        // access and code readability
        NSArray *attributes = [stringAttributes componentsSeparatedByString: @","];
        
        // Only provide the implementation for property if it is declared as @dynamic
        if ([attributes containsObject: kPropertyAttributeDynamic])
        {
            [self provideDynamicImplementationForProperty: properties[i]
                                           withAttributes: attributes];
        }
    }
    
    free(properties);
}


#pragma mark -
#pragma mark dynamic properties

/*! Returns a NSMutableDictionary which is used internally for mapping accessor names to property names. This is useful for properties with custom accessor names like `@property (getter = isValid) BOOL valid;`. This dictionary will contain a value `valid` for key `isValid` for the provided example. 
 
 This method creates a new NSMutableDictionary and attaches it to the receiver class using objc_setAssociatedObject if it has not been done before.
 */
+ (NSMutableDictionary *) dynamicPropertyNameForSelectorMapping
{
    NSMutableDictionary *mapping = objc_getAssociatedObject(self, kKeyPropertyNameForSelector);
    
    if (mapping == nil)
    {
        mapping = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self, kKeyPropertyNameForSelector, mapping,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return mapping;
}


/// A shortcut for dynamicPropertyNameForSelectorMapping value for a given selector
+ (NSString *) dynamicPropertyNameForSelector: (SEL) selector
{
    return [self dynamicPropertyNameForSelectorMapping][NSStringFromSelector(selector)];
}


/*! Provides the dynamic implementation (accessor methods) to the given property with attributes array created in initialize method of the receiver class.
 */
+ (void) provideDynamicImplementationForProperty: (objc_property_t) property
                                  withAttributes: (NSArray *) attributes
{
    NSString *getterName   = nil;
    NSString *setterName   = nil;
    NSString *typeEncoding = nil;
    
    // Iterate the attributes array and get getter/setter names and type encoding.
    [self getPropertyAttributes: attributes
                  outGetterName: &getterName
                  outSetterName: &setterName
                outTypeEncoding: &typeEncoding];
    
    NSAssert(typeEncoding != nil, @"");
    
    FRBManagedObjectPropertyType propertyType =
    [self dynamicPropertyTypeForTypeEncoding: typeEncoding];
    
    // Don't provide accessor methods for unsupported property types,
    // even if we added some default accessors, app still would probably crash.
    if (propertyType != FRBManagedObjectPropertyTypeUnsupported)
    {
        const char *charName = property_getName(property);
        NSString *stringName = [NSString stringWithCString: charName
                                                  encoding: NSASCIIStringEncoding];
        
        // Provide default getter/setter names if none specified in the property attributes
        if (getterName == nil)
            getterName = [self defaultGetterNameForPropertyName: stringName];
        
        if (setterName == nil)
            setterName = [self defaultSetterNameForPropertyName: stringName];
        
        // By this time we should already have non-nil getter/setter names and type encoding
        NSAssert(getterName   != nil, @"");
        NSAssert(setterName   != nil, @"");
        
        // Map getter/setter names to property name (useful for custom setters/getters)
        NSMutableDictionary *dynamicPropertyNameForSelector =
        [self dynamicPropertyNameForSelectorMapping];
        
        dynamicPropertyNameForSelector[getterName] = stringName;
        dynamicPropertyNameForSelector[setterName] = stringName;
        
        // This is needed since type encoding for Objective-C classes
        // includes the class name, so for NSString the type encoding
        // would be @"NSString", but we do not want to include the
        // class name into type encoding for accessor methods or the
        // KVC will not treat the class as KVC-compliant.
        if ([typeEncoding characterAtIndex: 0] == '@')
            typeEncoding = [typeEncoding substringToIndex: 1];
        
        // Add instance methods for the current property
        NSString *getterTypeEncoding =
        [NSString stringWithFormat: @"%@@:", typeEncoding];
        
        NSString *setterTypeEncoding =
        [NSString stringWithFormat: @"v@:%@", typeEncoding];
        
        // For some reason making a single implementation of a getter and a setter which would
        // work with all data types seems not possible. So I had to implement a separate getter/setter
        // for each type of property. This macro is used in the switch below so I don't have to write
        // a long list of cases. They are essentially the same and differ only in the type names.
        // This macro is undefined after the switch ends.
        #define SYNTHESIZE_CASE(CapitalizedType, LowercaseType)                                 \
        case FRBManagedObjectPropertyType##CapitalizedType:                                     \
        {                                                                                       \
            class_addMethod(self, NSSelectorFromString(getterName), (IMP)LowercaseType##Getter, \
                            [getterTypeEncoding cStringUsingEncoding: NSASCIIStringEncoding]);  \
                                                                                                \
            class_addMethod(self, NSSelectorFromString(setterName), (IMP)LowercaseType##Setter, \
                            [setterTypeEncoding cStringUsingEncoding: NSASCIIStringEncoding]);  \
        } break
        
        switch (propertyType)
        {
            SYNTHESIZE_CASE(Bool, bool);
                
            SYNTHESIZE_CASE(Char,     char);
            SYNTHESIZE_CASE(Int,      int);
            SYNTHESIZE_CASE(Short,    short);
            SYNTHESIZE_CASE(Long,     long);
            SYNTHESIZE_CASE(LongLong, longLong);
                
            SYNTHESIZE_CASE(UnsignedChar,     unsignedChar);
            SYNTHESIZE_CASE(UnsignedInt,      unsignedInt);
            SYNTHESIZE_CASE(UnsignedShort,    unsignedShort);
            SYNTHESIZE_CASE(UnsignedLong,     unsignedLong);
            SYNTHESIZE_CASE(UnsignedLongLong, unsignedLongLong);
                
            SYNTHESIZE_CASE(Float,  float);
            SYNTHESIZE_CASE(Double, double);
                
            case FRBManagedObjectPropertyTypeNSRange:
            {
                class_addMethod(self, NSSelectorFromString(getterName), (IMP)rangeGetter,
                                [getterTypeEncoding cStringUsingEncoding: NSASCIIStringEncoding]);
                
                class_addMethod(self, NSSelectorFromString(setterName), (IMP)rangeSetter,
                                [setterTypeEncoding cStringUsingEncoding: NSASCIIStringEncoding]);
            } break;
                
                
            default:
            {
                class_addMethod(self, NSSelectorFromString(getterName), (IMP)objectGetter,
                                [getterTypeEncoding cStringUsingEncoding: NSASCIIStringEncoding]);
                
                class_addMethod(self, NSSelectorFromString(setterName), (IMP)objectSetter,
                                [setterTypeEncoding cStringUsingEncoding: NSASCIIStringEncoding]);
            } break;
        }
    
        // Undefine the macro as it is not needed anymore
        #undef SYNTHESIZE_CASE
    }
}


+ (FRBManagedObjectPropertyType) dynamicPropertyTypeForTypeEncoding: (NSString *) typeEncoding
{
    NSAssert(typeEncoding.length > 0, @"");
    
    static NSDictionary *supportedTypeEncodings = nil;

    if (supportedTypeEncodings == nil)
    {
        supportedTypeEncodings =
        @{
          @"@" : @(FRBManagedObjectPropertyTypeId),
          
          @"c" : @(FRBManagedObjectPropertyTypeChar),
          @"i" : @(FRBManagedObjectPropertyTypeInt),
          @"s" : @(FRBManagedObjectPropertyTypeShort),
          @"l" : @(FRBManagedObjectPropertyTypeLong),
          @"q" : @(FRBManagedObjectPropertyTypeLongLong),
          @"C" : @(FRBManagedObjectPropertyTypeUnsignedChar),
          @"I" : @(FRBManagedObjectPropertyTypeUnsignedInt),
          @"S" : @(FRBManagedObjectPropertyTypeUnsignedShort),
          @"L" : @(FRBManagedObjectPropertyTypeUnsignedLong),
          @"Q" : @(FRBManagedObjectPropertyTypeUnsignedLongLong),
          
          @"f" : @(FRBManagedObjectPropertyTypeFloat),
          @"d" : @(FRBManagedObjectPropertyTypeDouble),
          
          @"B" : @(FRBManagedObjectPropertyTypeBool),
          
          @"{_NSRange=II}" : @(FRBManagedObjectPropertyTypeNSRange)
        };
    }
    
    if ([typeEncoding characterAtIndex: 0] == '@')
        typeEncoding = [typeEncoding substringToIndex: 1];
    
    NSNumber *value = supportedTypeEncodings[typeEncoding];
    
    if (value != nil) return [value integerValue];
    else return FRBManagedObjectPropertyTypeUnsupported;
}


+ (void) getPropertyAttributes: (NSArray *) attributes
                 outGetterName: (__autoreleasing NSString **) getterName
                 outSetterName: (__autoreleasing NSString **) setterName
               outTypeEncoding: (__autoreleasing NSString **) typeEncoding
{
    for (NSString *attribute in attributes)
    {
        // attribute.length shoud generally always be > 0,
        // but for the sake of code safety we have to check
        if (attribute.length > 0)
        {
            switch ([attribute characterAtIndex: 0])
            {
                // Getter name is specified after the 'G' char
                case 'G':
                {
                    if (getterName != nil)
                        *getterName = [attribute substringFromIndex: 1];
                } break;
                    
                // Setter name is specified after the 'S' char
                case 'S':
                {
                    if (setterName != nil)
                        *setterName = [attribute substringFromIndex: 1];
                } break;
                    
                // Type encoding is specified after the 'T' char
                case 'T':
                {
                    if (typeEncoding != nil)
                        *typeEncoding = [attribute substringFromIndex: 1];
                } break;
            }
        }
    }
}


/*! Returns a default getter name for property with a given propertyName. We say that the default getter name is equal to the property name.
 */
+ (NSString *) defaultGetterNameForPropertyName: (NSString *) propertyName
{
    return propertyName;
}


/*! Returns a default setter name for property with a given propertyName. Default setter name consists of the word 'set' with the property name which has its first letter capitalized.
 */
+ (NSString *) defaultSetterNameForPropertyName: (NSString *) propertyName
{
    if (propertyName.length > 1)
    {
        return [NSString stringWithFormat: @"set%c%@:",
                toupper([propertyName characterAtIndex:   0]),
                [propertyName substringFromIndex: 1]];
    }
    else
    {
        return [NSString stringWithFormat: @"set%@:",
                [propertyName uppercaseString]];
    }
}


/*! Returns a key in the _managedObjectRawData dictionary which will be used for setting/getting property value with a given selector. By default we use the dynamicPropertyNameForSelector: result as a key.
 */
+ (NSString *) rawDataKeyForAccessor: (SEL) selector
{
    return [self dynamicPropertyNameForSelector: selector];
}

@end


#pragma mark -
#pragma mark Dynamic accessor implementations

/* All accessor implementations are essentially the same with only return value and parameter type name different, so we use a single macro for synthesizing all of the accessors to reduce copy-pasting of the code.
 
 This macro is undefined later in this file.
 */
#define SYNTHESIZE_ACCESSOR_IMPS(Type, MethodNamePart)                                  \
static void MethodNamePart##Setter(FRBManagedObject *receiver, SEL _cmd, Type value)    \
{                                                                                       \
    assert([receiver isKindOfClass: [FRBManagedObject class]]);                         \
                                                                                        \
    NSString *key = [[receiver class] rawDataKeyForAccessor: _cmd];                     \
                                                                                        \
    assert(key != nil);                                                                 \
                                                                                        \
    NSMutableDictionary *data = (NSMutableDictionary *)receiver.managedObjectRawData;   \
                                                                                        \
    data[key] = @(value);                                                               \
}                                                                                       \
                                                                                        \
static Type MethodNamePart##Getter(FRBManagedObject *receiver, SEL _cmd)                \
{                                                                                       \
    assert([receiver isKindOfClass: [FRBManagedObject class]]);                         \
                                                                                        \
    NSString *key = [[receiver class] rawDataKeyForAccessor: _cmd];                     \
                                                                                        \
    assert(key != nil);                                                                 \
                                                                                        \
    NSMutableDictionary *data = (NSMutableDictionary *)receiver.managedObjectRawData;   \
    return [data[key] MethodNamePart##Value];                                           \
}

SYNTHESIZE_ACCESSOR_IMPS(bool, bool);

SYNTHESIZE_ACCESSOR_IMPS(double, double);
SYNTHESIZE_ACCESSOR_IMPS(float,  float);

SYNTHESIZE_ACCESSOR_IMPS(char,      char);
SYNTHESIZE_ACCESSOR_IMPS(int,       int);
SYNTHESIZE_ACCESSOR_IMPS(short,     short);
SYNTHESIZE_ACCESSOR_IMPS(long,      long);
SYNTHESIZE_ACCESSOR_IMPS(long long, longLong);

SYNTHESIZE_ACCESSOR_IMPS(unsigned char,      unsignedChar);
SYNTHESIZE_ACCESSOR_IMPS(unsigned int,       unsignedInt);
SYNTHESIZE_ACCESSOR_IMPS(unsigned short,     unsignedShort);
SYNTHESIZE_ACCESSOR_IMPS(unsigned long,      unsignedLong);
SYNTHESIZE_ACCESSOR_IMPS(unsigned long long, unsignedLongLong);

// Undefine the macro as it is not needed anymore
#undef SYNTHESIZE_ACCESSOR_IMPS


static void objectSetter(FRBManagedObject *receiver, SEL _cmd, id value)
{
    assert([receiver isKindOfClass: [FRBManagedObject class]]);

    NSString *key = [[receiver class] rawDataKeyForAccessor: _cmd];

    assert(key != nil);
    
    NSMutableDictionary *data = (NSMutableDictionary *)receiver.managedObjectRawData;
    
    if (value == nil) value = [NSNull null];

    data[key] = value;
}

static id objectGetter(FRBManagedObject *receiver, SEL _cmd)
{
    assert([receiver isKindOfClass: [FRBManagedObject class]]);

    NSString *key = [[receiver class] rawDataKeyForAccessor: _cmd];

    assert(key != nil);

    NSMutableDictionary *data = (NSMutableDictionary *)receiver.managedObjectRawData;
    
    id value = data[key];
    
    if ([value isKindOfClass: [NSNull class]]) value = nil;
    
    return value;
}


static void rangeSetter(FRBManagedObject *receiver, SEL _cmd, NSRange value)
{
    assert([receiver isKindOfClass: [FRBManagedObject class]]);
    
    NSString *key = [[receiver class] rawDataKeyForAccessor: _cmd];
    
    assert(key != nil);
    
    NSMutableDictionary *data = (NSMutableDictionary *)receiver.managedObjectRawData;
    
    data[key] = [NSValue valueWithRange: value];
}


static NSRange rangeGetter(FRBManagedObject *receiver, SEL _cmd)
{
    assert([receiver isKindOfClass: [FRBManagedObject class]]);
    
    NSString *key = [[receiver class] rawDataKeyForAccessor: _cmd];
    
    assert(key != nil);
    
    NSMutableDictionary *data = (NSMutableDictionary *)receiver.managedObjectRawData;
    
    id value = data[key];
    
    if (value == nil) return NSMakeRange(NSNotFound, 0);
    else
    {
        assert([value isKindOfClass: [NSValue class]]);
        return [value rangeValue];
    }
}

