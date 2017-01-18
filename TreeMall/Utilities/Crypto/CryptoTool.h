//
//  CryptoTool.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

typedef enum : NSUInteger {
    CryptoAlgorithmAES128ECBPKCS7,/* Also for PKCS5 padding*/
    CryptoAlgorithmAES128CBCPKCS7,
    CryptoAlgorithmAES256CBCPKCS7,
    CryptoAlgorithmTotal
} CryptoAlgorithm;

@interface CryptoTool : NSObject

+ (NSData *)encryptData:(NSData *)sourceData withKey:(NSData *)key andIV:(NSData *)iv forAlgorithm:(CryptoAlgorithm)algorithm;
+ (NSData *)decryptData:(NSData *)sourceData withKey:(NSData *)key andIV:(NSData *)iv forAlgorithm:(CryptoAlgorithm)algorithm;
+ (NSString *)md5ForData:(NSData *)sourceData;
+ (NSData *)md5DataForData:(NSData *)sourceData;
+ (NSString *)md5ForString:(NSString *)sourceString;
+ (NSData *)md5DataForString:(NSString *)sourceString;
+ (NSData *)base64EncodedDataFromData:(NSData *)sourceData withSeparateLines:(BOOL)separateLines;
+ (NSData *)dataFromBase64EncodedData:(NSData *)sourceData;

@end
