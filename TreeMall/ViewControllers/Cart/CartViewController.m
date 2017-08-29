//
//  CartViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CartViewController.h"
#import "LocalizedString.h"
#import "Definition.h"
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "TMInfoManager.h"
#import "DiscountViewController.h"
#import "PaymentTypeViewController.h"
#import "AdditionalPurchaseViewController.h"
#import "LocalizedString.h"
#import <Google/Analytics.h>
#import "EventLog.h"
#import "ProductDetailViewController.h"

@import FirebaseCrash;

@interface CartViewController () {
    id<GAITracker> gaTracker;
}

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)checkCartForType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId;
- (void)requestResultForCheckingProducts:(NSArray *)products ofCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId;
- (BOOL)processCheckingResult:(id)result inCart:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId;
- (void)renewConditionsForCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId;
- (void)requestResultForRenewConditionsOfProducts:(NSArray *)productConditions ofCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId;
- (BOOL)processRenewConditionsResult:(id)result inCart:(CartType)type;
- (void)checkAdditionalPurchaseForType:(CartType)type;
- (void)requestResultForCheckingAdditionalPurchaseForProducts:(NSArray *)products ofCartType:(CartType)type;
- (NSArray *)arrayOfAdditionalPurchaseFromResult:(id)result inCart:(CartType)type;
- (void)finalCheckCartContentForCartType:(CartType)type canPurchaseFastDelivery:(BOOL)canPurchaseFastDelivery;
- (void)requestFinalCheckProducts:(NSArray *)products inCart:(CartType)type canPurchaseFastDelivery:(BOOL)canPurchaseFastDelivery;
- (void)refreshContent;
- (void)refreshBottomBar;
- (void)resetBottomBar;
- (void)presentPaymentSelectionViewForProductId:(NSNumber *)productId;
- (CartUIType)cartUITypeForCartType:(CartType)cartType;
- (void)setSegmentedControlIndexForCartType:(CartType)type;
- (BOOL)isConditionSelectedForIdentifier:(NSNumber *)productIdentifier;
- (NSString *)paymentDetailForIdentifier:(NSNumber *)productIdentifier;
- (NSNumber *)quantityForIdentifier:(NSNumber *)productIdentifier;
- (NSString *)textForCartType:(CartType)cartType;
- (void)showQuantityInputViewForProduct:(NSDictionary *)product atIndex:(NSInteger)index;
- (BOOL)isGiftProduct:(NSDictionary *)product;

- (void)buttonItemClosePressed:(id)sender;
- (void)handlerOfCartContentChangedNotification:(NSNotification *)notification;

@end

