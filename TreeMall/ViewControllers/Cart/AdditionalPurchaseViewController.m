//
//  AdditionalPurchaseViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "AdditionalPurchaseViewController.h"
#import "APIDefinition.h"
#import "LocalizedString.h"
#import "SHPickerView.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "PaymentTypeViewController.h"
#import "Definition.h"
#import "SingleLabelCollectionReusableView.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface AdditionalPurchaseViewController () {
    id<GAITracker> gaTracker;
}

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)showQuantityInputViewForProduct:(NSDictionary *)product atIndex:(NSInteger)index;
- (BOOL)isGiftProduct:(NSDictionary *)product;
- (void)checkCartForType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId;
- (void)requestResultForCheckingProducts:(NSArray *)products ofCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId;

@end

@implementation AdditionalPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString AdditionalPurchaseProduct];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomBar];
    if (self.navigationController.tabBarController != nil)
    {
        [self.navigationController.tabBarController.view addSubview:self.viewLoading];
        [self.navigationController.tabBarController.view addSubview:self.viewQuantityInput];
    }
    else if (self.navigationController != nil)
    {
        [self.navigationController.view addSubview:self.viewLoading];
        [self.navigationController.view addSubview:self.viewQuantityInput];
    }
    
    gaTracker = [GAI sharedInstance].defaultTracker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // GA screen log
    [gaTracker set:kGAIScreenName value:self.title];
    [gaTracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
    
    CGFloat originY = 0.0;
    
    if (self.bottomBar)
    {
        CGFloat height = 50.0;
        CGRect frame = CGRectMake(0.0, self.view.frame.size.height - height, self.view.frame.size.width, height);
        self.bottomBar.frame = frame;
    }
    
    if (self.collectionView)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, CGRectGetMinY(self.bottomBar.frame) - originY);
        self.collectionView.frame = frame;
        [self.collectionView reloadData];
    }
    
    if (self.viewLoading)
    {
        if (self.navigationController.tabBarController != nil)
        {
            self.viewLoading.frame = self.navigationController.tabBarController.view.bounds;
            self.viewQuantityInput.frame = self.navigationController.tabBarController.view.bounds;
        }
        else if (self.navigationController != nil)
        {
            self.viewLoading.frame = self.navigationController.view.bounds;
            self.viewQuantityInput.frame = self.navigationController.view.bounds;
        }
        self.viewLoading.indicatorCenter = self.viewLoading.center;
        [self.viewLoading setNeedsLayout];
        
        [self.viewQuantityInput setNeedsLayout];
    }
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        [_collectionView registerClass:[AdditionalProductCollectionViewCell class] forCellWithReuseIdentifier:AdditionalProductCollectionViewCellIdentifier];
        [_collectionView registerClass:[SingleLabelCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SingleLabelCollectionReusableViewIdentifier];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
    }
    return _collectionView;
}

- (LabelButtonView *)bottomBar
{
    if (_bottomBar == nil)
    {
        _bottomBar = [[LabelButtonView alloc] initWithFrame:CGRectZero];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
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

- (FullScreenLoadingView *)viewLoading
{
    if (_viewLoading == nil)
    {
        _viewLoading = [[FullScreenLoadingView alloc] initWithFrame:CGRectZero];
        [_viewLoading setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        _viewLoading.alpha = 0.0;
    }
    return _viewLoading;
}

- (NSMutableDictionary *)dictionaryTotal
{
    if (_dictionaryTotal == nil)
    {
        _dictionaryTotal = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryTotal;
}

- (NSMutableDictionary *)dictionaryAll
{
    if (_dictionaryAll == nil)
    {
        _dictionaryAll = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryAll;
}

- (NSMutableArray *)arrayAllProducts
{
    if (_arrayAllProducts == nil)
    {
        _arrayAllProducts = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayAllProducts;
}

- (NSNumberFormatter *)numberFormatter
{
    if (_numberFormatter == nil)
    {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _numberFormatter;
}

- (FullScreenSelectNumberView *)viewQuantityInput
{
    if (_viewQuantityInput == nil)
    {
        _viewQuantityInput = [[FullScreenSelectNumberView alloc] initWithFrame:CGRectZero];
        _viewQuantityInput.delegate = self;
        [_viewQuantityInput setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        _viewQuantityInput.alpha = 0.0;
        _viewQuantityInput.minValue = 0;
    }
    return _viewQuantityInput;
}

- (NSString *)marketingDescription
{
    if (_marketingDescription == nil)
    {
        _marketingDescription = [[NSString alloc] initWithString:[LocalizedString AdditionalPurchaseProduct]];
    }
    return _marketingDescription;
}

#pragma mark - Private Methods

- (void)showLoadingViewAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewLoading.activityIndicator startAnimating];
        if (animated)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                [self.viewLoading setAlpha:1.0];
            } completion:nil];
        }
        else
        {
            [self.viewLoading setAlpha:1.0];
        }
    });
}

- (void)hideLoadingViewAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewLoading.activityIndicator stopAnimating];
        if (animated)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                [self.viewLoading setAlpha:0.0];
            } completion:nil];
        }
        else
        {
            [self.viewLoading setAlpha:0.0];
        }
    });
}

