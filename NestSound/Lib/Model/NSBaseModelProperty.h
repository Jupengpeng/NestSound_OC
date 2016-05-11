//
//  IMBaseModelProperty.h
//  iMei
//
//  Created by yandi on 15/3/20.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

/*
 相关知识请参见Runtime文档
 Type Encodings https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 Property Type String https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
 */
typedef NS_ENUM(NSUInteger, NSFetchModelPropertyValueType) {
    NSClassPropertyValueTypeNone = 0,
    NSClassPropertyTypeChar,
    NSClassPropertyTypeInt,
    NSClassPropertyTypeShort,
    NSClassPropertyTypeLong,
    NSClassPropertyTypeLongLong,
    NSClassPropertyTypeUnsignedChar,
    NSClassPropertyTypeUnsignedInt,
    NSClassPropertyTypeUnsignedShort,
    NSClassPropertyTypeUnsignedLong,
    NSClassPropertyTypeUnsignedLongLong,
    NSClassPropertyTypeFloat,
    NSClassPropertyTypeDouble,
    NSClassPropertyTypeBool,
    NSClassPropertyTypeVoid,
    NSClassPropertyTypeCharString,
    NSClassPropertyTypeObject,
    NSClassPropertyTypeClassObject,
    NSClassPropertyTypeSelector,
    NSClassPropertyTypeArray,
    NSClassPropertyTypeStruct,
    NSClassPropertyTypeUnion,
    NSClassPropertyTypeBitField,
    NSClassPropertyTypePointer,
    NSClassPropertyTypeUnknow
};

@interface NSBaseModelProperty : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isReadonly;
@property (nonatomic,copy) NSString *errorCode;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, assign) Class objectClass;
@property (nonatomic, strong) NSArray *objectProtocols;
@property (nonatomic, assign) NSFetchModelPropertyValueType valueType;

- (id)initWithName:(NSString *)name typeString:(NSString *)typeString;
@end