@implementation CartViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _currentType = CartTypeTotal;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    
    [self.view addSubview:self.segmentedView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBar];
    
    if (self.currentType == CartTypeDirectlyPurchase || self.currentType == CartTypeVisitGift)
    {
        self.segmentedView.hidden = YES;
    }
    else
    {
        self.segmentedView.hidden = NO;
    }
    
    
    if (self.navigationController.tabBarController != nil)
    {
        [self.navigationController.tabBarController.view addSubview:self.viewLoading];
        [self.navigationController.tabBarController.view addSubview:self.viewQuantityInput];
    }
    else if (self.navigationController.presentingViewController != nil)
    {
        [self.navigationController.view addSubview:self.viewLoading];
        [self.navigationController.view addSubview:self.viewQuantityInput];
        
        UIImage *image = [[UIImage imageNamed:@"car_popup_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemClosePressed:)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfCartContentChangedNotification:) name:PostNotificationName_CartContentChanged object:nil];

    gaTracker = [GAI sharedInstance].defaultTracker;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.currentType == CartTypeTotal)
    {
        self.currentType = CartTypeCommonDelivery;
    }
    if (self.currentType != CartTypeDirectlyPurchase && self.currentType != CartTypeVisitGift)
    {
        [self setSegmentedControlIndexForCartType:self.currentType];
    }
    [[TMInfoManager sharedManager] initializeCartForType:self.currentType];
    [self.arrayProducts removeAllObjects];
    
    [self checkCartForType:self.currentType shouldShowPaymentForProductId:nil];

    // GA screen log
    [gaTracker set:kGAIScreenName value:self.title];
    [gaTracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_CartContentChanged object:nil];
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
    
    CGFloat marginT = 10.0;
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat intervalV = 10.0;
    CGFloat originY = marginT;
    
    if (self.segmentedView)
    {
        CGRect frame = CGRectMake(marginL, originY, (self.view.frame.size.width - marginL - marginR), 40.0);
        self.segmentedView.frame = frame;
        originY = self.segmentedView.frame.origin.y + self.segmentedView.frame.size.height + intervalV;
    }
    
    if (self.bottomBar)
    {
        CGFloat height = 50.0;
        CGRect frame = CGRectMake(0.0, self.view.frame.size.height - height, self.view.frame.size.width, height);
        self.bottomBar.frame = frame;
    }
    
    if (self.currentType == CartTypeDirectlyPurchase || self.currentType == CartTypeVisitGift)
    {
        originY = 0.0;
    }
    
    if (self.tableView)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, CGRectGetMinY(self.bottomBar.frame) - originY);
        self.tableView.frame = frame;
        if (self.labelNoContent)
        {
            CGRect frame = CGRectMake(0.0, self.tableView.frame.size.height * 2 / 3, self.tableView.frame.size.width, 30.0);
            self.labelNoContent.frame = frame;
        }
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

- (SemiCircleEndsSegmentedView *)segmentedView
{
    if (_segmentedView == nil)
    {
        NSMutableArray *items = [NSMutableArray array];
        for (NSInteger index = CartUITypeStart; index < CartUITypeTotal; index++)
        {
            switch (index) {
                case CartUITypeCommonDelivery:
                {
                    [items addObject:[self textForCartType:CartTypeCommonDelivery]];
                }
                    break;
                case CartUITypeFastDelivery:
                {
                    [items addObject:[self textForCartType:CartTypeFastDelivery]];
                }
                    break;
                case CartUITypeStorePickup:
                {
                    [items addObject:[self textForCartType:CartTypeStorePickup]];
                }
                    break;
                
                default:
                    break;
            }
        }
        _segmentedView = [[SemiCircleEndsSegmentedView alloc] initWithFrame:CGRectZero andItems:items];
        [_segmentedView setDelegate:self];
        [_segmentedView setTintColor:TMMainColor];
    }
    return _segmentedView;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView registerClass:[CartProductTableViewCell class] forCellReuseIdentifier:CartProductTableViewCellIdentifier];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
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

- (NSMutableArray *)arrayProducts
{
    if (_arrayProducts == nil)
    {
        _arrayProducts = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayProducts;
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

- (NSNumberFormatter *)numberFormatter
{
    if (_numberFormatter == nil)
    {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _numberFormatter;
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
        [_labelNoContent setText:[LocalizedString NoProductInCart]];
        [_labelNoContent setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelNoContent;
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

- (FullScreenSelectNumberView *)viewQuantityInput
{
    if (_viewQuantityInput == nil)
    {
        _viewQuantityInput = [[FullScreenSelectNumberView alloc] initWithFrame:CGRectZero];
        _viewQuantityInput.delegate = self;
        [_viewQuantityInput setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        _viewQuantityInput.alpha = 0.0;
    }
    return _viewQuantityInput;
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
    NSArray *array = self.arrayProducts;
    if (array == nil || [array count] == 0)
    {
        array = [[TMInfoManager sharedManager] productArrayForCartType:type];
    }
    if (array == nil || [array count] == 0)
    {
        [self.arrayProducts removeAllObjects];
        [self.tableView setBackgroundView:self.tableBackgroundView];
        [self.tableView reloadData];
        [self resetBottomBar];
        return;
    }
    [self.tableView setBackgroundView:nil];
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
    [self requestResultForCheckingProducts:arrayCheck ofCartType:type shouldShowPaymentForProductId:productId];
}

- (void)requestResultForCheckingProducts:(NSArray *)products ofCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId
{
    __weak CartViewController *weakSelf = self;
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
//            [weakSelf refreshContent];
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
            [weakSelf refreshContent];
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
//                    NSLog(@"arrayCartFast:\n%@", [[TMInfoManager sharedManager].arrayCartFast description]);
//                    NSLog(@"dictionaryProductPurchaseInfoInCartFast:\n%@", [[TMInfoManager sharedManager].dictionaryProductPurchaseInfoInCartFast description]);
                    NSString *name = [[TMInfoManager sharedManager] nameOfRemovedProductId:productId inCart:type];
                    if (name)
                    {
                        NSString *totalString = [NSString stringWithFormat:@"%@：%@\n", name, stringError];
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
                __weak CartViewController *weakSelf = self;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString ProductsRemovedFromCart] message:notifyString preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [weakSelf renewConditionsForCartType:type shouldShowPaymentForProductId:productId];
                }];
                [alertController addAction:actionConfirm];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf presentViewController:alertController animated:YES completion:nil];
                });
            }
        }
    }
    return success;
}

