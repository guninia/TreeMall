//
//  SHAPIAdapter.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHCryptoModuleTemplate.h"

typedef enum : NSUInteger {
    SHPostFormatNone,
    SHPostFormatJson,
    SHPostFormatXML,
    SHPostFormatUrlEncoded,
    SHPostFormatNSData,
    SHPostFormatTotal
} SHPostFormat;

@interface SHAPIAdapter : NSObject <NSURLSessionDelegate>

@property (nonatomic, weak) id <SHAPIEncryptModuleTemplate> encryptModule;
@property (nonatomic, weak) id <SHAPIDecryptModuleTemplate> decryptModule;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *token;

+ (instancetype)sharedAdapter;

- (NSURLSessionDataTask *)sendRequestFromObject:(id)object ToUrl:(NSURL *)url withHeaderFields:(NSDictionary *)headerFields andPostObject:(id)postObject inPostFormat:(SHPostFormat)format encrypted:(BOOL)shouldEncrypt decryptedReturnData:(BOOL)shouldDecrypt completion:(void (^)(id, NSError *))block;

- (NSURLSessionDataTask *)sendRequestFromObject:(id)object ToUrl:(NSURL *)url withHeaderFields:(NSDictionary *)headerFields andPostObject:(id)postObject inPostFormat:(SHPostFormat)format encrypted:(BOOL)shouldEncrypt decryptedReturnData:(BOOL)shouldDecrypt completionWithMessage:(void (^)(id jsonObject, NSString *message, NSError *error))block;

@end
