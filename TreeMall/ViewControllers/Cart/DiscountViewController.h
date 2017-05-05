//
//  DiscountViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/24.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMInfoManager.h"

@class DiscountViewController;

@protocol DiscountViewControllerDelegate <NSObject>

@optional

- (void)didDismissDiscountViewController:(DiscountViewController *)discountViewController;

@end

@interface DiscountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <DiscountViewControllerDelegate> delegate;
@property (nonatomic, strong) UITableView *tableViewDiscount;
@property (nonatomic, strong) UIButton *buttonConfirm;

@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSArray *arrayPaymentMode;
@property (nonatomic, assign) CartType type;
@property (nonatomic, assign) BOOL isAddition;

@end
