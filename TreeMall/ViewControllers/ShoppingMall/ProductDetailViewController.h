//
//  ProductDetailViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailPromotionLabelView.h"
#import "ProductPriceLabel.h"

@interface ProductDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *dictionaryCommon;
@property (nonatomic, strong) NSDictionary *dictionaryDetail;

@property (nonatomic, strong) UICollectionView *collectionViewImage;
@property (nonatomic, strong) UIPageControl *pageControlImage;
@property (nonatomic, strong) UILabel *labelMarketing;
@property (nonatomic, strong) UILabel *labelProductName;
@property (nonatomic, strong) ProductDetailPromotionLabelView *viewPromotion;
@property (nonatomic, strong) ProductPriceLabel *labelOriginPrice;
@property (nonatomic, strong) ProductPriceLabel *labelPrice;

@end
