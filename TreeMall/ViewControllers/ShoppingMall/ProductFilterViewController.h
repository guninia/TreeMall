//
//  ProductFilterViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

typedef enum : NSUInteger {
    DeliverTypeNoSpecific,
    DeliverTypeFast,
    DeliverTypeConvenienceStore,
    DeliverTypeTotal
} DeliverType;

@interface ProductFilterViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *arrayCategoryDefault;
@property (nonatomic, strong) NSNumber *numberMinPriceDefault;
@property (nonatomic, strong) NSNumber *numberMaxPriceDefault;
@property (nonatomic, strong) NSNumber *numberMinPointDefault;
@property (nonatomic, strong) NSNumber *numberMaxPointDefault;
@property (nonatomic, strong) NSMutableArray *arrayCoupon;
@property (nonatomic, assign) DeliverType deliverType;
@property (nonatomic, strong) NMRangeSlider *sliderPrice;
@property (nonatomic, strong) NMRangeSlider *sliderPoint;
@property (nonatomic, strong) UIButton *buttonReset;
@property (nonatomic, strong) UIButton *buttonConfirm;

@property (nonatomic, strong) UICollectionView *collectionViewCategory;
@property (nonatomic, strong) UICollectionView *collectionViewCoupon;
@property (nonatomic, strong) UICollectionView *collectionViewDeliverType;

@end