- (void)renewConditionsForCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId
{
    NSArray *array = self.arrayProducts;
    if (array == nil || [array count] == 0)
    {
        array = [[TMInfoManager sharedManager] productArrayForCartType:type];
    }
    if (array == nil || [array count] == 0)
    {
        [self.arrayProducts removeAllObjects];
        [self.tableView setBackgroundView:self.tableBackgroundView];
        [self.tableView reloadData];
        [self resetBottomBar];
        return;
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
    [self requestResultForRenewConditionsOfProducts:arrayCheck ofCartType:type shouldShowPaymentForProductId:productId];
}

- (void)requestResultForRenewConditionsOfProducts:(NSArray *)productConditions ofCartType:(CartType)type shouldShowPaymentForProductId:(NSNumber *)productId
{
    NSNumber *userIdentifier = [TMInfoManager sharedManager].userIdentifier;
    if (userIdentifier == nil)
        return;
    __weak CartViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_renewProductConditions];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSString *stringCartType = [[NSNumber numberWithInteger:type] stringValue];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userIdentifier, SymphoxAPIParam_user_num, productConditions, SymphoxAPIParam_cart_item_order, stringCartType, SymphoxAPIParam_cart_type, nil];
    [self showLoadingViewAnimated:YES];
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
            [weakSelf refreshContent];
        }
        else
        {
            NSString *errorMessage = [LocalizedString CannotLoadData];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
//                NSString *errorCode = [userInfo objectForKey:SymphoxAPIParam_id];
//                if ([errorCode isEqualToString:@"E217"] || [errorCode isEqualToString:@"E403"] || [errorCode isEqualToString:@"E416"] || [errorCode isEqualToString:@"E402"] || [errorCode isEqualToString:@"E400"] || [errorCode isEqualToString:@"E999"])
//                {
//                    for (NSDictionary *product in productConditions)
//                    {
//                        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
//                        if (productId && [productId isEqual:[NSNull null]] == NO)
//                        {
//                            [[TMInfoManager sharedManager] nameOfRemovedProductId:productId inCart:type];
//                        }
//                    }
//                    [self.arrayProducts removeAllObjects];
//                }
                NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                if (serverMessage)
                {
                    errorMessage = serverMessage;
                }
            }
            NSArray *array = [[TMInfoManager sharedManager] productArrayForCartType:type];
            [self.arrayProducts setArray:array];
            NSLog(@"requestResultForRenewConditionsOfProducts - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
            [weakSelf refreshContent];
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
        [self.arrayProducts removeAllObjects];
        [self.dictionaryAll removeAllObjects];
        
        [self.dictionaryAll setDictionary:resultDictionary];
        NSDictionary *summary = [resultDictionary objectForKey:SymphoxAPIParam_account_result];
        if (summary)
        {
            [self.dictionaryTotal setDictionary:summary];
        }
        
        NSMutableArray *array = [[resultDictionary objectForKey:SymphoxAPIParam_cart_item] mutableCopy];
        NSString *errorTitle = nil;
        NSMutableString *notifyString = [NSMutableString string];
        if (array)
        {
            NSMutableArray *arrayInCart = [[TMInfoManager sharedManager] productArrayForCartType:type];
            for (NSDictionary *product in [array copy])
            {
//                NSString *cpdt_owner_num = [product objectForKey:SymphoxAPIParam_cpdt_owner_num];
                NSNumber *cpdt_num = [product objectForKey:SymphoxAPIParam_cpdt_num];
                if (cpdt_num == nil || [cpdt_num isEqual:[NSNull null]])
                    continue;
                NSNumber *qty = [product objectForKey:SymphoxAPIParam_qty];
                if (qty && [qty isEqual:[NSNull null]] == NO)
                {
                    [[TMInfoManager sharedManager] setPurchaseQuantity:qty forProduct:cpdt_num inCart:type];
                }
                NSDictionary *used_payemnt_mode = [product objectForKey:SymphoxAPIParam_used_payment_mode];
                if (used_payemnt_mode && [used_payemnt_mode isEqual:[NSNull null]] == NO)
                {
                    NSNumber *real_cpdt_num = [used_payemnt_mode objectForKey:SymphoxAPIParam_cpdt_num];
                    if (real_cpdt_num == nil || [real_cpdt_num isEqual:[NSNull null]])
                    {
                        real_cpdt_num = cpdt_num;
                    }
                    [[TMInfoManager sharedManager] setPurchaseInfoFromSelectedPaymentMode:used_payemnt_mode forProductId:cpdt_num withRealProductId:real_cpdt_num inCart:type asAdditional:NO];
                }
                NSArray *paymentModes = [product objectForKey:SymphoxAPIParam_payment_mode_list];
                if (paymentModes == nil || [paymentModes isEqual:[NSNull null]] || [paymentModes count] == 0)
                {
                    if ([notifyString length] == 0)
                    {
                        [notifyString appendString:[LocalizedString ProductsRemovedFromCart]];
                    }
                    NSNumber *cpdt_num = [product objectForKey:SymphoxAPIParam_cpdt_num];
                    NSString *name = [[TMInfoManager sharedManager] nameOfRemovedProductId:cpdt_num inCart:type];
                    if (name)
                    {
                        NSString *totalString = [NSString stringWithFormat:@"\n%@", name];
                        [notifyString appendString:totalString];
                    }
                    [array removeObject:product];
                    errorTitle = [LocalizedString NotEnoughPoints];
                }
                for (NSInteger index = 0; index < [[arrayInCart copy] count]; index++)
                {
                    NSDictionary *productInCart = [arrayInCart objectAtIndex:index];
                    NSNumber *cpdt_num_inCart = [productInCart objectForKey:SymphoxAPIParam_cpdt_num];
                    if (cpdt_num_inCart && [cpdt_num_inCart isEqual:[NSNull null]] == NO && [cpdt_num_inCart isEqualToNumber:cpdt_num])
                    {
                        [arrayInCart replaceObjectAtIndex:index withObject:product];
                    }
                }
            }
            [self.arrayProducts setArray:array];
            if ([notifyString length] > 0)
            {
                __weak CartViewController *weakSelf = self;
                if (errorTitle == nil)
                {
                    errorTitle = [LocalizedString ProductsRemovedFromCart];
                }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:errorTitle message:notifyString preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [weakSelf renewConditionsForCartType:type shouldShowPaymentForProductId:nil];
                }];
                [alertController addAction:actionConfirm];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf presentViewController:alertController animated:YES completion:nil];
                });
            }
        }
        success = YES;
    }
    
    return success;
}

