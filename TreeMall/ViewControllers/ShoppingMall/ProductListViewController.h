//
//  ProductListViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSubcategoryView.h"
#import "ProductListToolView.h"
#import "ProductListTitleView.h"
#import "ProductFilterViewController.h"
#import "SearchViewController.h"
#import "ProductTableViewCell.h"


typedef enum : NSUInteger {
    SortOptionPriceLowFirst,
    SortOptionPriceHighFirst,
    SortOptionPointLowFirst,
    SortOptionPointHighFirst,
    SortOptionOnShelfOrder,
    SortOptionTotal
} SortOption;

@interface ProductListViewController : UIViewController <ProductSubcategoryViewDelegate, ProductListToolViewDelegate, UITableViewDataSource, UITableViewDelegate, ProductListTitleViewDelegate, ProductFilterViewControllerDelegate, SearchViewControllerDelegate, ProductTableViewCellDelegate>

@property (nonatomic, strong) ProductListTitleView *viewTitle;
@property (nonatomic, strong) ProductSubcategoryView *viewSubcategory;
@property (nonatomic, strong) IBOutlet ProductListToolView *viewTool;
@property (nonatomic, strong) IBOutlet UITableView *tableViewProduct;
@property (nonatomic, strong) NSString *hallId;
@property (nonatomic, strong) NSNumber *layer;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *arrayCategory;
@property (nonatomic, strong) NSArray *arraySubcategory;
@property (nonatomic, strong) NSMutableArray *arrayProducts;
@property (nonatomic, strong) NSMutableDictionary *dictionarySubcategory;
@property (nonatomic, strong) NSMutableDictionary *dictionaryConditions;
@property (nonatomic, assign) NSInteger currentProductPage;
@property (nonatomic, assign) BOOL shouldShowSubCategory;
@property (nonatomic, assign) BOOL shouldShowLoadingFooter;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isSearchResult;
@property (nonatomic, strong) NSMutableArray *arraySortOption;
@property (nonatomic, assign) SortOption currentSortOption;

- (void)addKeywordToConditions:(NSString *)keyword;

@end