- (void)checkCartForType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId
{
    NSArray *array = self.arrayProductsFromCart;
    if (array == nil || [array count] == 0)
    {
        array = [[TMInfoManager sharedManager] productArrayForCartType:type];
    }
    
    NSDictionary *dictionary = [[TMInfoManager sharedManager] purchaseInfoForCartType:type];
    NSMutableArray *arrayCheck = [NSMutableArray array];
    for (NSDictionary *product in array)
    {
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId == nil)
        {
            continue;
        }
        NSDictionary *purchaseInfo = [dictionary objectForKey:productId];
        NSNumber *quantity = nil;
        if (purchaseInfo == nil)
        {
            quantity = [NSNumber numberWithInteger:1];
        }
        else
        {
            quantity = [purchaseInfo objectForKey:SymphoxAPIParam_qty];
        }
        NSNumber *realProductId = [purchaseInfo objectForKey:SymphoxAPIParam_real_cpdt_num];
        if (realProductId)
        {
            productId = realProductId;
        }
        NSMutableDictionary *dictionaryCheck = [NSMutableDictionary dictionary];
        [dictionaryCheck setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        [dictionaryCheck setObject:quantity forKey:SymphoxAPIParam_qty];
        [arrayCheck addObject:dictionaryCheck];
    }
    
    NSArray *arrayAddition = [[TMInfoManager sharedManager] productArrayForAdditionalCartType:type];
    NSDictionary *dictionaryAddition = [[TMInfoManager sharedManager] purchaseInfoForAdditionalCartType:type];
    for (NSDictionary *product in arrayAddition)
    {
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId == nil)
        {
            continue;
        }
        NSDictionary *purchaseInfo = [dictionaryAddition objectForKey:productId];
        NSNumber *quantity = nil;
        if (purchaseInfo == nil)
        {
            quantity = [NSNumber numberWithInteger:1];
        }
        else
        {
            quantity = [purchaseInfo objectForKey:SymphoxAPIParam_qty];
        }
        NSNumber *realProductId = [purchaseInfo objectForKey:SymphoxAPIParam_real_cpdt_num];
        if (realProductId)
        {
            productId = realProductId;
        }
        NSMutableDictionary *dictionaryCheck = [NSMutableDictionary dictionary];
        [dictionaryCheck setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        [dictionaryCheck setObject:quantity forKey:SymphoxAPIParam_qty];
        [arrayCheck addObject:dictionaryCheck];
    }
    
    [self requestResultForCheckingProducts:arrayCheck ofCartType:type shouldShowPaymentForProductId:productId];
}

- (void)requestResultForCheckingProducts:(NSArray *)products ofCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId
{
    __weak AdditionalPurchaseViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_checkProductAvailable];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSString *stringCartType = [[NSNumber numberWithInteger:type] stringValue];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:products, SymphoxAPIParam_cart_item_order, stringCartType, SymphoxAPIParam_cart_type, nil];
    [self showLoadingViewAnimated:NO];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        BOOL shouldHideLoadingView = YES;
        if (error == nil)
        {
            //            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"requestResultForCheckingProducts:\n%@", string);
                if ([weakSelf processCheckingResult:data inCart:type shouldShowPaymentForProductId:productId])
                {
                    [weakSelf renewConditionsForCartType:type shouldShowPaymentForProductId:productId];
                    shouldHideLoadingView = NO;
                }
                else
                {
                    NSLog(@"requestResultForCheckingProducts - get some error");
                }
            }
            else
            {
                NSLog(@"requestResultForCheckingProducts - Unexpected data format.");
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString CannotLoadData];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
                NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                if (serverMessage)
                {
                    errorMessage = serverMessage;
                }
            }
            NSLog(@"requestResultForCheckingProducts - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        if (shouldHideLoadingView)
        {
            [weakSelf hideLoadingViewAnimated:NO];
        }
    }];
}

- (BOOL)processCheckingResult:(id)result inCart:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId
{
    BOOL success = NO;
    if ([result isKindOfClass:[NSData class]] == NO)
        return success;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:result options:0 error:&error];
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resultDictionary = (NSDictionary *)jsonObject;
        NSArray *array = [resultDictionary objectForKey:SymphoxAPIParam_cart_item];
        if (array)
        {
            NSMutableString *notifyString = [NSMutableString string];
            for (NSDictionary *dictionary in array)
            {
                NSString *stringError = nil;
                NSNumber *numberStatus = [dictionary objectForKey:SymphoxAPIParam_status];
                BOOL shouldRemove = YES;
                if (numberStatus && [numberStatus isEqual:[NSNull null]] == NO)
                {
                    switch ([numberStatus integerValue]) {
                        case 0:
                        {
                            // Failed
                            stringError = [LocalizedString UnknownError];
                        }
                            break;
                        case 1:
                        {
                            // Success
                            shouldRemove = NO;
                            success = YES;
                        }
                            break;
                        case 2:
                        {
                            // Cart error
                            stringError = [LocalizedString CartError];
                        }
                            break;
                        case 3:
                        {
                            // Quantity not enough
                            stringError = [LocalizedString NotEnoughInStock];
                        }
                            break;
                        case 4:
                        {
                            // No multiple products available
                            stringError = [LocalizedString MultipleProductsUnacceptable];
                        }
                            break;
                        default:
                        {
                            stringError = [LocalizedString UnknownError];
                        }
                            break;
                    }
                }
                if (stringError)
                {
                    NSNumber *productId = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
                    NSString *name = [[TMInfoManager sharedManager] nameOfRemovedProductId:productId inCart:type];
                    if (name)
                    {
                        NSString *totalString = [NSString stringWithFormat:@"「%@」：%@\n", name, stringError];
                        [notifyString appendString:totalString];
                    }
                    else
                    {
                        [notifyString setString:[LocalizedString AlreadyRemoveSomeProduct]];
                    }
                    
                    NSString *nameAddition = [[TMInfoManager sharedManager] nameOfRemovedProductId:productId inAdditionalCart:type];
                    if (nameAddition)
                    {
                        NSString *totalString = [NSString stringWithFormat:@"「%@」：%@\n", nameAddition, stringError];
                        [notifyString appendString:totalString];
                    }
                    else
                    {
                        [notifyString setString:[LocalizedString AlreadyRemoveSomeProduct]];
                    }
                }
            }
            if ([notifyString length] > 0)
            {
                __weak AdditionalPurchaseViewController *weakSelf = self;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString ProductsRemovedFromCart] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [weakSelf renewConditionsForCartType:type shouldShowPaymentForProductId:productId];
                }];
                [alertController addAction:actionConfirm];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }
    }
    return success;
}

