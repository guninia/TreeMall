//
//  CryptoModule.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHCryptoModuleTemplate.h"

@interface CryptoModule : NSObject <SHAPIEncryptModuleTemplate, SHAPIDecryptModuleTemplate>

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *key;

+ (instancetype)sharedModule;

@end
