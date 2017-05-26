//
//  Definition.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#ifndef Definition_h
#define Definition_h

#import <Foundation/Foundation.h>

static NSString *PostNotificationName_TokenUpdated = @"TokenUpdated";
static NSString *PostNotificationName_NoInitialToken = @"NoInitialToken";
static NSString *PostNotificationName_UserLoggedIn = @"UserLoggedIn";
static NSString *PostNotificationName_UserRegisterred = @"UserRegisterred";
static NSString *PostNotificationName_UserAuthenticated = @"UserAuthenticated";
static NSString *PostNotificationName_EntranceDataPrepared = @"EntranceDataPrepared";
static NSString *PostNotificationName_UserInformationUpdated = @"UserInformationUpdated";
static NSString *PostNotificationName_UserPointUpdated = @"UserPointUpdated";
static NSString *PostNotificationName_UserCouponUpdated = @"UserCouponUpdated";
static NSString *PostNotificationName_UserLogout = @"UserLogout";
static NSString *PostNotificationName_JumpToMemberTab = @"JumpToMemberTab";
static NSString *PostNotificationName_JumpToMemberTabAndPresentCoupon = @"JumpToMemberTabAndPresentCoupon";
static NSString *PostNotificationName_CartContentChanged = @"CartContentChanged";
static NSString *PostNotificationName_JumpToShoppingMallAndPresentHall = @"JumpToShoppingMallAndPresentHall";
static NSString *PostNotificationName_FavoriteContentChanged = @"FavoriteContentChanged";

static NSString *UserDefault_IntroduceShown = @"IntroduceShown";

#define TMMainColor [UIColor colorWithRed:(90.0/255.0) green:(190.0/255.0) blue:(40.0/255.0) alpha:1.0]

typedef enum : NSUInteger {
    InvoiceLayoutTypeDefault,
    InvoiceLayoutTypeElectronicMemberInvoiceBind,
    InvoiceLayoutTypeElectronicMemberInvoiceNotBind,
    InvoiceLayoutTypeElectronicExtraCode,
    InvoiceLayoutTypeDonate,
    InvoiceLayoutTypeDonateSpecificGroup,
    InvoiceLayoutTypeTriplicate,
    InvoiceLayoutTypeTotal
} InvoiceLayoutType;

typedef enum : NSUInteger {
    InvoiceCellTagChooseType,
    InvoiceCellTagChooseElectronicType,
    InvoiceCellTagChooseDonateTarget,
    InvoiceCellTagElectronicCode,
    InvoiceCellTagDonateCode,
    InvoiceCellTagInvoiceTitle,
    InvoiceCellTagInvoiceIdentifier,
    InvoiceCellTagReceiver,
    InvoiceCellTagCity,
    InvoiceCellTagRegion,
    InvoiceCellTagAddress,
    InvoiceCellTagInvoiceDesc,
    InvoiceCellTagUnknown,
    InvoiceCellTagTotal
} InvoiceCellTag;

typedef enum : NSUInteger {
    InvoiceTypeOptionElectronic,
    InvoiceTypeOptionDonate,
    InvoiceTypeOptionTriplicate,
    InvoiceTypeOptionTotal
} InvoiceTypeOption;

typedef enum : NSUInteger {
    InvoiceElectronicSubTypeMember,
    InvoiceElectronicSubTypeNaturalPerson,
    InvoiceElectronicSubTypeCellphoneBarcode,
    InvoiceElectronicSubTypeTotal
} InvoiceElectronicSubType;

typedef enum : NSUInteger {
    InvoiceDonateTarget1,
    InvoiceDonateTarget2,
    InvoiceDonateTarget3,
    InvoiceDonateTargetOther,
    InvoiceDonateTargetTotal
} InvoiceDonateTarget;

#endif /* Definition_h */
