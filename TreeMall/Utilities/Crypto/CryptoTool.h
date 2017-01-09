//
//  CryptoTool.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface CryptoTool : NSObject

+ (NSData *)encryptData:(NSData *)sourceData withKey:(NSData *)key andIV:(NSData *)iv forAlgorithm:(CCAlgorithm)algorithm;
+ (NSString *)md5ForData:(NSData *)sourceData;
+ (NSString *)md5ForString:(NSString *)sourceString;
+ (NSData *)base64EncodedDataFromData:(NSData *)sourceData withSeparateLines:(BOOL)separateLines;
+ (NSData *)dataFromBase64EncodedData:(NSData *)sourceData;

@end
