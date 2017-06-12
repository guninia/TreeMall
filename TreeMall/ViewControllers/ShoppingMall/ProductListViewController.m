//
//  ProductListViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductListViewController.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "TMInfoManager.h"
#import "LoadingFooterView.h"
#import "LocalizedString.h"
#import "UIViewController+FTPopMenu.h"
#import "ProductDetailViewController.h"
#import "Utility.h"
#import "CartViewController.h"

@interface ProductListViewController ()

- (void)retrieveSubcategoryDataForIdentifier:(NSString *)identifier andLayer:(NSNumber *)layer;
- (BOOL)processSubcategoryData:(id)data forLayerIndex:(NSInteger)layerIndex;
- (void)retrieveProductsForConditions:(NSDictionary *)conditions byRefreshing:(BOOL)refresh;
- (BOOL)processProductsData:(id)data byRefreshing:(BOOL)refresh;
- (void)prepareSortOption;
- (void)refreshAllContentForHallId:(NSString *)hallId andLayer:(NSNumber *)layer withName:(NSString *)name;
- (void)showCartTypeSheetForProduct:(NSDictionary *)product;
- (void)addProduct:(NSDictionary *)product toCart:(CartType)cartType shouldShowAlert:(BOOL)shouldShowAlert;
- (NSArray *)cartArrayForProduct:(NSDictionary *)product;
- (BOOL)canDirectlyPurchaseProduct:(NSDictionary *)product;
- (void)presentCartViewForType:(CartType)type;
- (void)buttonItemSearchPressed:(id)sender;

@end

@implementation ProductListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _arrayCategory = nil;
        _arraySubcategory = nil;
        _arrayProducts = [[NSMutableArray alloc] initWithCapacity:0];
        _dictionarySubcategory = [[NSMutableDictionary alloc] initWithCapacity:0];
        _dictionaryConditions = [[NSMutableDictionary alloc] initWithCapacity:0];
        _currentProductPage = 0;
        _shouldShowLoadingFooter = YES;
        _isLoading = NO;
        _isSearchResult = NO;
        _arraySortOption = [[NSMutableArray alloc] initWithCapacity:0];
        _currentSortOption = SortOptionTotal;
        _shouldShowSubCategory = YES;
        [self prepareSortOption];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"ProductListViewController - hallId[%@] layer[%li] name[%@]", _hallId, (long)[_layer integerValue], _name);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    // Build and add subviews
    self.navigationItem.titleView = self.viewTitle;
    UIImage *image = [UIImage imageNamed:@"sho_btn_mag"];
    if (image)
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemSearchPressed:)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    [self.view addSubview:self.viewSubcategory];
    [self.view addSubview:self.tableViewProduct];
    self.viewTool.delegate = self;
    self.viewTitle.delegate = self;
    
    [self refreshAllContentForHallId:self.hallId andLayer:self.layer withName:self.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Override

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.shouldShowSubCategory && self.viewSubcategory)
    {
        CGRect frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.viewTool.frame.origin.y);
        NSLog(@"frame[%4.2f,%4.2f,%4.2f,%4.2f]", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.viewSubcategory.frame = frame;
        [self.viewSubcategory setNeedsLayout];
    }
    else
    {
        CGRect frame = self.viewTool.frame;
        frame.origin.y = 0.0;
        self.viewTool.frame = frame;
    }
    if (self.tableViewProduct)
    {
        CGFloat originY = self.viewTool.frame.origin.y + self.viewTool.frame.size.height;
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        self.tableViewProduct.frame = frame;
        
        if (self.labelNoContent)
        {
            CGRect frame = CGRectMake(0.0, self.tableViewProduct.frame.size.height * 2 / 3, self.tableViewProduct.frame.size.width, 30.0);
            self.labelNoContent.frame = frame;
        }
    }
}

- (ProductListTitleView *)viewTitle
{
    if (_viewTitle == nil)
    {
        CGSize screenRatio = [Utility sizeRatioAccordingTo320x480];
        _viewTitle = [[ProductListTitleView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0 * screenRatio.width, 40.0)];
        [_viewTitle setBackgroundColor:[UIColor clearColor]];
    }
    return _viewTitle;
}

- (ProductSubcategoryView *)viewSubcategory
{
    if (_viewSubcategory == nil)
    {
        _viewSubcategory = [[ProductSubcategoryView alloc] initWithFrame:CGRectZero];
        _viewSubcategory.delegate = self;
    }
    return _viewSubcategory;
}

- (UITableView *)tableViewProduct
{
    if (_tableViewProduct == nil)
    {
        _tableViewProduct = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableViewProduct setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1.0]];
        [_tableViewProduct setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableViewProduct setShowsVerticalScrollIndicator:NO];
        [_tableViewProduct setShowsHorizontalScrollIndicator:NO];
        [_tableViewProduct setDataSource:self];
        [_tableViewProduct setDelegate:self];
        [_tableViewProduct registerClass:[ProductTableViewCell class] forCellReuseIdentifier:ProductTableViewCellIdentifier];
        [_tableViewProduct registerClass:[LoadingFooterView class] forHeaderFooterViewReuseIdentifier:LoadingFooterViewIdentifier];
    }
    return _tableViewProduct;
}