- (void)checkAdditionalPurchaseForType:(CartType)type
{
    NSArray *array = self.arrayProducts;
    if (array == nil || [array count] == 0)
    {
        array = [[TMInfoManager sharedManager] productArrayForCartType:type];
    }
    if (array == nil || [array count] == 0)
    {
        return;
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
    [self requestResultForCheckingAdditionalPurchaseForProducts:arrayCheck ofCartType:type];
}

- (void)requestResultForCheckingAdditionalPurchaseForProducts:(NSArray *)products ofCartType:(CartType)type
{
    __weak CartViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_checkAdditionalPurchase];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSString *stringCartType = [[NSNumber numberWithInteger:type] stringValue];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[TMInfoManager sharedManager].userIdentifier, SymphoxAPIParam_user_num, products, SymphoxAPIParam_cart_item_order, stringCartType, SymphoxAPIParam_cart_type, nil];
    [self showLoadingViewAnimated:NO];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        NSArray *array = nil;
        BOOL shouldHideLoadingView = YES;
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"requestResultForCheckingAdditionalPurchaseForProducts:\n%@", string);
                array = [weakSelf arrayOfAdditionalPurchaseFromResult:resultObject inCart:type];
            }
            else
            {
                NSLog(@"requestResultForCheckingAdditionalPurchaseForProducts - Unexpected data format.");
            }
        }
        else
        {
            NSLog(@"requestResultForCheckingAdditionalPurchaseForProducts - error:\n%@", [error description]);
        }
        if (array && [array isEqual:[NSNull null]] == NO && [array count] > 0)
        {
            // Should show additional purchase page
            AdditionalPurchaseViewController *viewController = [[AdditionalPurchaseViewController alloc] initWithNibName:@"AdditionalPurchaseViewController" bundle:[NSBundle mainBundle]];
            [viewController.dictionaryTotal setDictionary:weakSelf.dictionaryTotal];
            [viewController.dictionaryAll setDictionary:weakSelf.dictionaryAll];
            viewController.arrayProducts = array;
            viewController.arrayProductsFromCart = weakSelf.arrayProducts;
            viewController.bottomBar.label.attributedText = weakSelf.bottomBar.label.attributedText;
            viewController.currentType = weakSelf.currentType;
            [viewController setHidesBottomBarWhenPushed:YES];
            
            [gaTracker send:[[GAIDictionaryBuilder
                              createEventWithCategory:[EventLog twoString:self.title _:logPara_下一步]
                              action:[EventLog to_:logPara_加購商品]
                              label:nil
                              value:nil] build]];

            [weakSelf.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            // If cart type is CartTypeFastDelivery, should check if the condition is matched to use Fast Delivery.
            // Otherwise, present payment type.
            BOOL reachLimit = YES;
            NSInteger threshold = 290;
            NSArray *arrayFastService = nil;
            NSArray *array_delivery_limit = [weakSelf.dictionaryAll objectForKey:SymphoxAPIParam_delivery_limit];
            if (array_delivery_limit && [array_delivery_limit isEqual:[NSNull null]] == NO && [array_delivery_limit count] > 0)
            {
                for (NSDictionary *delivery_limit in array_delivery_limit)
                {
                    NSString *limit_Type = [delivery_limit objectForKey:SymphoxAPIParam_limit_Type];
                    if (limit_Type == nil || [limit_Type isEqual:[NSNull null]])
                        continue;
                    if (type == CartTypeStorePickup && [limit_Type integerValue] != 1)
                        continue;
                    if (type == CartTypeFastDelivery && [limit_Type integerValue] != 2)
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
                if (type == CartTypeFastDelivery)
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
                            [weakSelf finalCheckCartContentForCartType:type canPurchaseFastDelivery:NO];
                        }];
                        [alertController addAction:action];
                    }
                    
                    UIAlertAction *actionShopping = [UIAlertAction actionWithTitle:[LocalizedString ContinueToShopping] style:UIAlertActionStyleDefault handler:nil];
                    
                    UIAlertAction *actionCheckout = [UIAlertAction actionWithTitle:[LocalizedString CheckOutDirectly] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [weakSelf finalCheckCartContentForCartType:type canPurchaseFastDelivery:NO];
                    }];
                    [alertController addAction:actionShopping];
                    [alertController addAction:actionCheckout];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf presentViewController:alertController animated:YES completion:nil];
                    });
                }
                else if (type == CartTypeStorePickup)
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
                [weakSelf finalCheckCartContentForCartType:type canPurchaseFastDelivery:NO];
                shouldHideLoadingView = NO;
            }
        }
        if (shouldHideLoadingView)
        {
            [weakSelf hideLoadingViewAnimated:NO];
        }
    }];
}

- (NSArray *)arrayOfAdditionalPurchaseFromResult:(id)result inCart:(CartType)type
{
    NSArray *array = nil;;
    
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:result options:0 error:&error];
    if (error == nil)
    {
        array = [dictionary objectForKey:SymphoxAPIParam_additional_purchase];
    }
    
    return array;
}

