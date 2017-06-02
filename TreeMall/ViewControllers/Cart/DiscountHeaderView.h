//
//  DiscountHeaderView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/24.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *DiscountHeaderViewIdentifier = @"DiscountHeaderView";

@interface DiscountHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelDiscountValue;

@end