- (UIImageView *)tableBackgroundView
{
    if (_tableBackgroundView == nil)
    {
        _tableBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_tableBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1.0]];
        [_tableBackgroundView setContentMode:UIViewContentModeCenter];
        UIImage *image = [UIImage imageNamed:@"men_ico_logo"];
        if (image)
        {
            [_tableBackgroundView setImage:image];
        }
        [_tableBackgroundView addSubview:self.labelNoContent];
    }
    return _tableBackgroundView;
}

- (UILabel *)labelNoContent
{
    if (_labelNoContent == nil)
    {
        _labelNoContent = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelNoContent setBackgroundColor:[UIColor clearColor]];
        [_labelNoContent setTextColor:[UIColor colorWithWhite:0.82 alpha:1.0]];
        [_labelNoContent setText:[LocalizedString NoMatchProduct]];
        [_labelNoContent setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelNoContent;
}

#pragma mark - Private Methods

- (void)retrieveSubcategoryDataForIdentifier:(NSString *)identifier andLayer:(NSNumber *)layer
{
    NSArray *categories = [[TMInfoManager sharedManager] subcategoriesForIdentifier:identifier atLayer:layer];
    if (categories)
    {
        self.arraySubcategory = categories;
        _viewSubcategory.dataArray = _arraySubcategory;
        return;
    }
    if (identifier == nil || layer == nil)
        return;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:identifier, SymphoxAPIParam_hall_id, layer, SymphoxAPIParam_layer, nil];
    
    __weak ProductListViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_Subcategories];
//    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
            //            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
//                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"retrieveSubcategoryDataForIdentifier - string[%@]", string);
                NSInteger layerIndex = [layer integerValue];
                if ([self processSubcategoryData:data forLayerIndex:layerIndex])
                {
                    // Should go next step.
                    _viewSubcategory.dataArray = _arraySubcategory;
                    
                    [[TMInfoManager sharedManager] setSubcategories:_arraySubcategory forIdentifier:identifier atLayer:layer];
                }
                else
                {
                    NSLog(@"retrieveSubcategoryDataForIdentifier - Cannot process data.");
                }
            }
            else
            {
                NSLog(@"retrieveSubcategoryDataForIdentifier - Unexpected data format.");
            }
        }
        else
        {
            NSLog(@"retrieveSubcategoryDataForIdentifier - error:\n%@", [error description]);
        }
    }];
}

- (BOOL)processSubcategoryData:(id)data forLayerIndex:(NSInteger)layerIndex
{
    BOOL success = NO;
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error == nil)
    {
        //        NSLog(@"jsonObject[%@]:\n%@", [[jsonObject class] description], [jsonObject description]);
        if ([jsonObject isKindOfClass:[NSArray class]])
        {
            NSArray *categories = (NSArray *)jsonObject;
            // Normal status.
            self.arraySubcategory = categories;
            success = YES;
        }
    }
    else
    {
        NSLog(@"processData - error:\n%@", error);
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"processData - result:\n%@", resultString);
    }
    
    return success;
}

- (void)retrieveProductsForConditions:(NSDictionary *)conditions byRefreshing:(BOOL)refresh
{
    //    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:identifier, SymphoxAPIParam_hall_id, layer, SymphoxAPIParam_layer, nil];
    if (self.isLoading)
    {
        return;
    }
    if (refresh)
    {
        [self.arrayProducts removeAllObjects];
        self.shouldShowLoadingFooter = YES;
        [self.tableViewProduct setBackgroundView:nil];
        [self.tableViewProduct reloadData];
    }
    self.isLoading = YES;
    __weak ProductListViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_Search];