- (void)finalCheckCartContentForCartType:(CartType)type canPurchaseFastDelivery:(BOOL)canPurchaseFastDelivery
{
    NSArray *array = self.arrayProducts;
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
    [self showLoadingViewAnimated:YES];
    __weak CartViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_finalCheckProductsInCart];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSString *stringCartType = [[NSNumber numberWithInteger:type] stringValue];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userIdentifier, SymphoxAPIParam_user_num, products, SymphoxAPIParam_cart_item_order, stringCartType, SymphoxAPIParam_cart_type, nil];
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
                        
                        if (cart_items && [cart_items isEqual:[NSNull null]] == NO)
                        {
                            [[TMInfoManager sharedManager] updateProductInfoForFastDeliveryFromInfos:cart_items];
                        }
                    }
                    
                    PaymentTypeViewController *viewController = [[PaymentTypeViewController alloc] initWithNibName:@"PaymentTypeViewController" bundle:[NSBundle mainBundle]];
                    viewController.dictionaryData = resultDictionary;
                    viewController.arrayProductsFromCart = weakSelf.arrayProducts;
                    viewController.type = type;
                    [viewController setHidesBottomBarWhenPushed:YES];
                    
                    [gaTracker send:[[GAIDictionaryBuilder
                                      createEventWithCategory:[EventLog twoString:self.title _:logPara_下一步]
                                      action:[EventLog to_:logPara_付款方式]
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
                NSLog(@"requestFinalCheckProducts - Unexpected data format.");
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
            NSLog(@"requestFinalCheckProducts - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:NO];
    }];
}

- (void)refreshContent
{
    __weak CartViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.arrayProducts count] == 0)
        {
            weakSelf.tableView.backgroundView = weakSelf.tableBackgroundView;
        }
        else
        {
            weakSelf.tableView.backgroundView = nil;
        }
        [weakSelf.tableView reloadData];
        
        [weakSelf refreshBottomBar];
    });
}

- (void)refreshBottomBar
{
    BOOL isConditionSelectedForAtLeastOneProduct = NO;
    for (NSDictionary *product in self.arrayProducts)
    {
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        isConditionSelectedForAtLeastOneProduct = [self isConditionSelectedForIdentifier:productId];
        if (isConditionSelectedForAtLeastOneProduct == YES)
        {
            break;
        }
    }
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
    if (isConditionSelectedForAtLeastOneProduct)
    {
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
    }
    else
    {
        NSString *stringTotal = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:0]];
        NSString *string = [NSString stringWithFormat:@"＄%@", stringTotal];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributeOrange];
        [totalString appendAttributedString:attrString];
    }
    [self.bottomBar.label setAttributedText:totalString];
}

- (void)resetBottomBar
{
    self.bottomBar.label.text = @"";
}

- (void)presentPaymentSelectionViewForProductId:(NSNumber *)productId
{
    if (productId == nil)
        return;
    NSDictionary *product = nil;
    for (NSDictionary *dictionary in self.arrayProducts)
    {
        NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO && [cpdt_num isEqualToNumber:productId])
        {
            product = dictionary;
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
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (CartUIType)cartUITypeForCartType:(CartType)cartType
{
    CartUIType uiType = CartUITypeTotal;
    switch (cartType) {
        case CartTypeCommonDelivery:
            uiType = CartUITypeCommonDelivery;
            break;
        case CartTypeStorePickup:
            uiType = CartUITypeStorePickup;
            break;
        case CartTypeFastDelivery:
            uiType = CartUITypeFastDelivery;
        default:
            break;
    }
    return uiType;
}

- (void)setSegmentedControlIndexForCartType:(CartType)type
{
    CartUIType uiType = [self cartUITypeForCartType:type];
    if (self.segmentedView.segmentedControl.selectedSegmentIndex != uiType)
    {
        self.segmentedView.segmentedControl.selectedSegmentIndex = uiType;
    }
}

- (BOOL)isConditionSelectedForIdentifier:(NSNumber *)productIdentifier
{
    BOOL selected = NO;
    NSString *paymentDiscription = [self paymentDetailForIdentifier:productIdentifier];
    if (paymentDiscription != nil)
    {
        selected = YES;
    }
    return selected;
}

- (NSString *)paymentDetailForIdentifier:(NSNumber *)productIdentifier
{
    NSString *paymentDiscription = nil;
    if (productIdentifier != nil && ([productIdentifier isEqual:[NSNull null]] == NO))
    {
        NSDictionary *purchaseInfos = [[TMInfoManager sharedManager] purchaseInfoForCartType:self.currentType];
        NSDictionary *purchaseInfo = [purchaseInfos objectForKey:productIdentifier];
        paymentDiscription = [purchaseInfo objectForKey:SymphoxAPIParam_discount_detail_desc];
    }
    if ([paymentDiscription isEqual:[NSNull null]])
    {
        paymentDiscription = nil;
    }
    return paymentDiscription;
}

- (NSNumber *)paymentTypeForIdentifier:(NSNumber *)productIdentifier
{
    NSNumber *paymentType = nil;
    if (productIdentifier != nil && ([productIdentifier isEqual:[NSNull null]] == NO))
    {
        NSDictionary *purchaseInfos = [[TMInfoManager sharedManager] purchaseInfoForCartType:self.currentType];
        NSDictionary *purchaseInfo = [purchaseInfos objectForKey:productIdentifier];
        paymentType = [purchaseInfo objectForKey:SymphoxAPIParam_payment_type];
    }
    if ([paymentType isEqual:[NSNull null]])
    {
        paymentType = nil;
    }
    return paymentType;
}

- (NSNumber *)quantityForIdentifier:(NSNumber *)productIdentifier
{
    NSNumber *quantity = nil;
    if (productIdentifier != nil && ([productIdentifier isEqual:[NSNull null]] == NO))
    {
        NSDictionary *purchaseInfos = [[TMInfoManager sharedManager] purchaseInfoForCartType:self.currentType];
        NSDictionary *purchaseInfo = [purchaseInfos objectForKey:productIdentifier];
        quantity = [purchaseInfo objectForKey:SymphoxAPIParam_qty];
    }
    if ([quantity isEqual:[NSNull null]])
    {
        quantity = nil;
    }
    return quantity;
}

- (NSString *)textForCartType:(CartType)cartType
{
    NSArray *array = [[TMInfoManager sharedManager] productArrayForCartType:cartType];
    NSInteger productCount = [array count];
    NSMutableString *text = [NSMutableString string];
    switch (cartType) {
        case CartTypeCommonDelivery:
        {
            [text appendString:[LocalizedString CommonDelivery]];
        }
            break;
        case CartTypeFastDelivery:
        {
            [text appendString:[LocalizedString FastDelivery]];
        }
            break;
        case CartTypeStorePickup:
        {
            [text appendString:[LocalizedString StorePickUp]];
        }
            break;
        default:
            break;
    }
    if (productCount > 0)
    {
        [text appendFormat:@"(%li)", (long)productCount];
    }
    return text;
}

- (void)showQuantityInputViewForProduct:(NSDictionary *)product atIndex:(NSInteger)index
{
    if (product == nil)
        return;
    NSNumber *maxSellQty = [product objectForKey:SymphoxAPIParam_max_sell_qty];
    
    NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
    NSDictionary *purchaseInfos = [[TMInfoManager sharedManager] purchaseInfoForCartType:self.currentType];
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
    NSString *remarks = [product objectForKey:SymphoxAPIParam_remark];
    if (remarks && [remarks isEqual:[NSNull null]] == NO && [remarks length] > 0)
    {
        self.viewQuantityInput.tips = remarks;
    }
    else
    {
        self.viewQuantityInput.tips = nil;
    }
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

#pragma mark - Actions

- (void)buttonItemClosePressed:(id)sender
{
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Notification Handler

- (void)handlerOfCartContentChangedNotification:(NSNotification *)notification
{
    for (CartUIType type = CartUITypeStart; type < CartUITypeTotal; type++)
    {
        NSString *text = nil;
        switch (type) {
            case CartUITypeCommonDelivery:
            {
                text = [self textForCartType:CartTypeCommonDelivery];
            }
                break;
            case CartUITypeFastDelivery:
            {
                text = [self textForCartType:CartTypeFastDelivery];
            }
                break;
            case CartUITypeStorePickup:
            {
                text = [self textForCartType:CartTypeStorePickup];
            }
                break;
            default:
                break;
        }
        if (text)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.segmentedView.segmentedControl setTitle:text forSegmentAtIndex:type];
            });
        }
    }
}

