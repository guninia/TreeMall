//
//  DiscountViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/24.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMInfoManager.h"

@interface DiscountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableViewDiscount;
@property (nonatomic, strong) UIButton *buttonConfirm;

@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSArray *arrayPaymentMode;
@property (nonatomic, assign) CartType type;

@end