- (void)renewConditionsForCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId
{
    NSArray *array = self.arrayProductsFromCart;
    if (array == nil || [array count] == 0)
    {
        array = [[TMInfoManager sharedManager] productArrayForCartType:type];
    }
    if (array == nil)
        return;
    
    NSDictionary *dictionary = [[TMInfoManager sharedManager] purchaseInfoForCartType:type];
    
    NSMutableArray *arrayCheck = [NSMutableArray array];
    for (NSDictionary *product in array)
    {
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId == nil)
        {
            continue;
        }
        NSDictionary *purchaseInfo = [dictionary objectForKey:productId];
        NSNumber *quantity = nil;
        if (purchaseInfo == nil)
        {
            quantity = [NSNumber numberWithInteger:1];
        }
        else
        {
            quantity = [purchaseInfo objectForKey:SymphoxAPIParam_qty];
        }
        NSDictionary *dictionaryMode = [purchaseInfo objectForKey:SymphoxAPIParam_payment_mode];
        if (dictionaryMode == nil)
        {
            dictionaryMode = [NSDictionary dictionaryWithObjectsAndKeys:@"0", SymphoxAPIParam_payment_type, [NSNumber numberWithInteger:0], SymphoxAPIParam_price, nil];
        }
        NSNumber *realProductId = [purchaseInfo objectForKey:SymphoxAPIParam_real_cpdt_num];
        if (realProductId)
        {
            productId = realProductId;
        }
        
        NSMutableDictionary *dictionaryCheck = [NSMutableDictionary dictionary];
        [dictionaryCheck setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        [dictionaryCheck setObject:quantity forKey:SymphoxAPIParam_qty];
        [dictionaryCheck setObject:dictionaryMode forKey:SymphoxAPIParam_payment_mode];
        [arrayCheck addObject:dictionaryCheck];
    }
    
    NSArray *arrayAddition = [[TMInfoManager sharedManager] productArrayForAdditionalCartType:type];
    NSDictionary *dictionaryAddition = [[TMInfoManager sharedManager] purchaseInfoForAdditionalCartType:type];
    
    for (NSDictionary *product in arrayAddition)
    {
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId == nil)
        {
            continue;
        }
        NSNumber *groupId = [product objectForKey:SymphoxAPIParam_cprg_num];
        
        NSDictionary *purchaseInfo = [dictionaryAddition objectForKey:productId];
        NSNumber *quantity = nil;
        if (purchaseInfo == nil)
        {
            quantity = [NSNumber numberWithInteger:1];
        }
        else
        {
            quantity = [purchaseInfo objectForKey:SymphoxAPIParam_qty];
        }
        NSDictionary *dictionaryMode = [purchaseInfo objectForKey:SymphoxAPIParam_payment_mode];
        if (dictionaryMode == nil)
        {
            dictionaryMode = [NSDictionary dictionaryWithObjectsAndKeys:@"0", SymphoxAPIParam_payment_type, [NSNumber numberWithInteger:0], SymphoxAPIParam_price, nil];
        }
        NSNumber *realProductId = [purchaseInfo objectForKey:SymphoxAPIParam_real_cpdt_num];
        if (realProductId)
        {
            productId = realProductId;
        }
        
        NSMutableDictionary *dictionaryCheck = [NSMutableDictionary dictionary];
        [dictionaryCheck setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        if (groupId && [groupId isEqual:[NSNull null]] == NO)
        {
            [dictionaryCheck setObject:groupId forKey:SymphoxAPIParam_group_id];
        }
        [dictionaryCheck setObject:quantity forKey:SymphoxAPIParam_qty];
        [dictionaryCheck setObject:dictionaryMode forKey:SymphoxAPIParam_payment_mode];
        [arrayCheck addObject:dictionaryCheck];
    }
    
    [self requestResultForRenewConditionsOfProducts:arrayCheck ofCartType:type shouldShowPaymentForProductId:productId];
}

- (void)requestResultForRenewConditionsOfProducts:(NSArray *)productConditions ofCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId
{
    NSNumber *userIdentifier = [TMInfoManager sharedManager].userIdentifier;
    if (userIdentifier == nil)
        return;
    __weak AdditionalPurchaseViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_renewProductConditions];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSString *stringCartType = [[NSNumber numberWithInteger:type] stringValue];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userIdentifier, SymphoxAPIParam_user_num, productConditions, SymphoxAPIParam_cart_item_order, stringCartType, SymphoxAPIParam_cart_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
            //            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"requestResultForRenewConditionsOfProducts:\n%@", string);
                if ([weakSelf processRenewConditionsResult:data inCart:type])
                {
                    // Should start calculate product promotion according to quantity
                    [weakSelf refreshContent];
                    
                    if (productId != nil)
                    {
                        [weakSelf presentPaymentSelectionViewForProductId:productId];
                    }
                }
                else
                {
                    NSLog(@"requestResultForRenewConditionsOfProducts - Cannot process data");
                }
            }
            else
            {
                NSLog(@"requestResultForRenewConditionsOfProducts - Unexpected data format.");
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString CannotLoadData];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
                NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                if (serverMessage)
                {
                    errorMessage = serverMessage;
                }
            }
            NSLog(@"requestResultForRenewConditionsOfProducts - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:NO];
    }];
}

