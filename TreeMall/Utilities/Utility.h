//
//  Utility.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+ (CGSize)sizeRatioAccordingToRefrenceSize:(CGSize)referenceSize;
+ (CGSize)sizeRatioAccordingTo320x480;
+ (NSString *)ipAddress;
+ (NSString *)ipAddressPreferIPv6:(BOOL)preferIPv6;
+ (BOOL)evaluateEmail:(NSString *)text;
+ (BOOL)evaluatePassword:(NSString *)text;
+ (BOOL)evaluatePhoneNumber:(NSString *)text;
+ (BOOL)evaluateLocalPhoneNumber:(NSString *)text;
+ (BOOL)evaluateCellPhoneNumber:(NSString *)text;
+ (BOOL)evaluateIdCardNumber:(NSString *)text;
+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color;
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end
