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
//    if (_key == nil)
//    {
        // Should produce key
        NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
        [dateFormmater setDateFormat:@"yyyyMMdd"];
        NSString *dateString = [dateFormmater stringFromDate:[NSDate date]];
        
        NSString *compositeString = [_apiKey stringByAppendingString:dateString];
//        NSLog(@"compositeString[%@]", compositeString);
        NSData *md5String = [CryptoTool md5DataForString:compositeString];
        
        _key = md5String;
//    }
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
            NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
            NSString *statusCat = [statusId stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
            NSString *statusCode = [statusId stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
            NSString *statusDescription = [dictionary objectForKey:SymphoxAPIParam_status_desc];
            
            if (statusDescription)
            {
                [userInfo setObject:statusDescription forKey:SymphoxAPIParam_server_desc];
            }
//            NSLog(@"API status[%@][%@]", statusId, statusDescription);
//            NSLog(@"statusCat[%@] statusCode[%@]", statusCat, statusCode);
            NSMutableString *errorMessage = [NSMutableString string];
            NSErrorDomain errorDomain = NSCocoaErrorDomain;
            NSInteger errorCode = NSNotFound;
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
                                    errorCode = CryptoErrorCodeDecryptAesError;
                                }
                            }
                            else
                            {
                                errorCode = CryptoErrorCodeDecodeBase64Error;
                            }
                        }
                    }
                        break;
                    case 2:
                    {
                        if (statusDescription)
                        {
                            [errorMessage appendString:statusDescription];
                        }
                        else
                        {
                            [errorMessage appendString:[LocalizedString SystemErrorTryLater]];
                        }
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 101:
                    case 102:
                    {
                        [errorMessage appendString:[LocalizedString UnexpectedFormat]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 107:
                    {
                        [errorMessage appendString:[LocalizedString NoSuchDonationCode]];
                        errorCode = CryptoErrorCodeServerResponseError;
                        
                    }
                        break;
                    case 202:
                    {
                        [errorMessage appendString:[LocalizedString NotMemberYet]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 209:
                    {
                        [errorMessage appendString:[LocalizedString CreditCardFormatError]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 210:
                    {
                        [errorMessage appendString:[LocalizedString BonusPointUsageLimitation]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 301:
                    {
                        [errorMessage appendString:[LocalizedString NoMatchedProduct]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 400:
                    {
                        [errorMessage appendString:[LocalizedString ProductSizeExceedLimit]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 403:
                    {
                        [errorMessage appendString:[LocalizedString NotEnoughProductInStock]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 404:
                    {
                        [errorMessage appendString:[LocalizedString ProductNoLongerAvailable]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 407:
                    {
                        [errorMessage appendString:[LocalizedString NoAdditionalPurchaseForTargetAmount]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    case 408:
                    case 411:
                    {
                        [errorMessage appendString:[LocalizedString NoAdditionalPurchase]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                    
                    default:
                    {
                        [errorMessage appendString:[LocalizedString SystemErrorTryLater]];
                        errorCode = CryptoErrorCodeServerResponseError;
                    }
                        break;
                }
            }
            if (errorCode != NSNotFound)
            {
                if ([errorMessage length] == 0)
                {
                    [errorMessage appendString:[LocalizedString SystemErrorTryLater]];
                }
                [errorMessage appendFormat:@"\n(%@)", statusId];
                [userInfo setObject:errorMessage forKey:SymphoxAPIParam_status_desc];
                error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:userInfo];
            }
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
