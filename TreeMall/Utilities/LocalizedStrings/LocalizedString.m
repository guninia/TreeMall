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

+ (NSString *)Category
{
    static NSString *Category = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Category = NSLocalizedString(@"Category", nil);
    });
    return Category;
}

+ (NSString *)PriceRange
{
    static NSString *PriceRange = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PriceRange = NSLocalizedString(@"PriceRange", nil);
    });
    return PriceRange;
}

+ (NSString *)PointRange
{
    static NSString *PointRange = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PointRange = NSLocalizedString(@"PointRange", nil);
    });
    return PointRange;
}

+ (NSString *)Coupon
{
    static NSString *Coupon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Coupon = NSLocalizedString(@"Coupon", nil);
    });
    return Coupon;
}

+ (NSString *)DeliverType
{
    static NSString *DeliverType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DeliverType = NSLocalizedString(@"DeliverType", nil);
    });
    return DeliverType;
}

+ (NSString *)Reset
{
    static NSString *Reset = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Reset = NSLocalizedString(@"Reset", nil);
    });
    return Reset;
}

+ (NSString *)CannotRetrieveFilterOptions
{
    static NSString *CannotRetrieveFilterOptions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CannotRetrieveFilterOptions = NSLocalizedString(@"CannotRetrieveFilterOptions", nil);
    });
    return CannotRetrieveFilterOptions;
}

+ (NSString *)NoSpecific
{
    static NSString *NoSpecific = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoSpecific = NSLocalizedString(@"NoSpecific", nil);
    });
    return NoSpecific;
}

+ (NSString *)Fast
{
    static NSString *Fast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Fast = NSLocalizedString(@"Fast", nil);
    });
    return Fast;
}

+ (NSString *)ReceiveAtConvenientStore
{
    static NSString *ReceiveAtConvenientStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReceiveAtConvenientStore = NSLocalizedString(@"ReceiveAtConvenientStore", nil);
    });
    return ReceiveAtConvenientStore;
}

+ (NSString *)Search
{
    static NSString *Search = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Search = NSLocalizedString(@"Search", nil);
    });
    return Search;
}

+ (NSString *)KeywordSearch
{
    static NSString *KeywordSearch = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KeywordSearch = NSLocalizedString(@"KeywordSearch", nil);
    });
    return KeywordSearch;
}

+ (NSString *)PleaseInputKeyword
{
    static NSString *PleaseInputKeyword = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputKeyword = NSLocalizedString(@"PleaseInputKeyword", nil);
    });
    return PleaseInputKeyword;
}

+ (NSString *)LatestSearch__
{
    static NSString *LatestSearch__ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LatestSearch__ = NSLocalizedString(@"LatestSearch__", nil);
    });
    return LatestSearch__;
}

+ (NSString *)HotSearch__
{
    static NSString *HotSearch__ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HotSearch__ = NSLocalizedString(@"HotSearch__", nil);
    });
    return HotSearch__;
}

+ (NSString *)SearchResult
{
    static NSString *SearchResult = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SearchResult = NSLocalizedString(@"SearchResult", nil);
    });
    return SearchResult;
}

+ (NSString *)Promotions
{
    static NSString *Promotions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Promotions = NSLocalizedString(@"Promotions", nil);
    });
    return Promotions;
}

+ (NSString *)AddToCart
{
    static NSString *AddToCart = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AddToCart = NSLocalizedString(@"AddToCart", nil);
    });
    return AddToCart;
}

+ (NSString *)Purchase
{
    static NSString *Purchase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Purchase = NSLocalizedString(@"Purchase", nil);
    });
    return Purchase;
}

+ (NSString *)OriginPrice_C_$
{
    static NSString *OriginPrice_C_$ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OriginPrice_C_$ = NSLocalizedString(@"OriginPrice_C_$", nil);
    });
    return OriginPrice_C_$;
}

+ (NSString *)PointNumber
{
    static NSString *PointNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PointNumber = NSLocalizedString(@"PointNumber", nil);
    });
    return PointNumber;
}

+ (NSString *)PointAddCash
{
    static NSString *PointAddCash = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PointAddCash = NSLocalizedString(@"PointAddCash", nil);
    });
    return PointAddCash;
}

+ (NSString *)FeedbackPointUpTo_S
{
    static NSString *FeedbackPointUpTo_S = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FeedbackPointUpTo_S = NSLocalizedString(@"FeedbackPointUpTo_S", nil);
    });
    return FeedbackPointUpTo_S;
}

+ (NSString *)Detail_RA_
{
    static NSString *Detail_RA_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Detail_RA_ = NSLocalizedString(@"Detail_RA_", nil);
    });
    return Detail_RA_;
}

+ (NSString *)ExchangeDescription
{
    static NSString *ExchangeDescription = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExchangeDescription = NSLocalizedString(@"ExchangeDescription", nil);
    });
    return ExchangeDescription;
}

+ (NSString *)InstallmentsCalculation
{
    static NSString *InstallmentsCalculation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InstallmentsCalculation = NSLocalizedString(@"InstallmentsCalculation", nil);
    });
    return InstallmentsCalculation;
}

+ (NSString *)ChooseSpec
{
    static NSString *ChooseSpec = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ChooseSpec = NSLocalizedString(@"ChooseSpec", nil);
    });
    return ChooseSpec;
}

+ (NSString *)ProductDetailNotice
{
    static NSString *ProductDetailNotice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ProductDetailNotice = NSLocalizedString(@"ProductDetailNotice", nil);
    });
    return ProductDetailNotice;
}

+ (NSString *)ProductIntroduce
{
    static NSString *ProductIntroduce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ProductIntroduce = NSLocalizedString(@"ProductIntroduce", nil);
    });
    return ProductIntroduce;
}

+ (NSString *)ProductSpec
{
    static NSString *ProductSpec = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ProductSpec = NSLocalizedString(@"ProductSpec", nil);
    });
    return ProductSpec;
}

+ (NSString *)Welcome_S__S_
{
    static NSString *Welcome_S__S_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Welcome_S__S_ = NSLocalizedString(@"Welcome_S__S_", nil);
    });
    return Welcome_S__S_;
}

+ (NSString *)PersonalDataModify
{
    static NSString *PersonalDataModify = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PersonalDataModify = NSLocalizedString(@"PersonalDataModify", nil);
    });
    return PersonalDataModify;
}

+ (NSString *)MyPoints
{
    static NSString *MyPoints = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MyPoints = NSLocalizedString(@"MyPoints", nil);
    });
    return MyPoints;
}

+ (NSString *)TotalCount
{
    static NSString *TotalCount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TotalCount = NSLocalizedString(@"TotalCount", nil);
    });
    return TotalCount;
}

+ (NSString *)ExpiredThisMonth
{
    static NSString *ExpiredThisMonth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExpiredThisMonth = NSLocalizedString(@"ExpiredThisMonth", nil);
    });
    return ExpiredThisMonth;
}

+ (NSString *)MyCoupon
{
    static NSString *MyCoupon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MyCoupon = NSLocalizedString(@"MyCoupon", nil);
    });
    return MyCoupon;
}

+ (NSString *)MyOrder
{
    static NSString *MyOrder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MyOrder = NSLocalizedString(@"MyOrder", nil);
    });
    return MyOrder;
}

+ (NSString *)Processing_BRA_S_BRA
{
    static NSString *Processing_BRA_S_BRA = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Processing_BRA_S_BRA = NSLocalizedString(@"Processing_BRA_S_BRA", nil);
    });
    return Processing_BRA_S_BRA;
}

