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

static NSString *TMInfoArchiveKey_PromotionRead = @"PromotionRead";
static NSString *TMInfoArchiveKey_UserInformation = @"UserInformation";
static NSString *TMInfoArchiveKey_UserIdentifier = @"UserIdentifier";
static NSString *TMInfoArchiveKey_UserName = @"UserName";
static NSString *TMInfoArchiveKey_UserEmail = @"UserEmail";
static NSString *TMInfoArchiveKey_UserGender = @"UserGender";
static NSString *TMInfoArchiveKey_UserEpoint = @"UserEpoint";
static NSString *TMInfoArchiveKey_UserEcoupon = @"UserEcoupon";
static NSString *TMInfoArchiveKey_CachedCategories = @"CachedCategories";
static NSString *TMInfoArchiveKey_ArchiveTimestamp = @"ArchiveTimestamp";
static NSString *TMInfoArchiveKey_OrderSetKeyword = @"OrderSetKeyword";
static NSString *TMInfoArchiveKey_OrderSetFavoriteId = @"OrderSetFavoriteId";
static NSString *TMInfoArchiveKey_Favorites = @"Favorites";
static NSString *TMInfoArchiveKey_FavoritesDetail = @"FavoritesDetail";

static NSString *SeparatorBetweenIdAndLayer = @"_";

static TMInfoManager *gTMInfoManager = nil;

static NSUInteger PromotionReadNumberMax = 100;
static NSUInteger SearchKeywordNumberMax = 8;

@interface TMInfoManager ()

- (NSURL *)urlForInfoDirectory;
- (NSURL *)urlForInfoArchive;
- (NSString *)keyForCategoryIdentifier:(NSString *)identifier withLayer:(NSNumber *)layer;
- (void)retrieveUserInformation;
- (void)processUserInfomation:(NSData *)data;

@end

@implementation TMInfoManager

@synthesize userIdentifier = _userIdentifier;
@synthesize userName = _userName;
@synthesize userEmail = _userEmail;
@synthesize userGender = _userGender;
@synthesize userEpoint = _userEpoint;
@synthesize userEcoupon = _userEcoupon;

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
        _orderedSetPromotionRead = [[NSMutableOrderedSet alloc] initWithCapacity:0];
        _dictionaryUserInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
        _dictionaryCachedCategories = [[NSMutableDictionary alloc] initWithCapacity:0];
        _dictionaryInitialFilter = [[NSMutableDictionary alloc] initWithCapacity:0];
        _dictionaryMainCategoryNameMapping = [[NSMutableDictionary alloc] initWithCapacity:0];
        _orderedSetKeyword = [[NSMutableOrderedSet alloc] initWithCapacity:0];
        _arrayFavorite = [[NSMutableArray alloc] initWithCapacity:0];
        _dictionaryFavoriteDetail = [[NSMutableDictionary alloc] initWithCapacity:0];
        _orderedSetFavoriteId = [[NSMutableOrderedSet alloc] initWithCapacity:0];
        _numberArchiveTimestamp = nil;
        _userIdentifier = nil;
        _userName = nil;
        _userEmail = nil;
        _userGender = TMGenderTotal;
        _userEpoint = nil;
        _userEcoupon = nil;
        archiveQueue = dispatch_queue_create("ArchiveQueue", DISPATCH_QUEUE_SERIAL);
        
        NSDictionary *dictionaryArchive = [self loadFromArchive];
        if (dictionaryArchive)
        {
            NSArray *arrayPromotionRead = [dictionaryArchive objectForKey:TMInfoArchiveKey_PromotionRead];
            if (arrayPromotionRead)
            {
                [_orderedSetPromotionRead addObjectsFromArray:arrayPromotionRead];
            }
            NSDictionary *dictionaryUserInfo = [dictionaryArchive objectForKey:TMInfoArchiveKey_UserInformation];
            if (dictionaryUserInfo)
            {
                [_dictionaryUserInfo setDictionary:dictionaryUserInfo];
            }
            NSArray *arrayKeyword = [dictionaryArchive objectForKey:TMInfoArchiveKey_OrderSetKeyword];
            if (arrayKeyword)
            {
                [_orderedSetKeyword addObjectsFromArray:arrayKeyword];
            }
            NSArray *arrayFavorites = [dictionaryArchive objectForKey:TMInfoArchiveKey_Favorites];
            if (arrayFavorites)
            {
//                NSLog(@"arrayFavorites:\n%@", [arrayFavorites description]);
                [_arrayFavorite addObjectsFromArray:arrayFavorites];
            }
            NSDictionary *dictionaryFavoriteDetail = [dictionaryArchive objectForKey:TMInfoArchiveKey_FavoritesDetail];
            if (dictionaryFavoriteDetail)
            {
                [_dictionaryFavoriteDetail setDictionary:dictionaryFavoriteDetail];
            }
            NSArray *arrayFavoriteId = [dictionaryArchive objectForKey:TMInfoArchiveKey_OrderSetFavoriteId];
            if (arrayFavoriteId)
            {
                [_orderedSetFavoriteId addObjectsFromArray:arrayFavoriteId];
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
        }
    }
    return self;
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

