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
    NSMutableDictionary *_dictionaryCachedCategories;
    NSNumber *_numberArchiveTimestamp;
}

@property (nonatomic, strong) NSMutableOrderedSet *orderedSetPromotionRead;
@property (nonatomic, strong) NSNumber *userIdentifier;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, assign) TMGender userGender;
@property (nonatomic, assign) NSNumber *userEpoint;
@property (nonatomic, assign) NSNumber *userEcoupon;
@property (nonatomic, strong) NSMutableDictionary *dictionaryInitialFilter;
@property (nonatomic, strong) NSMutableDictionary *dictionaryMainCategoryNameMapping;
@property (nonatomic, strong) NSMutableOrderedSet *orderedSetKeyword;
@property (nonatomic, strong) NSMutableOrderedSet *orderedSetFavoriteId;
@property (nonatomic, strong) NSMutableArray *arrayFavorite;
@property (nonatomic, strong) NSMutableDictionary *dictionaryFavoriteDetail;

+ (instancetype)sharedManager;

- (void)saveToArchive;
- (NSDictionary *)loadFromArchive;

- (void)readPromotionForIdentifier:(NSString *)identifier;
- (BOOL)alreadyReadPromotionForIdentifier:(NSString *)identifier;
- (void)updateUserInformationFromInfoDictionary:(NSDictionary *)infoDictionary;
- (void)setSubcategories:(NSArray *)subcategories forIdentifier:(NSString *)identifier atLayer:(NSNumber *)layer;
- (NSArray *)subcategoriesForIdentifier:(NSString *)identifier atLayer:(NSNumber *)layer;
- (NSDictionary *)cachedDictionaries;
- (NSArray *)categoriesContainsCategoryWithIdentifier:(NSString *)identifier;
- (void)findSiblingsInSameLayerAndContentForCategoryIdentifier:(NSString *)identifier withCompletion:(void (^)(NSArray *sibings, NSDictionary *content, NSNumber *layer))block;
- (void)retrieveToken;
- (void)addKeyword:(NSString *)keyword;
- (NSArray *)keywords;
- (void)removeAllKeywords;

- (void)setUserGenderByGenderText:(NSString *)genderText;
- (BOOL)addProductToFavorite:(NSDictionary *)product;
- (NSArray *)favorites;

@end