- (BOOL)processRenewConditionsResult:(id)result inCart:(CartType)type
{
    BOOL success = NO;
    
    if ([result isKindOfClass:[NSData class]] == NO)
        return success;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:result options:0 error:&error];
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"jsonObject:\n%@", [jsonObject description]);
        NSDictionary *resultDictionary = (NSDictionary *)jsonObject;
        [self.dictionaryTotal removeAllObjects];
        [self.arrayAllProducts removeAllObjects];
        [self.dictionaryAll removeAllObjects];
        
        [self.dictionaryAll setDictionary:resultDictionary];
        NSDictionary *summary = [resultDictionary objectForKey:SymphoxAPIParam_account_result];
        if (summary)
        {
            [self.dictionaryTotal setDictionary:summary];
        }
        NSArray *array = [resultDictionary objectForKey:SymphoxAPIParam_cart_item];
        if (array)
        {
            [self.arrayAllProducts setArray:array];
            NSDictionary *dictionaryAddition = [[TMInfoManager sharedManager] purchaseInfoForAdditionalCartType:type];
            for (NSDictionary *product in array)
            {
                NSNumber *cpdt_num = [product objectForKey:SymphoxAPIParam_cpdt_num];
                if (cpdt_num == nil || [cpdt_num isEqual:[NSNull null]])
                    continue;
                BOOL isAddition = ([dictionaryAddition objectForKey:cpdt_num] != nil);
                NSNumber *qty = [product objectForKey:SymphoxAPIParam_qty];
                if (qty && [qty isEqual:[NSNull null]] == NO)
                {
                    if (isAddition)
                    {
                        [[TMInfoManager sharedManager] setPurchaseQuantity:qty forProduct:cpdt_num inAdditionalCart:type];
                    }
                    else
                    {
                        [[TMInfoManager sharedManager] setPurchaseQuantity:qty forProduct:cpdt_num inCart:type];
                    }
                }
                NSDictionary *used_payemnt_mode = [product objectForKey:SymphoxAPIParam_used_payment_mode];
                if (used_payemnt_mode && [used_payemnt_mode isEqual:[NSNull null]] == NO)
                {
                    NSNumber *real_cpdt_num = [used_payemnt_mode objectForKey:SymphoxAPIParam_cpdt_num];
                    if (real_cpdt_num == nil || [real_cpdt_num isEqual:[NSNull null]])
                    {
                        real_cpdt_num = cpdt_num;
                    }
                    [[TMInfoManager sharedManager] setPurchaseInfoFromSelectedPaymentMode:used_payemnt_mode forProductId:cpdt_num withRealProductId:real_cpdt_num inCart:type asAdditional:isAddition];
                }
                BOOL shouldAddProduct = YES;
                for (NSDictionary *productFromCart in self.arrayProductsFromCart)
                {
                    NSNumber *cpdt_num_fromCart = [productFromCart objectForKey:SymphoxAPIParam_cpdt_num];
                    if ([cpdt_num_fromCart isEqualToNumber:cpdt_num])
                    {
                        shouldAddProduct = NO;
                        break;
                    }
                }
                if (shouldAddProduct && (isAddition == NO))
                {
                    [self.arrayProductsFromCart addObject:product];
                }
            }
        }
        success = YES;
    }
    
    return success;
}

- (void)refreshContent
{
    [self.collectionView reloadData];
    
    [self refreshBottomBar];
}

- (void)refreshBottomBar
{
    NSNumber *totalPoint = [self.dictionaryTotal objectForKey:SymphoxAPIParam_total_Point];
    if ([totalPoint isEqual:[NSNull null]])
    {
        totalPoint = nil;
    }
    NSNumber *totalCash = [self.dictionaryTotal objectForKey:SymphoxAPIParam_total_cash];
    if ([totalCash isEqual:[NSNull null]])
    {
        totalCash = nil;
    }
    NSNumber *totalCathayCash = [self.dictionaryTotal objectForKey:SymphoxAPIParam_total_cathay_cash];
    if ([totalCathayCash isEqual:[NSNull null]])
    {
        totalCathayCash = nil;
    }
    NSNumber *totalEpoint = [self.dictionaryTotal objectForKey:SymphoxAPIParam_total_ePoint];
    if ([totalEpoint isEqual:[NSNull null]])
    {
        totalEpoint = nil;
    }
    NSDictionary *attributeGray = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil];
    NSDictionary *attributeOrange = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:[LocalizedString Total_C] attributes:attributeGray];
    NSAttributedString *plusString = [[NSAttributedString alloc] initWithString:@"＋" attributes:attributeGray];
    NSInteger originLength = [totalString length];
    if (totalCash != nil && [totalCash integerValue] > 0)
    {
        NSString *stringTotal = [self.numberFormatter stringFromNumber:totalCash];
        NSString *string = [NSString stringWithFormat:@"＄%@", stringTotal];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributeOrange];
        [totalString appendAttributedString:attrString];
    }
    if (totalEpoint != nil && [totalEpoint integerValue] > 0)
    {
        if ([totalString length] > originLength)
        {
            [totalString appendAttributedString:plusString];
        }
        NSString *stringTotal = [self.numberFormatter stringFromNumber:totalEpoint];
        NSString *string = [NSString stringWithFormat:@"%@%@", stringTotal, [LocalizedString Point]];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributeOrange];
        [totalString appendAttributedString:attrString];
    }
    if ([totalString length] == originLength)
    {
        NSString *stringTotal = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:0]];
        NSString *string = [NSString stringWithFormat:@"＄%@", stringTotal];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributeOrange];
        [totalString appendAttributedString:attrString];
    }
    [self.bottomBar.label setAttributedText:totalString];
}

