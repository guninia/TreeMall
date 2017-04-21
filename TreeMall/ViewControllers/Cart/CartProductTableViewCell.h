//
//  CartProductTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

static NSString *CartProductTableViewCellIdentifier = @"CartProductTableViewCell";

@class CartProductTableViewCell;

@protocol CartProductTableViewCellDelegate <NSObject>

- (void)cartProductTableViewCell:(CartProductTableViewCell *)cell didPressedConditionBySender:(id)sender;
- (void)cartProductTableViewCell:(CartProductTableViewCell *)cell didPressedDeleteBySender:(id)sender;

@end

@interface CartProductTableViewCell : UITableViewCell

@property (nonatomic, weak) id <CartProductTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) UIImageView *imageViewProduct;
@property (nonatomic, strong) TTTAttributedLabel *labelName;
@property (nonatomic, strong) UILabel *labelDetail;
@property (nonatomic, strong) UILabel *labelPrice;
@property (nonatomic, strong) UIButton *buttonCondition;
@property (nonatomic, strong) UIButton *buttonDelete;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UILabel *labelPayment;
@property (nonatomic, strong) UILabel *labelQuantity;

@property (nonatomic, strong) NSDictionary *attributesProductName;
@property (nonatomic, strong) NSURL *imageUrl;

@end
