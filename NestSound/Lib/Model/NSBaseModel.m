//
//  IMBaseModel.m
//  iMei
//
//  Created by yandi on 15/3/20.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSBaseModelProperty.h"

@interface NSBaseModel()
- (void)setupCachedKeyMapper;
- (void)setupCachedProperties;
@end

#pragma mark - NSArray+NSBaseModel
@interface NSArray (NSBaseModel)
- (NSArray *)modelArrayWithClass:(Class)modelClass;
@end

@implementation NSArray (NSBaseModel)
- (NSArray *)modelArrayWithClass:(Class)modelClass {
    NSMutableArray *modelArray = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [modelArray addObject:[object modelArrayWithClass:modelClass]];
        } else if ([object isKindOfClass:[NSDictionary class]]){
            [modelArray addObject:[[modelClass alloc] initWithJSONDict:object]];
        } else {
            [modelArray addObject:object];
        }
    }
    return modelArray;
}
@end

#pragma mark - NSDictionary+NSBaseModel
@interface NSDictionary (NSBaseModel)
- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass;
@end

@implementation NSDictionary (NSBaseModel)
- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass{
    NSMutableDictionary *modelDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSDictionary class]]) {
            [modelDictionary setObject:[[modelClass alloc] initWithJSONDict:object] forKey:key];
        }else if ([object isKindOfClass:[NSArray class]]){
            [modelDictionary setObject:[object modelArrayWithClass:modelClass] forKey:key];
        }else{
            [modelDictionary setObject:object forKey:key];
        }
    }
    return modelDictionary;
}
@end


@implementation NSBaseModel
static const char *NSBaseModelKeyMapperKey;
static const char *NSBaseModelPropertiesKey;

#pragma mark -init
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupCachedKeyMapper];
        [self setupCachedProperties];
    }
    return self;
}

#pragma mark -initWithJSONDict
- (instancetype)initWithJSONDict:(NSDictionary *)dict {
    self = [self init];
    if (self) {
        [self injectJSONData:dict];
    }
    return self;
}

