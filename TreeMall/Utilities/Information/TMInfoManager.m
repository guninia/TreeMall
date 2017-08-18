//
//  TMInfoManager.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/12.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "TMInfoManager.h"
#import "CryptoModule.h"
#import "APIDefinition.h"
#import "SHAPIAdapter.h"
#import "Definition.h"
#import <SAMKeychain.h>
#import "LocalizedString.h"
#import "Utility.h"
#import <Google/Analytics.h>

#define TMProductFastDeliveryCash [NSNumber numberWithInteger:11354109]
#define TMProductFastDeliveryPoint [NSNumber numberWithInteger:11354108]

static NSString *TMInfoArchiveKey_PromotionRead = @"PromotionRead";
static NSString *TMInfoArchiveKey_UserInformation = @"UserInformation";
static NSString *TMInfoArchiveKey_UserIdentifier = @"UserIdentifier";
static NSString *TMInfoArchiveKey_UserName = @"UserName";
static NSString *TMInfoArchiveKey_UserEmail = @"UserEmail";
static NSString *TMInfoArchiveKey_UserGender = @"UserGender";
static NSString *TMInfoArchiveKey_UserEpoint = @"UserEpoint";
static NSString *TMInfoArchiveKey_UserEcoupon = @"UserEcoupon";
static NSString *TMInfoArchiveKey_UserAuthStatus = @"UserAuthStatus";
static NSString *TMInfoArchiveKey_UserBirth = @"UserBirth";
static NSString *TMInfoArchiveKey_UserEmailMasked = @"UserEmailMasked";
static NSString *TMInfoArchiveKey_UserIsEmailMember = @"UserIsEmailMember";
static NSString *TMInfoArchiveKey_UserEmailAuth = @"UserEmailAuth";
static NSString *TMInfoArchiveKey_UserInvoiceTitle = @"UserInvoiceTitle";
static NSString *TMInfoArchiveKey_UserInvoiceType = @"UserInvoiceType";
static NSString *TMInfoArchiveKey_UserMobileMasked = @"UserMobileMasked";
static NSString *TMInfoArchiveKey_UserIsNewMember = @"UserIsNewMember";
static NSString *TMInfoArchiveKey_UserOcbStatus = @"UserOcbStatus";
static NSString *TMInfoArchiveKey_UserOcbUrl = @"UserOcbUrl";
static NSString *TMInfoArchiveKey_UserHasPassword = @"UserHasPassword";
static NSString *TMInfoArchiveKey_UserTaxId = @"UserTaxId";
static NSString *TMInfoArchiveKey_UserTelephoneAreaCode = @"UserTelephoneAreaCode";
static NSString *TMInfoArchiveKey_UserTelephoneExtension = @"UserTelephoneExtension";
static NSString *TMInfoArchiveKey_UserTelephone = @"UserTelephone";
static NSString *TMInfoArchiveKey_UserIdCardNumber = @"UserIdCardNumber";
static NSString *TMInfoArchiveKey_UserZipCode = @"UserZipCode";
static NSString *TMInfoArchiveKey_UserAddress = @"UserAddress";
static NSString *TMInfoArchiveKey_UserLoginTime = @"UserLoginTime";
static NSString *TMInfoArchiveKey_UserLoginIP = @"UserLoginIP";

static NSString *TMInfoArchiveKey_CachedCategories = @"CachedCategories";
static NSString *TMInfoArchiveKey_ArchiveTimestamp = @"ArchiveTimestamp";
static NSString *TMInfoArchiveKey_OrderSetKeyword = @"OrderSetKeyword";
static NSString *TMInfoArchiveKey_OrderSetFavoriteId = @"OrderSetFavoriteId";
static NSString *TMInfoArchiveKey_Favorites = @"Favorites";
static NSString *TMInfoArchiveKey_FavoritesDetail = @"FavoritesDetail";

static NSString *TMInfoArchiveKey_CartCommon = @"CartCommon";
static NSString *TMInfoArchiveKey_CartStorePickUp = @"CartStorePickUp";
static NSString *TMInfoArchiveKey_CartFast = @"CartFast";
static NSString *TMInfoArchiveKey_PurchaseInfoInCartCommon = @"PurchaseInfoInCartCommon";
static NSString *TMInfoArchiveKey_PurchaseInfoInCartStorePickUp = @"PurchaseInfoInCartStorePickUp";
static NSString *TMInfoArchiveKey_PurchaseInfoInCartFast = @"PurchaseInfoInCartFast";

static NSString *TMIdentifier = @"TMID";
static NSString *TMDeviceIdentifier = @"TMUDID";

static NSString *SeparatorBetweenIdAndLayer = @"_";

static TMInfoManager *gTMInfoManager = nil;

static NSUInteger PromotionReadNumberMax = 100;
static NSUInteger SearchKeywordNumberMax = 8;

@interface TMInfoManager ()

- (NSURL *)urlForInfoDirectory;
- (NSURL *)urlForInfoArchiveWithIdentifier:(NSString *)identifier;
- (NSURL *)urlForFavoriteArchive;
- (void)applyDataFromArchivedDictionary:(NSDictionary *)dictionaryArchive;
- (void)applyFavoriteFromArchivedDictionary:(NSDictionary *)dictionaryArchive;
- (void)deleteArchiveForIdentifier:(NSNumber *)identifier;
- (void)resetData;
- (NSString *)keyForCategoryIdentifier:(NSString *)identifier withLayer:(NSNumber *)layer;
- (void)processUserInformation:(NSData *)data;
- (void)processUserPoint:(NSData *)data;
- (id)processUserCoupon:(NSData *)data;

- (void)handlerOfUserLoggedInNotification:(NSNotification *)notification;

@end

@implementation TMInfoManager

@synthesize userIdentifier = _userIdentifier;
@synthesize userName = _userName;
@synthesize userEmail = _userEmail;
@synthesize userGender = _userGender;
@synthesize userEpoint = _userEpoint;
@synthesize userEcoupon = _userEcoupon;
@synthesize userAuthStatus = _userAuthStatus;
@synthesize userBirth = _userBirth;
@synthesize userEmailMasked = _userEmailMasked;
@synthesize userIsEmailMember = _userIsEmailMember;
@synthesize userEmailAuth = _userEmailAuth;
@synthesize userInvoiceTitle = _userInvoiceTitle;
@synthesize userInvoiceType = _userInvoiceType;
@synthesize userMobileMasked = _userMobileMasked;
@synthesize userIsNewMember = _userIsNewMember;
@synthesize userOcbStatus = _userOcbStatus;
@synthesize userOcbUrl = _userOcbUrl;
@synthesize userHasPassword = _userHasPassword;
@synthesize userTaxId = _userTaxId;
@synthesize userTelephoneAreaCode = _userTelephoneAreaCode;
@synthesize userTelephoneExtension = _userTelephoneExtension;
@synthesize userTelephone = _userTelephone;
@synthesize userIDCardNumber = _userIDCardNumber;
@synthesize userZipCode = _userZipCode;
@synthesize userAddress = _userAddress;

#pragma mark - Constructor

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gTMInfoManager = [[TMInfoManager alloc] init];
    });
    return gTMInfoManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self resetData];
        archiveQueue = dispatch_queue_create("ArchiveQueue", DISPATCH_QUEUE_SERIAL);
        
        [self applyDataFromArchivedDictionary:[self loadFromArchive]];
        [self applyFavoriteFromArchivedDictionary:[self loadFromFavoriteArchive]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfUserLoggedInNotification:) name:PostNotificationName_UserLoggedIn object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserLoggedIn object:nil];
}

#pragma mark - Override

- (void)setUserIdentifier:(NSNumber *)userIdentifier
{
    if ([_userIdentifier unsignedLongLongValue] != [userIdentifier unsignedLongLongValue])
    {
        _userIdentifier = userIdentifier;
        if (_userIdentifier)
        {
            [_dictionaryUserInfo setObject:_userIdentifier forKey:TMInfoArchiveKey_UserIdentifier];
        }
    }
}

- (NSNumber *)userIdentifier
{
    if (_userIdentifier == nil)
    {
        _userIdentifier = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserIdentifier];
    }
    return _userIdentifier;
}

- (void)setUserName:(NSString *)userName
{
    if ([_userName isEqualToString:userName] == NO)
    {
        _userName = userName;
        if (_userName)
        {
            [_dictionaryUserInfo setObject:_userName forKey:TMInfoArchiveKey_UserName];
        }
    }
}

- (NSString *)userName
{
    if (_userName == nil)
    {
        _userName = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserName];
    }
    return _userName;
}

- (void)setUserEmail:(NSString *)userEmail
{
    if ([_userEmail isEqualToString:userEmail] == NO)
    {
        _userEmail = userEmail;
        if (_userEmail)
        {
            [_dictionaryUserInfo setObject:_userEmail forKey:TMInfoArchiveKey_UserEmail];
        }
    }
}

- (NSString *)userEmail
{
    if (_userEmail == nil)
    {
        _userEmail = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserEmail];
    }
    return _userEmail;
}

- (void)setUserGender:(TMGender)userGender
{
    if (_userGender != userGender)
    {
        _userGender = userGender;
        [_dictionaryUserInfo setObject:[NSNumber numberWithUnsignedInteger:_userGender] forKey:TMInfoArchiveKey_UserGender];
    }
}

- (TMGender)userGender
{
    if (_userGender == TMGenderTotal)
    {
        NSNumber *number = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserGender];
        if (number)
        {
            _userGender = [number unsignedIntegerValue];
        }
    }
    return _userGender;
}

- (void)setUserAuthStatus:(NSString *)userAuthStatus
{
    if ([userAuthStatus isEqualToString:_userAuthStatus] == NO)
    {
        _userAuthStatus = userAuthStatus;
        if (_userAuthStatus)
        {
            [_dictionaryUserInfo setObject:_userAuthStatus forKey:TMInfoArchiveKey_UserAuthStatus];
        }
    }
}

- (NSString *)userAuthStatus
{
    if (_userAuthStatus == nil)
    {
        _userAuthStatus = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserAuthStatus];
    }
    return _userAuthStatus;
}

- (void)setUserBirth:(NSString *)userBirth
{
    if ([userBirth isEqualToString:_userBirth] == NO)
    {
        _userBirth = userBirth;
        if (_userBirth)
        {
            [_dictionaryUserInfo setObject:_userBirth forKey:TMInfoArchiveKey_UserBirth];
        }
    }
}

- (NSString *)userBirth
{
    if (_userBirth == nil)
    {
        _userBirth = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserBirth];
    }
    return _userBirth;
}

- (void)setUserEmailMasked:(NSString *)userEmailMasked
{
    if ([userEmailMasked isEqualToString:_userEmailMasked] == NO)
    {
        _userEmailMasked = userEmailMasked;
        [_dictionaryUserInfo setObject:_userEmailMasked forKey:TMInfoArchiveKey_UserEmailMasked];
    }
}

- (NSString *)userEmailMasked
{
    if (_userEmailMasked == nil)
    {
        _userEmailMasked = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserEmailMasked];
    }
    return _userEmailMasked;
}

- (void)setUserIsEmailMember:(BOOL)userIsEmailMember
{
    _userIsEmailMember = userIsEmailMember;
    [_dictionaryUserInfo setObject:[NSNumber numberWithBool:_userIsEmailMember] forKey:TMInfoArchiveKey_UserIsEmailMember];
}

- (BOOL)userIsEmailMember
{
    NSNumber *numberBool = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserIsEmailMember];
    if (numberBool)
    {
        _userIsEmailMember = [numberBool boolValue];
    }
    return _userIsEmailMember;
}

- (void)setUserEmailAuth:(BOOL)userEmailAuth
{
    _userEmailAuth = userEmailAuth;
    [_dictionaryUserInfo setObject:[NSNumber numberWithBool:_userEmailAuth] forKey:TMInfoArchiveKey_UserEmailAuth];
}

