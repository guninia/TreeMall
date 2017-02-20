//
//  ProductListViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductTableViewCell.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "TMInfoManager.h"
#import "LoadingFooterView.h"
#import "LocalizedString.h"
#import "UIViewController+FTPopMenu.h"
#import "ProductDetailViewController.h"
#import "Utility.h"

@interface ProductListViewController ()

- (void)retrieveSubcategoryDataForIdentifier:(NSString *)identifier andLayer:(NSNumber *)layer;
- (BOOL)processSubcategoryData:(id)data forLayerIndex:(NSInteger)layerIndex;
- (void)retrieveProductsForConditions:(NSDictionary *)conditions byRefreshing:(BOOL)refresh;
- (BOOL)processProductsData:(id)data byRefreshing:(BOOL)refresh;
- (void)prepareSortOption;
- (void)refreshAllContentForHallId:(NSString *)hallId andLayer:(NSNumber *)layer withName:(NSString *)name;

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
    }
}

- (ProductListTitleView *)viewTitle
{
    if (_viewTitle == nil)
    {
        CGSize screenRatio = [Utility sizeRatioAccordingTo320x480];
        _viewTitle = [[ProductListTitleView alloc] initWithFrame:CGRectMake(0.0, 0.0, 180.0 * screenRatio.width, 40.0)];
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
        [_tableViewProduct setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
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
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"retrieveSubcategoryDataForIdentifier - string[%@]", string);
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
                if ([self processProductsData:data byRefreshing:refresh] == NO)
                {
                    NSLog(@"retrieveProductsForConditions - Cannot process data");
                }
            }
            else
            {
                NSLog(@"retrieveProductsForConditions - Unexpected data format.");
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString CannotLoadData];
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
            UIAlertAction *backAction = [UIAlertAction actionWithTitle:[LocalizedString GoBack] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                if (weakSelf.navigationController)
                {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    return;
                }
                if (weakSelf.presentingViewController)
                {
                    [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            [alertController addAction:backAction];
            if (errorProductNotFound == NO)
            {
                UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:[LocalizedString Reload] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [weakSelf retrieveProductsForConditions:conditions byRefreshing:refresh];
                }];
                [alertController addAction:reloadAction];
            }
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
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
                if (totalSizeNumber && [totalSizeNumber integerValue] == [self.arrayProducts count])
                {
                    self.shouldShowLoadingFooter = NO;
                }
                else
                {
                    self.shouldShowLoadingFooter = YES;
                }
            }
            [self.tableViewProduct reloadData];
            
            if ([[TMInfoManager sharedManager].dictionaryInitialFilter count] == 0)
            {
                NSNumber *numberMinPrice = [result objectForKey:SymphoxAPIParam_min_price];
                if (numberMinPrice != nil && ([numberMinPrice isEqual:[NSNull null]] == NO))
                {
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
    self.hallId = hallId;
    self.layer = layer;
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
//    NSLog(@"cellForRowAtIndexPath[%li][%li]", (long)indexPath.section, (long)indexPath.row);
    if (indexPath.row < [_arrayProducts count])
    {
        NSDictionary *dictionary = [_arrayProducts objectAtIndex:indexPath.row];
        NSString *imagePath = [dictionary objectForKey:SymphoxAPIParam_prod_pic_url];
        cell.imagePath = imagePath;
        NSMutableArray *arrayTags = [NSMutableArray array];
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
        if (freePoint && [freePoint integerValue] > 0)
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
        cell.price = price;
        
        NSNumber *point = [dictionary objectForKey:SymphoxAPIParam_point01];
        cell.point = point;
        
        NSNumber *discount = [dictionary objectForKey:SymphoxAPIParam_discount_hall_percentage];
        cell.discount = discount;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LoadingFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LoadingFooterViewIdentifier];
    footerView.viewBackground.backgroundColor = tableView.backgroundColor;
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
    NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
    viewController.dictionaryCommon = dictionary;
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
    [self showFTMenuFromView:view.buttonSort title:[LocalizedString ChooseOrder] textColor:[UIColor blackColor] perferedWidth:200.0 menuKey:SymphoxAPIParam_name inDictionaryFromArray:self.arraySortOption doneBlock:^(NSInteger selectedIndex){
        
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
        __weak ProductListViewController *weakSelf = self;
        UIAlertAction *actionReload = [UIAlertAction actionWithTitle:[LocalizedString Reload] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf refreshAllContentForHallId:weakSelf.hallId andLayer:weakSelf.layer withName:weakSelf.name];
        }];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:actionReload];
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

@end
