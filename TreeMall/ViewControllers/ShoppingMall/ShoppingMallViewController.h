//
//  ShoppingMallViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface ShoppingMallViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, SearchViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionViewCategory;
@property (nonatomic, strong) IBOutlet UITableView *tableViewSubcategory;
@property (nonatomic, strong) IBOutlet UITableView *tableViewExtraSubcategory;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewLeftArrow;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewRightArrow;

@property (nonatomic, strong) NSMutableArray *arrayMainCategory;
@property (nonatomic, assign) NSInteger selectedMainCategoryIndex;
@property (nonatomic, strong) NSMutableArray *arraySubcategory;
@property (nonatomic, assign) NSInteger selectedSubcategoryIndex;
@property (nonatomic, strong) NSMutableArray *arrayExtraSubcategory;
@property (nonatomic, strong) NSMutableArray *arrayExtraSubcategorySeeAll;

- (void)presentProductListViewForIdentifier:(NSString *)identifier named:(NSString *)name andLayer:(NSNumber *)layer;

@end