- (BOOL)userEmailAuth
{
    NSNumber *numberBool = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserEmailAuth];
    if (numberBool)
    {
        _userEmailAuth = [numberBool boolValue];
    }
    return _userEmailAuth;
}

- (void)setUserInvoiceTitle:(NSString *)userInvoiceTitle
{
    if ([userInvoiceTitle isEqualToString:_userInvoiceTitle] == NO)
    {
        _userInvoiceTitle = userInvoiceTitle;
        if (_userInvoiceTitle != nil)
        {
            [_dictionaryUserInfo setObject:_userInvoiceTitle forKey:TMInfoArchiveKey_UserInvoiceTitle];
        }
    }
}

- (NSString *)userInvoiceTitle
{
    if (_userInvoiceTitle == nil)
    {
        _userInvoiceTitle = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserInvoiceTitle];
    }
    return _userInvoiceTitle;
}

- (void)setUserInvoiceType:(NSString *)userInvoiceType
{
    if ([userInvoiceType isEqualToString:_userInvoiceType] == NO)
    {
        _userInvoiceType = userInvoiceType;
        if (_userInvoiceType != nil)
        {
            [_dictionaryUserInfo setObject:_userInvoiceType forKey:TMInfoArchiveKey_UserInvoiceType];
        }
    }
}

- (NSString *)userInvoiceType
{
    if (_userInvoiceType == nil)
    {
        _userInvoiceType = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserInvoiceType];
    }
    return _userInvoiceType;
}

- (void)setUserMobileMasked:(NSString *)userMobileMasked
{
    if ([userMobileMasked isEqualToString:_userMobileMasked] == NO)
    {
        _userMobileMasked = userMobileMasked;
        if (_userMobileMasked != nil)
        {
            [_dictionaryUserInfo setObject:_userMobileMasked forKey:TMInfoArchiveKey_UserMobileMasked];
        }
    }
}

- (NSString *)userMobileMasked
{
    if (_userMobileMasked == nil)
    {
        _userMobileMasked = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserMobileMasked];
    }
    return _userMobileMasked;
}

- (void)setUserIsNewMember:(BOOL)userIsNewMember
{
    _userIsNewMember = userIsNewMember;
    [_dictionaryUserInfo setObject:[NSNumber numberWithBool:_userIsNewMember] forKey:TMInfoArchiveKey_UserIsNewMember];
}

- (BOOL)userIsNewMember
{
    NSString *numberBool = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserIsNewMember];
    if (numberBool)
    {
        _userIsNewMember = [numberBool boolValue];
    }
    return _userIsNewMember;
}

- (void)setUserOcbStatus:(OCBStatus)userOcbStatus
{
    if (userOcbStatus != _userOcbStatus)
    {
        _userOcbStatus = userOcbStatus;
        if (_userOcbStatus != OCBStatusTotal)
        {
            [_dictionaryUserInfo setObject:[NSNumber numberWithUnsignedInteger:_userOcbStatus] forKey:TMInfoArchiveKey_UserOcbStatus];
        }
    }
}

- (OCBStatus)userOcbStatus
{
    if (_userOcbStatus == OCBStatusTotal)
    {
        NSNumber *numberBool = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserOcbStatus];
        if (numberBool)
        {
            _userOcbStatus = [numberBool boolValue];
        }
    }
    return _userOcbStatus;
}

- (void)setUserOcbUrl:(NSString *)userOcbUrl
{
    if ([userOcbUrl isEqualToString:_userOcbUrl] == NO)
    {
        _userOcbUrl = userOcbUrl;
        if (_userOcbUrl != nil)
        {
            [_dictionaryUserInfo setObject:_userOcbUrl forKey:TMInfoArchiveKey_UserOcbUrl];
        }
    }
}

- (NSString *)userOcbUrl
{
    if (_userOcbUrl == nil)
    {
        _userOcbUrl = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserOcbUrl];
    }
    return _userOcbUrl;
}

- (void)setUserHasPassword:(BOOL)userHasPassword
{
    _userHasPassword = userHasPassword;
    [_dictionaryUserInfo setObject:[NSNumber numberWithBool:_userHasPassword] forKey:TMInfoArchiveKey_UserHasPassword];
}

- (BOOL)userHasPassword
{
    NSNumber *numberBool = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserHasPassword];
    if (numberBool != nil)
    {
        _userHasPassword = [numberBool boolValue];
    }
    return _userHasPassword;
}

- (void)setUserTaxId:(NSString *)userTaxId
{
    if ([userTaxId isEqualToString:_userTaxId] == NO)
    {
        _userTaxId = userTaxId;
        if (_userTaxId != nil)
        {
            [_dictionaryUserInfo setObject:_userTaxId forKey:TMInfoArchiveKey_UserTaxId];
        }
    }
}

- (NSString *)userTaxId
{
    if (_userTaxId == nil)
    {
        _userTaxId = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserTaxId];
    }
    return _userTaxId;
}

- (void)setUserTelephoneAreaCode:(NSString *)userTelephoneAreaCode
{
    if ([userTelephoneAreaCode isEqualToString:_userTelephoneAreaCode] == NO)
    {
        _userTelephoneAreaCode = userTelephoneAreaCode;
        if (_userTelephoneAreaCode != nil)
        {
            [_dictionaryUserInfo setObject:_userTelephoneAreaCode forKey:TMInfoArchiveKey_UserTelephoneAreaCode];
        }
    }
}

- (NSString *)userTelephoneAreaCode
{
    if (_userTelephoneAreaCode == nil)
    {
        _userTelephoneAreaCode = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserTelephoneAreaCode];
    }
    return _userTelephoneAreaCode;
}

- (void)setUserTelephoneExtension:(NSString *)userTelephoneExtension
{
    if ([userTelephoneExtension isEqualToString:_userTelephoneExtension] == NO)
    {
        _userTelephoneExtension = userTelephoneExtension;
        if (_userTelephoneExtension != nil)
        {
            [_dictionaryUserInfo setObject:_userTelephoneExtension forKey:TMInfoArchiveKey_UserTelephoneExtension];
        }
    }
}

- (NSString *)userTelephoneExtension
{
    if (_userTelephoneExtension == nil)
    {
        _userTelephoneExtension = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserTelephoneExtension];
    }
    return _userTelephoneExtension;
}

- (void)setUserTelephone:(NSString *)userTelephone
{
    if ([userTelephone isEqualToString:_userTelephone] == NO)
    {
        _userTelephone = userTelephone;
        if (_userTelephone != nil)
        {
            [_dictionaryUserInfo setObject:_userTelephone forKey:TMInfoArchiveKey_UserTelephone];
        }
    }
}

- (NSString *)userTelephone
{
    if (_userTelephone == nil)
    {
        _userTelephone = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserTelephone];
    }
    return _userTelephone;
}

- (void)setUserIDCardNumber:(NSString *)userIDCardNumber
{
    if ([userIDCardNumber isEqualToString:_userIDCardNumber] == NO)
    {
        _userIDCardNumber = userIDCardNumber;
        if (_userIDCardNumber != nil)
        {
            [_dictionaryUserInfo setObject:_userIDCardNumber forKey:TMInfoArchiveKey_UserIdCardNumber];
        }
    }
}

- (NSString *)userIDCardNumber
{
    if (_userIDCardNumber == nil)
    {
        _userIDCardNumber = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserIdCardNumber];
    }
    return _userIDCardNumber;
}

- (void)setUserZipCode:(NSString *)userZipCode
{
    if ([userZipCode isEqualToString:_userZipCode] == NO)
    {
        _userZipCode = userZipCode;
        if (_userZipCode != nil)
        {
            [_dictionaryUserInfo setObject:_userZipCode forKey:TMInfoArchiveKey_UserZipCode];
        }
    }
}

- (NSString *)userZipCode
{
    if (_userZipCode == nil)
    {
        _userZipCode = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserZipCode];
    }
    return _userZipCode;
}

- (void)setUserAddress:(NSString *)userAddress
{
    if ([userAddress isEqualToString:_userAddress] == NO)
    {
        _userAddress = userAddress;
        if (_userAddress != nil)
        {
            [_dictionaryUserInfo setObject:_userAddress forKey:TMInfoArchiveKey_UserAddress];
        }
    }
}

- (NSString *)userAddress
{
    if (_userAddress == nil)
    {
        _userAddress = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserAddress];
    }
    return _userAddress;
}

- (NSString *)deviceIdentifier
{
    if (_deviceIdentifier == nil)
    {
        _deviceIdentifier = [Utility load:TMDeviceIdentifier];
        if (_deviceIdentifier == nil)
        {
            _deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            if (_deviceIdentifier)
            {
                [Utility save:TMDeviceIdentifier data:_deviceIdentifier];
            }
        }
    }
    return _deviceIdentifier;
}

