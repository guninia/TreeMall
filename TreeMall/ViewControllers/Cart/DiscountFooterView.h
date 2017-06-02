//
//  DiscountFooterView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/6/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *DiscountFooterViewIdentifier = @"DiscountFooterView";

@interface DiscountFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelDiscountValue;

@end
