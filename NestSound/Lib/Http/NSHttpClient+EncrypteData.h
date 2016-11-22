//
//  NSHttpClient+EncrypteData.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/2.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSHttpClient.h"

@interface NSHttpClient (EncrypteData)

-(NSDictionary *)encryptWithDictionary :(NSDictionary*)paramaters isEncrypt:(BOOL)isEncrypt_;
-(NSString *)dictionaryToJson:(NSDictionary *)dic;


@end