- (NSMutableDictionary *)dictionaryInitialFilter
{
    if (_dictionaryInitialFilter == nil)
    {
        _dictionaryInitialFilter = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryInitialFilter;
}

- (NSMutableDictionary *)dictionaryMainCategoryNameMapping
{
    if (_dictionaryMainCategoryNameMapping == nil)
    {
        _dictionaryMainCategoryNameMapping = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryMainCategoryNameMapping;
}

- (NSMutableOrderedSet *)orderedSetKeyword
{
    if (_orderedSetKeyword == nil)
    {
        _orderedSetKeyword = [[NSMutableOrderedSet alloc] initWithCapacity:0];
    }
    return _orderedSetKeyword;
}

- (NSMutableOrderedSet *)orderedSetFavoriteId
{
    if (_orderedSetFavoriteId == nil)
    {
        _orderedSetFavoriteId = [[NSMutableOrderedSet alloc] initWithCapacity:0];
    }
    return _orderedSetFavoriteId;
}

- (NSMutableOrderedSet *)orderedSetPromotionRead
{
    if (_orderedSetPromotionRead == nil)
    {
        _orderedSetPromotionRead = [[NSMutableOrderedSet alloc] initWithCapacity:0];
    }
    return _orderedSetPromotionRead;
}

- (NSMutableArray *)arrayKeywords
{
    if (_arrayKeywords == nil)
    {
        _arrayKeywords = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayKeywords;
}

- (NSMutableArray *)arrayFavorite
{
    if (_arrayFavorite == nil)
    {
        _arrayFavorite = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayFavorite;
}

- (NSMutableArray *)arrayCartCommon
{
    if (_arrayCartCommon == nil)
    {
        _arrayCartCommon = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCartCommon;
}

- (NSMutableDictionary *)dictionaryProductPurchaseInfoInCartCommon
{
    if (_dictionaryProductPurchaseInfoInCartCommon == nil)
    {
        _dictionaryProductPurchaseInfoInCartCommon = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryProductPurchaseInfoInCartCommon;
}

- (NSMutableArray *)arrayCartStorePickUp
{
    if (_arrayCartStorePickUp == nil)
    {
        _arrayCartStorePickUp = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCartStorePickUp;
}

- (NSMutableDictionary *)dictionaryProductPurchaseInfoInCartStorePickUp
{
    if (_dictionaryProductPurchaseInfoInCartStorePickUp == nil)
    {
        _dictionaryProductPurchaseInfoInCartStorePickUp = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryProductPurchaseInfoInCartStorePickUp;
}

- (NSMutableArray *)arrayCartFast
{
    if (_arrayCartFast == nil)
    {
        _arrayCartFast = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCartFast;
}

- (NSMutableDictionary *)dictionaryProductPurchaseInfoInCartFast
{
    if (_dictionaryProductPurchaseInfoInCartFast == nil)
    {
        _dictionaryProductPurchaseInfoInCartFast = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryProductPurchaseInfoInCartFast;
}

- (NSMutableArray *)arrayCartDirect
{
    if (_arrayCartDirect == nil)
    {
        _arrayCartDirect = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCartDirect;
}

- (NSMutableDictionary *)dictionaryProductPurchaseInfoInCartDirect
{
    if (_dictionaryProductPurchaseInfoInCartDirect == nil)
    {
        _dictionaryProductPurchaseInfoInCartDirect = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryProductPurchaseInfoInCartDirect;
}

- (NSMutableArray *)arrayCartCommonAddition
{
    if (_arrayCartCommonAddition == nil)
    {
        _arrayCartCommonAddition = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCartCommonAddition;
}

- (NSMutableDictionary *)dictionaryProductPurchaseInfoInCartCommonAddition
{
    if (_dictionaryProductPurchaseInfoInCartCommonAddition == nil)
    {
        _dictionaryProductPurchaseInfoInCartCommonAddition = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryProductPurchaseInfoInCartCommonAddition;
}

- (NSMutableArray *)arrayCartStorePickUpAddition
{
    if (_arrayCartStorePickUpAddition == nil)
    {
        _arrayCartStorePickUpAddition = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCartStorePickUpAddition;
}

- (NSMutableDictionary *)dictionaryProductPurchaseInfoInCartStorePickUpAddition
{
    if (_dictionaryProductPurchaseInfoInCartStorePickUpAddition == nil)
    {
        _dictionaryProductPurchaseInfoInCartStorePickUpAddition = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryProductPurchaseInfoInCartStorePickUpAddition;
}

- (NSMutableArray *)arrayCartFastAddition
{
    if (_arrayCartFastAddition == nil)
    {
        _arrayCartFastAddition = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCartFastAddition;
}

- (NSMutableDictionary *)dictionaryProductPurchaseInfoInCartFastAddition
{
    if (_dictionaryProductPurchaseInfoInCartFastAddition == nil)
    {
        _dictionaryProductPurchaseInfoInCartFastAddition = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryProductPurchaseInfoInCartFastAddition;
}

- (NSMutableArray *)arrayCartDirectAddition
{
    if (_arrayCartDirectAddition == nil)
    {
        _arrayCartDirectAddition = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCartDirectAddition;
}

- (NSMutableDictionary *)dictionaryProductPurchaseInfoInCartDirectAddition
{
    if (_dictionaryProductPurchaseInfoInCartDirectAddition == nil)
    {
        _dictionaryProductPurchaseInfoInCartDirectAddition = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryProductPurchaseInfoInCartDirectAddition;
}

#pragma mark - Public Methods

- (void)readPromotionForIdentifier:(NSString *)identifier
{
    if ([self alreadyReadPromotionForIdentifier:identifier])
    {
        NSInteger currentIndex = [_orderedSetPromotionRead indexOfObject:identifier];
        if (currentIndex != 0)
        {
            [_orderedSetPromotionRead removeObjectAtIndex:currentIndex];
            [_orderedSetPromotionRead insertObject:identifier atIndex:0];
        }
    }
    else
    {
        if ([_orderedSetPromotionRead count] >= PromotionReadNumberMax)
        {
            [_orderedSetPromotionRead removeObject:[_orderedSetPromotionRead lastObject]];
        }
        [_orderedSetPromotionRead insertObject:identifier atIndex:0];
    }
}

- (BOOL)alreadyReadPromotionForIdentifier:(NSString *)identifier
{
    BOOL alreadyRead = [_orderedSetPromotionRead containsObject:identifier];
    return alreadyRead;
}

- (void)saveToArchive
{
    __weak TMInfoManager *weakSelf = self;
    dispatch_async(archiveQueue, ^{
        NSMutableDictionary *dictionaryArchive = [NSMutableDictionary dictionary];
        [dictionaryArchive setObject:[weakSelf.orderedSetPromotionRead array] forKey:TMInfoArchiveKey_PromotionRead];
        [dictionaryArchive setObject:_dictionaryUserInfo forKey:TMInfoArchiveKey_UserInformation];
        [dictionaryArchive setObject:_dictionaryCachedCategories forKey:TMInfoArchiveKey_CachedCategories];
        [dictionaryArchive setObject:[weakSelf.orderedSetKeyword array] forKey:TMInfoArchiveKey_OrderSetKeyword];
        if (_numberArchiveTimestamp)
        {
            [dictionaryArchive setObject:_numberArchiveTimestamp forKey:TMInfoArchiveKey_ArchiveTimestamp];
        }
        [dictionaryArchive setObject:weakSelf.arrayCartCommon forKey:TMInfoArchiveKey_CartCommon];
        [dictionaryArchive setObject:weakSelf.dictionaryProductPurchaseInfoInCartCommon forKey:TMInfoArchiveKey_PurchaseInfoInCartCommon];
        [dictionaryArchive setObject:weakSelf.arrayCartStorePickUp forKey:TMInfoArchiveKey_CartStorePickUp];
        [dictionaryArchive setObject:weakSelf.dictionaryProductPurchaseInfoInCartStorePickUp forKey:TMInfoArchiveKey_PurchaseInfoInCartStorePickUp];
        [dictionaryArchive setObject:weakSelf.arrayCartFast forKey:TMInfoArchiveKey_CartFast];
        [dictionaryArchive setObject:weakSelf.dictionaryProductPurchaseInfoInCartFast forKey:TMInfoArchiveKey_PurchaseInfoInCartFast];
        if (weakSelf.userLoginDate)
        {
            [dictionaryArchive setObject:weakSelf.userLoginDate forKey:TMInfoArchiveKey_UserLoginTime];
        }
        if (weakSelf.userLoginIP)
        {
            [dictionaryArchive setObject:weakSelf.userLoginIP forKey:TMInfoArchiveKey_UserLoginIP];
        }
        
        NSMutableData *archiveData = [[NSMutableData alloc] initWithCapacity:0];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData];
        [archiver encodeObject:dictionaryArchive forKey:[CryptoModule sharedModule].apiKey];
        [archiver finishEncoding];
        
        NSString *identifier = nil;
        if (self.userIdentifier)
        {
            identifier = [self.userIdentifier stringValue];
        }
        NSURL *url = [weakSelf urlForInfoArchiveWithIdentifier:identifier];
//        NSLog(@"urlString[%@]", [url path]);
        NSError *error = nil;
        if ([archiveData writeToURL:url options:0 error:&error] == NO)
        {
            NSLog(@"TMInfoManager - archve failed.\n%@", [error description]);
        }
    });
}

- (void)saveToFavoriteArchive
{
    __weak TMInfoManager *weakSelf = self;
    dispatch_async(archiveQueue, ^{
        NSMutableDictionary *dictionaryArchive = [NSMutableDictionary dictionary];
        [dictionaryArchive setObject:[weakSelf.orderedSetFavoriteId array] forKey:TMInfoArchiveKey_OrderSetFavoriteId];
        [dictionaryArchive setObject:weakSelf.arrayFavorite forKey:TMInfoArchiveKey_Favorites];
        
        NSMutableData *archiveData = [[NSMutableData alloc] initWithCapacity:0];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData];
        [archiver encodeObject:dictionaryArchive forKey:[CryptoModule sharedModule].apiKey];
        [archiver finishEncoding];
        
        NSURL *url = [weakSelf urlForFavoriteArchive];
//        NSLog(@"urlString[%@]", [url path]);
        NSError *error = nil;
        if ([archiveData writeToURL:url options:0 error:&error] == NO)
        {
            NSLog(@"TMInfoManager - archve failed.\n%@", [error description]);
        }
    });
}

- (void)saveToLocal
{
    [[NSUserDefaults standardUserDefaults] setObject:[self.orderedSetFavoriteId array] forKey:TMInfoArchiveKey_OrderSetFavoriteId];
    [[NSUserDefaults standardUserDefaults] setObject:self.arrayFavorite forKey:TMInfoArchiveKey_Favorites];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)loadFromArchive
{
    if (self.userIdentifier == nil)
    {
        NSString *stringId = [SAMKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier] account:TMIdentifier];
        if (stringId)
        {
            NSNumber *identifier = [NSNumber numberWithInteger:[stringId integerValue]];
            self.userIdentifier = identifier;
        }
    }
    
    NSString *identifier = nil;
    if (self.userIdentifier)
    {
        identifier = [self.userIdentifier stringValue];
    }
    
    NSDictionary *dictionary = nil;
    NSURL *url = [self urlForInfoArchiveWithIdentifier:identifier];
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        NSData *data = [NSData dataWithContentsOfFile:[url path] options:0 error:&error];
        if (error == nil)
        {
            if (data)
            {
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                dictionary = [unarchiver decodeObjectForKey:[CryptoModule sharedModule].apiKey];
                [unarchiver finishDecoding];
            }
            else
            {
                NSLog(@"TMInfoManager - No data in archive");
            }
        }
        else
        {
            NSLog(@"TMInfoManager - load from archive error:\n%@", [error description]);
        }
    }
    else
    {
        NSLog(@"TMInfoManager - No archive.");
    }
    return dictionary;
}

- (NSDictionary *)loadFromFavoriteArchive
{
    NSDictionary *dictionary = nil;
    NSURL *url = [self urlForFavoriteArchive];
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        NSData *data = [NSData dataWithContentsOfFile:[url path] options:0 error:&error];
        if (error == nil)
        {
            if (data)
            {
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                dictionary = [unarchiver decodeObjectForKey:[CryptoModule sharedModule].apiKey];
                [unarchiver finishDecoding];
            }
            else
            {
                NSLog(@"TMInfoManager - No data in archive");
            }
        }
        else
        {
            NSLog(@"TMInfoManager - load from archive error:\n%@", [error description]);
        }
    }
    else
    {
        NSLog(@"TMInfoManager - No archive.");
    }
    return dictionary;
}

- (void)updateUserInformationFromInfoDictionary:(NSDictionary *)infoDictionary afterLoadingArchive:(BOOL)shouldLoadArchive
{
    //
    //  Need to do modification for data incoming.
    //
    
    NSNumber *identifier = [infoDictionary objectForKey:SymphoxAPIParam_user_num];
    if (identifier && [identifier isEqual:[NSNull null]] == NO)
    {
        self.userIdentifier = identifier;
        NSError *error = nil;
        [SAMKeychain setPassword:[self.userIdentifier stringValue] forService:[[NSBundle mainBundle] bundleIdentifier] account:TMIdentifier error:&error];
//        [[NSUserDefaults standardUserDefaults] setObject:self.userIdentifier forKey:TMIdentifier];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        if (error)
        {
            NSLog(@"store to keychain error:\n%@", [error description]);
        }
    }
    
    if (shouldLoadArchive)
    {
        [self applyDataFromArchivedDictionary:[self loadFromArchive]];
    }
    
    NSString *name = [infoDictionary objectForKey:SymphoxAPIParam_name];
    NSString *gender = [infoDictionary objectForKey:SymphoxAPIParam_sex];
    NSNumber *epoint = [infoDictionary objectForKey:SymphoxAPIParam_epoint];
    NSNumber *ecoupon = [infoDictionary objectForKey:SymphoxAPIParam_ecoupon];
    
    NSString *authStatus = [infoDictionary objectForKey:SymphoxAPIParam_auth_status];
    NSString *birth = [infoDictionary objectForKey:SymphoxAPIParam_birthday];
    NSString *emailMasked = [infoDictionary objectForKey:SymphoxAPIParam_email];
    NSString *emailMember = [infoDictionary objectForKey:SymphoxAPIParam_email_member];
    NSString *emailAuth = [infoDictionary objectForKey:SymphoxAPIParam_email_status];
    NSString *invoiceTitle = [infoDictionary objectForKey:SymphoxAPIParam_inv_title];
    NSString *invoiceType = [infoDictionary objectForKey:SymphoxAPIParam_inv_type];
    NSNumber *inv_bind = [infoDictionary objectForKey:SymphoxAPIParam_inv_bind];
    NSString *mobileMasked = [infoDictionary objectForKey:SymphoxAPIParam_mobile];
    NSString *newMember = [infoDictionary objectForKey:SymphoxAPIParam_new_member];
    NSString *ocbStatus = [infoDictionary objectForKey:SymphoxAPIParam_ocb_status];
    NSString *ocbUrl = [infoDictionary objectForKey:SymphoxAPIParam_ocb_url];
    NSString *passwordStatus = [infoDictionary objectForKey:SymphoxAPIParam_pwd_status];
    NSString *taxId = [infoDictionary objectForKey:SymphoxAPIParam_tax_id];
    NSString *telephoneAreaCode = [infoDictionary objectForKey:SymphoxAPIParam_tel_area];
    NSString *telephoneExtension = [infoDictionary objectForKey:SymphoxAPIParam_tel_ex];
    NSString *telephone = [infoDictionary objectForKey:SymphoxAPIParam_tel_num];
    NSString *idCardNumber = [infoDictionary objectForKey:SymphoxAPIParam_user_id];
    NSString *zipCode = [infoDictionary objectForKey:SymphoxAPIParam_zip];
    NSString *address = [infoDictionary objectForKey:SymphoxAPIParam_address];
    
    
    if ((self.userIdentifier == nil) || ([[self.userIdentifier stringValue] isEqualToString:[identifier stringValue]] == NO))
    {
        self.userIdentifier = nil;
        self.userName = nil;
        self.userGender = TMGenderTotal;
        self.userEpoint = nil;
        self.userEcoupon = nil;
    }
    if (name && [name isEqual:[NSNull null]] == NO && [name length] > 0)
    {
        self.userName = name;
    }
    if (gender && ([gender isEqual:[NSNull null]] == NO) && ([gender length] > 0))
    {
        if ([gender compare:SymphoxAPIParamValue_m options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            self.userGender = TMGenderMale;
        }
        else if ([gender compare:SymphoxAPIParamValue_f options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            self.userGender = TMGenderFemale;
        }
        else
        {
            self.userGender = TMGenderUnknown;
        }
    }
    else
    {
        self.userGender = TMGenderUnknown;
    }
    if (epoint && [epoint isEqual:[NSNull null]] == NO)
    {
        self.userEpoint = epoint;
    }
    if (ecoupon && [ecoupon isEqual:[NSNull null]] == NO)
    {
        self.userEcoupon = ecoupon;
    }
    if (authStatus && ([authStatus isEqual:[NSNull null]] == NO) && [authStatus length] > 0)
    {
        self.userAuthStatus = authStatus;
    }
    if (birth && ([birth isEqual:[NSNull null]] == NO) && ([birth length] > 0))
    {
        self.userBirth = birth;
    }
    if (emailMasked && ([emailMasked isEqual:[NSNull null]] == NO) && ([emailMasked length] > 0))
    {
        self.userEmailMasked = emailMasked;
    }
    if (emailMember && ([emailMember isEqual:[NSNull null]] == NO) && ([emailMember length] > 0))
    {
        BOOL isEmailMember = [emailMember boolValue];
        self.userIsEmailMember = isEmailMember;
    }
    if (emailAuth && ([emailAuth isEqual:[NSNull null]] == NO) && ([emailAuth length] > 0))
    {
        BOOL isEmailAuth = [emailAuth boolValue];
        self.userEmailAuth = isEmailAuth;
    }
    if (inv_bind && [inv_bind isEqual:[NSNull null]] == NO)
    {
        BOOL inv_bind_value = [inv_bind boolValue];
        self.userInvoiceBind = inv_bind_value;
    }
    if (invoiceTitle && ([invoiceTitle isEqual:[NSNull null]] == NO) && ([invoiceTitle length] > 0))
    {
        self.userInvoiceTitle = invoiceTitle;
    }
    if (invoiceTitle && ([invoiceTitle isEqual:[NSNull null]] == NO) && ([invoiceTitle length] > 0))
    {
        self.userInvoiceType = invoiceType;
    }
    if (mobileMasked && ([mobileMasked isEqual:[NSNull null]] == NO) && ([mobileMasked length] > 0))
    {
        self.userMobileMasked = mobileMasked;
    }
    if (newMember && ([newMember isEqual:[NSNull null]] == NO) && ([newMember length] > 0))
    {
        BOOL isNewMember = [newMember boolValue];
        self.userIsNewMember = isNewMember;
    }
    if (ocbStatus && ([ocbStatus isEqual:[NSNull null]] == NO) && ([ocbStatus length] > 0))
    {
        if ([ocbStatus compare:SymphoxAPIParamValue_Y options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            self.userOcbStatus = OCBStatusActivated;
        }
        else if ([ocbStatus compare:SymphoxAPIParamValue_T options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            self.userOcbStatus = OCBStatusShouldActivateInTreeMall;
        }
        else if ([ocbStatus compare:SymphoxAPIParamValue_N options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            self.userOcbStatus = OCBStatusShouldActivateInBank;
        }
        else if ([ocbStatus compare:SymphoxAPIParamValue_E options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            self.userOcbStatus = OCBStatusExpired;
        }
    }
    if (ocbUrl && ([ocbUrl isEqual:[NSNull null]] == NO) && ([ocbUrl length] > 0))
    {
        self.userOcbUrl = ocbUrl;
    }
    if (passwordStatus && ([passwordStatus isEqual:[NSNull null]] == NO) && ([passwordStatus length] > 0))
    {
        BOOL hasPassword = [passwordStatus boolValue];
        self.userHasPassword = hasPassword;
    }
    if (taxId && ([taxId isEqual:[NSNull null]] == NO) && ([taxId length] > 0))
    {
        self.userTaxId = taxId;
    }
    if (telephoneAreaCode && ([telephoneAreaCode isEqual:[NSNull null]] == NO) && ([telephoneAreaCode length] > 0))
    {
        self.userTelephoneAreaCode = telephoneAreaCode;
    }
    if (telephoneExtension && ([telephoneExtension isEqual:[NSNull null]] == NO) && ([telephoneExtension length] > 0))
    {
        self.userTelephoneExtension = telephoneExtension;
    }
    if (telephone && ([telephone isEqual:[NSNull null]] == NO) && ([telephone length] > 0))
    {
        self.userTelephone = telephone;
    }
    if (idCardNumber && ([idCardNumber isEqual:[NSNull null]] == NO) && ([idCardNumber length] > 0))
    {
        self.userIDCardNumber = idCardNumber;
    }
    if (zipCode && ([zipCode isEqual:[NSNull null]] == NO) && ([zipCode length] > 0))
    {
        self.userZipCode = zipCode;
    }
    if (address && ([address isEqual:[NSNull null]] == NO) && ([address length] > 0))
    {
        self.userAddress = address;
    }
    
    if (self.userLoginDate == nil)
    {
        NSString *stringDate = [self formattedStringFromDate:[NSDate date]];
        self.userLoginDate = stringDate;
        NSLog(@"Login time [%@]", stringDate);
    }
    if (self.userLoginIP == nil)
    {
        NSString *ipAddress = [Utility ipAddressPreferIPv6:NO];
        NSLog(@"Login IP [%@]", ipAddress);
        self.userLoginIP = ipAddress;
    }
    
    [self saveToArchive];
    
    // Assume that userAuthStatus should always be in the user information, if it is missing, we should reload user information again.
    if (self.userAuthStatus == nil)
    {
        // Should retrieve user information
        [self retrieveUserInformation];
    }
    
    if (self.userEpoint == nil && self.userIdentifier)
    {
        [self retrievePointDataFromObject:nil withCompletion:nil];
    }
    
    if (self.userEcoupon == nil && self.userIdentifier)
    {
        [self retrieveCouponDataFromObject:nil forPageIndex:1 couponState:CouponStateNotUsed sortFactor:SymphoxAPIParamValue_worth withSortOrder:SymphoxAPIParamValue_desc withCompletion:nil];
    }
}

- (void)setSubcategories:(NSArray *)subcategories forIdentifier:(NSString *)identifier atLayer:(NSNumber *)layer
{
    if (subcategories == nil)
        return;
    _numberArchiveTimestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    NSString *key = [self keyForCategoryIdentifier:identifier withLayer:layer];
    [_dictionaryCachedCategories setObject:subcategories forKey:key];
}

- (NSArray *)subcategoriesForIdentifier:(NSString *)identifier atLayer:(NSNumber *)layer
{
    NSString *key = [self keyForCategoryIdentifier:identifier withLayer:layer];
//    NSLog(@"subcategoriesForIdentifier - key[%@]", key);
    NSArray *categories = [_dictionaryCachedCategories objectForKey:key];
//    NSLog(@"subcategoriesForIdentifier - categories:\n%@", [categories description]);
    return categories;
}

- (NSDictionary *)cachedDictionaries
{
    return _dictionaryCachedCategories;
}

- (NSArray *)categoriesContainsCategoryWithIdentifier:(NSString *)identifier
{
    NSArray *categories = nil;
    for (NSString *key in [_dictionaryCachedCategories allKeys])
    {
        id value = [_dictionaryCachedCategories objectForKey:key];
        if ([value isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)value;
            for (NSDictionary *category in array)
            {
                NSString *hallId = [category objectForKey:SymphoxAPIParam_hall_id];
                if ([hallId isEqualToString:identifier])
                {
                    categories = array;
                    break;
                }
            }
        }
        if (categories != nil)
        {
            break;
        }
    }
    return categories;
}

- (void)findSiblingsInSameLayerAndContentForCategoryIdentifier:(NSString *)identifier withCompletion:(void (^)(NSArray *, NSDictionary *, NSNumber *))block
{
    NSArray *siblings = nil;
    NSDictionary *content = nil;
    NSNumber *layerNumber = nil;
    for (NSString *key in [_dictionaryCachedCategories allKeys])
    {
        id value = [_dictionaryCachedCategories objectForKey:key];
        if ([value isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)value;
            for (NSDictionary *category in array)
            {
                NSString *hallId = [category objectForKey:SymphoxAPIParam_hall_id];
                if ([hallId isEqualToString:identifier])
                {
                    siblings = array;
                    content = category;
                    break;
                }
            }
        }
        if (siblings != nil && content != nil)
        {
            NSArray *keyComponents = [key componentsSeparatedByString:SeparatorBetweenIdAndLayer];
            
            NSString *parentLayerString = [keyComponents lastObject];
            if (parentLayerString)
            {
                NSInteger layer = [parentLayerString integerValue] + 1;
                layerNumber = [NSNumber numberWithInteger:layer];
            }
            break;
        }
    }
    if (block)
    {
        block(siblings, content, layerNumber);
    }
}

- (void)retrieveToken:(void (^)(BOOL))completion
{
    CryptoModule *module = [CryptoModule sharedModule];
    [SHAPIAdapter sharedAdapter].encryptModule = module;
    [SHAPIAdapter sharedAdapter].decryptModule = module;
    
    __weak TMInfoManager *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, @"sym-api-key", nil];
    NSURL *url = [NSURL URLWithString:SymphoxAPI_token];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:[NSMutableData dataWithLength:0] inPostFormat:SHPostFormatNSData encrypted:YES decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //                NSLog(@"string[%@]", string);
                [SHAPIAdapter sharedAdapter].token = string;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_TokenUpdated object:self];
                
                if (weakSelf.userIdentifier != nil)
                {
                    [weakSelf retrieveUserInformation];
                }
            }
            if (completion != nil)
                completion(YES);
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_NoInitialToken object:self];
            id<GAITracker> gaTracker = [GAI sharedInstance].defaultTracker;
            [gaTracker send:[[GAIDictionaryBuilder
                              createEventWithCategory:@"retrieveToken"
                              action:[error description]
                              label:nil
                              value:nil] build]];
        }
        if (completion != nil)
            completion(NO);
    }];
}

- (void)addKeyword:(NSString *)keyword
{
    if (keyword == nil)
        return;
    if ([_orderedSetKeyword containsObject:keyword])
    {
        NSInteger index = [_orderedSetKeyword indexOfObject:keyword];
        if (index > 0)
        {
            [_orderedSetKeyword removeObjectAtIndex:index];
            [_orderedSetKeyword insertObject:keyword atIndex:0];
        }
    }
    else
    {
        if ([_orderedSetKeyword count] >= SearchKeywordNumberMax)
        {
            [_orderedSetKeyword removeObject:[_orderedSetKeyword lastObject]];
        }
        [_orderedSetKeyword insertObject:keyword atIndex:0];
    }
    [self saveToArchive];
}

- (NSArray *)keywords
{
    NSArray *keywords = [[_orderedSetKeyword array] copy];
    return keywords;
}

- (void)removeAllKeywords
{
    [_orderedSetKeyword removeAllObjects];
    [self saveToArchive];
}

- (void)setUserGenderByGenderText:(NSString *)genderText
{
    if ([genderText compare:@"m" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        self.userGender = TMGenderMale;
    }
    else if ([genderText compare:@"f" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        self.userGender = TMGenderFemale;
    }
    else
    {
        self.userGender = TMGenderUnknown;
    }
}

- (NSString *)addProductToFavorite:(NSDictionary *)product
{
    NSLog(@"product:\n%@", product);
    NSString *resultString = nil;
    NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
    if (productId == nil || [productId isEqual:[NSNull null]])
    {
        NSLog(@"addProductToFavorite - Cannot find product identifier");
        resultString = [LocalizedString CannotFindProductId];
        return resultString;
    }
    if ([self.orderedSetFavoriteId containsObject:productId])
    {
        NSLog(@"addProductToFavorite - Already in the favorite list.");
        resultString = [LocalizedString AlreadyInFavorite];
        return resultString;
    }
    [self.orderedSetFavoriteId addObject:productId];
    [self.arrayFavorite addObject:product];
    [self saveToFavoriteArchive];
    NSLog(@"orderedSetFavoriteId[%li] arrayFavorite[%li]", (long)self.orderedSetFavoriteId.count, (long)self.arrayFavorite.count);
    resultString = [LocalizedString AddToFavoriteSuccess];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_FavoriteContentChanged object:self];
    
    return resultString;
}

- (NSArray *)favorites
{
    NSArray *favorites = self.arrayFavorite;
    return favorites;
}

- (BOOL)favoriteContainsProductWithIdentifier:(NSNumber *)productId
{
    BOOL contains = NO;
    for (NSDictionary *product in self.arrayFavorite)
    {
        NSNumber *cpdt_num = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO && [cpdt_num isEqualToNumber:productId])
        {
            contains = YES;
            break;
        }
    }
    return contains;
}

- (void)removeProductFromFavorite:(NSInteger)productIndex
{
    if (productIndex < [self.arrayFavorite count])
    {
        NSDictionary *product = [self.arrayFavorite objectAtIndex:productIndex];
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        [self.orderedSetFavoriteId removeObject:productId];
        [self.arrayFavorite removeObjectAtIndex:productIndex];
    }
    [self saveToFavoriteArchive];
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_FavoriteContentChanged object:self];
}

- (void)removeFavoriteProductWithIdentifier:(NSNumber *)productId
{
    for (NSInteger productIndex = ([[self.arrayFavorite copy] count] - 1); productIndex >= 0; productIndex--)
    {
        NSDictionary *product = [self.arrayFavorite objectAtIndex:productIndex];
        NSNumber *currentProductId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if ([currentProductId isEqualToNumber:productId])
        {
            [self.arrayFavorite removeObjectAtIndex:productIndex];
            [self.orderedSetFavoriteId removeObject:productId];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_FavoriteContentChanged object:self];
}

- (NSInteger)numberOfProductsInFavorite
{
    NSInteger numberOfProducts = [self.arrayFavorite count];
    return numberOfProducts;
}

- (void)retrievePointDataFromObject:(id)object withCompletion:(void (^)(id, NSError *))block
{
    __weak TMInfoManager *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_memberPoint];
//    NSLog(@"retrieveUserInformation - [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:self.userIdentifier, SymphoxAPIParam_user_num, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"retrievePointDataFromObject - resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                [weakSelf processUserPoint:data];
            }
        }
        else
        {
            NSLog(@"retrievePointDataFromObject - error:\n%@", [error description]);
        }
    }];
}

- (void)retrieveCouponDataFromObject:(id)object forPageIndex:(NSInteger)pageIndex couponState:(CouponState)state sortFactor:(NSString *)factor withSortOrder:(NSString *)order withCompletion:(void (^)(id, NSError *))block
{
    __weak TMInfoManager *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_memberCoupon];
//    NSLog(@"retrieveUserInformation - [%@]", [url absoluteString]);
//    NSString *stateText = SymphoxAPIParamValue_NotUsed_cht;
    NSNumber *numberState = [NSNumber numberWithUnsignedInteger:state];
    
    NSNumber *numberPage = [NSNumber numberWithInteger:pageIndex];
    NSNumber *numberPageCount = [NSNumber numberWithInteger:25];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:self.userIdentifier, SymphoxAPIParam_user_num, numberState, SymphoxAPIParam_status, factor, SymphoxAPIParam_sort_column, order, SymphoxAPIParam_sort_order, numberPage, SymphoxAPIParam_page, numberPageCount, SymphoxAPIParam_page_count, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        id result = nil;
        if (error == nil)
        {
//            NSLog(@"retrieveCouponDataFromObject - resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                result = [weakSelf processUserCoupon:data];
            }
        }
        else
        {
            NSLog(@"retrieveCouponDataFromObject - error:\n%@", [error description]);
        }
        if (object != nil && block != nil)
        {
            block(result, error);
        }
    }];
}

- (void)logoutUser
{
    [SAMKeychain deletePasswordForService:[[NSBundle mainBundle] bundleIdentifier] account:TMIdentifier];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TMIdentifier];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    NSNumber *userId = [self.userIdentifier copy];
    [self resetData];
    [self deleteArchiveForIdentifier:userId];
    userId = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_UserLogout object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_CartContentChanged object:self];
}

- (void)retrieveUserInformation
{
    __weak TMInfoManager *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_memberInformation];
//    NSLog(@"retrieveUserInformation - [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:self.userIdentifier, SymphoxAPIParam_user_num, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"retrieveUserInformation - resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                [weakSelf processUserInformation:data];
            }
        }
        else
        {
            NSLog(@"retrieveUserInformation - error:\n%@", [error description]);
        }
    }];
}

