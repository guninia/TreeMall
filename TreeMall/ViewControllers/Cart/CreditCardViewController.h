//
//  CreditCardViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/16.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMInfoManager.h"

@interface CreditCardViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSDictionary *dictionaryOrderResultData;
@property (nonatomic, strong) NSDictionary *dictionaryTotalCost;
@property (nonatomic, strong) NSDictionary *dictionaryDelivery;
@property (nonatomic, strong) NSMutableDictionary *dictionaryInstallment;
@property (nonatomic, strong) NSString *tradeId;
@property (nonatomic, assign) CartType type;
@property (nonatomic, strong) NSString *selectedPaymentDescription;
@property (nonatomic, strong) NSMutableDictionary *params;

@end
