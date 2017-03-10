//
//  ProductDetailBottomBar.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/20.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailBottomBar;

@protocol ProductDetailBottomBarDelegate <NSObject>

- (void)productDetailBottomBar:(ProductDetailBottomBar *)bar didSelectFavoriteBySender:(id)sender;
- (void)productDetailBottomBar:(ProductDetailBottomBar *)bar didSelectAddToCartBySender:(id)sender;
- (void)productDetailBottomBar:(ProductDetailBottomBar *)bar didSelectPurchaseBySender:(id)sender;

@end

@interface ProductDetailBottomBar : UIView

@property (nonatomic, weak) id <ProductDetailBottomBarDelegate> delegate;
@property (nonatomic, strong) UIButton *buttonFavorite;
@property (nonatomic, strong) UIButton *buttonAddToCart;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIButton *buttonPurchase;
@property (nonatomic, strong) UILabel *labelInvalid;
@property (nonatomic, strong) NSArray *arrayButtonSettings;
@property (nonatomic, strong) UIColor *backgorundColorValid;
@property (nonatomic, strong) UIColor *backgroundColorInvalid;

@end