#pragma mark - SemiCircleEndsSegmentedViewDelegate

- (void)semiCircleEndsSegmentedView:(SemiCircleEndsSegmentedView *)view didChangeToIndex:(NSInteger)index
{
    NSInteger realIndex = CartTypeTotal;
    switch (index) {
        case CartUITypeCommonDelivery:
            realIndex = CartTypeCommonDelivery;
            break;
        case CartUITypeFastDelivery:
            realIndex = CartTypeFastDelivery;
            break;
        case CartUITypeStorePickup:
            realIndex = CartTypeStorePickup;
        default:
            break;
    }
    self.currentType = realIndex;
    [self resetBottomBar];
    [self.arrayProducts removeAllObjects];
    [self.tableView reloadData];
    [self checkCartForType:self.currentType shouldShowPaymentForProductId:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.arrayProducts count];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CartProductTableViewCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.tag = indexPath.row;
    if (cell.delegate == nil)
    {
        cell.delegate = self;
    }
    
    if (indexPath.row < [self.arrayProducts count])
    {
        NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
        
        NSNumber *numberCash = [dictionary objectForKey:SymphoxAPIParam_ori_cash];
        if ([numberCash isEqual:[NSNull null]])
        {
            numberCash = [dictionary objectForKey:SymphoxAPIParam_price03];
            if (numberCash == nil || [numberCash isEqual:[NSNull null]])
            {
                numberCash = nil;
            }
        }
        NSNumber *numberPoint = [dictionary objectForKey:SymphoxAPIParam_ori_point];
        if ([numberPoint isEqual:[NSNull null]])
        {
            numberPoint = [dictionary objectForKey:SymphoxAPIParam_point01];
            if (numberPoint == nil || [numberPoint isEqual:[NSNull null]])
            {
                numberPoint = nil;
            }
        }
        NSNumber *mixCash = [dictionary objectForKey:SymphoxAPIParam_cash];
        if ([mixCash isEqual:[NSNull null]])
        {
            mixCash = [dictionary objectForKey:SymphoxAPIParam_price02];
            if (mixCash == nil || [mixCash isEqual:[NSNull null]])
            {
                mixCash = nil;
            }
        }
        NSNumber *mixPoint = [dictionary objectForKey:SymphoxAPIParam_tmp_point];
        if ([mixPoint isEqual:[NSNull null]])
        {
            mixPoint = [dictionary objectForKey:SymphoxAPIParam_point02];
            if (mixPoint == nil || [mixPoint isEqual:[NSNull null]])
            {
                mixPoint = nil;
            }
        }
        
        NSString *cpdt_owner_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_owner_num];
        if ([cpdt_owner_num isEqual:[NSNull null]])
        {
            cpdt_owner_num = nil;
        }
        
        NSMutableAttributedString *totalCostString = [[NSMutableAttributedString alloc] init];
        NSInteger originLength = [totalCostString length];
//        NSDictionary *attributeGray = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
//        NSDictionary *attributeGraySmall = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
        NSDictionary *attributeRed = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18.0], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
        NSDictionary *attributeRedSmall = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
