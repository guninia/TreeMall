//
//  CryptoModule.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHCryptoModuleTemplate.h"

typedef enum : NSUInteger {
    CryptoErrorCodeJsonError = 9999900,
    CryptoErrorCodeDecryptAesError,
    CryptoErrorCodeDecodeBase64Error,
    CryptoErrorCodeUnexpectedFormatError,
    CryptoErrorCodeNoResultError,
    CryptoErrorCodeServerResponseError,
    CryptoErrorCodeTotal
} CryptoErrorCode;

@interface CryptoModule : NSObject <SHAPIEncryptModuleTemplate, SHAPIDecryptModuleTemplate>

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSData *key;

+ (instancetype)sharedModule;
- (NSData *)encryptFromSourceData:(NSData *)sourceData;
- (NSData *)decryptFromSourceData:(NSData *)sourceData completion:(void (^)(id, NSError *))block;

@end