+ (NSString *)Shipped_BRA_S_BRA
{
    static NSString *Shipped_BRA_S_BRA = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Shipped_BRA_S_BRA = NSLocalizedString(@"Shipped_BRA_S_BRA", nil);
    });
    return Shipped_BRA_S_BRA;
}

+ (NSString *)ReturnReplace_BRA_S_BRA
{
    static NSString *ReturnReplace_BRA_S_BRA = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReturnReplace_BRA_S_BRA = NSLocalizedString(@"ReturnReplace_BRA_S_BRA", nil);
    });
    return ReturnReplace_BRA_S_BRA;
}

+ (NSString *)All
{
    static NSString *All = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        All = NSLocalizedString(@"All", nil);
    });
    return All;
}

+ (NSString *)Processing
{
    static NSString *Processing = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Processing = NSLocalizedString(@"Processing", nil);
    });
    return Processing;
}

+ (NSString *)Shipping
{
    static NSString *Shipping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Shipping = NSLocalizedString(@"Shipping", nil);
    });
    return Shipping;
}

+ (NSString *)Return
{
    static NSString *Return = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Return = NSLocalizedString(@"Return", nil);
    });
    return Return;
}

+ (NSString *)PleaseInputProductName
{
    static NSString *PleaseInputProductName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputProductName = NSLocalizedString(@"PleaseInputProductName", nil);
    });
    return PleaseInputProductName;
}

+ (NSString *)OrderTime
{
    static NSString *OrderTime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OrderTime = NSLocalizedString(@"OrderTime", nil);
    });
    return OrderTime;
}

+ (NSString *)ShipType
{
    static NSString *ShipType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ShipType = NSLocalizedString(@"ShipType", nil);
    });
    return ShipType;
}

+ (NSString *)Mister
{
    static NSString *Mister = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Mister = NSLocalizedString(@"Mister", nil);
    });
    return Mister;
}

+ (NSString *)Miss
{
    static NSString *Miss = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Miss = NSLocalizedString(@"Miss", nil);
    });
    return Miss;
}

+ (NSString *)ThayPoint
{
    static NSString *ThayPoint = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ThayPoint = NSLocalizedString(@"ThayPoint", nil);
    });
    return ThayPoint;
}

+ (NSString *)DancingDividend
{
    static NSString *DancingDividend = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DancingDividend = NSLocalizedString(@"DancingDividend", nil);
    });
    return DancingDividend;
}

+ (NSString *)Pieces
{
    static NSString *Pieces = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Pieces = NSLocalizedString(@"Pieces", nil);
    });
    return Pieces;
}

+ (NSString *)Logout
{
    static NSString *Logout = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Logout = NSLocalizedString(@"Logout", nil);
    });
    return Logout;
}

+ (NSString *)LogoutReconfirm
{
    static NSString *LogoutReconfirm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LogoutReconfirm = NSLocalizedString(@"LogoutReconfirm", nil);
    });
    return LogoutReconfirm;
}

+ (NSString *)NotUsed
{
    static NSString *NotUsed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NotUsed = NSLocalizedString(@"NotUsed", nil);
    });
    return NotUsed;
}

+ (NSString *)AlreadyUsed
{
    static NSString *AlreadyUsed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AlreadyUsed = NSLocalizedString(@"AlreadyUsed", nil);
    });
    return AlreadyUsed;
}

+ (NSString *)Expired
{
    static NSString *Expired = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Expired = NSLocalizedString(@"Expired", nil);
    });
    return Expired;
}

+ (NSString *)ValueHighToLow
{
    static NSString *ValueHighToLow = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ValueHighToLow = NSLocalizedString(@"ValueHighToLow", nil);
    });
    return ValueHighToLow;
}

+ (NSString *)ValueLowToHigh
{
    static NSString *ValueLowToHigh = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ValueLowToHigh = NSLocalizedString(@"ValueLowToHigh", nil);
    });
    return ValueLowToHigh;
}

+ (NSString *)ValidDateEarlyToLate
{
    static NSString *ValidDateEarlyToLate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ValidDateEarlyToLate = NSLocalizedString(@"ValidDateEarlyToLate", nil);
    });
    return ValidDateEarlyToLate;
}

+ (NSString *)ValidDateLateToEarly
{
    static NSString *ValidDateLateToEarly = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ValidDateLateToEarly = NSLocalizedString(@"ValidDateLateToEarly", nil);
    });
    return ValidDateLateToEarly;
}

+ (NSString *)OrderId
{
    static NSString *OrderId = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OrderId = NSLocalizedString(@"OrderId", nil);
    });
    return OrderId;
}

+ (NSString *)Due
{
    static NSString *Due = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Due = NSLocalizedString(@"Due", nil);
    });
    return Due;
}

+ (NSString *)Start
{
    static NSString *Start = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Start = NSLocalizedString(@"Start", nil);
    });
    return Start;
}

+ (NSString *)CouponDetail
{
    static NSString *CouponDetail = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CouponDetail = NSLocalizedString(@"CouponDetail", nil);
    });
    return CouponDetail;
}

+ (NSString *)CampaignLink
{
    static NSString *CampaignLink = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CampaignLink = NSLocalizedString(@"CampaignLink", nil);
    });
    return CampaignLink;
}

+ (NSString *)AvailableHall
{
    static NSString *AvailableHall = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AvailableHall = NSLocalizedString(@"AvailableHall", nil);
    });
    return AvailableHall;
}

+ (NSString *)AvailableProduct
{
    static NSString *AvailableProduct = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AvailableProduct = NSLocalizedString(@"AvailableProduct", nil);
    });
    return AvailableProduct;
}

+ (NSString *)Remark
{
    static NSString *Remark = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Remark = NSLocalizedString(@"Remark", nil);
    });
    return Remark;
}

+ (NSString *)ShippingAndWarrentyDescription
{
    static NSString *ShippingAndWarrentyDescription = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ShippingAndWarrentyDescription = NSLocalizedString(@"ShippingAndWarrentyDescription", nil);
    });
    return ShippingAndWarrentyDescription;
}

+ (NSString *)OpenInSafari
{
    static NSString *OpenInSafari = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OpenInSafari = NSLocalizedString(@"OpenInSafari", nil);
    });
    return OpenInSafari;
}

+ (NSString *)CopyLink
{
    static NSString *CopyLink = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CopyLink = NSLocalizedString(@"CopyLink", nil);
    });
    return CopyLink;
}

+ (NSString *)LatestMonth
{
    static NSString *LatestMonth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LatestMonth = NSLocalizedString(@"LatestMonth", nil);
    });
    return LatestMonth;
}

+ (NSString *)LatestHalfYear
{
    static NSString *LatestHalfYear = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LatestHalfYear = NSLocalizedString(@"LatestHalfYear", nil);
    });
    return LatestHalfYear;
}

+ (NSString *)LatestYear
{
    static NSString *LatestYear = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LatestYear = NSLocalizedString(@"LatestYear", nil);
    });
    return LatestYear;
}

+ (NSString *)CommonDelivery
{
    static NSString *CommonDelivery = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CommonDelivery = NSLocalizedString(@"CommonDelivery", nil);
    });
    return CommonDelivery;
}

+ (NSString *)FastDelivery
{
    static NSString *FastDelivery = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FastDelivery = NSLocalizedString(@"FastDelivery", nil);
    });
    return FastDelivery;
}

+ (NSString *)StorePickUp
{
    static NSString *StorePickUp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        StorePickUp = NSLocalizedString(@"StorePickUp", nil);
    });
    return StorePickUp;
}

+ (NSString *)OrderAuthrizationNumber
{
    static NSString *OrderAuthrizationNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OrderAuthrizationNumber = NSLocalizedString(@"OrderAuthrizationNumber", nil);
    });
    return OrderAuthrizationNumber;
}

