//
//  ProductSubcategoryView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductSubcategoryView;

@protocol ProductSubcategoryViewDelegate <NSObject>

@optional
- (void)productSubcategoryView:(ProductSubcategoryView *)view didSelectShowAllBySender:(id)sender;
- (void)productSubcategoryView:(ProductSubcategoryView *)view didSelectSubcategory:(NSString *)categoryId atIndex:(NSInteger)index;

@end

@interface ProductSubcategoryView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <ProductSubcategoryViewDelegate> delegate;
@property (nonatomic, strong) UIButton *buttonShowAll;
@property (nonatomic, strong) UICollectionView *collectionViewSubcategory;
@property (nonatomic, strong) NSArray *dataArray;

@end