- (void)presentPaymentSelectionViewForProductId:(NSNumber *)productId
{
    if (productId == nil)
        return;
    NSDictionary *product = nil;
    for (NSDictionary *dictionary in self.arrayAllProducts)
    {
        NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO && [cpdt_num isEqualToNumber:productId])
        {
            product = dictionary;
            break;
        }
    }
    if (product == nil)
        return;
    
    NSArray *payment_mode_list = [product objectForKey:SymphoxAPIParam_payment_mode_list];
    if (payment_mode_list == nil || [payment_mode_list isEqual:[NSNull null]])
        return;
    DiscountViewController *viewController = [[DiscountViewController alloc] initWithNibName:@"DiscountViewController" bundle:[NSBundle mainBundle]];
    viewController.productId = productId;
    viewController.arrayPaymentMode = payment_mode_list;
    viewController.type = self.currentType;
    viewController.isAddition = YES;
    viewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)finalCheckCartContentForCartType:(CartType)type canPurchaseFastDelivery:(BOOL)canPurchaseFastDelivery
{
    NSArray *array = self.arrayProductsFromCart;
    if (array == nil || [array count] == 0)
    {
        array = [[TMInfoManager sharedManager] productArrayForCartType:type];
    }
    if (array == nil)
        return;
    
    NSDictionary *dictionary = [[TMInfoManager sharedManager] purchaseInfoForCartType:type];
    
    NSMutableArray *arrayCheck = [NSMutableArray array];
    
    for (NSDictionary *product in array)
    {
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId == nil)
        {
            continue;
        }
        NSDictionary *purchaseInfo = [dictionary objectForKey:productId];
        NSNumber *quantity = nil;
        if (purchaseInfo == nil)
        {
            quantity = [NSNumber numberWithInteger:1];
        }
        else
        {
            quantity = [purchaseInfo objectForKey:SymphoxAPIParam_qty];
        }
        NSDictionary *dictionaryMode = [purchaseInfo objectForKey:SymphoxAPIParam_payment_mode];
        if (dictionaryMode == nil)
        {
            dictionaryMode = [NSDictionary dictionaryWithObjectsAndKeys:@"0", SymphoxAPIParam_payment_type, [NSNumber numberWithInteger:0], SymphoxAPIParam_price, nil];
        }
        NSNumber *realProductId = [purchaseInfo objectForKey:SymphoxAPIParam_real_cpdt_num];
        if (realProductId)
        {
            productId = realProductId;
        }
        NSNumber *groupId = [purchaseInfo objectForKey:SymphoxAPIParam_group_id];
        
        
        NSMutableDictionary *dictionaryCheck = [NSMutableDictionary dictionary];
        [dictionaryCheck setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        [dictionaryCheck setObject:quantity forKey:SymphoxAPIParam_qty];
        [dictionaryCheck setObject:dictionaryMode forKey:SymphoxAPIParam_payment_mode];
        if (groupId && [groupId isEqual:[NSNull null]] == NO)
        {
            [dictionaryCheck setObject:groupId forKey:SymphoxAPIParam_group_id];
        }
        [arrayCheck addObject:dictionaryCheck];
    }
    
    NSArray *arrayAddition = [[TMInfoManager sharedManager] productArrayForAdditionalCartType:type];
    NSDictionary *dictionaryAddition = [[TMInfoManager sharedManager] purchaseInfoForAdditionalCartType:type];
    
    for (NSDictionary *product in arrayAddition)
    {
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId == nil)
        {
            continue;
        }
        NSNumber *groupId = [product objectForKey:SymphoxAPIParam_cprg_num];
        
        NSDictionary *purchaseInfo = [dictionaryAddition objectForKey:productId];
        NSNumber *quantity = nil;
        if (purchaseInfo == nil)
        {
            quantity = [NSNumber numberWithInteger:1];
        }
        else
        {
            quantity = [purchaseInfo objectForKey:SymphoxAPIParam_qty];
        }
        NSDictionary *dictionaryMode = [purchaseInfo objectForKey:SymphoxAPIParam_payment_mode];
        if (dictionaryMode == nil)
        {
            dictionaryMode = [NSDictionary dictionaryWithObjectsAndKeys:@"0", SymphoxAPIParam_payment_type, [NSNumber numberWithInteger:0], SymphoxAPIParam_price, nil];
        }
        NSNumber *realProductId = [purchaseInfo objectForKey:SymphoxAPIParam_real_cpdt_num];
        if (realProductId)
        {
            productId = realProductId;
        }
        
        NSMutableDictionary *dictionaryCheck = [NSMutableDictionary dictionary];
        [dictionaryCheck setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        if (groupId && [groupId isEqual:[NSNull null]] == NO)
        {
            [dictionaryCheck setObject:groupId forKey:SymphoxAPIParam_group_id];
        }
        [dictionaryCheck setObject:quantity forKey:SymphoxAPIParam_qty];
        [dictionaryCheck setObject:dictionaryMode forKey:SymphoxAPIParam_payment_mode];
        [arrayCheck addObject:dictionaryCheck];
    }
    if (type == CartTypeFastDelivery)
    {
        NSDictionary *productFastDelivery = [TMInfoManager sharedManager].productFastDelivery;
        if (productFastDelivery != nil)
        {
            [arrayCheck addObject:productFastDelivery];
        }
    }
    
    [self requestFinalCheckProducts:arrayCheck inCart:type canPurchaseFastDelivery:canPurchaseFastDelivery];
}