- (NSMutableArray *)productArrayForCartType:(CartType)type
{
    NSMutableArray *array = nil;
    switch (type) {
        case CartTypeCommonDelivery:
        {
            array = self.arrayCartCommon;
        }
            break;
        case CartTypeStorePickup:
        {
            array = self.arrayCartStorePickUp;
        }
            break;
        case CartTypeFastDelivery:
        {
            array = self.arrayCartFast;
        }
            break;
        case CartTypeDirectlyPurchase:
        {
            array = self.arrayCartDirect;
        }
            break;
        default:
            break;
    }
    return array;
}

- (NSMutableDictionary *)purchaseInfoForCartType:(CartType)type
{
    NSMutableDictionary *dictionaryPurchaseInfo = nil;
    switch (type) {
        case CartTypeCommonDelivery:
        {
            dictionaryPurchaseInfo = self.dictionaryProductPurchaseInfoInCartCommon;
        }
            break;
        case CartTypeStorePickup:
        {
            dictionaryPurchaseInfo = self.dictionaryProductPurchaseInfoInCartStorePickUp;
        }
            break;
        case CartTypeFastDelivery:
        {
            dictionaryPurchaseInfo = self.dictionaryProductPurchaseInfoInCartFast;
        }
            break;
        case CartTypeDirectlyPurchase:
        {
            dictionaryPurchaseInfo = self.dictionaryProductPurchaseInfoInCartDirect;
        }
            break;
        default:
            break;
    }
    return dictionaryPurchaseInfo;
}

