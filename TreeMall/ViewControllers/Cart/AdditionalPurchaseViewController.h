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
#import "TMInfoManager.h"
#import "FullScreenLoadingView.h"
#import "DiscountViewController.h"
#import "FullScreenSelectNumberView.h"

@interface AdditionalPurchaseViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AdditionalProductCollectionViewCellDelegate, LabelButtonViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, DiscountViewControllerDelegate, FullScreenSelectNumberViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LabelButtonView *bottomBar;
@property (nonatomic, strong) NSArray *arrayProducts;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, assign) CartType currentType;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;
@property (nonatomic, strong) NSMutableDictionary *dictionaryTotal;
@property (nonatomic, strong) NSMutableDictionary *dictionaryAll;
@property (nonatomic, strong) NSMutableArray *arrayAllProducts;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) FullScreenSelectNumberView *viewQuantityInput;
@property (nonatomic, strong) NSMutableArray *arrayProductsFromCart;
@property (nonatomic, strong) NSString *marketingDescription;

@end