+ (NSString *)T_CatId
{
    static NSString *T_CatId = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        T_CatId = NSLocalizedString(@"T_CatId", nil);
    });
    return T_CatId;
}

+ (NSString *)Total_N_Product
{
    static NSString *Total_N_Product = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Total_N_Product = NSLocalizedString(@"Total_N_Product", nil);
    });
    return Total_N_Product;
}

+ (NSString *)EmailAuthentication
{
    static NSString *EmailAuthentication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        EmailAuthentication = NSLocalizedString(@"EmailAuthentication", nil);
    });
    return EmailAuthentication;
}

+ (NSString *)IdentityAuthentication
{
    static NSString *IdentityAuthentication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IdentityAuthentication = NSLocalizedString(@"IdentityAuthentication", nil);
    });
    return IdentityAuthentication;
}

+ (NSString *)BasicInformationModification
{
    static NSString *BasicInformationModification = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BasicInformationModification = NSLocalizedString(@"BasicInformationModification", nil);
    });
    return BasicInformationModification;
}

+ (NSString *)ContactsSettings
{
    static NSString *ContactsSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ContactsSettings = NSLocalizedString(@"ContactsSettings", nil);
    });
    return ContactsSettings;
}

+ (NSString *)ChangePassword
{
    static NSString *ChangePassword = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ChangePassword = NSLocalizedString(@"ChangePassword", nil);
    });
    return ChangePassword;
}

+ (NSString *)NewsletterSubscribe
{
    static NSString *NewsletterSubscribe = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NewsletterSubscribe = NSLocalizedString(@"NewsletterSubscribe", nil);
    });
    return NewsletterSubscribe;
}

+ (NSString *)CompleteAuthenticationToGet_N_Points
{
    static NSString *CompleteAuthenticationToGet_N_Points = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CompleteAuthenticationToGet_N_Points = NSLocalizedString(@"CompleteAuthenticationToGet_N_Points", nil);
    });
    return CompleteAuthenticationToGet_N_Points;
}

+ (NSString *)CardMemberAuthenticationNotComplete
{
    static NSString *CardMemberAuthenticationNotComplete = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CardMemberAuthenticationNotComplete = NSLocalizedString(@"CardMemberAuthenticationNotComplete", nil);
    });
    return CardMemberAuthenticationNotComplete;
}

+ (NSString *)Authenticated
{
    static NSString *Authenticated = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Authenticated = NSLocalizedString(@"Authenticated", nil);
    });
    return Authenticated;
}

+ (NSString *)AccountInformationMaintain
{
    static NSString *AccountInformationMaintain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AccountInformationMaintain = NSLocalizedString(@"AccountInformationMaintain", nil);
    });
    return AccountInformationMaintain;
}

+ (NSString *)PleaseInputYourEmail
{
    static NSString *PleaseInputYourEmail = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputYourEmail = NSLocalizedString(@"PleaseInputYourEmail", nil);
    });
    return PleaseInputYourEmail;
}

+ (NSString *)PleaseInputEmail
{
    static NSString *PleaseInputEmail = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputEmail = NSLocalizedString(@"PleaseInputEmail", nil);
    });
    return PleaseInputEmail;
}

+ (NSString *)PleaseInputOldPassword
{
    static NSString *PleaseInputOldPassword = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputOldPassword = NSLocalizedString(@"PleaseInputOldPassword", nil);
    });
    return PleaseInputOldPassword;
}

+ (NSString *)PleaseInputNewPassword
{
    static NSString *PleaseInputNewPassword = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputNewPassword = NSLocalizedString(@"PleaseInputNewPassword", nil);
    });
    return PleaseInputNewPassword;
}

+ (NSString *)PleaseConfirmNewPassword
{
    static NSString *PleaseConfirmNewPassword = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseConfirmNewPassword = NSLocalizedString(@"PleaseConfirmNewPassword", nil);
    });
    return PleaseConfirmNewPassword;
}

+ (NSString *)PleaseInputYourNewPassword
{
    static NSString *PleaseInputYourNewPassword = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputYourNewPassword = NSLocalizedString(@"PleaseInputYourNewPassword", nil);
    });
    return PleaseInputYourNewPassword;
}

+ (NSString *)PleaseInputValidEmail
{
    static NSString *PleaseInputValidEmail = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputValidEmail = NSLocalizedString(@"PleaseInputValidEmail", nil);
    });
    return PleaseInputValidEmail;
}

+ (NSString *)PleaseInputValidPassword
{
    static NSString *PleaseInputValidPassword = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputValidPassword = NSLocalizedString(@"PleaseInputValidPassword", nil);
    });
    return PleaseInputValidPassword;
}

+ (NSString *)Send
{
    static NSString *Send = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Send = NSLocalizedString(@"Send", nil);
    });
    return Send;
}

+ (NSString *)ToSubscribeNewsletterPleaseCheckAndSend
{
    static NSString *ToSubscribeNewsletterPleaseCheckAndSend = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ToSubscribeNewsletterPleaseCheckAndSend = NSLocalizedString(@"ToSubscribeNewsletterPleaseCheckAndSend", nil);
    });
    return ToSubscribeNewsletterPleaseCheckAndSend;
}

+ (NSString *)_M_Reminder_M_
{
    static NSString *_M_Reminder_M_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _M_Reminder_M_ = NSLocalizedString(@"_M_Reminder_M_", nil);
    });
    return _M_Reminder_M_;
}

+ (NSString *)NewsletterSubscriptionNotation
{
    static NSString *NewsletterSubscriptionNotation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NewsletterSubscriptionNotation = NSLocalizedString(@"NewsletterSubscriptionNotation", nil);
    });
    return NewsletterSubscriptionNotation;
}

+ (NSString *)SubscribeNewsletter
{
    static NSString *SubscribeNewsletter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SubscribeNewsletter = NSLocalizedString(@"SubscribeNewsletter", nil);
    });
    return SubscribeNewsletter;
}

+ (NSString *)UpdateNewsletterSubscriptionSuccess
{
    static NSString *UpdateNewsletterSubscriptionSuccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UpdateNewsletterSubscriptionSuccess = NSLocalizedString(@"UpdateNewsletterSubscriptionSuccess", nil);
    });
    return UpdateNewsletterSubscriptionSuccess;
}

+ (NSString *)ExchangeRecommended
{
    static NSString *ExchangeRecommended = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExchangeRecommended = NSLocalizedString(@"ExchangeRecommended", nil);
    });
    return ExchangeRecommended;
}

+ (NSString *)CouponRecommended
{
    static NSString *CouponRecommended = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CouponRecommended = NSLocalizedString(@"CouponRecommended", nil);
    });
    return CouponRecommended;
}

+ (NSString *)PreferentialNotification
{
    static NSString *PreferentialNotification = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PreferentialNotification = NSLocalizedString(@"PreferentialNotification", nil);
    });
    return PreferentialNotification;
}

+ (NSString *)GoodMorning
{
    static NSString *GoodMorning = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GoodMorning = NSLocalizedString(@"GoodMorning", nil);
    });
    return GoodMorning;
}

+ (NSString *)GoodNoon
{
    static NSString *GoodNoon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GoodNoon = NSLocalizedString(@"GoodNoon", nil);
    });
    return GoodNoon;
}

+ (NSString *)GoodAfternoon
{
    static NSString *GoodAfternoon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GoodAfternoon = NSLocalizedString(@"GoodAfternoon", nil);
    });
    return GoodAfternoon;
}

+ (NSString *)GoodEvening
{
    static NSString *GoodEvening = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GoodEvening = NSLocalizedString(@"GoodEvening", nil);
    });
    return GoodEvening;
}

