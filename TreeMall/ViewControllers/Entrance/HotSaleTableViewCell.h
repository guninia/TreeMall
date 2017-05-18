//
//  HotSaleTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/28.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *HotSaleTableViewCellIdentifier = @"HotSaleTableViewCell";

@interface HotSaleTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) UIImageView *imageViewProduct;
@property (nonatomic, strong) UIImageView *imageViewTag;
@property (nonatomic, strong) UILabel *labelTag;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UILabel *labelPrice;
@property (nonatomic, strong) UIButton *buttonAddToCart;
@property (nonatomic, strong) UIButton *buttonFavorite;

@property (nonatomic, strong) NSURL *imageUrl;

@end