#pragma mark - NSBaseModel Configuration
- (void)setupCachedKeyMapper {
    if (objc_getAssociatedObject(self.class, &NSBaseModelKeyMapperKey) == nil) {
        NSDictionary *dict = [self modelKeyJSONKeyMapper];
        if (dict.count) {
            objc_setAssociatedObject(self.class, &NSBaseModelKeyMapperKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)setupCachedProperties{
    if (objc_getAssociatedObject(self.class, &NSBaseModelPropertiesKey) == nil) {
        NSMutableDictionary *propertyMap = [NSMutableDictionary dictionary];
        Class class = [self class];
        while (class != [NSObject class]) {
            unsigned int propertyCount;
            objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
            for (unsigned int i = 0; i < propertyCount; i++) {
                objc_property_t property = properties[i];
                const char *propertyName = property_getName(property);
                NSString *name = [NSString stringWithUTF8String:propertyName];
                const char *propertyAttrs = property_getAttributes(property);
                NSString *typeString = [NSString stringWithUTF8String:propertyAttrs];
                NSBaseModelProperty *modelProperty = [[NSBaseModelProperty alloc] initWithName:name typeString:typeString];
                if (!modelProperty.isReadonly) {
                    [propertyMap setValue:modelProperty forKey:modelProperty.name];
                }
            }
            free(properties);
            
            class = [class superclass];
        }
        objc_setAssociatedObject(self.class, &NSBaseModelPropertiesKey, propertyMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSDictionary *)modelKeyJSONKeyMapper{
    return @{};
}

#pragma mark - NSBaseModel Runtime Injection
- (void)injectJSONData:(id)dataObject {
    NSDictionary *keyMapper = objc_getAssociatedObject(self.class, &NSBaseModelKeyMapperKey);
    NSDictionary *properties = objc_getAssociatedObject(self.class, &NSBaseModelPropertiesKey);
    
    if ([dataObject isKindOfClass:[NSArray class]]) {
        NSBaseModelProperty *arrayProperty = nil;
        Class class = NULL;
        for (NSBaseModelProperty *property in [properties allValues]) {
            NSString *valueProtocol = [property.objectProtocols firstObject];
            class = NSClassFromString(valueProtocol);
            if ([valueProtocol isKindOfClass:[NSString class]] && [class isSubclassOfClass:[NSBaseModel class]]) {
                arrayProperty = property;
                break;
            }
        }
        if (arrayProperty && class) {
            id value = [(NSArray *)dataObject modelArrayWithClass:class];
            [self setValue:value forKey:arrayProperty.name];
        }
    } else if ([dataObject isKindOfClass:[NSDictionary class]]) {
        for (NSBaseModelProperty *property in [properties allValues]) {
            NSString *jsonKey = property.name;
            NSString *mapperKey = [keyMapper objectForKey:jsonKey];
            jsonKey = mapperKey ?: jsonKey;
            
            id jsonValue = [dataObject objectForKey:jsonKey];
            id propertyValue = [self valueForProperty:property withJSONValue:jsonValue];
            
            if (propertyValue) {
                [self setValue:propertyValue forKey:property.name];
            } else {
                id resetValue = (property.valueType == NSClassPropertyTypeObject) ? nil : @(0);
                [self setValue:resetValue forKey:property.name];
            }
        }
    }
}

- (id)valueForProperty:(NSBaseModelProperty *)property withJSONValue:(id)value{
    id resultValue = value;
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        resultValue = nil;
    } else {
        if (property.valueType != NSClassPropertyTypeObject) {
            
            if ([value isKindOfClass:[NSString class]]) {
                if (property.valueType == NSClassPropertyTypeInt ||
                    property.valueType == NSClassPropertyTypeUnsignedInt||
                    property.valueType == NSClassPropertyTypeShort||
                    property.valueType == NSClassPropertyTypeUnsignedShort) {
                    resultValue = [NSNumber numberWithInt:[(NSString *)value intValue]];
                }
                if (property.valueType == NSClassPropertyTypeLong ||
                    property.valueType == NSClassPropertyTypeUnsignedLong ||
                    property.valueType == NSClassPropertyTypeLongLong ||
                    property.valueType == NSClassPropertyTypeUnsignedLongLong){
                    resultValue = [NSNumber numberWithLongLong:[(NSString *)value longLongValue]];
                }
                if (property.valueType == NSClassPropertyTypeFloat) {
                    resultValue = [NSNumber numberWithFloat:[(NSString *)value floatValue]];
                }
                if (property.valueType == NSClassPropertyTypeDouble) {
                    resultValue = [NSNumber numberWithDouble:[(NSString *)value doubleValue]];
                }
                if (property.valueType == NSClassPropertyTypeChar) {
                    resultValue = [NSNumber numberWithBool:[(NSString *)value boolValue]];
                }
            }
        } else {
            Class valueClass = property.objectClass;
            if ([valueClass isSubclassOfClass:[NSBaseModel class]] &&
                [value isKindOfClass:[NSDictionary class]]) {
                resultValue = [[valueClass alloc] initWithJSONDict:value];
            }
            if ([valueClass isSubclassOfClass:[NSString class]] &&
                ![value isKindOfClass:[NSString class]]) {
                resultValue = [NSString stringWithFormat:@"%@",value];
            }
            if ([valueClass isSubclassOfClass:[NSNumber class]] &&
                [value isKindOfClass:[NSString class]]) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                resultValue = [numberFormatter numberFromString:value];
            }
            NSString *valueProtocol = [property.objectProtocols lastObject];
            if ([valueProtocol isKindOfClass:[NSString class]]) {
                Class valueProtocolClass = NSClassFromString(valueProtocol);
                if (valueProtocolClass != nil) {
                    if ([valueProtocolClass isSubclassOfClass:[NSBaseModel class]]) {
                        if ([value isKindOfClass:[NSArray class]]) {
                            resultValue = [(NSArray *)value modelArrayWithClass:valueProtocolClass];
                        }
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            resultValue = [(NSDictionary *)value modelDictionaryWithClass:valueProtocolClass];
                        }
                    }
                }
            }
        }
    }
    return resultValue;
}

@end

