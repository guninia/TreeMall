//
//  CryptoModule.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CryptoModule.h"
#import "CryptoTool.h"
#import "APIDefinition.h"
#import "LocalizedString.h"

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

- (NSData *)key
{
    if (_key == nil)
    {
        // Should produce key
        NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
        [dateFormmater setDateFormat:@"yyyyMMdd"];
        NSString *dateString = [dateFormmater stringFromDate:[NSDate date]];
        
        NSString *compositeString = [_apiKey stringByAppendingString:dateString];
//        NSLog(@"compositeString[%@]", compositeString);
        NSData *md5String = [CryptoTool md5DataForString:compositeString];
        
        _key = md5String;
    }
    return _key;
}

#pragma mark - SHAPIEncryptModuleTemplate

- (NSData *)encryptFromSourceData:(NSData *)sourceData
{
//    NSLog(@"encryptFromSourceData - key[%@]", self.key);
//    NSString *sourceString = [[NSString alloc] initWithData:sourceData encoding:NSUTF8StringEncoding];
//    NSLog(@"encryptFromSourceData - sourceString[%@]", sourceString);
    NSData *aesEncryptedData = [CryptoTool encryptData:sourceData withKey:self.key andIV:nil forAlgorithm:CryptoAlgorithmAES128ECBPKCS7];
    NSData *data = [CryptoTool base64EncodedDataFromData:aesEncryptedData withSeparateLines:NO];
    return data;
}

#pragma mark - SHAPIDecryptModuleTemplate

- (NSData *)decryptFromSourceData:(NSData *)sourceData completion:(void (^)(id, NSError *))block
{
//    NSString *string = [[NSString alloc] initWithData:sourceData encoding:NSUTF8StringEncoding];
//    NSLog(@"decryptFromSourceData:\n%@", string);
    NSError *error = nil;
    NSData *data = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:sourceData options:0 error:&error];
    if (error == nil)
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            NSString *statusId = [dictionary objectForKey:SymphoxAPIParam_status_id];
            if (statusId)
            {
                [userInfo setObject:statusId forKey:SymphoxAPIParam_id];
            }
            NSString *statusDescription = [dictionary objectForKey:SymphoxAPIParam_status_desc];
            if (statusDescription)
            {
                [userInfo setObject:statusDescription forKey:SymphoxAPIParam_server_desc];
            }
//            NSLog(@"API status[%@][%@]", statusId, statusDescription);
            
            NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
            NSString *statusCat = [statusId stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
            NSString *statusCode = [statusId stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
            NSLog(@"statusCat[%@] statusCode[%@]", statusCat, statusCode);
            if ([statusCat compare:@"E" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            {
                switch ([statusCode integerValue]) {
                    case 0:
                    {
                        // Success
                        if (result)
                        {
                            NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
                            NSData *sourceData = [CryptoTool dataFromBase64EncodedData:resultData];
                            if (sourceData)
                            {
                                data = [CryptoTool decryptData:sourceData withKey:self.key andIV:nil forAlgorithm:CryptoAlgorithmAES128ECBPKCS7];
                                if (data == nil)
                                {
                                    error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeDecryptAesError userInfo:userInfo];
                                }
                            }
                            else
                            {
                                error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeDecodeBase64Error userInfo:userInfo];
                            }
                        }
                    }
                        break;
                    case 107:
                    {
                        [userInfo setObject:[LocalizedString NoSuchDonationCode] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                    case 202:
                    {
                        [userInfo setObject:[LocalizedString NotMemberYet] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                    case 209:
                    {
                        [userInfo setObject:[LocalizedString CreditCardFormatError] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                    case 210:
                    {
                        [userInfo setObject:[LocalizedString BonusPointUsageLimitation] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                    case 301:
                    {
                        [userInfo setObject:[LocalizedString NoMatchedProduct] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                    case 403:
                    {
                        [userInfo setObject:[LocalizedString NotEnoughProductInStock] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                    case 404:
                    {
                        [userInfo setObject:[LocalizedString ProductNoLongerAvailable] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                    case 407:
                    {
                        [userInfo setObject:[LocalizedString NoAdditionalPurchaseForTargetAmount] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                    case 408:
                    case 411:
                    {
                        [userInfo setObject:[LocalizedString NoAdditionalPurchase] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                    
                    default:
                    {
                        [userInfo setObject:[LocalizedString SystemErrorTryLater] forKey:SymphoxAPIParam_status_desc];
                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
                    }
                        break;
                }
            }
//            if ([statusId compare:@"E000" options:NSCaseInsensitiveSearch] == NSOrderedSame)
//            {
//                if (result)
//                {
//                    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
//                    NSData *sourceData = [CryptoTool dataFromBase64EncodedData:resultData];
//                    if (sourceData)
//                    {
//                        data = [CryptoTool decryptData:sourceData withKey:self.key andIV:nil forAlgorithm:CryptoAlgorithmAES128ECBPKCS7];
//                        if (data == nil)
//                        {
//                            error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeDecryptAesError userInfo:userInfo];
//                        }
//                    }
//                    else
//                    {
//                        error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeDecodeBase64Error userInfo:userInfo];
//                    }
//                }
//            }
//            else
//            {
//                error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeServerResponseError userInfo:userInfo];
//            }
        }
        else
        {
            error = [NSError errorWithDomain:NSCocoaErrorDomain code:CryptoErrorCodeUnexpectedFormatError userInfo:userInfo];
        }
    }
    else
    {
        NSLog(@"decryptFromSourceData - error:\n%@", [error description]);
    }
    block(data, error);
    return data;
}

@end
