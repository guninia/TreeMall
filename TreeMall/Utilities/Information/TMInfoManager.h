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
    CouponStateAll = CouponStateStart,
    CouponStateNotUsed,
    CouponStateAlreadyUsed,
    CouponStateExpired,
    CouponStateTotal
} CouponState;

typedef enum : NSUInteger {
    CouponUIStateStart,
    CouponUIStateNotUsed = CouponUIStateStart,
    CouponUIStateAlreadyUsed,
    CouponUIStateExpired,
    CouponUIStateTotal
} CouponUIState;

typedef enum : NSUInteger {
    OrderStateStart,
    OrderStateNoSpecific = OrderStateStart,
    OrderStateProcessing,
    OrderStateShipping,
    OrderStateReturnOrReplace,
    OrderStateTotal
} OrderState;

typedef enum : NSUInteger {
    CartTypeStart,
    CartTypeCommonDelivery = CartTypeStart,
    CartTypeStorePickup,
    CartTypeFastDelivery,
    CartTypeDirectlyPurchase,
    CartTypeTotal
} CartType;

typedef enum : NSUInteger {
    CartUITypeStart,
    CartUITypeCommonDelivery = CartUITypeStart,
    CartUITypeFastDelivery,
    CartUITypeStorePickup,
    CartUITypeTotal
} CartUIType;

typedef enum : NSUInteger {
    AdditionalCartTypeCommonDelivery,
    AdditionalCartTypeStorePickup,
    AdditionalCartTypeFastDelivery,
    AdditionalCartTypeTotal
} AdditionalCartType;

typedef enum : NSUInteger {
    FastDeliveryProductTypeCash,
    FastDeliveryProductTypePoint,
    FastDeliveryProductTypeTotal
} FastDeliveryProductType;

@interface TMInfoManager : NSObject
{
    NSMutableDictionary *_dictionaryUserInfo;
    NSMutableDictionary *_dictionaryCachedCategories;
    NSNumber *_numberArchiveTimestamp;
    dispatch_queue_t archiveQueue;
}

@property (nonatomic, strong) NSNumber *userIdentifier;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, assign) TMGender userGender;
@property (nonatomic, strong) NSNumber *userEpoint;
@property (nonatomic, strong) NSNumber *userEcoupon;
@property (nonatomic, strong) NSNumber *userCouponAmount;
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
@property (nonatomic, strong) NSString *userLoginDate;
@property (nonatomic, strong) NSString *userLoginIP;
@property (nonatomic, strong) NSString *userPressAgreementDate;
@property (nonatomic, assign) BOOL userInvoiceBind;
@property (nonatomic, strong) NSString *deviceIdentifier;
@property (nonatomic, strong) NSMutableDictionary *dictionaryInitialFilter;
@property (nonatomic, strong) NSMutableDictionary *dictionaryMainCategoryNameMapping;
@property (nonatomic, strong) NSMutableOrderedSet *orderedSetKeyword;
@property (nonatomic, strong) NSMutableOrderedSet *orderedSetFavoriteId;
@property (nonatomic, strong) NSMutableOrderedSet *orderedSetPromotionRead;
@property (nonatomic, strong) NSMutableArray *arrayKeywords;
@property (nonatomic, strong) NSMutableArray *arrayFavorite;
@property (nonatomic, strong) NSMutableDictionary *dictionaryFavoriteDetail;
@property (nonatomic, strong) NSMutableArray *arrayCartCommon;
@property (nonatomic, strong) NSMutableDictionary *dictionaryProductPurchaseInfoInCartCommon;
@property (nonatomic, strong) NSMutableArray *arrayCartStorePickUp;
@property (nonatomic, strong) NSMutableDictionary *dictionaryProductPurchaseInfoInCartStorePickUp;
@property (nonatomic, strong) NSMutableArray *arrayCartFast;
@property (nonatomic, strong) NSMutableDictionary *dictionaryProductPurchaseInfoInCartFast;
@property (nonatomic, strong) NSMutableArray *arrayCartDirect;
@property (nonatomic, strong) NSMutableDictionary *dictionaryProductPurchaseInfoInCartDirect;
@property (nonatomic, strong) NSMutableArray *arrayCartCommonAddition;
@property (nonatomic, strong) NSMutableDictionary *dictionaryProductPurchaseInfoInCartCommonAddition;
@property (nonatomic, strong) NSMutableArray *arrayCartStorePickUpAddition;
@property (nonatomic, strong) NSMutableDictionary *dictionaryProductPurchaseInfoInCartStorePickUpAddition;
@property (nonatomic, strong) NSMutableArray *arrayCartFastAddition;
@property (nonatomic, strong) NSMutableDictionary *dictionaryProductPurchaseInfoInCartFastAddition;
@property (nonatomic, strong) NSMutableArray *arrayCartDirectAddition;
@property (nonatomic, strong) NSMutableDictionary *dictionaryProductPurchaseInfoInCartDirectAddition;
@property (nonatomic, strong) NSDictionary *productFastDelivery;
@property (nonatomic, strong) NSDictionary *productInfoForFastDelivery;
@property (nonatomic, strong) NSDictionary *dictionaryDocuments;

