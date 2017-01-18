//
//  LocalizedString.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "LocalizedString.h"

@implementation LocalizedString

+ (NSString *)Homepage
{
    static NSString *homepage = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        homepage = NSLocalizedString(@"Homepage", nil);
    });
    return homepage;
}

+ (NSString *)ProductOverview
{
    static NSString *productOverview = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        productOverview = NSLocalizedString(@"ProductOverview", nil);
    });
    return productOverview;
}

+ (NSString *)ShoppingCart
{
    static NSString *shoppingCart = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shoppingCart = NSLocalizedString(@"ShoppingCart", nil);
    });
    return shoppingCart;
}

+ (NSString *)MyFavorite
{
    static NSString *myFavorite = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myFavorite = NSLocalizedString(@"MyFavorite", nil);
    });
    return myFavorite;
}

+ (NSString *)Member
{
    static NSString *member = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        member = NSLocalizedString(@"Member", nil);
    });
    return member;
}

+ (NSString *)Account
{
    static NSString *account = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = NSLocalizedString(@"Account", nil);
    });
    return account;
}

+ (NSString *)Password
{
    static NSString *password = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        password = NSLocalizedString(@"Password", nil);
    });
    return password;
}

+ (NSString *)Login
{
    static NSString *login = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = NSLocalizedString(@"Login", nil);
    });
    return login;
}

+ (NSString *)facebookAccountLogin
{
    static NSString *facebookAccountLogin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        facebookAccountLogin = NSLocalizedString(@"FacebookAccountLogin", nil);
    });
    return facebookAccountLogin;
}

+ (NSString *)googlePlusAccountLogin
{
    static NSString *googlePlusAccountLogin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        googlePlusAccountLogin = NSLocalizedString(@"Google+AccountLogin", nil);
    });
    return googlePlusAccountLogin;
}

+ (NSString *)PromotionNotification
{
    static NSString *promotionNotification = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        promotionNotification = NSLocalizedString(@"PromotionNotification", nil);
    });
    return promotionNotification;
}

+ (NSString *)Notice
{
    static NSString *Notice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Notice = NSLocalizedString(@"Notice", nil);
    });
    return Notice;
}

+ (NSString *)AccountInputError
{
    static NSString *AccountInputError = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AccountInputError = NSLocalizedString(@"AccountInputError", nil);
    });
    return AccountInputError;
}

+ (NSString *)PasswordInputError
{
    static NSString *PasswordInputError = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PasswordInputError = NSLocalizedString(@"PasswordInputError", nil);
    });
    return PasswordInputError;
}

+ (NSString *)Confirm
{
    static NSString *Confirm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Confirm = NSLocalizedString(@"Confirm", nil);
    });
    return Confirm;
}

+ (NSString *)NetworkError
{
    static NSString *NetworkError = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NetworkError = NSLocalizedString(@"NetworkError", nil);
    });
    return NetworkError;
}

@end
