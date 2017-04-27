//
//  AdditionalPurchaseViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionalProductCollectionViewCell.h"
#import "LabelButtonView.h"

@interface AdditionalPurchaseViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AdditionalProductCollectionViewCellDelegate, LabelButtonViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LabelButtonView *bottomBar;
@property (nonatomic, strong) NSArray *arrayProducts;
@property (nonatomic, strong) NSNumberFormatter *formatter;

@end