//    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSLog(@"retrieveProductsForConditions - conditions:\n%@", [conditions description]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:conditions inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"retrieveProductsForConditions:\n%@", string);
                if ([weakSelf processProductsData:data byRefreshing:refresh] == NO)
                {
                    weakSelf.tableViewProduct.backgroundView = self.tableBackgroundView;
                    weakSelf.shouldShowLoadingFooter = NO;
                    NSLog(@"retrieveProductsForConditions - Cannot process data");
                }
            }
            else
            {
                weakSelf.tableViewProduct.backgroundView = self.tableBackgroundView;
                NSLog(@"retrieveProductsForConditions - Unexpected data format.");
                weakSelf.shouldShowLoadingFooter = NO;
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString NoMatchingProduct];
            NSDictionary *userInfo = error.userInfo;
            BOOL errorProductNotFound = NO;
            if (userInfo)
            {
                NSString *errorId = [userInfo objectForKey:SymphoxAPIParam_id];
                if ([errorId compare:SymphoxAPIError_E301 options:NSCaseInsensitiveSearch] == NSOrderedSame)
                {
                    errorProductNotFound = YES;
                }
                if (errorProductNotFound)
                {
                    NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                    if (serverMessage)
                    {
                        errorMessage = serverMessage;
                    }
                }
            }
            NSLog(@"retrieveProductsForConditions - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
//            if (errorProductNotFound == NO)
//            {
//                UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:[LocalizedString Reload] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                    [weakSelf retrieveProductsForConditions:conditions byRefreshing:refresh];
//                }];
//                [alertController addAction:reloadAction];
//            }
            [weakSelf presentViewController:alertController animated:YES completion:nil];
            weakSelf.tableViewProduct.backgroundView = self.tableBackgroundView;
            weakSelf.shouldShowLoadingFooter = NO;
        }
        [self.tableViewProduct reloadData];
        weakSelf.isLoading = NO;
    }];
}

- (BOOL)processProductsData:(id)data byRefreshing:(BOOL)refresh
{
    BOOL success = NO;
    
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && jsonObject)
    {
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            if (refresh)
            {
                [self.arrayProducts removeAllObjects];
            }
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            NSNumber *pageNumber = [dictionary objectForKey:SymphoxAPIParam_page];
            if (pageNumber)
            {
                _currentProductPage = [pageNumber integerValue];
            }
            NSDictionary *result = [dictionary objectForKey:SymphoxAPIParam_result];
            if (result && [result count] > 0)
            {
                NSArray *products = [result objectForKey:SymphoxAPIParam_productDetailList];
                if (products)
                {
                    [self.arrayProducts addObjectsFromArray:products];
                }
                NSNumber *totalSizeNumber = [result objectForKey:SymphoxAPIParam_total_size];
                if (totalSizeNumber && [totalSizeNumber integerValue] <= [self.arrayProducts count])
                {
                    self.shouldShowLoadingFooter = NO;
                }
                
                self.tableViewProduct.backgroundView = nil;
            }
            else
            {
                self.tableViewProduct.backgroundView = self.tableBackgroundView;
            }
            
            if ([[TMInfoManager sharedManager].dictionaryInitialFilter count] == 0)
            {
                NSNumber *numberMinPrice = [result objectForKey:SymphoxAPIParam_min_price];
                if (numberMinPrice != nil && ([numberMinPrice isEqual:[NSNull null]] == NO))
                {
                    NSLog(@"numberMinPrice[%f]", [numberMinPrice floatValue]);
                    [[TMInfoManager sharedManager].dictionaryInitialFilter setObject:numberMinPrice forKey:SymphoxAPIParam_min_price];
                }
                NSNumber *numberMaxPrice = [result objectForKey:SymphoxAPIParam_max_price];
                if (numberMaxPrice != nil && ([numberMaxPrice isEqual:[NSNull null]] == NO))
                {
                    [[TMInfoManager sharedManager].dictionaryInitialFilter setObject:numberMaxPrice forKey:SymphoxAPIParam_max_price];
                }
                NSNumber *numberMinPoint = [result objectForKey:SymphoxAPIParam_min_point];
                if (numberMinPoint != nil && ([numberMinPoint isEqual:[NSNull null]] == NO))
                {
//                    NSLog(@"numberMinPoint[%f]", [numberMinPoint floatValue]);
                    [[TMInfoManager sharedManager].dictionaryInitialFilter setObject:numberMinPoint forKey:SymphoxAPIParam_min_point];
                }
                NSNumber *numberMaxPoint = [result objectForKey:SymphoxAPIParam_max_point];
                if (numberMaxPoint != nil && ([numberMaxPoint isEqual:[NSNull null]] == NO))
                {
                    [[TMInfoManager sharedManager].dictionaryInitialFilter setObject:numberMaxPoint forKey:SymphoxAPIParam_max_point];
                }
                
                NSArray *categories = [dictionary objectForKey:SymphoxAPIParam_categoryLv1];
                if (categories != nil && ([categories isEqual:[NSNull null]] == NO))
                {
                    [[TMInfoManager sharedManager].dictionaryInitialFilter setObject:categories forKey:SymphoxAPIParam_categoryLv1];
                }
                
            }
            success = YES;
        }
        else
        {
            NSLog(@"retrieveProductsForConditions - Unexpected Json format.");
        }
    }
    else
    {
        NSLog(@"retrieveProductsForConditions - Unexpected Json format.");
    }
    
    return success;
}

