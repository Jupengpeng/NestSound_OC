//
//  NSHttpClient+EncrypteData.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/2.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSHttpClient+EncrypteData.h"
#import <Security/Security.h>
#import "RSAEncryptor.h"



//public key
#define RSAPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEIGwePp63orI08aZ+vWKgUJJcN7HDrgVpX9pja2465tzrbdWLif26RhiIn2lVz6QuEWhJwlM7cTMYYH1bacy4Z7e1eOIH6hlp3/TKiZMhjNJbyafuQjBkvs4sQVOaW/G4iKu5W+SFcYdCOiTo6vZe6KD9IbBXaL1P3BkaMHq2kQIDAQAB"

@implementation NSHttpClient (EncrypteData)




//base64 encode data
static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

//Base64 encode string
static NSData* base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

#pragma mark RSA encrypt/decrypt

-(NSDictionary *)encryptWithDictionary :(NSDictionary*)paramaters isEncrypt:(BOOL)isEncrypt_
{
    if (isEncrypt_) {
        
        if (paramaters) {
            NSMutableDictionary * dic =[[NSMutableDictionary alloc] initWithDictionary: paramaters];
            NSDictionary * par =  [dic objectForKey:requestData];
            NSString * parmaters = [self dictionaryToJson:par];
            
            NSString * EncryptedStr =  [RSAEncryptor encryptString:parmaters publicKey:RSAPublicKey];
            NSString * base64EncodeStr = base64_encode_data([EncryptedStr dataUsingEncoding:NSUTF8StringEncoding]);
            [dic removeObjectForKey:requestData];
            [dic setObject:base64EncodeStr forKey:requestData];
            return dic;
        }
        
        return nil;
        
    }else{
        
        NSMutableDictionary * dic =[[NSMutableDictionary alloc] initWithDictionary: paramaters];
        NSString  * par =  [dic objectForKey:requestData];
      //  NSString * parmaters = [self dictionaryWithJsonString:par];
        NSData * base64DecodeData = base64_decode(par);
        NSString * base64DecodeStr = [[NSString alloc] initWithData:base64DecodeData encoding:NSUTF8StringEncoding];
        NSString * decryptStr =  [RSAEncryptor decryptString:base64DecodeStr publicKey:RSAPublicKey];
        
        NSDictionary * resultDataDic = [self dictionaryWithJsonString:decryptStr];
        [dic removeObjectForKey:requestData];
//        [dic removeAllObjects];
        NSLog(@"ddddd%@",dic);
        [dic setObject:resultDataDic forKey:requestData];
        
        return dic;
    }

   
    
    

}


#pragma mark dictionaryToJson
-(NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError * paraError = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&paraError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

@end
