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

+ (NSString *)RegisterFailed
{
    static NSString *RegisterFailed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RegisterFailed = NSLocalizedString(@"NetworkError", nil);
    });
    return RegisterFailed;
}

+ (NSString *)LoginFailed
{
    static NSString *LoginFailed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LoginFailed = NSLocalizedString(@"LoginFailed", nil);
    });
    return LoginFailed;
}

+ (NSString *)UnknownError
{
    static NSString *UnknownError = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UnknownError = NSLocalizedString(@"UnknownError", nil);
    });
    return UnknownError;
}

+ (NSString *)JoinMember
{
    static NSString *JoinMember = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JoinMember = NSLocalizedString(@"JoinMember", nil);
    });
    return JoinMember;
}

+ (NSString *)ForgetPassword
{
    static NSString *ForgetPassword = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ForgetPassword = NSLocalizedString(@"ForgetPassword", nil);
    });
    return ForgetPassword;
}

+ (NSString *)PhoneInputError
{
    static NSString *PhoneInputError = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PhoneInputError = NSLocalizedString(@"PhoneInputError", nil);
    });
    return PhoneInputError;
}

+ (NSString *)ProcessFailed
{
    static NSString *ProcessFailed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ProcessFailed = NSLocalizedString(@"ProcessFailed", nil);
    });
    return ProcessFailed;
}

+ (NSString *)PasswordResent
{
    static NSString *PasswordResent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PasswordResent = NSLocalizedString(@"PasswordResent", nil);
    });
    return PasswordResent;
}

+ (NSString *)MessageFromSMS
{
    static NSString *MessageFromSMS = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MessageFromSMS = NSLocalizedString(@"MessageFromSMS", nil);
    });
    return MessageFromSMS;
}

+ (NSString *)And
{
    static NSString *And = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        And = NSLocalizedString(@"And", nil);
    });
    return And;
}

+ (NSString *)NoWayToSendPassword
{
    static NSString *NoWayToSendPassword = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoWayToSendPassword = NSLocalizedString(@"NoWayToSendPassword", nil);
    });
    return NoWayToSendPassword;
}

+ (NSString *)UnexpectedFormatFromNetwork
{
    static NSString *UnexpectedFormatFromNetwork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UnexpectedFormatFromNetwork = NSLocalizedString(@"UnexpectedFormatFromNetwork", nil);
    });
    return UnexpectedFormatFromNetwork;
}

+ (NSString *)UnexpectedFormatAfterParsing
{
    static NSString *UnexpectedFormatAfterParsing = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UnexpectedFormatAfterParsing = NSLocalizedString(@"UnexpectedFormatAfterParsing", nil);
    });
    return UnexpectedFormatAfterParsing;
}

+ (NSString *)EmailInputError
{
    static NSString *EmailInputError = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        EmailInputError = NSLocalizedString(@"EmailInputError", nil);
    });
    return EmailInputError;
}

+ (NSString *)PasswordNotConfirmed
{
    static NSString *PasswordNotConfirmed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PasswordNotConfirmed = NSLocalizedString(@"PasswordNotConfirmed", nil);
    });
    return PasswordNotConfirmed;
}

+ (NSString *)RequestMobileVerificationFailed
{
    static NSString *RequestMobileVerificationFailed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RequestMobileVerificationFailed = NSLocalizedString(@"RequestMobileVerificationFailed", nil);
    });
    return RequestMobileVerificationFailed;
}

+ (NSString *)PleaseInputMobileVerificationCode
{
    static NSString *PleaseInputMobileVerificationCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputMobileVerificationCode = NSLocalizedString(@"PleaseInputMobileVerificationCode", nil);
    });
    return PleaseInputMobileVerificationCode;
}

+ (NSString *)AlreadySendVerificationCode
{
    static NSString *AlreadySendVerificationCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AlreadySendVerificationCode = NSLocalizedString(@"AlreadySendVerificationCode", nil);
    });
    return AlreadySendVerificationCode;
}

+ (NSString *)ResendCode
{
    static NSString *ResendCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ResendCode = NSLocalizedString(@"ResendCode", nil);
    });
    return ResendCode;
}

+ (NSString *)NextStep
{
    static NSString *NextStep = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NextStep = NSLocalizedString(@"NextStep", nil);
    });
    return NextStep;
}

+ (NSString *)Authentication
{
    static NSString *Authentication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Authentication = NSLocalizedString(@"Authentication", nil);
    });
    return Authentication;
}

+ (NSString *)SelectAuthenticationType
{
    static NSString *SelectAuthenticationType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SelectAuthenticationType = NSLocalizedString(@"SelectAuthenticationType", nil);
    });
    return SelectAuthenticationType;
}

+ (NSString *)CreditCardMemberAuth
{
    static NSString *CreditCardMemberAuth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CreditCardMemberAuth = NSLocalizedString(@"CreditCardMemberAuth", nil);
    });
    return CreditCardMemberAuth;
}