- (void)prepareSortOption
{
    for (NSInteger index = 0; index < SortOptionTotal; index++)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSString *name = nil;
        NSInteger sortIndex = NSNotFound;
        switch (index) {
            case SortOptionPriceLowFirst:
            {
                name = [LocalizedString LowPriceFirst];
                sortIndex = 1;
            }
                break;
            case SortOptionPriceHighFirst:
            {
                name = [LocalizedString HighPriceFirst];
                sortIndex = 4;
            }
                break;
            case SortOptionPointLowFirst:
            {
                name = [LocalizedString LowPointFirst];
                sortIndex = 2;
            }
                break;
            case SortOptionPointHighFirst:
            {
                name = [LocalizedString HighPointFirst];
                sortIndex = 5;
            }
                break;
            case SortOptionOnShelfOrder:
            {
                name = [LocalizedString OnShelfOrder];
                sortIndex = 3;
            }
                break;
            default:
                break;
        }
        if (sortIndex != NSNotFound)
        {
            NSString *sortId = [NSString stringWithFormat:@"%li", (long)sortIndex];
            [dictionary setObject:sortId forKey:SymphoxAPIParam_sort_type];
        }
        if (name != nil)
        {
            [dictionary setObject:name forKey:SymphoxAPIParam_name];
        }
        [_arraySortOption addObject:dictionary];
    }
}

- (void)refreshAllContentForHallId:(NSString *)hallId andLayer:(NSNumber *)layer withName:(NSString *)name
{
    if (hallId == nil)
    {
        if (self.hallId != nil)
        {
            hallId = self.hallId;
        }
        if (self.layer != nil)
        {
            layer = self.layer;
        }
    }
    else
    {
        self.hallId = hallId;
        self.layer = layer;
    }
    self.name = name;
    self.currentProductPage = 0;
    self.arraySubcategory = nil;
    
    // Set view title
    if (_isSearchResult)
    {
        self.viewTitle.titleText = [LocalizedString SearchResult];
    }
    else if (self.name != nil)
    {
        self.viewTitle.titleText = self.name;
    }
    else
    {
        self.viewTitle.titleText = @"";
    }
    if ([self.arrayCategory count] > 1)
    {
        [self.viewTitle.buttonArrowDown setHidden:NO];
    }
    else
    {
        [self.viewTitle.buttonArrowDown setHidden:YES];
    }
    
    // Deal with ProductSubcategoryView and layer
    if ([_layer integerValue] >= 4 || _isSearchResult)
    {
        _shouldShowSubCategory = NO;
    }
    if (_shouldShowSubCategory)
    {
        if (_arraySubcategory == nil || [_arraySubcategory count] == 0)
        {
            // Should load subcategories from server
            [self retrieveSubcategoryDataForIdentifier:self.hallId andLayer:self.layer];
        }
        else
        {
            self.viewSubcategory.dataArray = _arraySubcategory;
        }
    }
    else
    {
        [self.viewSubcategory setHidden:YES];
    }
    
    // Prepare to retrieve product list.
    if (self.hallId && self.layer)
    {
        NSString *layerKey = nil;
        switch ([self.layer integerValue]) {
            case 1:
            {
                layerKey = SymphoxAPIParam_cpse_id;
            }
                break;
            case 2:
            {
                layerKey = SymphoxAPIParam_cpnhl_id;
            }
                break;
            case 3:
            {
                layerKey = SymphoxAPIParam_cpte_id;
            }
                break;
            case 4:
            {
                layerKey = SymphoxAPIParam_cptm_id;
            }
                break;
            default:
                break;
        }
        [_dictionaryConditions setObject:self.hallId forKey:layerKey];
    }
    if (_currentProductPage == 0)
    {
        _currentProductPage = 1;
        [_dictionaryConditions setObject:[NSNumber numberWithInteger:_currentProductPage] forKey:SymphoxAPIParam_page];
        if (_currentSortOption == SortOptionTotal)
        {
            _currentSortOption = SortOptionPriceLowFirst;
            NSDictionary *sortContent = [_arraySortOption objectAtIndex:_currentSortOption];
            NSString *sortType = [sortContent objectForKey:SymphoxAPIParam_sort_type];
            if (sortType)
            {
                [_dictionaryConditions setObject:sortType forKey:SymphoxAPIParam_sort_type];
            }
            NSString *name = [sortContent objectForKey:SymphoxAPIParam_name];
            if (name)
            {
                [self.viewTool.buttonSort setTitle:name forState:UIControlStateNormal];
            }
        }
    }
    if ([_dictionaryConditions count] > 0)
    {
        [self retrieveProductsForConditions:_dictionaryConditions byRefreshing:YES];
    }
}