- (void)addProduct:(NSDictionary *)product toCartForType:(CartType)type
{
    if (product == nil)
        return;
    NSNumber *currentProductId = [product objectForKey:SymphoxAPIParam_cpdt_num];
    if (currentProductId == nil || [currentProductId isEqual:[NSNull null]])
        return;
    
    NSMutableArray *array = [self productArrayForCartType:type];
    if (array == nil)
        return;
    
    __block BOOL alreadyInCart = NO;
    [array enumerateObjectsUsingBlock:^(id _Nonnull object, NSUInteger idx, BOOL *stop){
        NSDictionary *product = (NSDictionary *)object;
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId && [productId isEqual:[NSNull null]] == NO)
        {
            if ([currentProductId isEqualToNumber:productId])
            {
                alreadyInCart = YES;
                *stop = YES;
            }
        }
    }];
    if (alreadyInCart)
    {
        return;
    }
    
    [self setPurchaseQuantity:[NSNumber numberWithInteger:1] forProduct:currentProductId inCart:type];
    NSDictionary *dictionaryMode = [NSDictionary dictionary];
//    [self setPurchasePaymentMode:dictionaryMode forProduct:currentProductId inCart:type];
    [self setPurchaseInfoFromSelectedPaymentMode:dictionaryMode forProductId:currentProductId withRealProductId:currentProductId inCart:type asAdditional:NO];
    [array addObject:product];
    [self saveToArchive];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_CartContentChanged object:self];
}

- (void)setPurchaseQuantity:(NSNumber *)quantity forProduct:(NSNumber *)productId inCart:(CartType)cartType
{
    NSMutableDictionary *dictionaryPurchaseInfo = [self purchaseInfoForCartType:cartType];
    if (dictionaryPurchaseInfo == nil)
        return;
    NSMutableDictionary *dictionary = [[dictionaryPurchaseInfo objectForKey:productId] mutableCopy];
    if (dictionary == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:quantity forKey:SymphoxAPIParam_qty];
    
    [dictionaryPurchaseInfo setObject:dictionary forKey:productId];
    [self saveToArchive];
}

- (void)setPurchasePaymentMode:(NSDictionary *)dictionaryPaymentMode forProduct:(NSNumber *)productId withRealProductId:(NSNumber *)realProductId inCart:(CartType)cartType
{
    if (dictionaryPaymentMode == nil)
        return;
    
    NSMutableDictionary *dictionaryPurchaseInfo = [self purchaseInfoForCartType:cartType];
    if (dictionaryPurchaseInfo == nil)
        return;
    
    NSMutableDictionary *dictionary = [[dictionaryPurchaseInfo objectForKey:productId] mutableCopy];
    if (dictionary == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:dictionaryPaymentMode forKey:SymphoxAPIParam_payment_mode];
    if (realProductId != nil)
    {
        [dictionary setObject:realProductId forKey:SymphoxAPIParam_real_cpdt_num];
    }
    
    [dictionaryPurchaseInfo setObject:dictionary forKey:productId];
    NSLog(@"dictionaryProductPurchaseInfoInCartCommon:\n%@", [self.dictionaryProductPurchaseInfoInCartCommon description]);
//    NSLog(@"dictionaryProductPurchaseInfoInCartFast:\n%@", [self.dictionaryProductPurchaseInfoInCartFast description]);
//    NSLog(@"dictionaryProductPurchaseInfoInCartStorePickUp:\n%@", [self.dictionaryProductPurchaseInfoInCartStorePickUp description]);
//    NSLog(@"dictionaryProductPurchaseInfoInCartDirect:\n%@", [self.dictionaryProductPurchaseInfoInCartDirect description]);
    [self saveToArchive];
}

- (void)setDiscountTypeDescription:(NSString *)description forProduct:(NSNumber *)productId inCart:(CartType)cartType
{
    if (description == nil)
        return;
    
    NSMutableDictionary *dictionaryPurchaseInfo = [self purchaseInfoForCartType:cartType];
    if (dictionaryPurchaseInfo == nil)
        return;
    
    NSMutableDictionary *dictionary = [[dictionaryPurchaseInfo objectForKey:productId] mutableCopy];
    if (dictionary == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:description forKey:SymphoxAPIParam_discount_type_desc];
    
    [dictionaryPurchaseInfo setObject:dictionary forKey:productId];
    
    [self saveToArchive];
}

