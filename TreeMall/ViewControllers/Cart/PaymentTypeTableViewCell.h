//
//  PaymentTypeTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *PaymentTypeTableViewCellIdentifier = @"PaymentTypeTableViewCell";

@class PaymentTypeTableViewCell;

@protocol PaymentTypeTableViewCellDelegate <NSObject>

- (void)PaymentTypeTableViewCell:(PaymentTypeTableViewCell *)cell didSelectActionBySender:(id)sender;

@end

@interface PaymentTypeTableViewCell : UITableViewCell

@property (nonatomic, weak) id <PaymentTypeTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIButton *buttonCheck;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIButton *buttonAction;
@property (nonatomic, strong) NSString *actionTitle;

@end