- (void)showCartTypeSheetForProduct:(NSDictionary *)product
{
    BOOL canDirectlyPurchase = [self canDirectlyPurchaseProduct:product];
    NSArray *arrayCartType = [self cartArrayForProduct:product];
    
    __weak ProductListViewController *weakSelf = self;
    if ([arrayCartType count] > 1)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString AddToCart] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSDictionary *dictionary in arrayCartType)
        {
            NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
            NSNumber *cartType = [dictionary objectForKey:SymphoxAPIParam_cart_type];
            UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [weakSelf addProduct:product toCart:[cartType integerValue] shouldShowAlert:YES];
            }];
            [alertController addAction:action];
        }
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([arrayCartType count] > 0)
    {
        NSDictionary *dictionary = [arrayCartType objectAtIndex:0];
        NSNumber *numberCartType = [dictionary objectForKey:SymphoxAPIParam_cart_type];
        [self addProduct:product toCart:[numberCartType integerValue] shouldShowAlert:YES];
    }
    else if (canDirectlyPurchase)
    {
        [[TMInfoManager sharedManager] resetCartForType:CartTypeDirectlyPurchase];
        [self addProduct:product toCart:CartTypeDirectlyPurchase shouldShowAlert:NO];
        [self presentCartViewForType:CartTypeDirectlyPurchase];
    }
}

- (void)addProduct:(NSDictionary *)product toCart:(CartType)cartType shouldShowAlert:(BOOL)shouldShowAlert
{
    [[TMInfoManager sharedManager] addProduct:product toCartForType:cartType];
    if (shouldShowAlert)
    {
        NSString *message = [NSString stringWithFormat:[LocalizedString AddedTo_S_], @""];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (NSArray *)cartArrayForProduct:(NSDictionary *)product
{
    NSMutableArray *arrayCartType = [NSMutableArray array];
    
    NSNumber *normal_cart = [product objectForKey:SymphoxAPIParam_normal_cart];
    if (normal_cart && [normal_cart isEqual:[NSNull null]] == NO && [normal_cart boolValue] == YES)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[NSNumber numberWithInteger:CartTypeCommonDelivery] forKey:SymphoxAPIParam_cart_type];
        [dictionary setObject:[LocalizedString CommonDelivery] forKey:SymphoxAPIParam_name];
        [arrayCartType addObject:dictionary];
    }
    NSNumber *to_store_cart = [product objectForKey:SymphoxAPIParam_to_store_cart];
    if (to_store_cart && [to_store_cart isEqual:[NSNull null]] == NO && [to_store_cart boolValue] == YES)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[NSNumber numberWithInteger:CartTypeStorePickup] forKey:SymphoxAPIParam_cart_type];
        [dictionary setObject:[LocalizedString StorePickUp] forKey:SymphoxAPIParam_name];
        [arrayCartType addObject:dictionary];
    }
    NSNumber *fast_delivery_cart = [product objectForKey:SymphoxAPIParam_fast_delivery_cart];
    if (fast_delivery_cart && [fast_delivery_cart isEqual:[NSNull null]] == NO && [fast_delivery_cart boolValue] == YES)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[NSNumber numberWithInteger:CartTypeFastDelivery] forKey:SymphoxAPIParam_cart_type];
        [dictionary setObject:[LocalizedString FastDelivery] forKey:SymphoxAPIParam_name];
        [arrayCartType addObject:dictionary];
    }
    return arrayCartType;
}

- (BOOL)canDirectlyPurchaseProduct:(NSDictionary *)product
{
    BOOL canPurchaseDirectly = NO;
    NSNumber *single_shopping_cart = [product objectForKey:SymphoxAPIParam_single_shopping_cart];
    if (single_shopping_cart && [single_shopping_cart isEqual:[NSNull null]] == NO)
    {
        canPurchaseDirectly = [single_shopping_cart boolValue];
    }
    return canPurchaseDirectly;
}

- (void)presentCartViewForType:(CartType)type
{
    CartViewController *viewController = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:[NSBundle mainBundle]];
    viewController.title = [LocalizedString ShoppingCart];
    viewController.currentType = type;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Public Methods

- (void)addKeywordToConditions:(NSString *)keyword
{
    if (keyword == nil || [keyword length] == 0)
        return;
    [self.dictionaryConditions setObject:keyword forKey:SymphoxAPIParam_keywords];
}

#pragma mark - Actions

- (void)buttonItemSearchPressed:(id)sender
{
    SearchViewController *viewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
        {
            numberOfRows = [_arrayProducts count];
        }
            break;
        default:
            break;
    }
    
//    NSLog(@"numberOfRows[%li]", (long)numberOfRows);
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductTableViewCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.tag = indexPath.row;
    if (cell.delegate == nil)
    {
        cell.delegate = self;
    }
    cell.price = nil;
    cell.point = nil;
    cell.priceType = PriceTypeTotal;
