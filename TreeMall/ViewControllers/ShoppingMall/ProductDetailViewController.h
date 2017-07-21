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
#import <DTCoreText.h>

@interface ProductDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProductDetailBottomBarDelegate, BorderedDoubleViewDelegate, DTAttributedTextContentViewDelegate, UIPopoverPresentationControllerDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSDictionary *dictionaryCommon;
@property (nonatomic, strong) NSDictionary *dictionaryDetail;
@property (nonatomic, strong) NSArray *arrayImagePath;
@property (nonatomic, strong) NSNumber *productIdentifier;
@property (nonatomic, assign) NSInteger specIndex;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *labelFastDelivery;
@property (nonatomic, strong) UILabel *labelDiscount;
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
@property (nonatomic, strong) DTAttributedLabel *labelAdText;
@property (nonatomic, strong) UIWebView *webViewAdText;
@property (nonatomic, strong) ProductDetailSectionTitleView *viewIntroTitle;
@property (nonatomic, strong) DTAttributedLabel *labelIntro;
@property (nonatomic, strong) UIWebView *webViewIntro;
@property (nonatomic, strong) ProductDetailSectionTitleView *viewSpecTitle;
@property (nonatomic, strong) DTAttributedLabel *labelSpec;
@property (nonatomic, strong) UIWebView *webViewSpec;
@property (nonatomic, strong) ProductDetailSectionTitleView *viewRemarkTitle;
@property (nonatomic, strong) DTAttributedLabel *labelRemark;
@property (nonatomic, strong) UIWebView *webViewRemark;
@property (nonatomic, strong) ProductDetailSectionTitleView *viewShippingAndWarrentyTitle;
@property (nonatomic, strong) DTAttributedLabel *labelShippingAndWarrenty;
@property (nonatomic, strong) UIWebView *webViewShippingAndWarrenty;
@property (nonatomic, assign) CGSize sizeTextViewSpec;
@property (nonatomic, strong) ProductDetailBottomBar *bottomBar;
@property (nonatomic, strong) NSMutableArray *arrayViewNotice;
@property (nonatomic, strong) NSMutableArray *arrayCartType;
@property (nonatomic, strong) NSMutableArray *arrayIntroImageView;
@property (nonatomic, strong) NSMutableArray *arraySpecImageView;

@end