- (void)setDiscountDetailDescription:(NSString *)description forProduct:(NSNumber *)productId inCart:(CartType)cartType
{
    if (description == nil)
        return;
    
    NSMutableDictionary *dictionaryPurchaseInfo = [self purchaseInfoForCartType:cartType];
    if (dictionaryPurchaseInfo == nil)
        return;
    
    NSMutableDictionary *dictionary = [[dictionaryPurchaseInfo objectForKey:productId] mutableCopy];
    if (dictionary == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:description forKey:SymphoxAPIParam_discount_detail_desc];
    
    [dictionaryPurchaseInfo setObject:dictionary forKey:productId];
    
    [self saveToArchive];
}

- (NSString *)nameOfRemovedProductId:(NSNumber *)productIdToRemove inCart:(CartType)type
{
    NSLog(@"--- 1 arrayCartFast[%li]:\n%@", (long)type, [self.arrayCartFast description]);
    NSLog(@"--- 1 dictionaryProductPurchaseInfoInCartFast[%li]:\n%@", (long)type, [self.dictionaryProductPurchaseInfoInCartFast description]);
    if (productIdToRemove == nil)
        return nil;
    NSMutableArray *array = [self productArrayForCartType:type];
    if (array == nil)
        return nil;
    NSMutableDictionary *purchaseInfo = [self purchaseInfoForCartType:type];
    
    __block NSInteger index = NSNotFound;
    __block NSString *name = nil;
    [array enumerateObjectsUsingBlock:^(id _Nonnull object, NSUInteger idx, BOOL *stop){
        NSDictionary *product = (NSDictionary *)object;
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId && [productId isEqual:[NSNull null]] == NO)
        {
            if ([productIdToRemove isEqualToNumber:productId])
            {
                name = [product objectForKey:SymphoxAPIParam_name];
                if (name == nil)
                {
                    name = [product objectForKey:SymphoxAPIParam_cpdt_name];
                }
                index = idx;
                *stop = YES;
            }
        }
    }];
    if (index == NSNotFound)
        return nil;
    if (index < [array count])
    {
        [array removeObjectAtIndex:index];
    }
    NSLog(@"arrayCartFast:\n%@", [self.arrayCartFast description]);
    if (purchaseInfo)
    {
        [purchaseInfo removeObjectForKey:productIdToRemove];
    }
    NSLog(@"dictionaryProductPurchaseInfoInCartFast:\n%@", [self.dictionaryProductPurchaseInfoInCartFast description]);
    [self saveToArchive];
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_CartContentChanged object:self];
    if (name == nil)
        return nil;
    NSString *productName = [NSString stringWithString:name];
    NSLog(@"--- 1 arrayCartFast[%li]:\n%@", (long)type, [self.arrayCartFast description]);
    NSLog(@"--- 1 dictionaryProductPurchaseInfoInCartFast[%li]:\n%@", (long)type, [self.dictionaryProductPurchaseInfoInCartFast description]);
    return productName;
}

- (NSMutableArray *)productArrayForAdditionalCartType:(CartType)type
{
    NSMutableArray *array = nil;
    switch (type) {
        case CartTypeCommonDelivery:
        {
            array = self.arrayCartCommonAddition;
        }
            break;
        case CartTypeStorePickup:
        {
            array = self.arrayCartStorePickUpAddition;
        }
            break;
        case CartTypeFastDelivery:
        {
            array = self.arrayCartFastAddition;
        }
            break;
        case CartTypeDirectlyPurchase:
        {
            array = self.arrayCartDirectAddition;
        }
            break;
        default:
            break;
    }
    return array;
}

- (NSMutableDictionary *)purchaseInfoForAdditionalCartType:(CartType)type
{
    NSMutableDictionary *dictionaryPurchaseInfo = nil;
    switch (type) {
        case CartTypeCommonDelivery:
        {
            dictionaryPurchaseInfo = self.dictionaryProductPurchaseInfoInCartCommonAddition;
        }
            break;
        case CartTypeStorePickup:
        {
            dictionaryPurchaseInfo = self.dictionaryProductPurchaseInfoInCartStorePickUpAddition;
        }
            break;
        case CartTypeFastDelivery:
        {
            dictionaryPurchaseInfo = self.dictionaryProductPurchaseInfoInCartFastAddition;
        }
            break;
        case CartTypeDirectlyPurchase:
        {
            dictionaryPurchaseInfo = self.dictionaryProductPurchaseInfoInCartDirectAddition;
        }
            break;
        default:
            break;
    }
    return dictionaryPurchaseInfo;
}

- (void)addProduct:(NSDictionary *)product toAdditionalCartForType:(CartType)type
{
    if (product == nil)
        return;
    NSNumber *currentProductId = [product objectForKey:SymphoxAPIParam_cpdt_num];
    if (currentProductId == nil || [currentProductId isEqual:[NSNull null]])
        return;
    
    NSMutableArray *array = [self productArrayForAdditionalCartType:type];
    if (array == nil)
        return;
    
    __block BOOL alreadyInCart = NO;
    [array enumerateObjectsUsingBlock:^(id _Nonnull object, NSUInteger idx, BOOL *stop){
        NSDictionary *product = (NSDictionary *)object;
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId && [productId isEqual:[NSNull null]] == NO)
        {
            if ([currentProductId isEqualToNumber:productId])
            {
                alreadyInCart = YES;
                *stop = YES;
            }
        }
    }];
    if (alreadyInCart)
    {
        return;
    }
    [self setPurchaseQuantity:[NSNumber numberWithInteger:1] forProduct:currentProductId inAdditionalCart:type];
    NSDictionary *dictionaryMode = [NSDictionary dictionary];
//    [self setPurchasePaymentMode:dictionaryMode forProduct:currentProductId inAdditionalCart:type];
    [self setPurchaseInfoFromSelectedPaymentMode:dictionaryMode forProductId:currentProductId withRealProductId:currentProductId inCart:type asAdditional:YES];
    [array addObject:product];
//    [self saveToArchive];
}

- (void)setPurchaseQuantity:(NSNumber *)quantity forProduct:(NSNumber *)productId inAdditionalCart:(CartType)cartType
{
    NSMutableDictionary *dictionaryPurchaseInfo = [self purchaseInfoForAdditionalCartType:cartType];
    if (dictionaryPurchaseInfo == nil)
        return;
    NSMutableDictionary *dictionary = [[dictionaryPurchaseInfo objectForKey:productId] mutableCopy];
    if (dictionary == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:quantity forKey:SymphoxAPIParam_qty];
    
    [dictionaryPurchaseInfo setObject:dictionary forKey:productId];
//    [self saveToArchive];
}

- (void)setPurchasePaymentMode:(NSDictionary *)dictionaryPaymentMode forProduct:(NSNumber *)productId withRealProductId:(NSNumber *)realProductId inAdditionalCart:(CartType)cartType
{
    if (dictionaryPaymentMode == nil)
        return;
    
    NSMutableDictionary *dictionaryPurchaseInfo = [self purchaseInfoForAdditionalCartType:cartType];
    if (dictionaryPurchaseInfo == nil)
        return;
    
    NSMutableDictionary *dictionary = [[dictionaryPurchaseInfo objectForKey:productId] mutableCopy];
    if (dictionary == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:dictionaryPaymentMode forKey:SymphoxAPIParam_payment_mode];
    if (realProductId != nil)
    {
        [dictionary setObject:realProductId forKey:SymphoxAPIParam_real_cpdt_num];
    }
    
    [dictionaryPurchaseInfo setObject:dictionary forKey:productId];
    NSLog(@"dictionaryProductPurchaseInfoInCartCommonAddition:\n%@", [self.dictionaryProductPurchaseInfoInCartCommonAddition description]);
    NSLog(@"dictionaryProductPurchaseInfoInCartStorePickUpAddition:\n%@", [self.dictionaryProductPurchaseInfoInCartStorePickUpAddition description]);
    NSLog(@"dictionaryProductPurchaseInfoInCartFastAddition:\n%@", [self.dictionaryProductPurchaseInfoInCartFastAddition description]);
//    [self saveToArchive];
}

- (void)setDiscountTypeDescription:(NSString *)description forProduct:(NSNumber *)productId inAdditionalCart:(CartType)cartType
{
    if (description == nil)
        return;
    
    NSMutableDictionary *dictionaryPurchaseInfo = [self purchaseInfoForAdditionalCartType:cartType];
    if (dictionaryPurchaseInfo == nil)
        return;
    
    NSMutableDictionary *dictionary = [[dictionaryPurchaseInfo objectForKey:productId] mutableCopy];
    if (dictionary == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:description forKey:SymphoxAPIParam_discount_type_desc];
    
    [dictionaryPurchaseInfo setObject:dictionary forKey:productId];
    
    //    [self saveToArchive];
}

- (void)setDiscountDetailDescription:(NSString *)description forProduct:(NSNumber *)productId inAdditionalCart:(CartType)cartType
{
    if (description == nil)
        return;
    
    NSMutableDictionary *dictionaryPurchaseInfo = [self purchaseInfoForAdditionalCartType:cartType];
    if (dictionaryPurchaseInfo == nil)
        return;
    
    NSMutableDictionary *dictionary = [[dictionaryPurchaseInfo objectForKey:productId] mutableCopy];
    if (dictionary == nil)
    {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:description forKey:SymphoxAPIParam_discount_detail_desc];
    
    [dictionaryPurchaseInfo setObject:dictionary forKey:productId];
    
//    [self saveToArchive];
}

- (NSString *)nameOfRemovedProductId:(NSNumber *)productIdToRemove inAdditionalCart:(CartType)type
{
    if (productIdToRemove == nil)
        return nil;
    NSMutableArray *array = [self productArrayForAdditionalCartType:type];
    if (array == nil)
        return nil;
    NSMutableDictionary *purchaseInfo = [self purchaseInfoForAdditionalCartType:type];
    
    __block NSInteger index = NSNotFound;
    __block NSString *name = nil;
    [array enumerateObjectsUsingBlock:^(id _Nonnull object, NSUInteger idx, BOOL *stop){
        NSDictionary *product = (NSDictionary *)object;
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId && [productId isEqual:[NSNull null]] == NO)
        {
            if ([productIdToRemove isEqualToNumber:productId])
            {
                name = [product objectForKey:SymphoxAPIParam_name];
                if (name == nil)
                {
                    name = [product objectForKey:SymphoxAPIParam_cpdt_name];
                }
                index = idx;
                *stop = YES;
            }
        }
    }];
    if (index == NSNotFound)
        return nil;
    if (index < [array count])
    {
        [array removeObjectAtIndex:index];
    }
    if (purchaseInfo)
    {
        [purchaseInfo removeObjectForKey:productIdToRemove];
    }
    [self saveToArchive];
    
    if (name == nil)
        return nil;
    NSString *productName = [NSString stringWithString:name];
    return productName;
}