+ (NSString *)SoldOut
{
    static NSString *SoldOut = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SoldOut = NSLocalizedString(@"SoldOut", nil);
    });
    return SoldOut;
}

+ (NSString *)CartError
{
    static NSString *CartError = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CartError = NSLocalizedString(@"CartError", nil);
    });
    return CartError;
}

+ (NSString *)NotEnoughInStock
{
    static NSString *NotEnoughInStock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NotEnoughInStock = NSLocalizedString(@"NotEnoughInStock", nil);
    });
    return NotEnoughInStock;
}

+ (NSString *)MultipleProductsUnacceptable
{
    static NSString *MultipleProductsUnacceptable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MultipleProductsUnacceptable = NSLocalizedString(@"MultipleProductsUnacceptable", nil);
    });
    return MultipleProductsUnacceptable;
}

+ (NSString *)ProductsRemovedFromCart
{
    static NSString *ProductsRemovedFromCart = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ProductsRemovedFromCart = NSLocalizedString(@"ProductsRemovedFromCart", nil);
    });
    return ProductsRemovedFromCart;
}

+ (NSString *)ChooseQuantityAndDiscount
{
    static NSString *ChooseQuantityAndDiscount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ChooseQuantityAndDiscount = NSLocalizedString(@"ChooseQuantityAndDiscount", nil);
    });
    return ChooseQuantityAndDiscount;
}

+ (NSString *)Total_C
{
    static NSString *Total_C = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Total_C = NSLocalizedString(@"Total_C", nil);
    });
    return Total_C;
}

+ (NSString *)Quantity
{
    static NSString *Quantity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Quantity = NSLocalizedString(@"Quantity", nil);
    });
    return Quantity;
}

+ (NSString *)GoingToDeleteProduct_S_
{
    static NSString *GoingToDeleteProduct_S_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GoingToDeleteProduct_S_ = NSLocalizedString(@"GoingToDeleteProduct_S_", nil);
    });
    return GoingToDeleteProduct_S_;
}

+ (NSString *)ThisProduct
{
    static NSString *ThisProduct = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ThisProduct = NSLocalizedString(@"ThisProduct", nil);
    });
    return ThisProduct;
}

+ (NSString *)_Q_
{
    static NSString *_Q_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _Q_ = NSLocalizedString(@"_Q_", nil);
    });
    return _Q_;
}

+ (NSString *)PleaseLogin
{
    static NSString *PleaseLogin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseLogin = NSLocalizedString(@"PleaseLogin", nil);
    });
    return PleaseLogin;
}

+ (NSString *)GoingToRemoveLatestSearchList
{
    static NSString *GoingToRemoveLatestSearchList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GoingToRemoveLatestSearchList = NSLocalizedString(@"GoingToRemoveLatestSearchList", nil);
    });
    return GoingToRemoveLatestSearchList;
}

+ (NSString *)CannotFindProductId
{
    static NSString *CannotFindProductId = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CannotFindProductId = NSLocalizedString(@"CannotFindProductId", nil);
    });
    return CannotFindProductId;
}

+ (NSString *)AlreadyInFavorite
{
    static NSString *AlreadyInFavorite = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AlreadyInFavorite = NSLocalizedString(@"AlreadyInFavorite", nil);
    });
    return AlreadyInFavorite;
}

+ (NSString *)AddToFavoriteSuccess
{
    static NSString *AddToFavoriteSuccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AddToFavoriteSuccess = NSLocalizedString(@"AddToFavoriteSuccess", nil);
    });
    return AddToFavoriteSuccess;
}

+ (NSString *)NoMatchingProduct
{
    static NSString *NoMatchingProduct = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoMatchingProduct = NSLocalizedString(@"NoMatchingProduct", nil);
    });
    return NoMatchingProduct;
}

+ (NSString *)ChangePasswordSuccess
{
    static NSString *ChangePasswordSuccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ChangePasswordSuccess = NSLocalizedString(@"ChangePasswordSuccess", nil);
    });
    return ChangePasswordSuccess;
}

+ (NSString *)PleaseSelectQuantity
{
    static NSString *PleaseSelectQuantity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseSelectQuantity = NSLocalizedString(@"PleaseSelectQuantity", nil);
    });
    return PleaseSelectQuantity;
}

+ (NSString *)PleaseChooseDiscount
{
    static NSString *PleaseChooseDiscount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseChooseDiscount = NSLocalizedString(@"PleaseChooseDiscount", nil);
    });
    return PleaseChooseDiscount;
}

+ (NSString *)PurchaseFastDeliveryFor_I_Dollars
{
    static NSString *PurchaseFastDeliveryFor_I_Dollars = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PurchaseFastDeliveryFor_I_Dollars = NSLocalizedString(@"PurchaseFastDeliveryFor_I_Dollars", nil);
    });
    return PurchaseFastDeliveryFor_I_Dollars;
}

+ (NSString *)PurchaseFastDeliveryFor_I_Points
{
    static NSString *PurchaseFastDeliveryFor_I_Points = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PurchaseFastDeliveryFor_I_Points = NSLocalizedString(@"PurchaseFastDeliveryFor_I_Points", nil);
    });
    return PurchaseFastDeliveryFor_I_Points;
}

+ (NSString *)ContinueToShopping
{
    static NSString *ContinueToShopping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ContinueToShopping = NSLocalizedString(@"ContinueToShopping", nil);
    });
    return ContinueToShopping;
}

+ (NSString *)CheckOutDirectly
{
    static NSString *CheckOutDirectly = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CheckOutDirectly = NSLocalizedString(@"CheckOutDirectly", nil);
    });
    return CheckOutDirectly;
}

+ (NSString *)TodayFocus
{
    static NSString *TodayFocus = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TodayFocus = NSLocalizedString(@"TodayFocus", nil);
    });
    return TodayFocus;
}

+ (NSString *)SpecialService
{
    static NSString *SpecialService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SpecialService = NSLocalizedString(@"SpecialService", nil);
    });
    return SpecialService;
}

+ (NSString *)Dollars
{
    static NSString *Dollars = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Dollars = NSLocalizedString(@"Dollars", nil);
    });
    return Dollars;
}

+ (NSString *)CathayCardOnly
{
    static NSString *CathayCardOnly = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CathayCardOnly = NSLocalizedString(@"CathayCardOnly", nil);
    });
    return CathayCardOnly;
}

+ (NSString *)NoInterestInstallment
{
    static NSString *NoInterestInstallment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoInterestInstallment = NSLocalizedString(@"NoInterestInstallment", nil);
    });
    return NoInterestInstallment;
}

+ (NSString *)InstallmentAvailableBank
{
    static NSString *InstallmentAvailableBank = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InstallmentAvailableBank = NSLocalizedString(@"InstallmentAvailableBank", nil);
    });
    return InstallmentAvailableBank;
}

+ (NSString *)ModifySuccess
{
    static NSString *ModifySuccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ModifySuccess = NSLocalizedString(@"ModifySuccess", nil);
    });
    return ModifySuccess;
}

+ (NSString *)ModifyFailed
{
    static NSString *ModifyFailed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ModifyFailed = NSLocalizedString(@"ModifyFailed", nil);
    });
    return ModifyFailed;
}

+ (NSString *)PleaseInputEmailOrIdNumber
{
    static NSString *PleaseInputEmailOrIdNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputEmailOrIdNumber = NSLocalizedString(@"PleaseInputEmailOrIdNumber", nil);
    });
    return PleaseInputEmailOrIdNumber;
}

