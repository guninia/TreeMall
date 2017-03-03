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

typedef enum : NSUInteger {
    OCBStatusActivated,
    OCBStatusShouldActivateInTreeMall,
    OCBStatusShouldActivateInBank,
    OCBStatusExpired, /*Update In Bank Then Activate In TreeMall*/
    OCBStatusTotal
} OCBStatus;

typedef enum : NSUInteger {
    CouponStateStart,
    CouponStateNotUsed = CouponStateStart,
    CouponStateAlreadyUsed,
    CouponStateExpired,
    CouponStateTotal
} CouponState;

@interface TMInfoManager : NSObject
{
    NSMutableDictionary *_dictionaryUserInfo;
    NSMutableDictionary *_dictionaryCachedCategories;
    NSNumber *_numberArchiveTimestamp;
    dispatch_queue_t archiveQueue;
}

@property (nonatomic, strong) NSMutableOrderedSet *orderedSetPromotionRead;
@property (nonatomic, strong) NSNumber *userIdentifier;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, assign) TMGender userGender;
@property (nonatomic, strong) NSNumber *userEpoint;
@property (nonatomic, strong) NSNumber *userEcoupon;
@property (nonatomic, strong) NSNumber *userPointTotal;
@property (nonatomic, strong) NSNumber *userPointDividend;
@property (nonatomic, strong) NSNumber *userPointExpired;
@property (nonatomic, strong) NSString *userPointAdText;
@property (nonatomic, strong) NSString *userPointAdUrl;
@property (nonatomic, strong) NSString *userAuthStatus;
@property (nonatomic, strong) NSString *userBirth;
@property (nonatomic, strong) NSString *userEmailMasked;
@property (nonatomic, assign) BOOL userIsEmailMember;
@property (nonatomic, assign) BOOL userEmailAuth;
@property (nonatomic, strong) NSString *userInvoiceTitle;
@property (nonatomic, strong) NSString *userInvoiceType;
@property (nonatomic, strong) NSString *userMobileMasked;
@property (nonatomic, assign) BOOL userIsNewMember;
@property (nonatomic, assign) OCBStatus userOcbStatus;
@property (nonatomic, strong) NSString *userOcbUrl;
@property (nonatomic, assign) BOOL userHasPassword;
@property (nonatomic, strong) NSString *userTaxId;
@property (nonatomic, strong) NSString *userTelephoneAreaCode;
@property (nonatomic, strong) NSString *userTelephoneExtension;
@property (nonatomic, strong) NSString *userTelephone;
@property (nonatomic, strong) NSString *userIDCardNumber;
@property (nonatomic, strong) NSString *userZipCode;
@property (nonatomic, strong) NSString *userAddress;
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
- (void)retrievePointDataFromObject:(id)object withCompletion:(void (^)(id result, NSError *error))block;
- (void)retrieveCouponDataFromObject:(id)object forPageIndex:(NSInteger)pageIndex couponState:(CouponState)state sortFactor:(NSString *)factor withSortOrder:(NSString *)order withCompletion:(void (^)(id result, NSError *error))block;
- (void)logoutUser;

@end
