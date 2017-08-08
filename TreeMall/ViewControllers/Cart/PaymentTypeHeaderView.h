//
//  PaymentTypeHeaderView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *PaymentTypeHeaderViewIdentifier = @"PaymentTypeHeaderView";

@class PaymentTypeHeaderView;

@protocol PaymentTypeHeaderViewDelegate <NSObject>

@optional
- (void)paymentTypeHeaderView:(PaymentTypeHeaderView *)view didPressActionBySender:(id)sender;

@end

@interface PaymentTypeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id <PaymentTypeHeaderViewDelegate> delegate;
@property (nonatomic, strong) UIView *viewTitleBackground;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIButton *buttonAction;

@end
