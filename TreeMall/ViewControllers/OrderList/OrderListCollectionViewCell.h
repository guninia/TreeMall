//
//  OrderListCollectionViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>
#import "OrderDeliverProgressView.h"

static NSString *OrderListCollectionViewCellIdentifier = @"OrderListCollectionViewCell";

@interface OrderListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TTTAttributedLabel *labelTitle;
@property (nonatomic, strong) UILabel *labelOrderState;
@property (nonatomic, strong) UIView *viewOrderStateBackground;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) OrderDeliverProgressView *progressView;
@property (nonatomic, strong) UIButton *buttonDeliverId;
@property (nonatomic, strong) UIButton *buttonTotalProducts;

@property (nonatomic, strong) NSDictionary *attributesTitle;
@property (nonatomic, assign) BOOL shouldShowProgress;
@property (nonatomic, strong) NSURL *imageUrl;

+ (CGFloat)heightForCellWidth:(CGFloat)width andDataDictionary:(NSDictionary *)dictionary;

@end
