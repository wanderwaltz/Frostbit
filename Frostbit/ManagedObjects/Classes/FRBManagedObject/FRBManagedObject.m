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
#pragma mark Static constants

static   id dynamicGetter(__strong id self, SEL _cmd);
static void dynamicSetter(__strong id self, SEL _cmd, id value);

static NSString * const kPropertyAttributeDynamic = @"D";

static const void * const kAssociationKeySelectorMapping = &kAssociationKeySelectorMapping;


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
+ (NSMutableDictionary *) dynamicSelectorPropertyNameMapping
{
    NSMutableDictionary *mapping = objc_getAssociatedObject(self, kAssociationKeySelectorMapping);
    
    if (mapping == nil)
    {
        mapping = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self, kAssociationKeySelectorMapping, mapping,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return mapping;
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

    const char *charName = property_getName(property);
    NSString *stringName = [NSString stringWithCString: charName
                                              encoding: NSASCIIStringEncoding];

    // Provide default getter/setter names if none specified in the property attributes
    if (getterName == nil)
        getterName = [self defaultGetterNameForPropertyName: stringName];
    
    if (setterName == nil)
        setterName = [self defaultSetterNameForPropertyName: stringName];
    
    // Map getter/setter names to property name (useful for custom setters/getters)
    NSMutableDictionary *selectorPropertyNameMapping = [self dynamicSelectorPropertyNameMapping];
    
    selectorPropertyNameMapping[getterName] = stringName;
    selectorPropertyNameMapping[setterName] = stringName;
    
    // By this time we should already have non-nil getter/setter names and type encoding
    NSAssert(getterName   != nil, @"");
    NSAssert(setterName   != nil, @"");
    NSAssert(typeEncoding != nil, @"");
    
    // Add instance methods for the current property
    NSString *getterTypeEncoding =
    [NSString stringWithFormat: @"%@@:", typeEncoding];
    
    NSString *setterTypeEncoding =
    [NSString stringWithFormat: @"v@:%@", typeEncoding];
    
    class_addMethod(self, NSSelectorFromString(getterName), (IMP)dynamicGetter,
                    [getterTypeEncoding cStringUsingEncoding: NSASCIIStringEncoding]);
    
    class_addMethod(self, NSSelectorFromString(setterName), (IMP)dynamicSetter,
                    [setterTypeEncoding cStringUsingEncoding: NSASCIIStringEncoding]);
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


/*! Returns a key in the _managedObjectRawData dictionary which will be used for setting/getting property value with a given selector. By default we check the dynamicSelectorPropertyNameMapping for the property name and use the value stored there as the key.
 */
+ (NSString *) rawDataKeyForAccessor: (SEL) selector
{
    NSMutableDictionary *selectorPropertyNameMapping =
    [self dynamicSelectorPropertyNameMapping];
    
    NSString *propertyName = selectorPropertyNameMapping[NSStringFromSelector(selector)];
    
    return propertyName;
}

@end


#pragma mark -
#pragma mark Dynamic accessor implementations

/*! Dynamic implementation for property getter of FRBManagedObject.
 */
static id dynamicGetter(FRBManagedObject *receiver, SEL _cmd)
{
    assert([receiver isKindOfClass: [FRBManagedObject class]]);
    
    NSString *key = [[receiver class] rawDataKeyForAccessor: _cmd];
    
    assert(key != nil);
    
    id value = receiver.managedObjectRawData[key];
    
    if ([value isKindOfClass: [NSNull class]])
        value = nil;
    
    return value;
}


/*! Dynamic implementation for property setter of FRBManagedObject.
 */
static void dynamicSetter(FRBManagedObject *receiver, SEL _cmd, id value)
{
    assert([receiver isKindOfClass: [FRBManagedObject class]]);
    
    NSString *key = [[receiver class] rawDataKeyForAccessor: _cmd];
    
    assert(key != nil);
    
    if (value == nil) value = [NSNull null];
    
    ((NSMutableDictionary *)receiver.managedObjectRawData)[key] = value;
}