+ (NSString *)NoMatchProduct
{
    static NSString *NoMatchProduct = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoMatchProduct = NSLocalizedString(@"NoMatchProduct", nil);
    });
    return NoMatchProduct;
}

+ (NSString *)NoProductInCart
{
    static NSString *NoProductInCart = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoProductInCart = NSLocalizedString(@"NoProductInCart", nil);
    });
    return NoProductInCart;
}

+ (NSString *)NoCollections
{
    static NSString *NoCollections = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoCollections = NSLocalizedString(@"NoCollections", nil);
    });
    return NoCollections;
}

+ (NSString *)AlreadyRemoveSomeProduct
{
    static NSString *AlreadyRemoveSomeProduct = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AlreadyRemoveSomeProduct = NSLocalizedString(@"AlreadyRemoveSomeProduct", nil);
    });
    return AlreadyRemoveSomeProduct;
}

+ (NSString *)ActionLink
{
    static NSString *ActionLink = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ActionLink = NSLocalizedString(@"ActionLink", nil);
    });
    return ActionLink;
}

+ (NSString *)HotSaleRanking
{
    static NSString *HotSaleRanking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HotSaleRanking = NSLocalizedString(@"HotSaleRanking", nil);
    });
    return HotSaleRanking;
}

+ (NSString *)ProductInfo
{
    static NSString *ProductInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ProductInfo = NSLocalizedString(@"ProductInfo", nil);
    });
    return ProductInfo;
}

+ (NSString *)AdditionalPurchaseProduct
{
    static NSString *AdditionalPurchaseProduct = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AdditionalPurchaseProduct = NSLocalizedString(@"AdditionalPurchaseProduct", nil);
    });
    return AdditionalPurchaseProduct;
}

+ (NSString *)AlreadyPurchase_I_Piece
{
    static NSString *AlreadyPurchase_I_Piece = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AlreadyPurchase_I_Piece = NSLocalizedString(@"AlreadyPurchase_I_Piece", nil);
    });
    return AlreadyPurchase_I_Piece;
}

+ (NSString *)Order
{
    static NSString *Order = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Order = NSLocalizedString(@"Order", nil);
    });
    return Order;
}

+ (NSString *)Total_I_ProductAnd_I_Pieces
{
    static NSString *Total_I_ProductAnd_I_Pieces = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Total_I_ProductAnd_I_Pieces = NSLocalizedString(@"Total_I_ProductAnd_I_Pieces", nil);
    });
    return Total_I_ProductAnd_I_Pieces;
}

+ (NSString *)BonusPoint
{
    static NSString *BonusPoint = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BonusPoint = NSLocalizedString(@"BonusPoint", nil);
    });
    return BonusPoint;
}

+ (NSString *)CathayCash
{
    static NSString *CathayCash = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CathayCash = NSLocalizedString(@"CathayCash", nil);
    });
    return CathayCash;
}

+ (NSString *)DiscountChosen
{
    static NSString *DiscountChosen = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DiscountChosen = NSLocalizedString(@"DiscountChosen", nil);
    });
    return DiscountChosen;
}

+ (NSString *)PaymentType
{
    static NSString *PaymentType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PaymentType = NSLocalizedString(@"PaymentType", nil);
    });
    return PaymentType;
}

+ (NSString *)CreditCard
{
    static NSString *CreditCard = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CreditCard = NSLocalizedString(@"CreditCard", nil);
    });
    return CreditCard;
}

+ (NSString *)OneTimePayment
{
    static NSString *OneTimePayment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OneTimePayment = NSLocalizedString(@"OneTimePayment", nil);
    });
    return OneTimePayment;
}

+ (NSString *)CreditCardInstallment
{
    static NSString *CreditCardInstallment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CreditCardInstallment = NSLocalizedString(@"CreditCardInstallment", nil);
    });
    return CreditCardInstallment;
}

+ (NSString *)BuyNow
{
    static NSString *BuyNow = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BuyNow = NSLocalizedString(@"BuyNow", nil);
    });
    return BuyNow;
}

+ (NSString *)Activate
{
    static NSString *Activate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Activate = NSLocalizedString(@"Activate", nil);
    });
    return Activate;
}

+ (NSString *)BuyNowInstallment
{
    static NSString *BuyNowInstallment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BuyNowInstallment = NSLocalizedString(@"BuyNowInstallment", nil);
    });
    return BuyNowInstallment;
}

+ (NSString *)PointAsDollarCreditCardInstallment
{
    static NSString *PointAsDollarCreditCardInstallment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PointAsDollarCreditCardInstallment = NSLocalizedString(@"PointAsDollarCreditCardInstallment", nil);
    });
    return PointAsDollarCreditCardInstallment;
}

+ (NSString *)PayAfterDelivery
{
    static NSString *PayAfterDelivery = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PayAfterDelivery = NSLocalizedString(@"PayAfterDelivery", nil);
    });
    return PayAfterDelivery;
}

+ (NSString *)InstallmentTerm
{
    static NSString *InstallmentTerm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InstallmentTerm = NSLocalizedString(@"InstallmentTerm", nil);
    });
    return InstallmentTerm;
}

+ (NSString *)AgreeTreeMallBusinessTerm
{
    static NSString *AgreeTreeMallBusinessTerm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AgreeTreeMallBusinessTerm = NSLocalizedString(@"AgreeTreeMallBusinessTerm", nil);
    });
    return AgreeTreeMallBusinessTerm;
}

+ (NSString *)TermsDetail
{
    static NSString *TermsDetail = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TermsDetail = NSLocalizedString(@"TermsDetail", nil);
    });
    return TermsDetail;
}

+ (NSString *)AcceptTheTermsFirst
{
    static NSString *AcceptTheTermsFirst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AcceptTheTermsFirst = NSLocalizedString(@"AcceptTheTermsFirst", nil);
    });
    return AcceptTheTermsFirst;
}

+ (NSString *)PleaseChoosePaymentType
{
    static NSString *PleaseChoosePaymentType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseChoosePaymentType = NSLocalizedString(@"PleaseChoosePaymentType", nil);
    });
    return PleaseChoosePaymentType;
}

+ (NSString *)ReceiverInfo
{
    static NSString *ReceiverInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReceiverInfo = NSLocalizedString(@"ReceiverInfo", nil);
    });
    return ReceiverInfo;
}

+ (NSString *)Receiver
{
    static NSString *Receiver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Receiver = NSLocalizedString(@"Receiver", nil);
    });
    return Receiver;
}

+ (NSString *)PleaseInputName
{
    static NSString *PleaseInputName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputName = NSLocalizedString(@"PleaseInputName", nil);
    });
    return PleaseInputName;
}

+ (NSString *)CellPhone
{
    static NSString *CellPhone = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CellPhone = NSLocalizedString(@"CellPhone", nil);
    });
    return CellPhone;
}

+ (NSString *)PleaseInputCellPhoneNumber
{
    static NSString *PleaseInputCellPhoneNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputCellPhoneNumber = NSLocalizedString(@"PleaseInputCellPhoneNumber", nil);
    });
    return PleaseInputCellPhoneNumber;
}

+ (NSString *)DayPhone
{
    static NSString *DayPhone = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DayPhone = NSLocalizedString(@"DayPhone", nil);
    });
    return DayPhone;
}

+ (NSString *)PleaseInputPhoneNumber
{
    static NSString *PleaseInputPhoneNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputPhoneNumber = NSLocalizedString(@"PleaseInputPhoneNumber", nil);
    });
    return PleaseInputPhoneNumber;
}

+ (NSString *)NightPhone
{
    static NSString *NightPhone = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NightPhone = NSLocalizedString(@"NightPhone", nil);
    });
    return NightPhone;
}

