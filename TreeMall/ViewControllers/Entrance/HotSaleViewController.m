//
//  HotSaleViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/28.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "HotSaleViewController.h"
#import "CryptoModule.h"
#import "APIDefinition.h"
#import "SHAPIAdapter.h"
#import "ProductDetailViewController.h"
#import "LocalizedString.h"
#import "TMInfoManager.h"
#import "CartViewController.h"
#import "LoginViewController.h"
#import "LoadingFooterView.h"

@interface HotSaleViewController ()

@property (nonatomic, assign) BOOL shouldShowLoadingView;

- (void)retrieveDataForType:(HotSaleType)type;
- (BOOL)processData:(id)data;
- (NSMutableDictionary *)dictionaryCommonFromHotSale:(NSDictionary *)dictionary;
- (void)addProduct:(NSDictionary *)product toCart:(CartType)cartType named:(NSString *)cartName shouldShowAlert:(BOOL)shouldShowAlert;
- (void)addFavoriteProduct:(NSDictionary *)product;
- (NSString *)titleForCartType:(CartType)cartType;
- (void)presentCartViewForType:(CartType)type;

- (void)buttonItemPressed:(id)sender;

@end

@implementation HotSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldShowLoadingView = YES;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIImage *image = [[UIImage imageNamed:@"car_popup_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemPressed:)];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    [self retrieveDataForType:self.type];
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
    
    if (self.tableView)
    {
        self.tableView.frame = self.view.bounds;
    }
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1.0]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[HotSaleTableViewCell class] forCellReuseIdentifier:HotSaleTableViewCellIdentifier];
        [_tableView registerClass:[LoadingFooterView class] forHeaderFooterViewReuseIdentifier:LoadingFooterViewIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)arrayProducts
{
    if (_arrayProducts == nil)
    {
        _arrayProducts = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayProducts;
}

- (NSNumberFormatter *)formatter
{
    if (_formatter == nil)
    {
        _formatter = [[NSNumberFormatter alloc] init];
        [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _formatter;
}

#pragma mark - Private Methods

- (void)retrieveDataForType:(HotSaleType)type
{
    __weak HotSaleViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSString *stringType = nil;
    switch (type) {
        case HotSaleTypePoint:
        {
            stringType = @"aquariusHomePointOrderRank";
        }
            break;
        case HotSaleTypeCoupon:
        {
            stringType = @"aquariusHomeEcouponOrderRank";
        }
            break;
        default:
        {
            stringType = @"aquariusHomeOrderRank";
        }
            break;
    }
    NSString *totalUrlString = [SymphoxAPI_getHotSaleProducts stringByAppendingFormat:@"?type=%@", stringType];
    NSLog(@"totalUrlString[%@]", totalUrlString);
    NSURL *url = [NSURL URLWithString:totalUrlString];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:stringType, SymphoxAPIParam_type, nil];
    NSLog(@"retrieveDataForType [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:nil inPostFormat:SHPostFormatNone encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        weakSelf.shouldShowLoadingView = NO;
        if (error == nil)
        {
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"string[%@]", string);
                // Should continue to process data.
                if ([weakSelf processData:data])
                {
                    [weakSelf.tableView reloadData];
                }
            }
            else
            {
                NSLog(@"Unexpected data format.");
            }
        }
        else
        {
            NSLog(@"error:\n%@", [error description]);
        }
    }];
}

- (BOOL)processData:(id)data
{
    BOOL success = NO;
    
    NSError *error = nil;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil)
    {
        if ([resultObject isKindOfClass:[NSArray class]])
        {
            NSArray *arrayResult = (NSArray *)resultObject;
            [self.arrayProducts setArray:arrayResult];
            success = YES;
        }
    }
    
    return success;
}