//    NSLog(@"cellForRowAtIndexPath[%li][%li]", (long)indexPath.section, (long)indexPath.row);
    if (indexPath.row < [_arrayProducts count])
    {
        NSDictionary *dictionary = [_arrayProducts objectAtIndex:indexPath.row];
        
        NSString *imagePath = [dictionary objectForKey:SymphoxAPIParam_prod_pic_url];
        cell.imagePath = imagePath;
        
        NSMutableArray *arrayTags = [NSMutableArray array];
        NSNumber *is_delivery_store = [dictionary objectForKey:SymphoxAPIParam_is_delivery_store];
        if (is_delivery_store && [is_delivery_store isEqual:[NSNull null]] == NO && [is_delivery_store boolValue])
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"超取", ProductTableViewCellTagText, [UIColor colorWithRed:(152.0/255.0) green:(194.0/255.0) blue:(67.0/255.0) alpha:1.0], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        NSNumber *quick = [dictionary objectForKey:SymphoxAPIParam_quick];
        if (quick && ([quick isEqual:[NSNull null]] == NO) && [quick boolValue])
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"8H", ProductTableViewCellTagText, [UIColor colorWithRed:(152.0/255.0) green:(194.0/255.0) blue:(67.0/255.0) alpha:1.0], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        
        NSNumber *discountNow = [dictionary objectForKey:SymphoxAPIParam_chk_tactic_click];
        if (discountNow && ([discountNow isEqual:[NSNull null]] == NO) && [discountNow boolValue])
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[LocalizedString ClickToDiscount], ProductTableViewCellTagText, [UIColor colorWithRed:(134.0/255.0) green:(209.0/255.0) blue:(188.0/255.0) alpha:1.0], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        NSArray *installments = [dictionary objectForKey:SymphoxAPIParam_seekInstallmentList];
        if (installments && ([installments isEqual:[NSNull null]] == NO) && [installments count] > 0)
        {
            NSDictionary *longestPeriodInstallment = [installments lastObject];
            NSNumber *installmentNumber = [longestPeriodInstallment objectForKey:SymphoxAPIParam_installment_num];
            if (installmentNumber && [installmentNumber integerValue] > 0)
            {
                NSString *numberString = [NSString stringWithFormat:[LocalizedString S_InstallmentNumber], (long)[installmentNumber integerValue]];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:numberString, ProductTableViewCellTagText, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
                [arrayTags addObject:dictionary];
            }
        }
        NSNumber *freePoint = [dictionary objectForKey:SymphoxAPIParam_freepoint];
        if (freePoint && ([freePoint isEqual:[NSNull null]] == NO) && [freePoint integerValue] > 0)
        {
            NSString *freePointString = [NSString stringWithFormat:[LocalizedString Free_S_Point], (long)[freePoint integerValue]];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:freePointString, ProductTableViewCellTagText, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        cell.arrayTagsData = arrayTags;
        
        NSString *marketText = [dictionary objectForKey:SymphoxAPIParam_market_name];
        cell.marketingText = marketText;
        
        NSString *productName = [dictionary objectForKey:SymphoxAPIParam_cpdt_name];
        cell.productName = productName;
        
        NSNumber *price = [dictionary objectForKey:SymphoxAPIParam_price03];
        NSNumber *point = [dictionary objectForKey:SymphoxAPIParam_point01];
        NSNumber *price1 = [dictionary objectForKey:SymphoxAPIParam_price02];
        NSNumber *point1 = [dictionary objectForKey:SymphoxAPIParam_point02];
        BOOL hasPurePrice = (price && [price isEqual:[NSNull null]] == NO && [price unsignedIntegerValue] > 0);
        BOOL hasPurePoint = (point && [point isEqual:[NSNull null]] == NO && [point unsignedIntegerValue] > 0);
        if (hasPurePrice && hasPurePoint)
        {
            cell.price = price;
            cell.point = point;
            cell.priceType = PriceTypeBothPure;
        }
        else if (hasPurePrice)
        {
            cell.price = price;
            cell.priceType = PriceTypePurePrice;
        }
        else if (hasPurePoint)
        {
            cell.point = point;
            cell.priceType = PriceTypePurePoint;
        }
        else
        {
            if (price1 && [price1 isEqual:[NSNull null]] == NO)
            {
                cell.price = price1;
            }
            if (point1 && [point1 isEqual:[NSNull null]] == NO)
            {
                cell.point = point1;
            }
            cell.priceType = PriceTypeMixed;
        }
        
        NSNumber *discount = [dictionary objectForKey:SymphoxAPIParam_discount_hall_percentage];
        cell.discount = discount;
        
        NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO)
        {
            BOOL isFavorite = [[TMInfoManager sharedManager] favoriteContainsProductWithIdentifier:cpdt_num];
            cell.favorite = isFavorite;
        }
        
        BOOL canPurchaseDirectly = [self canDirectlyPurchaseProduct:dictionary];
        
        NSArray *arrayCarts = [self cartArrayForProduct:dictionary];
        if (([arrayCarts count] > 0) || canPurchaseDirectly)
        {
            cell.buttonCart.hidden = NO;
        }
        else
        {
            cell.buttonCart.hidden = YES;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LoadingFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LoadingFooterViewIdentifier];
    footerView.viewBackground.backgroundColor = self.tableBackgroundView.backgroundColor;
    return footerView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 168.0;
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForFooter = 0.0;
    switch (section) {
        case 1:
        {
            if (_shouldShowLoadingFooter)
            {
                heightForFooter = 50.0;
            }
        }
            break;
            
        default:
            break;
    }
    return heightForFooter;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[LoadingFooterView class]])
    {
        LoadingFooterView *loadingView = (LoadingFooterView *)view;
        [loadingView.activityIndicator startAnimating];
    }
    [self.dictionaryConditions setObject:[NSNumber numberWithInteger:(self.currentProductPage + 1)] forKey:SymphoxAPIParam_page];
    [self retrieveProductsForConditions:self.dictionaryConditions byRefreshing:NO];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[LoadingFooterView class]])
    {
        LoadingFooterView *loadingView = (LoadingFooterView *)view;
        [loadingView.activityIndicator stopAnimating];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
    [viewController setHidesBottomBarWhenPushed:YES];
    NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
    viewController.dictionaryCommon = dictionary;
    viewController.title = [LocalizedString ProductInfo];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - ProductListToolViewDelegate

- (void)productListToolView:(ProductListToolView *)view didSelectSortBySender:(id)sender
{
    if (_isLoading)
    {
        return;
    }
    __weak ProductListViewController *weakSelf = self;
    [self showFTMenuFromView:view.buttonSort title:nil textColor:[UIColor blackColor] perferedWidth:200.0 menuKey:SymphoxAPIParam_name inDictionaryFromArray:self.arraySortOption doneBlock:^(NSInteger selectedIndex){
        
        // Get information of selected sort type
        NSDictionary *dictionary = [weakSelf.arraySortOption objectAtIndex:selectedIndex];
        NSString *sortType = [dictionary objectForKey:SymphoxAPIParam_sort_type];
        
        // Change the sort button text
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        if (name)
        {
            [weakSelf.viewTool.buttonSort setTitle:name forState:UIControlStateNormal];
        }
        
        // Refresh the product list
        if (sortType)
        {
            [weakSelf.dictionaryConditions setObject:sortType forKey:SymphoxAPIParam_sort_type];
        }
        weakSelf.currentProductPage = 1;
        [weakSelf.dictionaryConditions setObject:[NSNumber numberWithInteger:weakSelf.currentProductPage] forKey:SymphoxAPIParam_page];
        [weakSelf retrieveProductsForConditions:weakSelf.dictionaryConditions byRefreshing:YES];
        
    } cancelBlock:nil];
}

- (void)productListToolView:(ProductListToolView *)view didSelectFilterBySender:(id)sender
{
    if (self.isLoading)
        return;
    if ([[TMInfoManager sharedManager].dictionaryInitialFilter count] == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString CannotRetrieveFilterOptions] preferredStyle:UIAlertControllerStyleAlert];
//        __weak ProductListViewController *weakSelf = self;
//        UIAlertAction *actionReload = [UIAlertAction actionWithTitle:[LocalizedString Reload] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            [weakSelf refreshAllContentForHallId:weakSelf.hallId andLayer:weakSelf.layer withName:weakSelf.name];
//        }];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:actionReload];
        [alertController addAction:actionConfirm];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    ProductFilterViewController *viewController = [[ProductFilterViewController alloc] initWithNibName:@"ProductFilterViewController" bundle:[NSBundle mainBundle]];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - ProductSubcategoryViewDelegate

- (void)productSubcategoryView:(ProductSubcategoryView *)view didSelectShowAllBySender:(id)sender
{
    NSLog(@"arraySubcategory:\n%@", [_arraySubcategory description]);
    if ([_arraySubcategory count] == 0)
    {
        return;
    }
    __weak ProductListViewController *weakSelf = self;
    [self showFTMenuFromView:view.buttonShowAll title:nil textColor:[UIColor blackColor] perferedWidth:200.0 menuKey:SymphoxAPIParam_name inDictionaryFromArray:self.arraySubcategory doneBlock:^(NSInteger selectedIndex){
        if (selectedIndex >= [weakSelf.arraySubcategory count])
        {
            return;
        }
        NSDictionary *dictionary = [weakSelf.arraySubcategory objectAtIndex:selectedIndex];
        NSString *hallId = [dictionary objectForKey:SymphoxAPIParam_hall_id];
        NSNumber *layer = [dictionary objectForKey:SymphoxAPIParam_layer];
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        ProductListViewController *viewController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:[NSBundle mainBundle]];
        viewController.hallId = hallId;
        viewController.layer = layer;
        viewController.name = name;
        viewController.arrayCategory = weakSelf.arraySubcategory;
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    } cancelBlock:nil];
}

