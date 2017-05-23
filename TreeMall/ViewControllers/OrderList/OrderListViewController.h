//
//  OrderListViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownListButton.h"
#import "SemiCircleEndsSegmentedView.h"
#import "ProductDetailSectionTitleView.h"
#import "TMInfoManager.h"
#import "OrderHeaderReusableView.h"
#import "OrderListCollectionViewCell.h"

typedef enum : NSUInteger {
    OrderTimeStart,
    OrderTimeNoSpecific = OrderTimeStart,
    OrderTimeLatestMonth,
    OrderTimeLatestHalfYear,
    OrderTimeLatestYear,
    OrderTimeTotal
} OrderTime;

typedef enum : NSUInteger {
    DeliverTypeStart,
    DeliverTypeNoSpecific = DeliverTypeStart,
    DeliverTypeCommon,
    DeliverTypeFastDelivery,
    DeliverTypeStorePickUp,
    DeliverTypeTotal
} DeliverType;

@interface OrderListViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SemiCircleEndsSegmentedViewDelegate, OrderHeaderReusableViewDelegate, OrderListCollectionViewCellDelegate>

@property (nonatomic, strong) SemiCircleEndsSegmentedView *segmentedView;
@property (nonatomic, strong) UIView *viewSearchBackground;
@property (nonatomic, strong) UITextField *textFieldProductName;
@property (nonatomic, strong) UIView *viewButtonBackground;
@property (nonatomic, strong) DropdownListButton *buttonOrderTime;
@property (nonatomic, strong) DropdownListButton *buttonShipType;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) ProductDetailSectionTitleView *viewTitle;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *arrayOrderTimeOptions;
@property (nonatomic, strong) NSMutableArray *arrayDeliverTypes;
@property (nonatomic, assign) OrderTime orderTime;
@property (nonatomic, assign) DeliverType deliverType;
@property (nonatomic, assign) OrderState orderState;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger totalOrder;
@property (nonatomic, assign) BOOL shouldShowLoadingView;
@property (nonatomic, strong) NSMutableArray *arrayCarts;


@end
