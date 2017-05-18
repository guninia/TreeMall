//
//  StorePickupInfoViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/17.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText.h>
#import "TMInfoManager.h"
#import "ReceiverInfoCell.h"

@interface StorePickupInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DTAttributedTextContentViewDelegate, UIPopoverPresentationControllerDelegate, ReceiverInfoCellDelegate>

@property (nonatomic, assign) CartType type;
@property (nonatomic, strong) NSMutableDictionary *dictionaryInstallment;
@property (nonatomic, strong) NSString *invoiceDescription;
@property (nonatomic, strong) NSString *tradeId;
@property (nonatomic, strong) NSDictionary *dictionaryTotalCost;
@property (nonatomic, strong) NSString *selectedPaymentDescription;

@end
