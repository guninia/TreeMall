//
//  ChosenDiscountTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ChosenDiscountTableViewCellIdentifier = @"ChosenDiscountTableViewCell";

@interface ChosenDiscountTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *viewTitle;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelDetail;

@end