+ (NSString *)ReceiverAddress
{
    static NSString *ReceiverAddress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReceiverAddress = NSLocalizedString(@"ReceiverAddress", nil);
    });
    return ReceiverAddress;
}

+ (NSString *)DeliveryCity
{
    static NSString *DeliveryCity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DeliveryCity = NSLocalizedString(@"DeliveryCity", nil);
    });
    return DeliveryCity;
}

+ (NSString *)DeliveryRegion
{
    static NSString *DeliveryRegion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DeliveryRegion = NSLocalizedString(@"DeliveryRegion", nil);
    });
    return DeliveryRegion;
}

+ (NSString *)Address
{
    static NSString *Address = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Address = NSLocalizedString(@"Address", nil);
    });
    return Address;
}

+ (NSString *)DeliveryTime
{
    static NSString *DeliveryTime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DeliveryTime = NSLocalizedString(@"DeliveryTime", nil);
    });
    return DeliveryTime;
}

+ (NSString *)Note
{
    static NSString *Note = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Note = NSLocalizedString(@"Note", nil);
    });
    return Note;
}

+ (NSString *)PleaseSelectCity
{
    static NSString *PleaseSelectCity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseSelectCity = NSLocalizedString(@"PleaseSelectCity", nil);
    });
    return PleaseSelectCity;
}

+ (NSString *)PleaseSelectRegion
{
    static NSString *PleaseSelectRegion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseSelectRegion = NSLocalizedString(@"PleaseSelectRegion", nil);
    });
    return PleaseSelectRegion;
}

+ (NSString *)PleaseInputAddress
{
    static NSString *PleaseInputAddress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputAddress = NSLocalizedString(@"PleaseInputAddress", nil);
    });
    return PleaseInputAddress;
}

+ (NSString *)PleaseSelectDeliveryTime
{
    static NSString *PleaseSelectDeliveryTime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseSelectDeliveryTime = NSLocalizedString(@"PleaseSelectDeliveryTime", nil);
    });
    return PleaseSelectDeliveryTime;
}

+ (NSString *)PleaseInputNote
{
    static NSString *PleaseInputNote = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputNote = NSLocalizedString(@"PleaseInputNote", nil);
    });
    return PleaseInputNote;
}

+ (NSString *)SameAsCellPhone
{
    static NSString *SameAsCellPhone = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SameAsCellPhone = NSLocalizedString(@"SameAsCellPhone", nil);
    });
    return SameAsCellPhone;
}

+ (NSString *)Nine_Twelve_InTheMorning
{
    static NSString *Nine_Twelve_InTheMorning = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Nine_Twelve_InTheMorning = NSLocalizedString(@"Nine_Twelve_InTheMorning", nil);
    });
    return Nine_Twelve_InTheMorning;
}

+ (NSString *)Twelve_Seventeen_InTheAfternoon
{
    static NSString *Twelve_Seventeen_InTheAfternoon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Twelve_Seventeen_InTheAfternoon = NSLocalizedString(@"Twelve_Seventeen_InTheAfternoon", nil);
    });
    return Twelve_Seventeen_InTheAfternoon;
}

+ (NSString *)Seventeen_Twenty_InTheEvening
{
    static NSString *Seventeen_Twenty_InTheEvening = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Seventeen_Twenty_InTheEvening = NSLocalizedString(@"Seventeen_Twenty_InTheEvening", nil);
    });
    return Seventeen_Twenty_InTheEvening;
}

+ (NSString *)NotSpecified
{
    static NSString *NotSpecified = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NotSpecified = NSLocalizedString(@"NotSpecified", nil);
    });
    return NotSpecified;
}

+ (NSString *)AddedTo_S_
{
    static NSString *AddedTo_S_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AddedTo_S_ = NSLocalizedString(@"AddedTo_S_", nil);
    });
    return AddedTo_S_;
}

+ (NSString *)InvoiceDeliverAddress
{
    static NSString *InvoiceDeliverAddress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InvoiceDeliverAddress = NSLocalizedString(@"InvoiceDeliverAddress", nil);
    });
    return InvoiceDeliverAddress;
}

+ (NSString *)InvoiceType
{
    static NSString *InvoiceType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InvoiceType = NSLocalizedString(@"InvoiceType", nil);
    });
    return InvoiceType;
}

+ (NSString *)PleaseSelect
{
    static NSString *PleaseSelect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseSelect = NSLocalizedString(@"PleaseSelect", nil);
    });
    return PleaseSelect;
}

+ (NSString *)ElectronicInvoiceCarrier
{
    static NSString *ElectronicInvoiceCarrier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ElectronicInvoiceCarrier = NSLocalizedString(@"ElectronicInvoiceCarrier", nil);
    });
    return ElectronicInvoiceCarrier;
}

+ (NSString *)InvoiceDonation
{
    static NSString *InvoiceDonation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InvoiceDonation = NSLocalizedString(@"InvoiceDonation", nil);
    });
    return InvoiceDonation;
}

+ (NSString *)CertificateID
{
    static NSString *CertificateID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CertificateID = NSLocalizedString(@"CertificateID", nil);
    });
    return CertificateID;
}

+ (NSString *)CellphoneBarcode
{
    static NSString *CellphoneBarcode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CellphoneBarcode = NSLocalizedString(@"CellphoneBarcode", nil);
    });
    return CellphoneBarcode;
}

+ (NSString *)PleaseInput
{
    static NSString *PleaseInput = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInput = NSLocalizedString(@"PleaseInput", nil);
    });
    return PleaseInput;
}

+ (NSString *)HeartCode
{
    static NSString *HeartCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HeartCode = NSLocalizedString(@"HeartCode", nil);
    });
    return HeartCode;
}

+ (NSString *)InvoiceTitle
{
    static NSString *InvoiceTitle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InvoiceTitle = NSLocalizedString(@"InvoiceTitle", nil);
    });
    return InvoiceTitle;
}

+ (NSString *)UnifiedNumber
{
    static NSString *UnifiedNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UnifiedNumber = NSLocalizedString(@"UnifiedNumber", nil);
    });
    return UnifiedNumber;
}

+ (NSString *)InvoiceReceiver
{
    static NSString *InvoiceReceiver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InvoiceReceiver = NSLocalizedString(@"InvoiceReceiver", nil);
    });
    return InvoiceReceiver;
}

+ (NSString *)ElectronicInvoice
{
    static NSString *ElectronicInvoice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ElectronicInvoice = NSLocalizedString(@"ElectronicInvoice", nil);
    });
    return ElectronicInvoice;
}

+ (NSString *)InvoiceDonate
{
    static NSString *InvoiceDonate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InvoiceDonate = NSLocalizedString(@"InvoiceDonate", nil);
    });
    return InvoiceDonate;
}

+ (NSString *)TriplicateUniformInvoice
{
    static NSString *TriplicateUniformInvoice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TriplicateUniformInvoice = NSLocalizedString(@"TriplicateUniformInvoice", nil);
    });
    return TriplicateUniformInvoice;
}

+ (NSString *)CarrierMember
{
    static NSString *CarrierMember = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CarrierMember = NSLocalizedString(@"CarrierMember", nil);
    });
    return CarrierMember;
}

+ (NSString *)CarrierNaturalPerson
{
    static NSString *CarrierNaturalPerson = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CarrierNaturalPerson = NSLocalizedString(@"CarrierNaturalPerson", nil);
    });
    return CarrierNaturalPerson;
}

+ (NSString *)CarrierCellPhoneBarcode
{
    static NSString *CarrierCellPhoneBarcode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CarrierCellPhoneBarcode = NSLocalizedString(@"CarrierCellPhoneBarcode", nil);
    });
    return CarrierCellPhoneBarcode;
}

