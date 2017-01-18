//
//  SHCryptoModuleTemplate.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#ifndef SHCryptoModuleTemplate_h
#define SHCryptoModuleTemplate_h

#import <Foundation/Foundation.h>

@protocol SHAPIDecryptModuleTemplate <NSObject>

- (NSData *)decryptFromSourceData:(NSData *)sourceData completion:(void (^)(id, NSError *))block;

@end

@protocol SHAPIEncryptModuleTemplate <NSObject>

- (NSData *)encryptFromSourceData:(NSData *)sourceData;

@end

#endif /* SHCryptoModuleTemplate_h */