+ (NSString *)ConglomerateEmployeeAuth
{
    static NSString *ConglomerateEmployeeAuth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ConglomerateEmployeeAuth = NSLocalizedString(@"ConglomerateEmployeeAuth", nil);
    });
    return ConglomerateEmployeeAuth;
}

+ (NSString *)OtherCustomerOfCathay
{
    static NSString *OtherCustomerOfCathay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OtherCustomerOfCathay = NSLocalizedString(@"OtherCustomerOfCathay", nil);
    });
    return OtherCustomerOfCathay;
}

+ (NSString *)Cancel
{
    static NSString *Cancel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Cancel = NSLocalizedString(@"Cancel", nil);
    });
    return Cancel;
}

+ (NSString *)AuthenticateSuccess
{
    static NSString *AuthenticateSuccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AuthenticateSuccess = NSLocalizedString(@"AuthenticateSuccess", nil);
    });
    return AuthenticateSuccess;
}

+ (NSString *)AuthenticateFailed
{
    static NSString *AuthenticateFailed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AuthenticateFailed = NSLocalizedString(@"AuthenticateFailed", nil);
    });
    return AuthenticateFailed;
}

+ (NSString *)See_S_All
{
    static NSString *See_S_All = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        See_S_All = NSLocalizedString(@"See_S_All", nil);
    });
    return See_S_All;
}

+ (NSString *)Category_N_List
{
    static NSString *Category_N_List = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Category_N_List = NSLocalizedString(@"Category_N_List", nil);
    });
    return Category_N_List;
}

+ (NSString *)ClickToDiscount
{
    static NSString *ClickToDiscount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ClickToDiscount = NSLocalizedString(@"Category_N_List", nil);
    });
    return ClickToDiscount;
}

+ (NSString *)S_InstallmentNumber
{
    static NSString *S_InstallmentNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_InstallmentNumber = NSLocalizedString(@"S_InstallmentNumber", nil);
    });
    return S_InstallmentNumber;
}

+ (NSString *)Free_S_Point
{
    static NSString *Free_S_Point = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Free_S_Point = NSLocalizedString(@"Free_S_Point", nil);
    });
    return Free_S_Point;
}

+ (NSString *)F_PercentOff
{
    static NSString *F_PercentOff = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        F_PercentOff = NSLocalizedString(@"F_PercentOff", nil);
    });
    return F_PercentOff;
}

+ (NSString *)CannotLoadData
{
    static NSString *CannotLoadData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CannotLoadData = NSLocalizedString(@"CannotLoadData", nil);
    });
    return CannotLoadData;
}

+ (NSString *)GoBack
{
    static NSString *GoBack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GoBack = NSLocalizedString(@"GoBack", nil);
    });
    return GoBack;
}

+ (NSString *)Reload
{
    static NSString *Reload = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Reload = NSLocalizedString(@"Reload", nil);
    });
    return Reload;
}

+ (NSString *)PleaseTryAgainLater
{
    static NSString *PleaseTryAgainLater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseTryAgainLater = NSLocalizedString(@"PleaseTryAgainLater", nil);
    });
    return PleaseTryAgainLater;
}

+ (NSString *)LowPriceFirst
{
    static NSString *LowPriceFirst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LowPriceFirst = NSLocalizedString(@"LowPriceFirst", nil);
    });
    return LowPriceFirst;
}

+ (NSString *)HighPriceFirst
{
    static NSString *HighPriceFirst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HighPriceFirst = NSLocalizedString(@"HighPriceFirst", nil);
    });
    return HighPriceFirst;
}

+ (NSString *)LowPointFirst
{
    static NSString *LowPointFirst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LowPointFirst = NSLocalizedString(@"LowPointFirst", nil);
    });
    return LowPointFirst;
}

+ (NSString *)HighPointFirst
{
    static NSString *HighPointFirst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HighPointFirst = NSLocalizedString(@"HighPointFirst", nil);
    });
    return HighPointFirst;
}

+ (NSString *)OnShelfOrder
{
    static NSString *OnShelfOrder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OnShelfOrder = NSLocalizedString(@"OnShelfOrder", nil);
    });
    return OnShelfOrder;
}

+ (NSString *)Point
{
    static NSString *Point = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Point = NSLocalizedString(@"Point", nil);
    });
    return Point;
}

+ (NSString *)ChooseOrder
{
    static NSString *ChooseOrder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ChooseOrder = NSLocalizedString(@"ChooseOrder", nil);
    });
    return ChooseOrder;
}

+ (NSString *)CategoryList
{
    static NSString *CategoryList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CategoryList = NSLocalizedString(@"CategoryList", nil);
    });
    return CategoryList;
}

+ (NSString *)AdvanceFilter
{
    static NSString *AdvanceFilter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AdvanceFilter = NSLocalizedString(@"AdvanceFilter", nil);
    });
    return AdvanceFilter;
}

@end
