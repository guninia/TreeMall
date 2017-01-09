//
//  CryptoModule.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CryptoModule.h"
#import "CryptoTool.h"

static CryptoModule *gCryptoModule = nil;

@implementation CryptoModule

#pragma mark - Constructor

+ (instancetype)sharedModule
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gCryptoModule = [[CryptoModule alloc] init];
    });
    return gCryptoModule;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _apiKey = @"c0a96525284b0c676fe6a7f0aa6a1fee";
        _key = nil;
    }
    return self;
}

#pragma mark - Override

- (NSString *)key
{
    if (_key == nil)
    {
        // Should produce key
        NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
        [dateFormmater setDateFormat:@"yyyyMMdd"];
        NSString *dateString = [dateFormmater stringFromDate:[NSDate date]];
        
        NSString *compositeString = [_apiKey stringByAppendingString:dateString];
        
        NSString *md5String = [CryptoTool md5ForString:compositeString];
        
        _key = md5String;
    }
    return _key;
}

#pragma mark - SHAPIEncryptModuleTemplate

- (NSData *)encryptFromSourceData:(NSData *)sourceData
{
    NSData *keyData = [self.key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesEncryptedData = [CryptoTool encryptData:sourceData withKey:keyData andIV:nil forAlgorithm:kCCAlgorithmAES];
    NSData *data = [CryptoTool base64EncodedDataFromData:aesEncryptedData withSeparateLines:NO];
    return data;
}

#pragma mark - SHAPIDecryptModuleTemplate

- (NSData *)decryptFromSourceData:(NSData *)sourceData
{
    NSData *data = nil;
    
    return data;
}

@end
