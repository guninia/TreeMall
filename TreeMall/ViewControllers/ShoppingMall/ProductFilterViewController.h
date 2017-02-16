//
//  ProductFilterViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelRangeSliderView.h"

typedef enum : NSUInteger {
    DeliverTypeNoSpecific,
    DeliverTypeFast,
    DeliverTypeConvenienceStore,
    DeliverTypeTotal
} DeliverType;

@class ProductFilterViewController;

@protocol ProductFilterViewControllerDelegate <NSObject>

- (void)productFilterViewController:(ProductFilterViewController *)viewController didSelectAdvancedConditions:(NSDictionary *)conditions;

@end

@interface ProductFilterViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <ProductFilterViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *arrayCategoryDefault;
@property (nonatomic, strong) NSNumber *numberMinPriceDefault;
@property (nonatomic, strong) NSNumber *numberMaxPriceDefault;
@property (nonatomic, strong) NSNumber *numberMinPointDefault;
@property (nonatomic, strong) NSNumber *numberMaxPointDefault;
@property (nonatomic, strong) NSMutableArray *arrayCoupon;
@property (nonatomic, assign) DeliverType deliverType;
@property (nonatomic, strong) NSMutableArray *arrayDeliverType;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *labelCategory;
@property (nonatomic, strong) UILabel *labelPriceRange;
@property (nonatomic, strong) UILabel *labelPointRange;
@property (nonatomic, strong) UILabel *labelCoupon;
@property (nonatomic, strong) UILabel *labelDeliverType;
@property (nonatomic, strong) LabelRangeSliderView *sliderViewPrice;
@property (nonatomic, strong) LabelRangeSliderView *sliderViewPoint;
@property (nonatomic, strong) UIButton *buttonReset;
@property (nonatomic, strong) UIButton *buttonConfirm;
@property (nonatomic, assign) NSInteger selectIndexForCategory;
@property (nonatomic, assign) NSInteger selectIndexForCoupon;
@property (nonatomic, assign) NSInteger selectIndexForDeliverType;
@property (nonatomic, assign) NSRange selectedRangeForPrice;
@property (nonatomic, assign) NSRange selectedRangeForPoint;

@property (nonatomic, strong) UICollectionView *collectionViewCategory;
@property (nonatomic, strong) UICollectionView *collectionViewCoupon;
@property (nonatomic, strong) UICollectionView *collectionViewDeliverType;

@end
