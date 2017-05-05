//
//  PaymentTypeHeaderView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *PaymentTypeHeaderViewIdentifier = @"PaymentTypeHeaderView";

@interface PaymentTypeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *viewTitleBackground;
@property (nonatomic, strong) UILabel *labelTitle;

@end
