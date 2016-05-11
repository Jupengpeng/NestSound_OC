//
//  IMBaseModelProperty.m
//  iMei
//
//  Created by yandi on 15/3/20.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "NSBaseModelProperty.h"

#define TypeIndicator @"T"
#define ReadonlyIndicator @"R"

@implementation NSBaseModelProperty

static NSDictionary *encodedTypesMap;

#pragma mark -encodedTypesMap
+ (NSDictionary *)encodedTypesMap{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        encodedTypesMap = @{@"c":@1, @"i":@2, @"s":@3, @"l":@4, @"q":@5,
                            @"C":@6, @"I":@7, @"S":@8, @"L":@9, @"Q":@10,
                            @"f":@11,@"d":@12,@"B":@13,@"v":@14,@"*":@15,
                            @"@":@16,@"#":@17,@":":@18,@"[":@19,@"{":@20,
                            @"(":@21,@"b":@22,@"^":@23,@"?":@24};
    });
    return encodedTypesMap;
}

#pragma mark -initWithName ...
- (id)initWithName:(NSString *)name typeString:(NSString *)typeString{
    self = [super init];
    if (self != nil) {
        self.name = name;
        
        NSArray *typeStringComponents = [typeString componentsSeparatedByString:@","];
        if (typeStringComponents.count > 0) {
            NSString *typeInfo = [typeStringComponents objectAtIndex:0];
            
            NSScanner *scanner = [NSScanner scannerWithString:typeInfo];
            [scanner scanUpToString:TypeIndicator intoString:NULL];
            [scanner scanString:TypeIndicator intoString:NULL];
            NSUInteger scanLocation = scanner.scanLocation;
            if (typeInfo.length > scanLocation) {
                NSString *typeCode = [typeInfo substringWithRange:NSMakeRange(scanLocation, 1)];
                NSNumber *indexNumber = [[self.class encodedTypesMap] objectForKey:typeCode];
                self.valueType = (NSFetchModelPropertyValueType)[indexNumber integerValue];
                
                if (self.valueType == NSClassPropertyTypeObject) {
                    scanner.scanLocation += 1;
                    if ([scanner scanString:@"\"" intoString:NULL]) {
                        NSString *objectClassName = nil;
                        [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet]
                                            intoString:&objectClassName];
                        self.typeName = objectClassName;
                        self.objectClass = NSClassFromString(objectClassName);
                        
                        NSMutableArray *protocols = [NSMutableArray array];
                        while ([scanner scanString:@"<" intoString:NULL]) {
                            NSString* protocolName = nil;
                            [scanner scanUpToString:@">" intoString: &protocolName];
                            if (protocolName != nil) {
                                [protocols addObject:protocolName];
                            }
                            [scanner scanString:@">" intoString:NULL];
                        }
                        if ([protocols count] > 0) {
                            self.objectProtocols = protocols;
                        }
                    }
                }
            }
            if ([typeStringComponents containsObject:ReadonlyIndicator]) {
                self.isReadonly = YES;
            }
        }
    }
    return self;
}
@end
