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

@end