//        NSAttributedString *plusString = [[NSAttributedString alloc] initWithString:@"＋" attributes:attributeRed];
        BOOL hasPureCash = (numberCash != nil) && ([numberCash unsignedIntegerValue] > 0) && cpdt_owner_num && ([cpdt_owner_num integerValue] == 3);
        BOOL hasPurePoint = (numberPoint != nil) && ([numberPoint unsignedIntegerValue] > 0) && cpdt_owner_num && ([cpdt_owner_num integerValue] == 1);
        BOOL hasMixedPrice = (numberCash != nil) && ([numberCash unsignedIntegerValue] > 0) && (numberPoint != nil) && ([numberPoint unsignedIntegerValue] > 0) && cpdt_owner_num && ([cpdt_owner_num integerValue] == 2);
        
        if (hasPureCash)
        {
            NSString *stringTotal = [self.numberFormatter stringFromNumber:numberCash];
            NSString *string = [NSString stringWithFormat:@"＄%@", stringTotal];
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributeRed];
            [totalCostString appendAttributedString:attrString];
        }
        else if (hasPurePoint)
        {
            NSString *stringTotal = [self.numberFormatter stringFromNumber:numberPoint];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringTotal attributes:attributeRed];
            NSAttributedString *attrPoint = [[NSAttributedString alloc] initWithString:[LocalizedString Point] attributes:attributeRedSmall];
            [attrString appendAttributedString:attrPoint];
            [totalCostString appendAttributedString:attrString];
        }
        else if (hasMixedPrice)
        {
            NSString *stringCash = [self.numberFormatter stringFromNumber:numberCash];
            if (stringCash)
            {
                NSString *string = [NSString stringWithFormat:@"＄%@", stringCash];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributeRed];
                [totalCostString appendAttributedString:attrString];
                NSAttributedString *slashString = [[NSAttributedString alloc] initWithString:@" + " attributes:attributeRed];
                [totalCostString appendAttributedString:slashString];
            }
            
            NSString *stringPoint = [self.numberFormatter stringFromNumber:numberPoint];
            if (stringPoint)
            {
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringPoint attributes:attributeRed];
                NSAttributedString *attrPoint = [[NSAttributedString alloc] initWithString:[LocalizedString Point] attributes:attributeRedSmall];
                [attrString appendAttributedString:attrPoint];
                [totalCostString appendAttributedString:attrString];
            }
        }
        if ([totalCostString length] == originLength)
        {
            NSString *stringTotal = [self.numberFormatter stringFromNumber:[NSNumber numberWithInteger:0]];
            NSString *string = [NSString stringWithFormat:@"＄%@", stringTotal];
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributeRed];
            [totalCostString appendAttributedString:attrString];
        }
        
        [cell.labelPrice setAttributedText:totalCostString];
        
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        if (name != nil && ([name isEqual:[NSNull null]] == NO) && [name length] > 0)
        {
            cell.labelName.text = name;
            cell.labelName.hidden = NO;
        }
        else
        {
            name = [dictionary objectForKey:SymphoxAPIParam_cpdt_name];
            if (name != nil && ([name isEqual:[NSNull null]] == NO) && [name length] > 0)
            {
                cell.labelName.text = name;
                cell.labelName.hidden = NO;
            }
            else
            {
                cell.labelName.hidden = YES;
            }
        }
        
        NSString *market_name = [dictionary objectForKey:SymphoxAPIParam_market_name];
        if (market_name != nil && ([market_name isEqual:[NSNull null]] == NO) && [market_name length] > 0)
        {
            cell.labelDetail.text = market_name;
            cell.labelDetail.hidden = NO;
        }
        else
        {
            cell.labelDetail.hidden = YES;
        }
        
        NSString *imagePath = [dictionary objectForKey:SymphoxAPIParam_img_url];
        if (imagePath != nil && ([imagePath isEqual:[NSNull null]] == NO) && [imagePath length] > 0)
        {
            NSURL *url = [NSURL URLWithString:imagePath];
            cell.imageUrl = url;
        }
        else
        {
            imagePath = [dictionary objectForKey:SymphoxAPIParam_prod_pic_url];
            if (imagePath != nil && ([imagePath isEqual:[NSNull null]] == NO) && [imagePath length] > 0)
            {
                NSURL *url = [NSURL URLWithString:imagePath];
                cell.imageUrl = url;
            }
        }
        
        NSNumber *productIdentifier = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        NSNumber *quantity = [self quantityForIdentifier:productIdentifier];
        if (quantity == nil)
        {
            quantity = [dictionary objectForKey:SymphoxAPIParam_qty];
            if (quantity == nil || [quantity isEqual:[NSNull null]])
            {
                quantity = [NSNumber numberWithInteger:0];
            }
        }
        NSString *quantityString = [NSString stringWithFormat:@"Ｘ%li", (long)[quantity integerValue]];
        cell.labelQuantity.text = quantityString;
        
        NSString *paymentDiscription = [self paymentDetailForIdentifier:productIdentifier];
        NSNumber *paymentType = [self paymentTypeForIdentifier:productIdentifier];
        
        NSDictionary *used_payment_mode = [dictionary objectForKey:SymphoxAPIParam_used_payment_mode];
        if (used_payment_mode && [used_payment_mode isEqual:[NSNull null]] == NO)
        {
            NSNumber *payment_type = [used_payment_mode objectForKey:SymphoxAPIParam_payment_type];
            if (payment_type && [payment_type isEqual:[NSNull null]] == NO)
            {
                paymentType = payment_type;
                NSString *discount_detail_desc = [used_payment_mode objectForKey:SymphoxAPIParam_discount_detail_desc];
                if (discount_detail_desc && [discount_detail_desc isEqual:[NSNull null]] == NO)
                {
                    paymentDiscription = discount_detail_desc;
                }
            }
        }
        BOOL isGift = [self isGiftProduct:dictionary];
        if (([paymentType integerValue] != 99) || isGift)
        {
            cell.labelPayment.text = paymentDiscription;
            cell.alreadySelectQuantityAndPayment = YES;
        }
        else
        {
            cell.labelPayment.text = @"";
            cell.alreadySelectQuantityAndPayment = NO;
        }
        if (isGift)
        {
            [cell.buttonDelete setUserInteractionEnabled:NO];
            [cell.buttonCondition setUserInteractionEnabled:NO];
//            cell.labelPayment.text = [LocalizedString ThisIsGift];
            [cell.buttonCondition setTitle:[LocalizedString ThisIsGift] forState:UIControlStateNormal];
            [cell.labelPayment setTextColor:[UIColor lightGrayColor]];
        }
        else
        {
            [cell.buttonCondition setUserInteractionEnabled:YES];
            [cell.buttonDelete setUserInteractionEnabled:YES];
            [cell.buttonCondition setTitle:[LocalizedString ChooseQuantityAndDiscount] forState:UIControlStateNormal];
            [cell.labelPayment setTextColor:[UIColor darkGrayColor]];
        }
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 150.0;
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.arrayProducts count])
    {
        NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
        NSNumber *productIdentifier = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (productIdentifier && [productIdentifier isEqual:[NSNull null]] == NO)
        {
            ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
            viewController.title = [LocalizedString ProductInfo];
            viewController.productIdentifier = productIdentifier;
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - CartProductTableViewCellDelegate

- (void)cartProductTableViewCell:(CartProductTableViewCell *)cell didPressedConditionBySender:(id)sender
{
    if (cell.tag >= [self.arrayProducts count])
    {
        return;
    }
    NSDictionary *product = [self.arrayProducts objectAtIndex:cell.tag];
    if ([self isGiftProduct:product])
    {
        return;
    }
    [self showQuantityInputViewForProduct:product atIndex:cell.tag];
}

- (void)cartProductTableViewCell:(CartProductTableViewCell *)cell didPressedDeleteBySender:(id)sender
{
    if (cell.tag >= [self.arrayProducts count])
        return;
    NSDictionary *dictionary = [self.arrayProducts objectAtIndex:cell.tag];
    NSNumber *productId = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
    if (productId == nil)
        return;
    NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
    if (name == nil)
    {
        name = [dictionary objectForKey:SymphoxAPIParam_cpdt_name];
    }
    NSString *nameQuote = nil;
    if (name == nil || [name isEqual:[NSNull null]] || [name length] == 0)
    {
        nameQuote = [LocalizedString ThisProduct];
    }
    else
    {
        nameQuote = [NSString stringWithFormat:[LocalizedString _Q_], name];
    }
    NSString *message = [NSString stringWithFormat:[LocalizedString GoingToDeleteProduct_S_], nameQuote];
    
    __weak CartViewController *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf.arrayProducts removeObjectAtIndex:cell.tag];
        NSString *name = [[TMInfoManager sharedManager] nameOfRemovedProductId:productId inCart:weakSelf.currentType];
        if (name)
        {
            [self checkCartForType:weakSelf.currentType shouldShowPaymentForProductId:nil];
        }
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:self.title _:logPara_列表一]
                          action:[EventLog index:cell.tag _:logPara_刪除]
                          label:[EventLog threeString:[EventLog cartTypeInString:_currentType] _:[productId stringValue] _:name]
                          value:nil] build]];
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionConfirm];
    [self presentViewController:alertController animated:YES completion:nil];
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
        NSNumber *maxSellQty = [product objectForKey:SymphoxAPIParam_max_sell_qty];
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
    BOOL canProceed = YES;
    for (NSDictionary *product in self.arrayProducts)
    {
        if ([self isGiftProduct:product])
        {
            continue;
        }
        
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        BOOL isConditionSelected = [self isConditionSelectedForIdentifier:productId];
        if (isConditionSelected == NO)
        {
            canProceed = NO;
            break;
        }
    }
    if (canProceed == NO)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString PleaseSelectQuantityAndPaymentForEachProduct] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        __weak CartViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    [self checkAdditionalPurchaseForType:self.currentType];
}

#pragma mark - FullScreenSelectNumberViewDelegate

- (void)fullScreenSelectNumberView:(FullScreenSelectNumberView *)view didSelectNumberAsString:(NSString *)stringNumber
{
    NSDictionary *product = [self.arrayProducts objectAtIndex:view.tag];
    NSString *text = stringNumber;
    if (text == nil || [text length] == 0 || [text integerValue] == 0)
    {
        text = @"1";
    }
    NSNumber *quantity = [NSNumber numberWithInteger:[text integerValue]];
    NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
    if (productId && quantity)
    {
        [[TMInfoManager sharedManager] setPurchaseQuantity:quantity forProduct:productId inCart:self.currentType];
    }
    [self checkCartForType:self.currentType shouldShowPaymentForProductId:productId];
}

@end