- (NSMutableDictionary *)dictionaryCommonFromHotSale:(NSDictionary *)dictionary
{
    if (dictionary == nil)
        return nil;
    NSMutableDictionary *dictionaryCommon = [NSMutableDictionary dictionary];
    
    NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
    if (cpdt_num)
    {
        [dictionaryCommon setObject:cpdt_num forKey:SymphoxAPIParam_cpdt_num];
    }
    NSString *cpdt_name = [dictionary objectForKey:SymphoxAPIParam_cpdt_name];
    if (cpdt_name)
    {
        [dictionaryCommon setObject:cpdt_name forKey:SymphoxAPIParam_cpdt_name];
    }
    NSString *pic_link = [dictionary objectForKey:SymphoxAPIParam_pic_link];
    if (pic_link)
    {
        [dictionaryCommon setObject:pic_link forKey:SymphoxAPIParam_prod_pic_url];
    }
    NSString *cpro_price = [dictionary objectForKey:SymphoxAPIParam_cpro_price];
    if (cpro_price)
    {
        [dictionaryCommon setObject:cpro_price forKey:SymphoxAPIParam_cpro_price];
    }
    NSNumber *pure_price = [dictionary objectForKey:SymphoxAPIParam_pure_price];
    if (pure_price)
    {
        [dictionaryCommon setObject:pure_price forKey:SymphoxAPIParam_price03];
    }
    NSNumber *pure_point = [dictionary objectForKey:SymphoxAPIParam_pure_point];
    if (pure_point)
    {
        [dictionaryCommon setObject:pure_point forKey:SymphoxAPIParam_point01];
    }
    NSNumber *mix_price = [dictionary objectForKey:SymphoxAPIParam_mix_price];
    if (mix_price)
    {
        [dictionaryCommon setObject:mix_price forKey:SymphoxAPIParam_price02];
    }
    NSNumber *mix_point = [dictionary objectForKey:SymphoxAPIParam_mix_point];
    if (mix_point)
    {
        [dictionaryCommon setObject:mix_point forKey:SymphoxAPIParam_point02];
    }
    
    BOOL common = NO;
    BOOL store = NO;
    BOOL fast = NO;
    BOOL direct = NO;
    NSArray *can_used_cart = [dictionary objectForKey:SymphoxAPIParam_can_used_cart];
    if (can_used_cart && [can_used_cart isEqual:[NSNull null]] == NO)
    {
        for (NSString *type in can_used_cart)
        {
            switch ([type integerValue]) {
                case CartTypeCommonDelivery:
                {
                    common = YES;
                }
                    break;
                case CartTypeStorePickup:
                {
                    store = YES;
                }
                    break;
                case CartTypeFastDelivery:
                {
                    fast = YES;
                }
                    break;
                case CartTypeDirectlyPurchase:
                {
                    direct = YES;
                }
                    break;
                default:
                    break;
            }
        }
    }
    NSNumber *numberCommon = [NSNumber numberWithBool:common];
    NSNumber *numberStore = [NSNumber numberWithBool:store];
    NSNumber *numberFast = [NSNumber numberWithBool:fast];
    NSNumber *numberDirect = [NSNumber numberWithBool:direct];
    
    [dictionaryCommon setObject:numberCommon forKey:SymphoxAPIParam_normal_cart];
    [dictionaryCommon setObject:numberStore forKey:SymphoxAPIParam_to_store_cart];
    [dictionaryCommon setObject:numberFast forKey:SymphoxAPIParam_fast_delivery_cart];
    [dictionaryCommon setObject:numberDirect forKey:SymphoxAPIParam_single_shopping_cart];
    return dictionaryCommon;
}

- (void)addProduct:(NSDictionary *)product toCart:(CartType)cartType named:(NSString *)cartName shouldShowAlert:(BOOL)shouldShowAlert
{
    NSMutableDictionary *dictionaryCommon = [self dictionaryCommonFromHotSale:product];
    [[TMInfoManager sharedManager] addProduct:dictionaryCommon toCartForType:cartType];
    if (shouldShowAlert)
    {
        NSString *message = [NSString stringWithFormat:[LocalizedString AddedTo_S_], cartName];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)addFavoriteProduct:(NSDictionary *)product
{
    NSMutableDictionary *dictionaryCommon = [self dictionaryCommonFromHotSale:product];
    NSString *message = [[TMInfoManager sharedManager] addProductToFavorite:dictionaryCommon];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)titleForCartType:(CartType)cartType
{
    NSString *title = nil;
    switch (cartType) {
        case CartTypeCommonDelivery:
        {
            title = [LocalizedString CommonDelivery];
        }
            break;
        case CartTypeStorePickup:
        {
            title = [LocalizedString StorePickUp];
        }
            break;
        case CartTypeFastDelivery:
        {
            title = [LocalizedString FastDelivery];
        }
            break;
        default:
            break;
    }
    return title;
}

- (void)presentCartViewForType:(CartType)type
{
    CartViewController *viewController = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:[NSBundle mainBundle]];
    viewController.title = [LocalizedString ShoppingCart];
    viewController.currentType = type;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Actions

- (void)buttonItemPressed:(id)sender
{
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.arrayProducts count];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HotSaleTableViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    if (cell.delegate == nil)
    {
        cell.delegate = self;
    }
    cell.price = nil;
    cell.point = nil;
    cell.priceType = PriceTypeTotal;
    NSString *textRank = @"";
//    NSString *title = @"";
    NSURL *imageUrl = nil;
    BOOL isFavorite = NO;
    
    if (indexPath.row < [self.arrayProducts count])
    {
        NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
        
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
        
        NSNumber *rank = [dictionary objectForKey:SymphoxAPIParam_rank];
        if (rank && [rank isEqual:[NSNull null]] == NO)
        {
            NSString *stringRank = [rank stringValue];
            if (stringRank)
            {
                textRank = [NSString stringWithFormat:@"NO.%@", stringRank];
            }
        }
        
        NSString *marketText = [dictionary objectForKey:SymphoxAPIParam_market_name];
        cell.marketingText = marketText;
        
        NSString *cpdt_name = [dictionary objectForKey:SymphoxAPIParam_cpdt_name];
        if (cpdt_name && [cpdt_name isEqual:[NSNull null]] == NO && [cpdt_name length] > 0)
        {
            cell.productName = cpdt_name;
        }
        
        NSString *pic_link = [dictionary objectForKey:SymphoxAPIParam_pic_link];
        if (pic_link && [pic_link isEqual:[NSNull null]] == NO && [pic_link length] > 0)
        {
            NSURL *url = [NSURL URLWithString:pic_link];
            if (url)
            {
                imageUrl = url;
            }
        }
        
        NSNumber *price = [dictionary objectForKey:SymphoxAPIParam_pure_price];
        NSNumber *point = [dictionary objectForKey:SymphoxAPIParam_pure_point];
        NSNumber *price1 = [dictionary objectForKey:SymphoxAPIParam_mix_price];
        NSNumber *point1 = [dictionary objectForKey:SymphoxAPIParam_mix_point];
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
        NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO)
        {
            isFavorite = [[TMInfoManager sharedManager] favoriteContainsProductWithIdentifier:cpdt_num];
        }
        NSArray *carts = [dictionary objectForKey:SymphoxAPIParam_can_used_cart];
        if ([carts containsObject:@"0"] || [carts containsObject:@"1"] || [carts containsObject:@"2"] || [carts containsObject:@"3"])
        {
            cell.buttonAddToCart.hidden = NO;
        }
        else
        {
            cell.buttonAddToCart.hidden = YES;
        }
    }
    
