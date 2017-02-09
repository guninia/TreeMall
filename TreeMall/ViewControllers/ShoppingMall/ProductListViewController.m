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

@interface ProductListViewController ()

- (void)retrieveSubcategoryDataForIdentifier:(NSString *)identifier andLayer:(NSNumber *)layer;
- (BOOL)processSubcategoryData:(id)data forLayerIndex:(NSInteger)layerIndex;
- (void)retrieveProductsForConditions:(NSDictionary *)conditions byRefreshing:(BOOL)refresh;
- (BOOL)processProductsData:(id)data byRefreshing:(BOOL)refresh;

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"ProductListViewController - hallId[%@] layer[%li] name[%@]", _hallId, (long)[_layer integerValue], _name);
    [self.view addSubview:self.viewSubcategory];
    [self.view addSubview:self.tableViewProduct];
    
    if (_arraySubcategory == nil || [_arraySubcategory count] == 0)
    {
        // Should load subcategories from server
        [self retrieveSubcategoryDataForIdentifier:self.hallId andLayer:self.layer];
    }
    else
    {
        _viewSubcategory.dataArray = _arraySubcategory;
    }
    
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
    }
    if ([_dictionaryConditions count] > 0)
    {
        [self retrieveProductsForConditions:_dictionaryConditions byRefreshing:YES];
    }
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
    if (self.viewSubcategory)
    {
        CGRect frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.viewTool.frame.origin.y);
        NSLog(@"frame[%4.2f,%4.2f,%4.2f,%4.2f]", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.viewSubcategory.frame = frame;
        [self.viewSubcategory setNeedsLayout];
    }
    if (self.tableViewProduct)
    {
        CGFloat originY = self.viewTool.frame.origin.y + self.viewTool.frame.size.height;
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        self.tableViewProduct.frame = frame;
    }
}

- (ProductSubcategoryView *)viewSubcategory
{
    if (_viewSubcategory == nil)
    {
        _viewSubcategory = [[ProductSubcategoryView alloc] initWithFrame:CGRectZero];
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
    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
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
    self.isLoading = YES;
    __weak ProductListViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_Search];
    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:conditions inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
//                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"retrieveProductsForConditions:\n%@", string);
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
            NSLog(@"retrieveProductsForConditions - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString CannotLoadData] preferredStyle:UIAlertControllerStyleAlert];
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
            UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:[LocalizedString Reload] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [weakSelf retrieveProductsForConditions:conditions byRefreshing:refresh];
            }];
            [alertController addAction:backAction];
            [alertController addAction:reloadAction];
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
    if (indexPath.row < [_arrayProducts count])
    {
        NSDictionary *dictionary = [_arrayProducts objectAtIndex:indexPath.row];
        NSString *imagePath = [dictionary objectForKey:SymphoxAPIParam_prod_pic_url];
        cell.imagePath = imagePath;
        NSMutableArray *arrayTags = [NSMutableArray array];
        NSNumber *quick = [dictionary objectForKey:SymphoxAPIParam_quick];
        if (quick && [quick boolValue])
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"8H", ProductTableViewCellTagText, [UIColor colorWithRed:(152.0/255.0) green:(194.0/255.0) blue:(67.0/255.0) alpha:1.0], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        NSNumber *discountNow = [dictionary objectForKey:SymphoxAPIParam_chk_tactic_click];
        if (discountNow && [discountNow boolValue])
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[LocalizedString ClickToDiscount], ProductTableViewCellTagText, [UIColor colorWithRed:(134.0/255.0) green:(209.0/255.0) blue:(188.0/255.0) alpha:1.0], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        NSArray *installments = [dictionary objectForKey:SymphoxAPIParam_seekInstallmentList];
        if (installments && [installments count] > 0)
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
    CGFloat heightForRow = 160.0;
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

@end