- (void)requestFinalCheckProducts:(NSArray *)products inCart:(CartType)type canPurchaseFastDelivery:(BOOL)canPurchaseFastDelivery
{
    NSNumber *userIdentifier = [TMInfoManager sharedManager].userIdentifier;
    if (userIdentifier == nil)
        return;
    __weak AdditionalPurchaseViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_finalCheckProductsInCart];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSString *stringCartType = [[NSNumber numberWithInteger:type] stringValue];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userIdentifier, SymphoxAPIParam_user_num, products, SymphoxAPIParam_cart_item_order, stringCartType, SymphoxAPIParam_cart_type, nil];
    [self showLoadingViewAnimated:YES];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
            //            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"requestFinalCheckProducts:\n%@", string);
                NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSArray *cart_items = [resultDictionary objectForKey:SymphoxAPIParam_cart_item];
                if (error == nil)
                {
                    if (weakSelf.currentType == CartTypeFastDelivery)
                    {
//                        NSArray *cart_items = [resultDictionary objectForKey:SymphoxAPIParam_cart_item];
                        if (cart_items && [cart_items isEqual:[NSNull null]] == NO)
                        {
                            [[TMInfoManager sharedManager] updateProductInfoForFastDeliveryFromInfos:cart_items];
                        }
                    }
                    
                    PaymentTypeViewController *viewController = [[PaymentTypeViewController alloc] initWithNibName:@"PaymentTypeViewController" bundle:[NSBundle mainBundle]];
                    viewController.dictionaryData = resultDictionary;
                    viewController.arrayProductsFromCart = weakSelf.arrayProductsFromCart;
                    viewController.type = type;
                    [viewController setHidesBottomBarWhenPushed:YES];

                    [gaTracker send:[[GAIDictionaryBuilder
                                      createEventWithCategory:[EventLog twoString:self.title _:logPara_下一步]
                                      action:[EventLog to_:viewController.title]
                                      label:nil
                                      value:nil] build]];
                    
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                else
                {
                    NSLog(@"requestResultForRenewConditionsOfProducts - error:\n%@", [error description]);
                }
            }
            else
            {
                NSLog(@"requestResultForRenewConditionsOfProducts - Unexpected data format.");
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString CannotLoadData];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
                NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                if (serverMessage)
                {
                    errorMessage = serverMessage;
                }
            }
            NSLog(@"requestResultForRenewConditionsOfProducts - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:NO];
    }];
}

- (void)showQuantityInputViewForProduct:(NSDictionary *)product atIndex:(NSInteger)index
{
    if (product == nil)
        return;
    NSNumber *maxSellQty = [product objectForKey:SymphoxAPIParam_storage];
    
    NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
    
    NSDictionary *purchaseInfos = [[TMInfoManager sharedManager] purchaseInfoForAdditionalCartType:self.currentType];
    NSNumber *quantity = nil;
    if (productId && [productId isEqual:[NSNull null]] == NO)
    {
        NSDictionary *purchaseInfo = [purchaseInfos objectForKey:productId];
        if (purchaseInfo)
        {
            quantity = [purchaseInfo objectForKey:SymphoxAPIParam_qty];
        }
    }
    if (quantity && [quantity unsignedShortValue] > 0)
    {
        self.viewQuantityInput.currentValue = [quantity unsignedIntegerValue];
    }
    if (maxSellQty && [maxSellQty isEqual:[NSNull null]] == NO)
    {
        self.viewQuantityInput.maxValue = [maxSellQty unsignedIntegerValue];
    }
    
    NSString * name = [product objectForKey:SymphoxAPIParam_cpdt_name];
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:self.title _:logPara_直接購買]
                      action:logPara_點擊
                      label:[EventLog twoString:[productId stringValue] _:name]
                      value:nil] build]];
    
    self.viewQuantityInput.tag = index;
    [self.viewQuantityInput show];
}

