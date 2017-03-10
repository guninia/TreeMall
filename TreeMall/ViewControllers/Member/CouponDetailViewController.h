//
//  CouponDetailViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/3.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponDetailDescriptionView.h"

@interface CouponDetailViewController : UIViewController <CouponDetailDescriptionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    CGFloat marginL;
    CGFloat marginR;
    CGFloat intervalV;
    CGFloat intervalH;
    NSInteger columnForCategory;
    NSInteger columnForProduct;
}

@property (nonatomic, strong) NSDictionary *dictionaryData;
@property (nonatomic, strong) CouponDetailDescriptionView *viewDescription;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arraySectionType;
@property (nonatomic, strong) NSString *stringDateStart;
@property (nonatomic, strong) NSString *stringDateGoodThru;
@property (nonatomic, strong) NSString *stringCouponValue;

@end