- (void)setUserEpoint:(NSNumber *)userEpoint
{
    if ([_userEpoint unsignedLongLongValue] != [userEpoint unsignedLongLongValue])
    {
        _userEpoint = userEpoint;
        if (_userEpoint)
        {
            [_dictionaryUserInfo setObject:userEpoint forKey:TMInfoArchiveKey_UserEpoint];
        }
    }
}

- (NSNumber *)userEpoint
{
    if (_userEpoint == nil)
    {
        _userEpoint = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserEpoint];
    }
    return _userEpoint;
}

- (void)setUserEcoupon:(NSNumber *)userEcoupon
{
    if ([_userEcoupon unsignedLongLongValue] != [userEcoupon unsignedLongLongValue])
    {
        _userEcoupon = userEcoupon;
        if (_userEcoupon)
        {
            [_dictionaryUserInfo setObject:_userEcoupon forKey:TMInfoArchiveKey_UserEcoupon];
        }
    }
}

- (NSNumber *)userEcoupon
{
    if (_userEcoupon == 0)
    {
        _userEcoupon = [_dictionaryUserInfo objectForKey:TMInfoArchiveKey_UserEcoupon];
    }
    return _userEcoupon;
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
        [dictionaryArchive setObject:[_orderedSetPromotionRead array] forKey:TMInfoArchiveKey_PromotionRead];
        [dictionaryArchive setObject:_dictionaryUserInfo forKey:TMInfoArchiveKey_UserInformation];
        [dictionaryArchive setObject:_dictionaryCachedCategories forKey:TMInfoArchiveKey_CachedCategories];
        [dictionaryArchive setObject:[_orderedSetKeyword array] forKey:TMInfoArchiveKey_OrderSetKeyword];
        [dictionaryArchive setObject:[_orderedSetFavoriteId array] forKey:TMInfoArchiveKey_OrderSetFavoriteId];
        [dictionaryArchive setObject:_arrayFavorite forKey:TMInfoArchiveKey_Favorites];
        [dictionaryArchive setObject:_dictionaryFavoriteDetail forKey:TMInfoArchiveKey_FavoritesDetail];
        if (_numberArchiveTimestamp)
        {
            [dictionaryArchive setObject:_numberArchiveTimestamp forKey:TMInfoArchiveKey_ArchiveTimestamp];
        }
        NSMutableData *archiveData = [[NSMutableData alloc] initWithCapacity:0];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData];
        [archiver encodeObject:dictionaryArchive forKey:[CryptoModule sharedModule].apiKey];
        [archiver finishEncoding];
        
        NSURL *url = [weakSelf urlForInfoArchive];