- (BOOL)isGiftProduct:(NSDictionary *)product
{
    BOOL isGift = NO;
    
    NSString *cpdt_owner_num = [product objectForKey:SymphoxAPIParam_cpdt_owner_num];
    if ([cpdt_owner_num integerValue] == 4)
    {
        isGift = YES;
    }
    
    return isGift;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = [self.arrayProducts count];
    return numberOfItems;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = nil;
    if (indexPath.section == 0)
    {
        SingleLabelCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SingleLabelCollectionReusableViewIdentifier forIndexPath:indexPath];
        if ([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            view.label.text = self.marketingDescription;
        }
        headerView = view;
    }
    return headerView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AdditionalProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AdditionalProductCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    if (cell.delegate == nil)
    {
        cell.delegate = self;
    }
    
    NSString *textName = @"";
    NSString *textMarketing = @"";
    NSURL *url = nil;
    NSString *textPrice = @"";
    NSString *buttonTitle = [LocalizedString Purchase];
    if (indexPath.row < [self.arrayProducts count])
    {
        NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        if (name && [name isEqual:[NSNull null]] == NO)
        {
            textName = name;
        }
        NSString *marketing = [dictionary objectForKey:@"martket_name"];
        if (marketing && [marketing isEqual:[NSNull null]] == NO)
        {
            textMarketing = marketing;
        }
        NSString *imagePath = [dictionary objectForKey:SymphoxAPIParam_img_url];
        if (imagePath && [imagePath isEqual:[NSNull null]] == NO)
        {
            url = [NSURL URLWithString:imagePath];
        }
        NSNumber *price = [dictionary objectForKey:SymphoxAPIParam_price];
        if (price && [price isEqual:[NSNull null]] == NO)
        {
            NSString *stringPrice = [self.formatter stringFromNumber:price];
            if (stringPrice)
            {
                textPrice = [NSString stringWithFormat:@"＄%@", stringPrice];
            }
        }
        NSNumber *productId = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId && [productId isEqual:[NSNull null]] == NO)
        {
            NSMutableDictionary *purchaseInfos = [[TMInfoManager sharedManager] purchaseInfoForAdditionalCartType:self.currentType];
            NSDictionary *singlePurchaseInfo = [purchaseInfos objectForKey:productId];
            if (singlePurchaseInfo)
            {
                NSNumber *quantity = [singlePurchaseInfo objectForKey:SymphoxAPIParam_qty];
                if (quantity)
                {
                    buttonTitle = [NSString stringWithFormat:[LocalizedString AlreadyPurchase_I_Piece], (long)[quantity integerValue]];
                }
            }
        }
    }
    
    cell.labelMarketing.attributedText = [[NSAttributedString alloc] initWithString:textMarketing attributes:cell.attributesMarketName];
    cell.labelName.attributedText = [[NSAttributedString alloc] initWithString:textName attributes:cell.attributesText];
    cell.imageUrl = url;
    cell.labelPrice.text = textPrice;
    [cell.buttonPurchase setTitle:buttonTitle forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat maxWidth = collectionView.frame.size.width;
    CGFloat height = [SingleLabelCollectionReusableView heightForText:self.marketingDescription inViewWithWidth:maxWidth];
    CGSize size = CGSizeMake(maxWidth, height);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    CGSize itemSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    NSInteger column = floor(collectionView.frame.size.width / itemSize.width);
    CGFloat totalCellWidth = itemSize.width * column;
    CGFloat totalInterval = collectionView.frame.size.width - totalCellWidth;
    CGFloat singleInterval = totalInterval / (column + 1);
    edgeInsets.left = singleInterval;
    edgeInsets.right = singleInterval;
    return edgeInsets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat cellWidth = 150.0;
//    NSString *textName = @"";
//    NSString *textMarketing = @"";
//    NSString *textPrice = @"";
//    if (indexPath.row < [self.arrayProducts count])
//    {
//        NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
//        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
//        if (name && [name isEqual:[NSNull null]] == NO)
//        {
//            textName = name;
//        }
//        NSString *marketing = [dictionary objectForKey:@"martket_name"];
//        if (marketing && [marketing isEqual:[NSNull null]] == NO)
//        {
//            textMarketing = marketing;
//        }
//        NSNumber *price = [dictionary objectForKey:SymphoxAPIParam_price];
//        if (price && [price isEqual:[NSNull null]] == NO)
//        {
//            NSString *stringPrice = [self.formatter stringFromNumber:price];
//            if (stringPrice)
//            {
//                textPrice = [NSString stringWithFormat:@"＄%@", stringPrice];
//            }
//        }
//    }
//    CGFloat heightForItem = [AdditionalProductCollectionViewCell cellHeightForWidth:cellWidth containsMarketName:textMarketing productName:textName andPrice:textPrice];
//    NSLog(@"heightForItem[%li][%4.2f]", (long)indexPath.row, heightForItem);
    CGSize cellSize = CGSizeMake(150.0, 310.0);
    return cellSize;
}

#pragma mark - AdditionalProductCollectionViewCellDelegate