//    cell.labelTitle.text = title;
    cell.labelTag.text = textRank;
    cell.imageUrl = imageUrl;
    cell.favorite = isFavorite;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LoadingFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LoadingFooterViewIdentifier];
    footerView.viewBackground.backgroundColor = tableView.backgroundColor;
    return footerView;
}

#pragma mark - UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 170.0;
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.arrayProducts count])
    {
        NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
        NSNumber *productId = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId && [productId isEqual:[NSNull null]] == NO)
        {
            ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
            viewController.productIdentifier = productId;
            viewController.title = [LocalizedString ProductInfo];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForFooter = 0.0;
    switch (section) {
        case 0:
        {
            if (self.shouldShowLoadingView)
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
        LoadingFooterView *footerView = (LoadingFooterView *)view;
        [footerView.activityIndicator startAnimating];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[LoadingFooterView class]])
    {
        LoadingFooterView *footerView = (LoadingFooterView *)view;
        [footerView.activityIndicator stopAnimating];
    }
}

#pragma mark - HotSaleTableViewCellDelegate

- (void)hotSaleTableViewCell:(HotSaleTableViewCell *)cell didPressAddToCartBySender:(id)sender
{
    if ([TMInfoManager sharedManager].userIdentifier == nil)
    {
        // Should login first.
        LoginViewController *viewControllerLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerLogin];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    if (cell.tag >= [self.arrayProducts count])
        return;
    NSDictionary *dictionary = [self.arrayProducts objectAtIndex:cell.tag];
    NSArray *carts = [dictionary objectForKey:SymphoxAPIParam_can_used_cart];
    if (carts == nil || [carts isEqual:[NSNull null]])
        return;
    
    NSMutableArray *arrayAvailableCarts = [NSMutableArray array];
    BOOL canDirectlyPurchase = [carts containsObject:@"3"];
    for (NSString *stringType in carts)
    {
        CartType type = [stringType integerValue];
        if (type < CartTypeDirectlyPurchase)
        {
            [arrayAvailableCarts addObject:[NSNumber numberWithInteger:type]];
        }
    }
    if ([arrayAvailableCarts count] > 1)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString AddToCart] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSNumber *numberCartType in arrayAvailableCarts)
        {
            NSInteger type = [numberCartType integerValue];
            NSString *title = [self titleForCartType:type];
            __weak HotSaleViewController *weakSelf = self;
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [weakSelf addProduct:dictionary toCart:type named:title shouldShowAlert:YES];
            }];
            [alertController addAction:action];
        }
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([arrayAvailableCarts count] > 0)
    {
        NSNumber *numberCartType = [arrayAvailableCarts objectAtIndex:0];
        NSInteger type = [numberCartType integerValue];
        NSString *title = [self titleForCartType:type];
        [self addProduct:dictionary toCart:type named:title shouldShowAlert:YES];
    }
    else if (canDirectlyPurchase)
    {
        [[TMInfoManager sharedManager] resetCartForType:CartTypeDirectlyPurchase];
        [self addProduct:dictionary toCart:CartTypeDirectlyPurchase named:@"" shouldShowAlert:NO];
        [self presentCartViewForType:CartTypeDirectlyPurchase];
    }
}

- (void)hotSaleTableViewCell:(HotSaleTableViewCell *)cell didPressFavoriteBySender:(id)sender
{
    if (cell.tag >= [self.arrayProducts count])
        return;
    NSDictionary *dictionary = [self.arrayProducts objectAtIndex:cell.tag];
    [self addFavoriteProduct:dictionary];
    
    BOOL isFavorite = NO;
    NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
    if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO)
    {
        isFavorite = [[TMInfoManager sharedManager] favoriteContainsProductWithIdentifier:cpdt_num];
    }
    cell.favorite = isFavorite;
}

@end