- (void)productSubcategoryView:(ProductSubcategoryView *)view didSelectSubcategoryAtIndex:(NSInteger)index
{
    NSDictionary *dictionary = [_arraySubcategory objectAtIndex:index];
    NSLog(@"dictionary:\n%@", [dictionary description]);
    NSString *hallId = [dictionary objectForKey:SymphoxAPIParam_hall_id];
    NSNumber *layer = [dictionary objectForKey:SymphoxAPIParam_layer];
    NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
    ProductListViewController *viewController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:[NSBundle mainBundle]];
    viewController.hallId = hallId;
    viewController.layer = layer;
    viewController.name = name;
    viewController.arrayCategory = self.arraySubcategory;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - ProductListTitleViewDelegate

- (void)productListTitleView:(ProductListTitleView *)view willSelectTitleBySender:(id)sender
{
    if (self.isLoading)
    {
        return;
    }
//    NSLog(@"self.arrayCategory:\n%@", [self.arrayCategory description]);
    if ([self.arrayCategory count] <= 1)
    {
        return;
    }
    __weak ProductListViewController *weakSelf = self;
    [self showFTMenuFromView:self.viewTitle title:nil textColor:[UIColor blackColor] perferedWidth:200.0 menuKey:SymphoxAPIParam_name inDictionaryFromArray:self.arrayCategory doneBlock:^(NSInteger selectedIndex){
        if (selectedIndex >= [weakSelf.arrayCategory count])
        {
            return;
        }
        NSDictionary *dictionary = [weakSelf.arrayCategory objectAtIndex:selectedIndex];
        NSString *hallId = [dictionary objectForKey:SymphoxAPIParam_hall_id];
        NSNumber *layer = [dictionary objectForKey:SymphoxAPIParam_layer];
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        
        [weakSelf refreshAllContentForHallId:hallId andLayer:layer withName:name];
    } cancelBlock:nil];
}