- (void)additionalProductCollectionViewCell:(AdditionalProductCollectionViewCell *)cell didSelectPurchaseBySender:(id)sender
{
    if (cell.tag >= [self.arrayProducts count])
        return;
    NSDictionary *product = [self.arrayProducts objectAtIndex:cell.tag];
    
    [self showQuantityInputViewForProduct:product atIndex:cell.tag];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numberOfRows = 0;
    if (pickerView.tag < [self.arrayProducts count])
    {
        NSDictionary *product = [self.arrayProducts objectAtIndex:pickerView.tag];
        NSNumber *maxSellQty = [product objectForKey:SymphoxAPIParam_storage];
        if (maxSellQty && ([maxSellQty isEqual:[NSNull null]] == NO))
        {
            numberOfRows = [maxSellQty integerValue];
        }
    }
    return numberOfRows;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [NSString stringWithFormat:@"%li", ((long)row + 1)];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SHPickerView *shPickerView = (SHPickerView *)pickerView;
    if (shPickerView.owner == nil)
        return;
    if ([shPickerView.owner isKindOfClass:[UITextField class]])
    {
        UITextField *textField = shPickerView.owner;
        textField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
}

#pragma mark - LabelButtonViewDelegate

- (void)labelButtonView:(LabelButtonView *)view didPressButton:(id)sender
{
    // If cart type is CartTypeFastDelivery, should check if the condition is matched to use Fast Delivery.
    // Otherwise, present payment type.
    BOOL reachLimit = YES;
    NSInteger threshold = 290;
    NSArray *arrayFastService = nil;
    NSArray *array_delivery_limit = [self.dictionaryAll objectForKey:SymphoxAPIParam_delivery_limit];
    if (array_delivery_limit && [array_delivery_limit isEqual:[NSNull null]] == NO && [array_delivery_limit count] > 0)
    {
        for (NSDictionary *delivery_limit in array_delivery_limit)
        {
            NSString *limit_Type = [delivery_limit objectForKey:SymphoxAPIParam_limit_Type];
            if (limit_Type == nil || [limit_Type isEqual:[NSNull null]])
                continue;
            if (self.currentType == CartTypeStorePickup && [limit_Type integerValue] != 1)
                continue;
            if (self.currentType == CartTypeFastDelivery && [limit_Type integerValue] != 2)
                continue;
            NSString *reach_limit = [delivery_limit objectForKey:SymphoxAPIParam_reach_limit];
            if (reach_limit == nil || [reach_limit isEqual:[NSNull null]])
                continue;
            reachLimit = [reach_limit boolValue];
            NSString *numberThreshold = [delivery_limit objectForKey:SymphoxAPIParam_doorsill];
            if (numberThreshold && [numberThreshold isEqual:[NSNull null]] == NO)
            {
                threshold = [numberThreshold integerValue];
            }
            NSArray *payment_mode_list = [delivery_limit objectForKey:SymphoxAPIParam_payment_mode_list];
            if (payment_mode_list && [payment_mode_list isEqual:[NSNull null]] == NO)
            {
                arrayFastService = payment_mode_list;
            }
            break;
        }
    }
    if (reachLimit == NO)
    {
        __weak AdditionalPurchaseViewController *weakSelf = self;
        if (self.currentType == CartTypeFastDelivery)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            for (NSDictionary *fastService in arrayFastService)
            {
                NSMutableString *totalString = [NSMutableString string];
                NSNumber *price = [fastService objectForKey:SymphoxAPIParam_price];
                if (price && [price isEqual:[NSNull null]] == NO && [price integerValue] > 0)
                {
                    [totalString appendFormat:@"%li%@", (long)[price integerValue], [LocalizedString Dollars]];
                }
                NSNumber *total_point = [fastService objectForKey:SymphoxAPIParam_total_point];
                if (total_point && [total_point isEqual:[NSNull null]] == NO && [total_point integerValue] > 0)
                {
                    if ([totalString length] > 0)
                    {
                        [totalString appendString:@"＋"];
                    }
                    [totalString appendFormat:@"%li%@", (long)[total_point integerValue], [LocalizedString Point]];
                }
                [totalString appendString:[LocalizedString PurchaseFastDelivery]];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:totalString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [TMInfoManager sharedManager].productFastDelivery = [[TMInfoManager sharedManager] productFastDeliveryFromReferenceDictionary:fastService];
                    [weakSelf finalCheckCartContentForCartType:weakSelf.currentType canPurchaseFastDelivery:NO];
                }];
                [alertController addAction:action];
            }
            
            UIAlertAction *actionShopping = [UIAlertAction actionWithTitle:[LocalizedString ContinueToShopping] style:UIAlertActionStyleDefault handler:nil];
            
            UIAlertAction *actionCheckout = [UIAlertAction actionWithTitle:[LocalizedString CheckOutDirectly] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [TMInfoManager sharedManager].productFastDelivery = nil;
                [weakSelf finalCheckCartContentForCartType:weakSelf.currentType canPurchaseFastDelivery:NO];
            }];
            [alertController addAction:actionShopping];
            [alertController addAction:actionCheckout];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            });
        }
        else if (self.currentType == CartTypeStorePickup)
        {
            NSString *message = [NSString stringWithFormat:[LocalizedString StorePickupShouldReachLimit], (long)threshold];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            });
        }
    }
    else
    {
        [self finalCheckCartContentForCartType:self.currentType canPurchaseFastDelivery:NO];
    }
}

#pragma mark - DiscountViewControllerDelegate

- (void)didDismissDiscountViewController:(DiscountViewController *)discountViewController
{
    [self checkCartForType:self.currentType shouldShowPaymentForProductId:nil];
}

#pragma mark - FullScreenSelectNumberViewDelegate

- (void)fullScreenSelectNumberView:(FullScreenSelectNumberView *)view didSelectNumberAsString:(NSString *)stringNumber
{
    NSDictionary *product = [self.arrayProducts objectAtIndex:view.tag];
    NSString *text = stringNumber;
    if (text == nil || [text length] == 0)
    {
        text = @"1";
    }
    
    NSNumber *quantity = [NSNumber numberWithInteger:[text integerValue]];
    NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
    if (productId && quantity)
    {
        if ([quantity integerValue] == 0)
        {
            NSString *productName = [[TMInfoManager sharedManager] nameOfRemovedProductId:productId inAdditionalCart:self.currentType];
            NSLog(@"Product[%@] removed from cart.", productName);
        }
        else
        {
            [[TMInfoManager sharedManager] addProduct:product toAdditionalCartForType:self.currentType];
            [[TMInfoManager sharedManager] setPurchaseQuantity:quantity forProduct:productId inAdditionalCart:self.currentType];
        }
    }
    [self checkCartForType:self.currentType shouldShowPaymentForProductId:productId];
}

@end
