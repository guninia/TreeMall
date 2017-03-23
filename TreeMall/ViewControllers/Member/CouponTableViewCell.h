//
//  CouponTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/3.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

static NSString *CouponTableViewCellIdentifier = @"CouponTableViewCell";

@interface CouponTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageViewArrowR;
@property (nonatomic, strong) UIImageView *imageViewCoupon;
@property (nonatomic, strong) UILabel *labelValue;
@property (nonatomic, strong) TTTAttributedLabel *labelTitle;
@property (nonatomic, strong) UILabel *labelDateStart;
@property (nonatomic, strong) UILabel *labelDateGoodThru;
@property (nonatomic, strong) UILabel *labelOrderId;
@property (nonatomic, strong) NSNumber *numberValue;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) NSDictionary *attributeTitle;

@end