#pragma mark - ProductFilterViewControllerDelegate

- (void)productFilterViewController:(ProductFilterViewController *)viewController didSelectAdvancedConditions:(NSDictionary *)conditions
{
    // Deal with hallId
    NSString *selectedHallId = [conditions objectForKey:SymphoxAPIParam_cpse_id];
    __block NSString *newHallId = nil;
    __block NSNumber *newLayer = nil;
    __block NSString *newName = nil;
    
    NSArray *cachedDictionaries = [[TMInfoManager sharedManager] categoriesContainsCategoryWithIdentifier:selectedHallId];
    NSLog(@"cachedDictionaries\n%@", cachedDictionaries);
    
    // Remove all category relative condition
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_cpse_id];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_cpnhl_id];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_cpte_id];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_cptm_id];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_carrier_type];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_delivery_store];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_ecoupon_type];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_price_from];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_price_to];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_point_from];
    [self.dictionaryConditions removeObjectForKey:SymphoxAPIParam_point_to];
    
    __weak ProductListViewController *weakSelf = self;
    [[TMInfoManager sharedManager] findSiblingsInSameLayerAndContentForCategoryIdentifier:selectedHallId withCompletion:^(NSArray *siblings, NSDictionary *content, NSNumber *layer){
//        NSLog(@"siblings[%li]:\n%@", (long)[layer integerValue], [siblings description]);
//        NSLog(@"content:\n%@", [content description]);
        weakSelf.arrayCategory = siblings;
        newName = [content objectForKey:SymphoxAPIParam_name];
        newLayer = layer;
        newHallId = selectedHallId;
        [weakSelf.dictionaryConditions addEntriesFromDictionary:conditions];
        [weakSelf refreshAllContentForHallId:newHallId andLayer:newLayer withName:newName];
    }];
}

#pragma mark - SearchViewControllerDelegate

- (void)searchViewController:(SearchViewController *)viewController didSelectToSearchKeyword:(NSString *)keyword
{
    NSLog(@"Should start search by keyword \"%@\"", keyword);
    ProductListViewController *listViewController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:[NSBundle mainBundle]];
    listViewController.isSearchResult = YES;
    [listViewController addKeywordToConditions:keyword];
    listViewController.hallId = nil;
    listViewController.layer = nil;
    listViewController.name = nil;
    [self.navigationController pushViewController:listViewController animated:YES];
}

#pragma mark - ProductTableViewCellDelegate

- (void)productTableViewCell:(ProductTableViewCell *)cell didSelectToAddToCartBySender:(id)sender
{
    if (cell.tag >= [self.arrayProducts count])
        return;
    NSDictionary *product = [self.arrayProducts objectAtIndex:cell.tag];
    [self showCartTypeSheetForProduct:product];
}

- (void)productTableViewCell:(ProductTableViewCell *)cell didSelectToAddToFavoriteBySender:(id)sender
{
    if (cell.tag >= [self.arrayProducts count])
        return;
    NSDictionary *product = [self.arrayProducts objectAtIndex:cell.tag];
    NSNumber *cpdt_num = [product objectForKey:SymphoxAPIParam_cpdt_num];
    if (cpdt_num == nil || [cpdt_num isEqual:[NSNull null]])
        return;
    if ([[TMInfoManager sharedManager] favoriteContainsProductWithIdentifier:cpdt_num])
    {
        return;
    }
    [[TMInfoManager sharedManager] addProductToFavorite:product];
    cell.favorite = YES;
}

@end