+ (instancetype)sharedManager;

- (void)saveToArchive;
- (NSDictionary *)loadFromArchive;

- (void)readPromotionForIdentifier:(NSString *)identifier;
- (BOOL)alreadyReadPromotionForIdentifier:(NSString *)identifier;
- (void)updateUserInformationFromInfoDictionary:(NSDictionary *)infoDictionary afterLoadingArchive:(BOOL)shouldLoadArchive;
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
- (NSString *)addProductToFavorite:(NSDictionary *)product;
- (NSArray *)favorites;
- (BOOL)favoriteContainsProductWithIdentifier:(NSNumber *)productId;
- (void)removeProductFromFavorite:(NSInteger)productIndex;
- (NSInteger)numberOfProductsInFavorite;
- (void)retrievePointDataFromObject:(id)object withCompletion:(void (^)(id result, NSError *error))block;
- (void)retrieveCouponDataFromObject:(id)object forPageIndex:(NSInteger)pageIndex couponState:(CouponState)state sortFactor:(NSString *)factor withSortOrder:(NSString *)order withCompletion:(void (^)(id result, NSError *error))block;
- (void)logoutUser;
- (void)retrieveUserInformation;

- (NSMutableArray *)productArrayForCartType:(CartType)type;
- (NSMutableDictionary *)purchaseInfoForCartType:(CartType)type;
- (void)addProduct:(NSDictionary *)product toCartForType:(CartType)type;
- (void)setPurchaseQuantity:(NSNumber *)quantity forProduct:(NSNumber *)productId inCart:(CartType)cartType;
- (void)setPurchasePaymentMode:(NSDictionary *)dictionaryPaymentMode forProduct:(NSNumber *)productId withRealProductId:(NSNumber *)realProductId inCart:(CartType)cartType;
- (void)setDiscountTypeDescription:(NSString *)description forProduct:(NSNumber *)productId inCart:(CartType)cartType;
- (void)setDiscountDetailDescription:(NSString *)description forProduct:(NSNumber *)productId inCart:(CartType)cartType;
- (NSString *)nameOfRemovedProductId:(NSNumber *)productIdToRemove inCart:(CartType)type;

- (NSMutableArray *)productArrayForAdditionalCartType:(CartType)type;
- (NSMutableDictionary *)purchaseInfoForAdditionalCartType:(CartType)type;
- (void)addProduct:(NSDictionary *)product toAdditionalCartForType:(CartType)type;
- (void)setPurchaseQuantity:(NSNumber *)quantity forProduct:(NSNumber *)productId inAdditionalCart:(CartType)cartType;
- (void)setPurchasePaymentMode:(NSDictionary *)dictionaryPaymentMode forProduct:(NSNumber *)productId withRealProductId:(NSNumber *)realProductId inAdditionalCart:(CartType)cartType;
- (void)setDiscountTypeDescription:(NSString *)description forProduct:(NSNumber *)productId inAdditionalCart:(CartType)cartType;
- (void)setDiscountDetailDescription:(NSString *)description forProduct:(NSNumber *)productId inAdditionalCart:(CartType)cartType;
- (NSString *)nameOfRemovedProductId:(NSNumber *)productIdToRemove inAdditionalCart:(CartType)type;

- (void)setPurchaseInfoFromSelectedPaymentMode:(NSDictionary *)paymentModeSelected forProductId:(NSNumber *)productId withRealProductId:(NSNumber *)realProductId inCart:(CartType)cartType asAdditional:(BOOL)isAdditional;

- (NSInteger)numberOfProductsInCart:(CartType)type;

- (void)resetCartForType:(CartType)type;
- (void)initializeCartForType:(CartType)type;

- (NSString *)formattedStringFromDate:(NSDate *)date;

- (void)sendPushToken:(NSString *)token;

- (NSDictionary *)productFastDeliveryWithType:(FastDeliveryProductType)productType;
- (NSDictionary *)productInfoForFastDeliveryFromInfo:(NSDictionary *)originInfo;
- (void)resetProductFastDelivery;
- (void)updateProductInfoForFastDeliveryFromInfos:(NSArray *)originInfos;

@end
