//
//  CryptoTool.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CryptoTool.h"

@implementation CryptoTool

+ (NSData *)encryptData:(NSData *)sourceData withKey:(NSData *)key andIV:(NSData *)iv forAlgorithm:(CryptoAlgorithm)algorithm
{
    NSData *result = nil;
    
    NSInteger keySize = 0;
    NSInteger blockSize = 0;
    CCOptions options = 0;
    CCAlgorithm ccAlgorithm = 0;
    
    switch (algorithm) {
        case CryptoAlgorithmAES128ECBPKCS7:
        {
            ccAlgorithm = kCCAlgorithmAES128;
            keySize = kCCKeySizeAES128;
            blockSize = kCCBlockSizeAES128;
            options = (kCCOptionPKCS7Padding | kCCOptionECBMode);
        }
            break;
        case CryptoAlgorithmAES128CBCPKCS7:
        {
            ccAlgorithm = kCCAlgorithmAES128;
            keySize = kCCKeySizeAES128;
            blockSize = kCCBlockSizeAES128;
            options = kCCOptionPKCS7Padding;
        }
            break;
        case CryptoAlgorithmAES256CBCPKCS7:
        {
            ccAlgorithm = kCCAlgorithmAES;
            keySize = kCCKeySizeAES256;
            blockSize = kCCBlockSizeAES128;
            options = kCCOptionPKCS7Padding;
        }
            break;
        default:
            break;
    }
    
    // Setup key
    unsigned char cKey[keySize + 1];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:keySize];
    
    // setup iv
    char cIv[blockSize];
    bzero(cIv, blockSize);
    if (iv)
    {
        [iv getBytes:cIv length:blockSize];
    }
    
    // setup output buffer
    size_t dataLength = [sourceData length];
    size_t bufferSize = dataLength + blockSize;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, ccAlgorithm, options, cKey, keySize, cIv, [sourceData bytes], dataLength, buffer, bufferSize, &encryptedSize);
    if (cryptStatus == kCCSuccess)
    {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    }
    else
    {
        free(buffer);
        NSLog(@"[ERROR] failed to encrypt|CCCryptoStatus: %d", cryptStatus);
    }
    return result;
}

+ (NSData *)decryptData:(NSData *)sourceData withKey:(NSData *)key andIV:(NSData *)iv forAlgorithm:(CryptoAlgorithm)algorithm
{
    NSData *result = nil;
    
    NSInteger keySize = 0;
    NSInteger blockSize = 0;
    CCOptions options = 0;
    
    switch (algorithm) {
        case kCCAlgorithmAES:
        {
            keySize = kCCKeySizeAES128;
            blockSize = kCCBlockSizeAES128;
            options = (kCCOptionPKCS7Padding | kCCOptionECBMode);
        }
            break;
            
        default:
            break;
    }
    
    // Setup key
    unsigned char cKey[keySize + 1];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:keySize];
    
    // setup iv
    char cIv[blockSize];
    bzero(cIv, blockSize);
    if (iv)
    {
        [iv getBytes:cIv length:blockSize];
    }
    
    // setup output buffer
    size_t dataLength = [sourceData length];
    size_t bufferSize = dataLength + blockSize;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, algorithm, options, cKey, keySize, cIv, [sourceData bytes], dataLength, buffer, bufferSize, &decryptedSize);
    if (cryptStatus == kCCSuccess)
    {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    }
    else
    {
        free(buffer);
        NSLog(@"[ERROR] failed to decrypt|CCCryptoStatus: %d", cryptStatus);
    }
    return result;
}

+ (NSString *)md5ForData:(NSData *)sourceData
{
    NSMutableString *md5String = nil;
    if (sourceData)
    {
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5([sourceData bytes], (CC_LONG)[sourceData length], result);
        
        md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
            [md5String appendFormat:@"%02x", result[i]];
    }
    return md5String;
}

+ (NSData *)md5DataForData:(NSData *)sourceData
{
    NSData *resultData = nil;
    if (sourceData)
    {
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5([sourceData bytes], (CC_LONG)[sourceData length], result);
        resultData = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    }
    return resultData;
}

+ (NSString *)md5ForString:(NSString *)sourceString
{
    NSData *data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *md5String = [CryptoTool md5ForData:data];
    return md5String;
}

+ (NSData *)md5DataForString:(NSString *)sourceString
{
    NSData *data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *md5Data = [CryptoTool md5DataForData:data];
    return md5Data;
}

+ (NSData *)base64EncodedDataFromData:(NSData *)sourceData withSeparateLines:(BOOL)separateLines
{
    NSDataBase64EncodingOptions options = (separateLines)? NSDataBase64EncodingEndLineWithLineFeed:kNilOptions;
    return [sourceData base64EncodedDataWithOptions:options];
}

+ (NSData *)dataFromBase64EncodedData:(NSData *)sourceData
{
    return [[NSData alloc] initWithBase64EncodedData:sourceData options:kNilOptions];
}

@end
