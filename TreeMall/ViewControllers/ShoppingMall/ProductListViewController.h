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

@interface ProductListViewController : UIViewController <ProductSubcategoryViewDelegate, ProductListToolViewDelegate, UITableViewDataSource, UITableViewDelegate>

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
@property (nonatomic, assign) BOOL shouldShowLoadingFooter;
@property (nonatomic, assign) BOOL isLoading;

@end