+ (NSString *)SampleImage
{
    static NSString *SampleImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SampleImage = NSLocalizedString(@"SampleImage", nil);
    });
    return SampleImage;
}

+ (NSString *)DonateTarget1
{
    static NSString *DonateTarget1 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DonateTarget1 = NSLocalizedString(@"DonateTarget1", nil);
    });
    return DonateTarget1;
}

+ (NSString *)DonateTarget2
{
    static NSString *DonateTarget2 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DonateTarget2 = NSLocalizedString(@"DonateTarget2", nil);
    });
    return DonateTarget2;
}

+ (NSString *)DonateTarget3
{
    static NSString *DonateTarget3 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DonateTarget3 = NSLocalizedString(@"DonateTarget3", nil);
    });
    return DonateTarget3;
}

+ (NSString *)DonateTargetOther
{
    static NSString *DonateTargetOther = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DonateTargetOther = NSLocalizedString(@"DonateTargetOther", nil);
    });
    return DonateTargetOther;
}

+ (NSString *)DonateTarget
{
    static NSString *DonateTarget = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DonateTarget = NSLocalizedString(@"DonateTarget", nil);
    });
    return DonateTarget;
}

+ (NSString *)SameAsReceiver
{
    static NSString *SameAsReceiver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SameAsReceiver = NSLocalizedString(@"SameAsReceiver", nil);
    });
    return SameAsReceiver;
}

+ (NSString *)SelectReceiver
{
    static NSString *SelectReceiver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SelectReceiver = NSLocalizedString(@"SelectReceiver", nil);
    });
    return SelectReceiver;
}

+ (NSString *)PleaseInputRegionNumber
{
    static NSString *PleaseInputRegionNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputRegionNumber = NSLocalizedString(@"PleaseInputRegionNumber", nil);
    });
    return PleaseInputRegionNumber;
}

+ (NSString *)PleaseInputSpecificNumber
{
    static NSString *PleaseInputSpecificNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputSpecificNumber = NSLocalizedString(@"PleaseInputSpecificNumber", nil);
    });
    return PleaseInputSpecificNumber;
}

+ (NSString *)FastArrive
{
    static NSString *FastArrive = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FastArrive = NSLocalizedString(@"FastArrive", nil);
    });
    return FastArrive;
}

+ (NSString *)InvoiceDelivery
{
    static NSString *InvoiceDelivery = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        InvoiceDelivery = NSLocalizedString(@"InvoiceDelivery", nil);
    });
    return InvoiceDelivery;
}

+ (NSString *)CashToPay
{
    static NSString *CashToPay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CashToPay = NSLocalizedString(@"CashToPay", nil);
    });
    return CashToPay;
}

+ (NSString *)DiscountByEPoint
{
    static NSString *DiscountByEPoint = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DiscountByEPoint = NSLocalizedString(@"DiscountByEPoint", nil);
    });
    return DiscountByEPoint;
}

+ (NSString *)DiscountByPoint
{
    static NSString *DiscountByPoint = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DiscountByPoint = NSLocalizedString(@"DiscountByPoint", nil);
    });
    return DiscountByPoint;
}

+ (NSString *)Total_I_product
{
    static NSString *Total_I_product = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Total_I_product = NSLocalizedString(@"Total_I_product", nil);
    });
    return Total_I_product;
}

+ (NSString *)BankCode
{
    static NSString *BankCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BankCode = NSLocalizedString(@"BankCode", nil);
    });
    return BankCode;
}

+ (NSString *)BankAccountToPay
{
    static NSString *BankAccountToPay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BankAccountToPay = NSLocalizedString(@"BankAccountToPay", nil);
    });
    return BankAccountToPay;
}

+ (NSString *)PaymentDeadline
{
    static NSString *PaymentDeadline = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PaymentDeadline = NSLocalizedString(@"PaymentDeadline", nil);
    });
    return PaymentDeadline;
}

+ (NSString *)CashShouldPay
{
    static NSString *CashShouldPay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CashShouldPay = NSLocalizedString(@"CashShouldPay", nil);
    });
    return CashShouldPay;
}

+ (NSString *)DiscountPreferencial
{
    static NSString *DiscountPreferencial = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DiscountPreferencial = NSLocalizedString(@"DiscountPreferencial", nil);
    });
    return DiscountPreferencial;
}

+ (NSString *)PaymentInfo
{
    static NSString *PaymentInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PaymentInfo = NSLocalizedString(@"PaymentInfo", nil);
    });
    return PaymentInfo;
}

+ (NSString *)AccountTransferInfo
{
    static NSString *AccountTransferInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AccountTransferInfo = NSLocalizedString(@"AccountTransferInfo", nil);
    });
    return AccountTransferInfo;
}

+ (NSString *)PleaseInputValidValidDate
{
    static NSString *PleaseInputValidValidDate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputValidValidDate = NSLocalizedString(@"PleaseInputValidValidDate", nil);
    });
    return PleaseInputValidValidDate;
}

+ (NSString *)PleaseInputValidCardNumber
{
    static NSString *PleaseInputValidCardNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputValidCardNumber = NSLocalizedString(@"PleaseInputValidCardNumber", nil);
    });
    return PleaseInputValidCardNumber;
}

+ (NSString *)PleaseInputValidSecurityCode
{
    static NSString *PleaseInputValidSecurityCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseInputValidSecurityCode = NSLocalizedString(@"PleaseInputValidSecurityCode", nil);
    });
    return PleaseInputValidSecurityCode;
}

+ (NSString *)ConvenienceStore
{
    static NSString *ConvenienceStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ConvenienceStore = NSLocalizedString(@"ConvenienceStore", nil);
    });
    return ConvenienceStore;
}

+ (NSString *)StoreNumber
{
    static NSString *StoreNumber = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        StoreNumber = NSLocalizedString(@"StoreNumber", nil);
    });
    return StoreNumber;
}

+ (NSString *)StoreName
{
    static NSString *StoreName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        StoreName = NSLocalizedString(@"StoreName", nil);
    });
    return StoreName;
}

+ (NSString *)StoreAddress
{
    static NSString *StoreAddress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        StoreAddress = NSLocalizedString(@"StoreAddress", nil);
    });
    return StoreAddress;
}

+ (NSString *)ChoosePickupStore
{
    static NSString *ChoosePickupStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ChoosePickupStore = NSLocalizedString(@"ChoosePickupStore", nil);
    });
    return ChoosePickupStore;
}

+ (NSString *)AlreadySentEmailAuth_S_
{
    static NSString *AlreadySentEmailAuth_S_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AlreadySentEmailAuth_S_ = NSLocalizedString(@"AlreadySentEmailAuth_S_", nil);
    });
    return AlreadySentEmailAuth_S_;
}

+ (NSString *)PleaseAgreeMemberTermsFirst
{
    static NSString *PleaseAgreeMemberTermsFirst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseAgreeMemberTermsFirst = NSLocalizedString(@"PleaseAgreeMemberTermsFirst", nil);
    });
    return PleaseAgreeMemberTermsFirst;
}

+ (NSString *)CreditCardInfo
{
    static NSString *CreditCardInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CreditCardInfo = NSLocalizedString(@"CreditCardInfo", nil);
    });
    return CreditCardInfo;
}

+ (NSString *)Greetings
{
    static NSString *Greetings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Greetings = NSLocalizedString(@"Greetings", nil);
    });
    return Greetings;
}

+ (NSString *)Contacts
{
    static NSString *Contacts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Contacts = NSLocalizedString(@"Contacts", nil);
    });
    return Contacts;
}