- (void)setPurchaseInfoFromSelectedPaymentMode:(NSDictionary *)paymentModeSelected forProductId:(NSNumber *)productId withRealProductId:(NSNumber *)realProductId inCart:(CartType)cartType asAdditional:(BOOL)isAdditional
{
    NSMutableDictionary *paymentMode = [NSMutableDictionary dictionary];
    
    id payment_type = [paymentModeSelected objectForKey:SymphoxAPIParam_payment_type];
    if (payment_type)
    {
        [paymentMode setObject:payment_type forKey:SymphoxAPIParam_payment_type];
    }
    id price = [paymentModeSelected objectForKey:SymphoxAPIParam_price];
    if (price)
    {
        [paymentMode setObject:price forKey:SymphoxAPIParam_price];
    }
    id total_point = [paymentModeSelected objectForKey:SymphoxAPIParam_total_point];
    if (total_point)
    {
        [paymentMode setObject:total_point forKey:SymphoxAPIParam_total_point];
    }
    id point = [paymentModeSelected objectForKey:SymphoxAPIParam_point];
    if (point)
    {
        [paymentMode setObject:point forKey:SymphoxAPIParam_point];
    }
    id epoint = [paymentModeSelected objectForKey:SymphoxAPIParam_epoint];
    if (epoint)
    {
        [paymentMode setObject:epoint forKey:SymphoxAPIParam_epoint];
    }
    id cpoint = [paymentModeSelected objectForKey:SymphoxAPIParam_cpoint];
    if (cpoint)
    {
        [paymentMode setObject:cpoint forKey:SymphoxAPIParam_cpoint];
    }
    id coupon_discount = [paymentModeSelected objectForKey:SymphoxAPIParam_coupon_discount];
    if (coupon_discount)
    {
        [paymentMode setObject:coupon_discount forKey:SymphoxAPIParam_coupon_discount];
    }
    id eacc_num = [paymentModeSelected objectForKey:SymphoxAPIParam_eacc_num];
    if (eacc_num)
    {
        [paymentMode setObject:eacc_num forKey:SymphoxAPIParam_eacc_num];
    }
    id cm_id = [paymentModeSelected objectForKey:SymphoxAPIParam_cm_id];
    if (cm_id)
    {
        [paymentMode setObject:cm_id forKey:SymphoxAPIParam_cm_id];
    }
    
    if (isAdditional)
    {
        [[TMInfoManager sharedManager] setPurchasePaymentMode:paymentMode forProduct:productId withRealProductId:realProductId inAdditionalCart:cartType];
    }
    else
    {
        [[TMInfoManager sharedManager] setPurchasePaymentMode:paymentMode forProduct:productId withRealProductId:realProductId inCart:cartType];
    }
    
    id discount_type_desc = [paymentModeSelected objectForKey:SymphoxAPIParam_discount_type_desc];
    id discount_detail_desc = [paymentModeSelected objectForKey:SymphoxAPIParam_discount_detail_desc];
    if ([discount_detail_desc isKindOfClass:[NSString class]])
    {
        if (isAdditional)
        {
            [[TMInfoManager sharedManager] setDiscountTypeDescription:discount_type_desc forProduct:productId inAdditionalCart:cartType];
            [[TMInfoManager sharedManager] setDiscountDetailDescription:discount_detail_desc forProduct:productId inAdditionalCart:cartType];
        }
        else
        {
            [[TMInfoManager sharedManager] setDiscountTypeDescription:discount_type_desc forProduct:productId inCart:cartType];
            [[TMInfoManager sharedManager] setDiscountDetailDescription:discount_detail_desc forProduct:productId inCart:cartType];
        }
    }
}

- (NSInteger)numberOfProductsInCart:(CartType)type
{
    NSInteger totalCount = 0;
    switch (type) {
        case CartTypeCommonDelivery:
        {
            totalCount += [self.arrayCartCommon count];
        }
            break;
        case CartTypeStorePickup:
        {
            totalCount += [self.arrayCartStorePickUp count];
        }
            break;
        case CartTypeFastDelivery:
        {
            totalCount += [self.arrayCartFast count];
        }
            break;
        case CartTypeTotal:
        {
            totalCount += [self.arrayCartCommon count];
            totalCount += [self.arrayCartStorePickUp count];
            totalCount += [self.arrayCartFast count];
        }
            break;
        default:
            break;
    }
    return totalCount;
}

- (void)resetCartForType:(CartType)type
{
    NSMutableArray *array = [self productArrayForCartType:type];
    NSMutableArray *additionArray = [self productArrayForAdditionalCartType:type];
    NSMutableDictionary *dictionary = [self purchaseInfoForCartType:type];
    NSMutableDictionary *additionDictionary = [self purchaseInfoForAdditionalCartType:type];
    
    [array removeAllObjects];
    [dictionary removeAllObjects];
    [additionArray removeAllObjects];
    [additionDictionary removeAllObjects];
    
    if (type == CartTypeFastDelivery)
    {
        [self resetProductFastDelivery];
    }
    
    [self saveToArchive];
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_CartContentChanged object:self];
}

- (void)initializeCartForType:(CartType)type
{
    NSMutableArray *additionArray = [self productArrayForAdditionalCartType:type];
    NSMutableDictionary *additionDictionary = [self purchaseInfoForAdditionalCartType:type];
    [additionArray removeAllObjects];
    [additionDictionary removeAllObjects];
    if (type == CartTypeFastDelivery)
    {
        [self resetProductFastDelivery];
    }
}

- (NSString *)formattedStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}

- (void)sendPushToken:(NSString *)token
{
    __weak TMInfoManager *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_sendPushInfo];
    NSString *udid = self.deviceIdentifier;
    NSNumber *userId = self.userIdentifier;
    NSString *userIdentifier = nil;
    if (userId)
    {
        userIdentifier = [userId stringValue];
    }
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_06", SymphoxAPIParam_txid, udid, SymphoxAPIParam_device_id, token, SymphoxAPIParam_device_token, userIdentifier, SymphoxAPIParam_user_sn, @"i", SymphoxAPIParam_device_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSString *string = [[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding];
//            NSLog(@"retrieveData:\n%@", string);
        }
        else
        {
            NSLog(@"sendPushToken - error:\n%@", error);
        }
        
    }];
}

- (NSDictionary *)productFastDeliveryWithType:(FastDeliveryProductType)productType
{
    NSDictionary *product = nil;
    NSNumber *cpdt_num = nil;
    NSNumber *payment_type = nil;
    
    switch (productType) {
        case FastDeliveryProductTypeCash:
        {
            cpdt_num = TMProductFastDeliveryCash;
            payment_type = [NSNumber numberWithInteger:0];
        }
            break;
        case FastDeliveryProductTypePoint:
        {
            cpdt_num = TMProductFastDeliveryPoint;
            payment_type = [NSNumber numberWithInteger:1];
        }
            break;
        default:
            break;
    }
    if (cpdt_num && payment_type)
    {
        NSDictionary *payment_mode = [NSDictionary dictionaryWithObjectsAndKeys:payment_type, SymphoxAPIParam_payment_type, nil];
        product = [NSDictionary dictionaryWithObjectsAndKeys:cpdt_num, SymphoxAPIParam_cpdt_num, [NSNumber numberWithInteger:1], SymphoxAPIParam_qty, payment_mode, SymphoxAPIParam_payment_mode, nil];
    }
    
    return product;
}

- (NSDictionary *)productFastDeliveryFromReferenceDictionary:(NSDictionary *)dictionary
{
    NSDictionary *product = nil;
    NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
    NSNumber *payment_type = [dictionary objectForKey:SymphoxAPIParam_payment_type];
    if (cpdt_num && payment_type)
    {
        NSMutableDictionary *payment_mode = [NSMutableDictionary dictionary];
        [payment_mode setObject:payment_type forKey:SymphoxAPIParam_payment_type];
        NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO)
        {
            [payment_mode setObject:cpdt_num forKey:SymphoxAPIParam_cpdt_num];
        }
        NSNumber *cpoint = [dictionary objectForKey:SymphoxAPIParam_cpoint];
        if (cpoint && [cpoint isEqual:[NSNull null]] == NO)
        {
            [payment_mode setObject:cpoint forKey:SymphoxAPIParam_cpoint];
        }
        NSNumber *epoint = [dictionary objectForKey:SymphoxAPIParam_epoint];
        if (epoint && [epoint isEqual:[NSNull null]] == NO)
        {
            [payment_mode setObject:epoint forKey:SymphoxAPIParam_epoint];
        }
        NSNumber *point = [dictionary objectForKey:SymphoxAPIParam_point];
        if (point && [point isEqual:[NSNull null]] == NO)
        {
            [payment_mode setObject:point forKey:SymphoxAPIParam_point];
        }
        NSNumber *price = [dictionary objectForKey:SymphoxAPIParam_price];
        if (price && [price isEqual:[NSNull null]] == NO)
        {
            [payment_mode setObject:price forKey:SymphoxAPIParam_price];
        }
        NSNumber *total_point = [dictionary objectForKey:SymphoxAPIParam_total_point];
        if (total_point && [total_point isEqual:[NSNull null]] == NO)
        {
            [payment_mode setObject:total_point forKey:SymphoxAPIParam_total_point];
        }
        product = [NSDictionary dictionaryWithObjectsAndKeys:cpdt_num, SymphoxAPIParam_cpdt_num, [NSNumber numberWithInteger:1], SymphoxAPIParam_qty, payment_mode, SymphoxAPIParam_payment_mode, nil];
    }
    return product;
}

- (NSDictionary *)productInfoForFastDeliveryFromInfo:(NSDictionary *)originInfo
{
    NSMutableDictionary *productInfo = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *used_payment_mode = [[originInfo objectForKey:SymphoxAPIParam_used_payment_mode] mutableCopy];
    if (used_payment_mode && [used_payment_mode isEqual:[NSNull null]] == NO)
    {
        [used_payment_mode removeObjectForKey:SymphoxAPIParam_cpdt_num];
        
        NSString *description = [used_payment_mode objectForKey:SymphoxAPIParam_description];
        if (description)
        {
            [used_payment_mode removeObjectForKey:SymphoxAPIParam_description];
        }
        NSString *discount_type_desc = [used_payment_mode objectForKey:SymphoxAPIParam_discount_type_desc];
        if (discount_type_desc)
        {
            [used_payment_mode removeObjectForKey:SymphoxAPIParam_discount_type_desc];
            if ([discount_type_desc isEqual:[NSNull null]] == NO)
            {
                [productInfo setObject:discount_type_desc forKey:SymphoxAPIParam_discount_type_desc];
            }
        }
        NSString *discount_detail_desc = [used_payment_mode objectForKey:SymphoxAPIParam_discount_detail_desc];
        if (discount_detail_desc)
        {
            [used_payment_mode removeObjectForKey:SymphoxAPIParam_discount_detail_desc];
            if ([discount_detail_desc isEqual:[NSNull null]] == NO)
            {
                [productInfo setObject:discount_detail_desc forKey:SymphoxAPIParam_discount_detail_desc];
            }
        }
        NSString *discount_cash_desc = [used_payment_mode objectForKey:SymphoxAPIParam_discount_cash_desc];
        if (discount_cash_desc)
        {
            [used_payment_mode removeObjectForKey:SymphoxAPIParam_discount_cash_desc];
        }
    }
    [productInfo setObject:used_payment_mode forKey:SymphoxAPIParam_payment_mode];
    [productInfo setObject:[NSNumber numberWithInteger:1] forKey:SymphoxAPIParam_qty];
    return productInfo;
}

- (void)resetProductFastDelivery
{
    self.productFastDelivery = nil;
    self.productInfoForFastDelivery = nil;
}

- (void)updateProductInfoForFastDeliveryFromInfos:(NSArray *)originInfos
{
    if (originInfos == nil)
        return;
    for (NSDictionary *originInfo in originInfos)
    {
        NSNumber *cpdt_num = [originInfo objectForKey:SymphoxAPIParam_cpdt_num];
        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO && ([cpdt_num isEqualToNumber:TMProductFastDeliveryCash] || [cpdt_num isEqualToNumber:TMProductFastDeliveryPoint]))
        {
            self.productInfoForFastDelivery = [self productInfoForFastDeliveryFromInfo:originInfo];
            break;
        }
    }
}

#pragma mark - Private Methods

- (NSURL *)urlForInfoDirectory
{
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"TMInfo"];
    NSError *error = nil;
    if ([[NSFileManager defaultManager] createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error])
    {
        [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        if (error)
        {
            NSLog(@"applicationDocumentsDirectory - url setResourceValue Failed:\n%@", [error description]);
        }
//        NSLog(@"_storagePathUrl.path[%@]", [_storagePathUrl path]);
    }
    else
    {
        NSLog(@"createDirectoryAtURL[%@] failed:\n%@", url, [error description]);
    }
    return url;
}

