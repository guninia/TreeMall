//
//  PaymentTypeViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/25.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMInfoManager.h"
#import "PaymentTypeTableViewCell.h"
#import "FullScreenLoadingView.h"

@interface PaymentTypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PaymentTypeTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelOrderTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelOrderTotal;
@property (nonatomic, weak) IBOutlet UILabel *labelTotalTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelTotalAmount;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *labelDiscountTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelPaymentTitle;
@property (nonatomic, weak) IBOutlet UIView *separator;
@property (nonatomic, strong) UITableView *tableViewDiscount;
@property (nonatomic, strong) UITableView *tableViewPayment;
@property (nonatomic, strong) UISwitch *switchAgree;
@property (nonatomic, strong) UILabel *labelAgree;
@property (nonatomic, strong) UIButton *buttonAgree;
@property (nonatomic, strong) UIButton *buttonTermsContent;
@property (nonatomic, strong) UIButton *buttonNext;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;

@property (nonatomic, strong) NSDictionary *dictionaryData;
@property (nonatomic, assign) CartType type;
@property (nonatomic, strong) NSMutableArray *arrayPaymentSections;
@property (nonatomic, strong) NSMutableArray *arrayInstallment;
@property (nonatomic, strong) NSMutableArray *arrayDiscount;
@property (nonatomic, strong) NSArray *arrayBuyNowDelivery;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) NSIndexPath *selectedIndexPathOfPayment;
@property (nonatomic, strong) NSDictionary *selectedInstallment;

@end