+ (NSString *)PleaseSelectQuantityAndPaymentForEachProduct
{
    static NSString *PleaseSelectQuantityAndPaymentForEachProduct = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseSelectQuantityAndPaymentForEachProduct = NSLocalizedString(@"PleaseSelectQuantityAndPaymentForEachProduct", nil);
    });
    return PleaseSelectQuantityAndPaymentForEachProduct;
}

+ (NSString *)NoCashPayment
{
    static NSString *NoCashPayment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoCashPayment = NSLocalizedString(@"NoCashPayment", nil);
    });
    return NoCashPayment;
}

+ (NSString *)SelectPickupStore
{
    static NSString *SelectPickupStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SelectPickupStore = NSLocalizedString(@"SelectPickupStore", nil);
    });
    return SelectPickupStore;
}

+ (NSString *)CompleteOrder
{
    static NSString *CompleteOrder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CompleteOrder = NSLocalizedString(@"CompleteOrder", nil);
    });
    return CompleteOrder;
}

+ (NSString *)OtherDiscount
{
    static NSString *OtherDiscount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OtherDiscount = NSLocalizedString(@"OtherDiscount", nil);
    });
    return OtherDiscount;
}

+ (NSString *)OtherDiscountContent
{
    static NSString *OtherDiscountContent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OtherDiscountContent = NSLocalizedString(@"OtherDiscountContent", nil);
    });
    return OtherDiscountContent;
}

+ (NSString *)CheckPromotionTotalDiscount
{
    static NSString *CheckPromotionTotalDiscount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CheckPromotionTotalDiscount = NSLocalizedString(@"CheckPromotionTotalDiscount", nil);
    });
    return CheckPromotionTotalDiscount;
}

+ (NSString *)PaymentTotalCount
{
    static NSString *PaymentTotalCount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PaymentTotalCount = NSLocalizedString(@"PaymentTotalCount", nil);
    });
    return PaymentTotalCount;
}

+ (NSString *)CheckoutInfo
{
    static NSString *CheckoutInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CheckoutInfo = NSLocalizedString(@"CheckoutInfo", nil);
    });
    return CheckoutInfo;
}

+ (NSString *)Shipped
{
    static NSString *Shipped = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Shipped = NSLocalizedString(@"Shipped", nil);
    });
    return Shipped;
}

+ (NSString *)CreditCardHint
{
    static NSString *CreditCardHint = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CreditCardHint = NSLocalizedString(@"CreditCardHint", nil);
    });
    return CreditCardHint;
}

+ (NSString *)CurrentlyNoCoupon
{
    static NSString *CurrentlyNoCoupon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CurrentlyNoCoupon = NSLocalizedString(@"CurrentlyNoCoupon", nil);
    });
    return CurrentlyNoCoupon;
}

+ (NSString *)DeliverProgress
{
    static NSString *DeliverProgress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DeliverProgress = NSLocalizedString(@"DeliverProgress", nil);
    });
    return DeliverProgress;
}

+ (NSString *)PleaseSelectPaymentType
{
    static NSString *PleaseSelectPaymentType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PleaseSelectPaymentType = NSLocalizedString(@"PleaseSelectPaymentType", nil);
    });
    return PleaseSelectPaymentType;
}

+ (NSString *)CurrentlyNoOrder
{
    static NSString *CurrentlyNoOrder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CurrentlyNoOrder = NSLocalizedString(@"CurrentlyNoOrder", nil);
    });
    return CurrentlyNoOrder;
}

+ (NSString *)ThisProductNoInstallment
{
    static NSString *ThisProductNoInstallment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ThisProductNoInstallment = NSLocalizedString(@"ThisProductNoInstallment", nil);
    });
    return ThisProductNoInstallment;
}

+ (NSString *)ChangePasswordFailed
{
    static NSString *ChangePasswordFailed = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ChangePasswordFailed = NSLocalizedString(@"ChangePasswordFailed", nil);
    });
    return ChangePasswordFailed;
}

+ (NSString *)EightHourDelivery
{
    static NSString *EightHourDelivery = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        EightHourDelivery = NSLocalizedString(@"EightHourDelivery", nil);
    });
    return EightHourDelivery;
}

+ (NSString *)ThisIsGift
{
    static NSString *ThisIsGift = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ThisIsGift = NSLocalizedString(@"ThisIsGift", nil);
    });
    return ThisIsGift;
}

+ (NSString *)OrderDetailAlert
{
    static NSString *OrderDetailAlert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OrderDetailAlert = NSLocalizedString(@"OrderDetailAlert", nil);
    });
    return OrderDetailAlert;
}

+ (NSString *)NoSuchDonationCode
{
    static NSString *NoSuchDonationCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoSuchDonationCode = NSLocalizedString(@"NoSuchDonationCode", nil);
    });
    return NoSuchDonationCode;
}

+ (NSString *)SystemErrorTryLater
{
    static NSString *SystemErrorTryLater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SystemErrorTryLater = NSLocalizedString(@"SystemErrorTryLater", nil);
    });
    return SystemErrorTryLater;
}

+ (NSString *)NotMemberYet
{
    static NSString *NotMemberYet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NotMemberYet = NSLocalizedString(@"NotMemberYet", nil);
    });
    return NotMemberYet;
}

+ (NSString *)CreditCardFormatError
{
    static NSString *CreditCardFormatError = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CreditCardFormatError = NSLocalizedString(@"CreditCardFormatError", nil);
    });
    return CreditCardFormatError;
}

+ (NSString *)BonusPointUsageLimitation
{
    static NSString *BonusPointUsageLimitation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BonusPointUsageLimitation = NSLocalizedString(@"BonusPointUsageLimitation", nil);
    });
    return BonusPointUsageLimitation;
}

+ (NSString *)NoMatchedProduct
{
    static NSString *NoMatchedProduct = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoMatchedProduct = NSLocalizedString(@"NoMatchedProduct", nil);
    });
    return NoMatchedProduct;
}

+ (NSString *)NotEnoughProductInStock
{
    static NSString *NotEnoughProductInStock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NotEnoughProductInStock = NSLocalizedString(@"NotEnoughProductInStock", nil);
    });
    return NotEnoughProductInStock;
}

+ (NSString *)ProductNoLongerAvailable
{
    static NSString *ProductNoLongerAvailable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ProductNoLongerAvailable = NSLocalizedString(@"ProductNoLongerAvailable", nil);
    });
    return ProductNoLongerAvailable;
}

+ (NSString *)NoAdditionalPurchaseForTargetAmount
{
    static NSString *NoAdditionalPurchaseForTargetAmount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoAdditionalPurchaseForTargetAmount = NSLocalizedString(@"NoAdditionalPurchaseForTargetAmount", nil);
    });
    return NoAdditionalPurchaseForTargetAmount;
}

+ (NSString *)NoAdditionalPurchase
{
    static NSString *NoAdditionalPurchase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoAdditionalPurchase = NSLocalizedString(@"NoAdditionalPurchase", nil);
    });
    return NoAdditionalPurchase;
}

+ (NSString *)FreepointDescription
{
    static NSString *FreepointDescription = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FreepointDescription = NSLocalizedString(@"FreepointDescription", nil);
    });
    return FreepointDescription;
}

+ (NSString *)DiscountTips
{
    static NSString *DiscountTips = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DiscountTips = NSLocalizedString(@"DiscountTips", nil);
    });
    return DiscountTips;
}

+ (NSString *)NotEnoughPoints
{
    static NSString *NotEnoughPoints = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NotEnoughPoints = NSLocalizedString(@"NotEnoughPoints", nil);
    });
    return NotEnoughPoints;
}

@end