- (NSURL *)urlForInfoArchiveWithIdentifier:(NSString *)identifier
{
    NSString *name = @"archive";
    if (identifier)
    {
        name = identifier;
    }
    NSURL *url = [[[self urlForInfoDirectory] URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"dat"];
    return url;
}

- (NSURL *)urlForFavoriteArchive
{
    NSString *name = @"f";
    NSURL *url = [[[self urlForInfoDirectory] URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"dat"];
    return url;
}

- (void)applyDataFromArchivedDictionary:(NSDictionary *)dictionaryArchive
{
    if (dictionaryArchive == nil)
        return;
    NSArray *arrayPromotionRead = [dictionaryArchive objectForKey:TMInfoArchiveKey_PromotionRead];
    if (arrayPromotionRead)
    {
        [self.orderedSetPromotionRead addObjectsFromArray:arrayPromotionRead];
    }
    NSDictionary *dictionaryUserInfo = [dictionaryArchive objectForKey:TMInfoArchiveKey_UserInformation];
    if (dictionaryUserInfo)
    {
        [_dictionaryUserInfo setDictionary:dictionaryUserInfo];
    }
    NSArray *arrayKeyword = [dictionaryArchive objectForKey:TMInfoArchiveKey_OrderSetKeyword];
    if (arrayKeyword)
    {
        [self.orderedSetKeyword addObjectsFromArray:arrayKeyword];
    }
    BOOL shouldUpdateCachedData = YES;
    NSNumber *numberTimestamp = [dictionaryArchive objectForKey:TMInfoArchiveKey_ArchiveTimestamp];
    if (numberTimestamp)
    {
        _numberArchiveTimestamp = numberTimestamp;
        NSTimeInterval archiveTime = [_numberArchiveTimestamp doubleValue];
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval cachedAvail = 60.0 * 60.0 * 12;
        if (fabs((currentTime - archiveTime)) < cachedAvail)
        {
            shouldUpdateCachedData = NO;
        }
    }
    if (shouldUpdateCachedData == NO)
    {
        NSDictionary *dictionaryCategories = [dictionaryArchive objectForKey:TMInfoArchiveKey_CachedCategories];
        if (dictionaryCategories)
        {
            [_dictionaryCachedCategories setDictionary:dictionaryCategories];
        }
    }
    NSArray *arrayCartCommon = [dictionaryArchive objectForKey:TMInfoArchiveKey_CartCommon];
    if (arrayCartCommon)
    {
        [self.arrayCartCommon setArray:arrayCartCommon];
    }
    NSDictionary *dictionaryCartCommon = [dictionaryArchive objectForKey:TMInfoArchiveKey_PurchaseInfoInCartCommon];
    if (dictionaryCartCommon)
    {
        [self.dictionaryProductPurchaseInfoInCartCommon setDictionary:dictionaryCartCommon];
    }
    NSArray *arrayCartStorePickUp = [dictionaryArchive objectForKey:TMInfoArchiveKey_CartStorePickUp];
    if (arrayCartStorePickUp)
    {
        [self.arrayCartStorePickUp setArray:arrayCartStorePickUp];
    }
    NSDictionary *dictionaryCartStorePickUp = [dictionaryArchive objectForKey:TMInfoArchiveKey_PurchaseInfoInCartStorePickUp];
    if (dictionaryCartStorePickUp)
    {
        [self.dictionaryProductPurchaseInfoInCartStorePickUp setDictionary:dictionaryCartStorePickUp];
    }
    NSArray *arrayCartFast = [dictionaryArchive objectForKey:TMInfoArchiveKey_CartFast];
    if (arrayCartFast)
    {
        [self.arrayCartFast setArray:arrayCartFast];
    }
    NSDictionary *dictionaryCartFast = [dictionaryArchive objectForKey:TMInfoArchiveKey_PurchaseInfoInCartFast];
    if (dictionaryCartFast)
    {
        [self.dictionaryProductPurchaseInfoInCartFast setDictionary:dictionaryCartFast];
    }
    NSString *loginIP = [dictionaryArchive objectForKey:TMInfoArchiveKey_UserLoginIP];
    if (loginIP)
    {
        self.userLoginIP = loginIP;
    }
    NSString *loginDate = [dictionaryArchive objectForKey:TMInfoArchiveKey_UserLoginTime];
    if (loginDate)
    {
        self.userLoginDate = loginDate;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_CartContentChanged object:self];
}

- (void)applyFavoriteFromArchivedDictionary:(NSDictionary *)dictionaryArchive
{
    if (dictionaryArchive == nil)
        return;
    NSArray *arrayFavorites = [dictionaryArchive objectForKey:TMInfoArchiveKey_Favorites];
    if (arrayFavorites)
    {
        [self.arrayFavorite addObjectsFromArray:arrayFavorites];
    }
    NSArray *arrayFavoriteId = [dictionaryArchive objectForKey:TMInfoArchiveKey_OrderSetFavoriteId];
    if (arrayFavoriteId)
    {
        [self.orderedSetFavoriteId addObjectsFromArray:arrayFavoriteId];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_FavoriteContentChanged object:self];
}

- (void)deleteArchiveForIdentifier:(NSNumber *)identifier
{
    NSString *stringIdentifier = nil;
    if (identifier == nil)
    {
        if (self.userIdentifier)
        {
            stringIdentifier = [self.userIdentifier stringValue];
        }
    }
    else
    {
        stringIdentifier = [identifier stringValue];
    }
    
    NSURL *url = [self urlForInfoArchiveWithIdentifier:stringIdentifier];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
        if (error)
        {
            NSLog(@"Cannot remove archive. Error:\n%@", [error description]);
        }
    }
}

- (void)resetData
{
    if (_dictionaryCachedCategories == nil)
    {
        _dictionaryCachedCategories = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    if (_dictionaryUserInfo == nil)
    {
        _dictionaryUserInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    else
    {
        [_dictionaryUserInfo removeAllObjects];
    }
    
    [self.orderedSetPromotionRead removeAllObjects];
    [self.dictionaryInitialFilter removeAllObjects];
    [self.orderedSetKeyword removeAllObjects];
    [self.arrayCartCommon removeAllObjects];
    [self.dictionaryProductPurchaseInfoInCartCommon removeAllObjects];
    [self.arrayCartStorePickUp removeAllObjects];
    [self.dictionaryProductPurchaseInfoInCartStorePickUp removeAllObjects];
    [self.arrayCartFast removeAllObjects];
    [self.dictionaryProductPurchaseInfoInCartFast removeAllObjects];
    [self.arrayCartFastAddition removeAllObjects];
    [self.arrayCartCommonAddition removeAllObjects];
    [self.arrayCartStorePickUpAddition removeAllObjects];
    [self.dictionaryProductPurchaseInfoInCartCommonAddition removeAllObjects];
    [self.dictionaryProductPurchaseInfoInCartStorePickUpAddition removeAllObjects];
    [self.dictionaryProductPurchaseInfoInCartFastAddition removeAllObjects];
    
    _numberArchiveTimestamp = nil;
    _userIdentifier = nil;
    _userName = nil;
    _userEmail = nil;
    _userGender = TMGenderTotal;
    _userEpoint = nil;
    _userPointTotal = nil;
    _userPointDividend = nil;
    _userPointExpired = nil;
    _userPointAdText = nil;
    _userPointAdUrl = nil;
    _userEcoupon = nil;
    _userCouponAmount = nil;
    _userAuthStatus = nil;
    _userBirth = nil;
    _userEmailMasked = nil;
    _userIsEmailMember = NO;
    _userEmailAuth = NO;
    _userInvoiceTitle =  nil;
    _userInvoiceType = nil;
    _userMobileMasked = nil;
    _userIsNewMember = NO;
    _userOcbStatus = OCBStatusTotal;
    _userOcbUrl = nil;
    _userHasPassword = NO;
    _userTaxId = nil;
    _userTelephoneAreaCode = nil;
    _userTelephoneExtension = nil;
    _userTelephone = nil;
    _userIDCardNumber = nil;
    _userZipCode = nil;
    _userAddress = nil;
    _userInvoiceBind = NO;
}

- (NSString *)keyForCategoryIdentifier:(NSString *)identifier withLayer:(NSNumber *)layer
{
    NSMutableString *key = [NSMutableString string];
    if (identifier)
    {
        [key appendString:identifier];
    }
    if (layer)
    {
        [key appendString:SeparatorBetweenIdAndLayer];
        [key appendString:[layer stringValue]];
    }
    return key;
}

- (void)processUserInformation:(NSData *)data
{
    if (data == nil)
        return;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && jsonObject)
    {
//        NSLog(@"processUserInfomation - jsonObject:\n%@", jsonObject);
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            [self updateUserInformationFromInfoDictionary:jsonObject afterLoadingArchive:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_UserInformationUpdated object:self];
        }
    }
}

- (void)processUserPoint:(NSData *)data
{
    if (data == nil)
        return;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && jsonObject)
    {
//        NSLog(@"processUserPoint - jsonObject:\n%@", jsonObject);
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            NSInteger totalPoint = 0;
            NSNumber *epoint = [dictionary objectForKey:SymphoxAPIParam_epoint];
            if (epoint && [epoint isEqual:[NSNull null]] == NO)
            {
                self.userEpoint = epoint;
                totalPoint +=  [self.userEpoint integerValue];
            }
            NSNumber *pointDividend = [dictionary objectForKey:SymphoxAPIParam_point];
            if (pointDividend && [pointDividend isEqual:[NSNull null]] == NO)
            {
                self.userPointDividend = pointDividend;
                totalPoint += [self.userPointDividend integerValue];
            }
            self.userPointTotal = [NSNumber numberWithInteger:totalPoint];
            
            NSNumber *pointExpired = [dictionary objectForKey:SymphoxAPIParam_exp_point];
            if (pointExpired && [pointExpired isEqual:[NSNull null]] == NO)
            {
                self.userPointExpired = pointExpired;
            }
            NSString *adText = [dictionary objectForKey:SymphoxAPIParam_ad_text];
            if (adText && [adText isEqual:[NSNull null]] == NO)
            {
                self.userPointAdText = adText;
            }
            NSString *adUrl = [dictionary objectForKey:SymphoxAPIParam_ad_url];
            if (adUrl && [adUrl isEqual:[NSNull null]] == NO)
            {
                self.userPointAdUrl = adUrl;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_UserPointUpdated object:self userInfo:dictionary];
        }
    }
}

- (id)processUserCoupon:(NSData *)data
{
    id resultObject = nil;
    
    if (data == nil)
        return resultObject;
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && jsonObject)
    {
//        NSLog(@"processUserCoupon - jsonObject:\n%@", jsonObject);
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            NSNumber *quantity = [dictionary objectForKey:SymphoxAPIParam_qty];
            if (quantity)
            {
                self.userEcoupon = quantity;
            }
            NSNumber *amount = [dictionary objectForKey:SymphoxAPIParam_amount];
            if (amount)
            {
                self.userCouponAmount = amount;
            }
            resultObject = dictionary;
            [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_UserCouponUpdated object:self];
        }
    }
    return resultObject;
}

#pragma mark - Notification Handler

- (void)handlerOfUserLoggedInNotification:(NSNotification *)notification
{
    // Should record
    NSString *stringDate = [self formattedStringFromDate:[NSDate date]];
    self.userLoginDate = stringDate;
    NSLog(@"Login time [%@]", stringDate);
    NSString *ipAddress = [Utility ipAddressPreferIPv6:NO];
    NSLog(@"Login IP [%@]", ipAddress);
    self.userLoginIP = ipAddress;
    
    [self saveToArchive];
}

@end
