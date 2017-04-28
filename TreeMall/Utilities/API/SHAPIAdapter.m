//
//  SHAPIAdapter.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SHAPIAdapter.h"

static SHAPIAdapter *gAPIAdapter = nil;

@implementation SHAPIAdapter

+ (instancetype)sharedAdapter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gAPIAdapter = [[SHAPIAdapter alloc] init];
    });
    return gAPIAdapter;
}

#pragma mark - Constructor

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _encryptModule = nil;
        _decryptModule = nil;
        _token = nil;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.allowsCellularAccess = YES;
        configuration.timeoutIntervalForRequest = 60.0;
        configuration.HTTPMaximumConnectionsPerHost = 6.0;
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

#pragma mark - Public Methods

- (NSURLSessionDataTask *)sendRequestFromObject:(id)object ToUrl:(NSURL *)url withHeaderFields:(NSDictionary *)headerFields andPostObject:(id)postObject inPostFormat:(SHPostFormat)format encrypted:(BOOL)shouldEncrypt decryptedReturnData:(BOOL)shouldDecrypt completion:(void (^)(id, NSError *))block;
{
    return [self sendRequestFromObject:object ToUrl:url withHeaderFields:headerFields andPostObject:postObject inPostFormat:format encrypted:shouldEncrypt decryptedReturnData:shouldDecrypt completionWithMessage:^(id jsonObject, NSString *message, NSError *error) {
        if (block) {
            block(jsonObject, error);
        }
    }];
}

- (NSURLSessionDataTask *)sendRequestFromObject:(id)object ToUrl:(NSURL *)url withHeaderFields:(NSDictionary *)headerFields andPostObject:(id)postObject inPostFormat:(SHPostFormat)format encrypted:(BOOL)shouldEncrypt decryptedReturnData:(BOOL)shouldDecrypt completionWithMessage:(void (^)(id jsonObject, NSString *message, NSError *error))block;
{
    //    NSLog(@"===========================================");
    //    NSLog(@"sendRequestToUrl[%@]", [url absoluteString]);
    NSMutableURLRequest *request = nil;
    NSError *error = nil;
    NSData *postRawData = nil;
    NSString *contentType = nil;
    BOOL forcePost = YES;
    if (postObject)
    {
        switch (format) {
            case SHPostFormatJson:
            {
                postRawData = [NSJSONSerialization dataWithJSONObject:postObject options:NSJSONWritingPrettyPrinted error:&error];
                NSString *postString = [[NSString alloc] initWithData:postRawData encoding:NSUTF8StringEncoding];
                NSLog(@"sendRequestFromObject - postRawData:\n%@", postString);
                contentType = @"application/octet-stream";
            }
                break;
            case SHPostFormatXML:
            {
                // I'm too lazy to implement this format.
                contentType = @"application/text";
            }
                break;
            case SHPostFormatUrlEncoded:
            {
                if ([postObject isKindOfClass:[NSDictionary class]])
                {
                    NSMutableString *string = [NSMutableString string];
                    NSDictionary *postDictionary = (NSDictionary *)postObject;
                    for (NSString *key in [postDictionary allKeys])
                    {
                        if ([string length] > 0)
                        {
                            [string appendString:@"&"];
                        }
                        NSString *value = [postDictionary objectForKey:key];
                        [string appendFormat:@"%@=%@", key, value];
                    }
//                    NSLog(@"sendRequestFromObject - postString[%@]", string);
                    postRawData = [string dataUsingEncoding:NSUTF8StringEncoding];
                }
                contentType = @"application/x-www-form-urlencoded; charset=utf8";
            }
                break;
            case SHPostFormatNSData:
            {
                postRawData = (NSData *)postObject;
                contentType = @"application/x-www-form-urlencoded; charset=utf8";
            }
                break;
            case SHPostFormatNone:
            {
                postRawData = nil;
                forcePost = NO;
            }
                break;
            default:
            {
                contentType = @"application/x-www-form-urlencoded; charset=utf8";
            }
                break;
        }
        //        NSLog(@"sendRequestToUrl - postDictionary:\n%@", postDictionary);
        if (error)
        {
            NSLog(@"sendRequestToUrl - Create post data error:\n%@", [error description]);
            NSError *error = [NSError errorWithDomain:(__bridge NSString *)kCFErrorDomainCFNetwork code:kCFErrorHTTPParseFailure userInfo:nil];
            block(nil, nil, error);
            return nil;
        }
        //        NSString *string = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        //        NSLog(@"string:\n%@", string);
    }
    
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    if (request == nil)
    {
        //        NSLog(@"sendRequestToUrl - Invalid URL.");
        NSError *error = [NSError errorWithDomain:(__bridge NSString *)kCFErrorDomainCFNetwork code:kCFErrorHTTPBadURL userInfo:nil];
        block(nil, nil, error);
        return nil;
    }
    
    // Add custom header field
    if (headerFields != nil)
    {
        for (NSString *field in [headerFields allKeys])
        {
            NSString *value = [headerFields objectForKey:field];
//            NSLog(@"Field[%@] Value[%@]", field, value);
            [request addValue:value forHTTPHeaderField:field];
        }
    }
    if (postRawData)
    {
        NSData *postData = nil;
        if (shouldEncrypt && _encryptModule != nil && [_encryptModule respondsToSelector:@selector(encryptFromSourceData:)])
        {
            postData = [_encryptModule encryptFromSourceData:postRawData];
        }
        else
        {
            postData = postRawData;
        }
        NSString *postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//        NSLog(@"sendRequestToUrl - postString:\n%@", postString);
        NSString *lengthString = [NSString stringWithFormat:@"%lu", (unsigned long)[postString length]];
//        NSLog(@"sendRequestToUrl[%@] - post length[%@]", [url absoluteString], lengthString);
        [request setHTTPMethod:@"POST"];
        [request setValue:lengthString forHTTPHeaderField:@"Content-Length"];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
//        NSLog(@"sendRequestToUrl - contentType[%@]", contentType);
        [request setHTTPBody:postData];
    }
    else
    {
        [request setHTTPMethod:forcePost?@"POST":@"GET"];
    }
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (block)
        {
            if (data)
            {
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"URL[%@]\nresponse[%@]:\nerror:\n%@\ndata:\n%@\n\n", [url absoluteString], [response description], [error description], string);
            }
            __block id resultObject = nil;
            NSString *originalMessageFromServer = nil;
            __block NSError *finalError = error;
            if (error == nil)
            {
                if (shouldDecrypt && _decryptModule != nil && [_decryptModule respondsToSelector:@selector(decryptFromSourceData:completion:)])
                {
                    [_decryptModule decryptFromSourceData:data completion:^(id decryptResult, NSError *decryptError){
                        resultObject = decryptResult;
                        finalError = decryptError;
                    }];
                }
                else
                {
                    resultObject = data;
                }
            }
            else
            {
                NSLog(@"[%@] error:\n%@", url.absoluteString, error.description);
                finalError = error;
            }
            if (object)
            {
                // Make sure the block run in main thread, because there may be some UI initialize behavior in the block.
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(resultObject, originalMessageFromServer, finalError);
                });
            }
            return;
        }
    }];
    [task resume];
    return task;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

@end
