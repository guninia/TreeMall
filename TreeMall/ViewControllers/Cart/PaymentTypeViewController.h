//
//  PaymentTypeViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/25.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMInfoManager.h"

@interface PaymentTypeViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *labelOrderTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelOrderTotal;
@property (nonatomic, weak) IBOutlet UILabel *labelTotalTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelTotalAmount;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *labelDiscountTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelPaymentTitle;

@property (nonatomic, strong) NSDictionary *dictionaryData;
@property (nonatomic, assign) CartType type;

@end
