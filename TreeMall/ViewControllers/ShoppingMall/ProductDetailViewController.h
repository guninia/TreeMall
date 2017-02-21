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
#import "ProductDetailBottomBar.h"
#import "BorderedDoubleLabelView.h"
#import "ImageTitleButton.h"
#import "ImageTextView.h"
#import "ProductDetailSectionTitleView.h"

@interface ProductDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProductDetailBottomBarDelegate, BorderedDoubleViewDelegate>

@property (nonatomic, strong) NSDictionary *dictionaryCommon;
@property (nonatomic, strong) NSDictionary *dictionaryDetail;
@property (nonatomic, strong) NSArray *arrayImage;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionViewImage;
@property (nonatomic, strong) UIPageControl *pageControlImage;
@property (nonatomic, strong) UILabel *labelMarketing;
@property (nonatomic, strong) UILabel *labelProductName;
@property (nonatomic, strong) ProductDetailPromotionLabelView *viewPromotion;
@property (nonatomic, strong) ProductPriceLabel *labelOriginPrice;
@property (nonatomic, strong) ProductPriceLabel *labelPrice;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) BorderedDoubleLabelView *viewPoint;
@property (nonatomic, strong) BorderedDoubleLabelView *viewPointCash;
@property (nonatomic, strong) BorderedDoubleLabelView *viewPointFeedback;
@property (nonatomic, strong) ImageTitleButton *buttonExchangeDesc;
@property (nonatomic, strong) ImageTitleButton *buttonInstallmentCal;
@property (nonatomic, strong) BorderedDoubleLabelView *viewChooseSpec;
@property (nonatomic, strong) ImageTextView *viewNotice;
@property (nonatomic, strong) ProductDetailSectionTitleView *viewSpecTitle;
@property (nonatomic, strong) ProductDetailBottomBar *bottomBar;

@end