//        NSLog(@"urlString[%@]", [url path]);
        NSError *error = nil;
        if ([archiveData writeToURL:url options:0 error:&error] == NO)
        {
            NSLog(@"TMInfoManager - archve failed.\n%@", [error description]);
        }
    });
}

- (NSDictionary *)loadFromArchive
{
    NSDictionary *dictionary = nil;
    NSURL *url = [self urlForInfoArchive];
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

- (void)updateUserInformationFromInfoDictionary:(NSDictionary *)infoDictionary
{
    
    //
    //  Need to do modification for data incoming.
    //
    
    NSNumber *identifier = [infoDictionary objectForKey:SymphoxAPIParam_user_num];
    NSString *name = [infoDictionary objectForKey:SymphoxAPIParam_name];
    NSString *gender = [infoDictionary objectForKey:SymphoxAPIParam_sex];
    NSNumber *epoint = [infoDictionary objectForKey:SymphoxAPIParam_epoint];
    NSNumber *ecoupon = [infoDictionary objectForKey:SymphoxAPIParam_ecoupon];
    if ((self.userIdentifier == nil) || ([[self.userIdentifier stringValue] isEqualToString:[identifier stringValue]] == NO))
    {
        self.userIdentifier = nil;
        self.userName = nil;
        self.userGender = TMGenderTotal;
        self.userEpoint = nil;
        self.userEcoupon = nil;
    }
    if (identifier)
    {
        self.userIdentifier = identifier;
    }
    if (name)
    {
        self.userName = name;
    }
    if ([gender length] == 0)
    {
        self.userGender = TMGenderUnknown;
    }
    else
    {
        // Should implement once receive real data.
        self.userGender = TMGenderUnknown;
    }
    if (epoint)
    {
        self.userEpoint = epoint;
    }
    if (ecoupon)
    {
        self.userEcoupon = ecoupon;
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

- (void)retrieveToken
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
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_NoInitialToken object:self];
        }
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
}

- (NSArray *)keywords
{
    NSArray *keywords = [[_orderedSetKeyword array] copy];
    return keywords;
}

- (void)removeAllKeywords
{
    [_orderedSetKeyword removeAllObjects];
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

- (BOOL)addProductToFavorite:(NSDictionary *)product
{
    NSLog(@"product:\n%@", product);
    NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
    if (productId == nil || [productId isEqual:[NSNull null]])
    {
        NSLog(@"addProductToFavorite - Cannot find product identifier");
        return NO;
    }
    if ([self.orderedSetFavoriteId containsObject:productId])
    {
        NSLog(@"addProductToFavorite - Already in the favorite list.");
        return NO;
    }
    [self.orderedSetFavoriteId addObject:productId];
    [self.arrayFavorite addObject:product];
    NSLog(@"orderedSetFavoriteId[%li] arrayFavorite[%li]", (long)self.orderedSetFavoriteId.count, (long)self.arrayFavorite.count);
    return YES;
}

- (NSArray *)favorites
{
    NSArray *favorites = self.arrayFavorite;
    return favorites;
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

- (NSURL *)urlForInfoArchive
{
    NSURL *url = [[[self urlForInfoDirectory] URLByAppendingPathComponent:@"archive"] URLByAppendingPathExtension:@"dat"];
    return url;
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

- (void)retrieveUserInformation
{
    __weak TMInfoManager *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_memberInformation];
    NSLog(@"retrieveUserInformation - [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:self.userIdentifier, SymphoxAPIParam_user_num, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
            NSLog(@"retrieveUserInformation - resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                [weakSelf processUserInfomation:data];
            }
        }
        else
        {
            NSLog(@"retrieveUserInformation - error:\n%@", [error description]);
        }
    }];
}

- (void)processUserInfomation:(NSData *)data
{
    if (data == nil)
        return;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && jsonObject)
    {
        NSLog(@"processUserInfomation - jsonObject:\n%@", jsonObject);
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            [self updateUserInformationFromInfoDictionary:jsonObject];
            
        }
    }
}

@end
