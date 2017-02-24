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

@end
