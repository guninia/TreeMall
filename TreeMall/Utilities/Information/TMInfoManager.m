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

static NSString *TMInfoArchiveKey_PromotionRead = @"PromotionRead";
static NSString *TMInfoArchiveKey_UserInformation = @"UserInformation";
static NSString *TMInfoArchiveKey_UserIdentifier = @"UserIdentifier";
static NSString *TMInfoArchiveKey_UserName = @"UserName";
static NSString *TMInfoArchiveKey_UserEmail = @"UserEmail";
static NSString *TMInfoArchiveKey_UserGender = @"UserGender";
static NSString *TMInfoArchiveKey_UserEpoint = @"UserEpoint";
static NSString *TMInfoArchiveKey_UserEcoupon = @"UserEcoupon";

static TMInfoManager *gTMInfoManager = nil;

static NSUInteger PromotionReadNumberMax = 100;

@interface TMInfoManager ()

- (NSURL *)urlForInfoDirectory;
- (NSURL *)urlForInfoArchive;

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
        _userIdentifier = nil;
        _userName = nil;
        _userEmail = nil;
        _userGender = TMGenderTotal;
        _userEpoint = nil;
        _userEcoupon = nil;
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
        [_orderedSetPromotionRead exchangeObjectAtIndex:0 withObjectAtIndex:currentIndex];
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
    NSMutableDictionary *dictionaryArchive = [NSMutableDictionary dictionary];
    [dictionaryArchive setObject:[_orderedSetPromotionRead array] forKey:TMInfoArchiveKey_PromotionRead];
    [dictionaryArchive setObject:_dictionaryUserInfo forKey:TMInfoArchiveKey_UserInformation];
    NSMutableData *archiveData = [[NSMutableData alloc] initWithCapacity:0];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData];
    [archiver encodeObject:dictionaryArchive forKey:[CryptoModule sharedModule].apiKey];
    [archiver finishEncoding];
    
    NSURL *url = [self urlForInfoArchive];
    NSLog(@"urlString[%@]", [url path]);
    NSError *error = nil;
    if ([archiveData writeToURL:url options:0 error:&error] == NO)
    {
        NSLog(@"TMInfoManager - archve failed.\n%@", [error description]);
    }
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

@end
