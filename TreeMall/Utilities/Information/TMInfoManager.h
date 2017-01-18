//
//  TMInfoManager.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/12.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TMGenderMale,
    TMGenderFemale,
    TMGenderThird,
    TMGenderUnknown,
    TMGenderTotal
} TMGender;

@interface TMInfoManager : NSObject
{
    NSMutableDictionary *_dictionaryUserInfo;
}

@property (nonatomic, strong) NSMutableOrderedSet *orderedSetPromotionRead;
@property (nonatomic, strong) NSNumber *userIdentifier;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, assign) TMGender userGender;
@property (nonatomic, assign) NSNumber *userEpoint;
@property (nonatomic, assign) NSNumber *userEcoupon;

+ (instancetype)sharedManager;

- (void)saveToArchive;
- (NSDictionary *)loadFromArchive;

- (void)readPromotionForIdentifier:(NSString *)identifier;
- (BOOL)alreadyReadPromotionForIdentifier:(NSString *)identifier;

@end
