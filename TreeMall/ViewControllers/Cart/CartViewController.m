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

@interface CartViewController ()

- (void)checkCartForType:(CartType)type;
- (void)requestResultForCheckingProducts:(NSArray *)products ofCartType:(CartType)type;
- (BOOL)processCheckingResult:(id)result inCart:(CartType)type;
- (void)renewConditionsForCartType:(CartType)type;
- (void)requestResultForRenewConditionsOfProducts:(NSArray *)productConditions ofCartType:(CartType)type;
- (BOOL)processRenewConditionsResult:(id)result inCart:(CartType)type;

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
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    
    [self.view addSubview:self.segmentedView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBar];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.currentType == CartTypeTotal)
    {
        self.currentType = CartTypeCommonDelivery;
        [self.segmentedView.segmentedControl setSelectedSegmentIndex:CartTypeCommonDelivery];
    }
    [self checkCartForType:self.currentType];
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
    
    if (self.tableView)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.height, CGRectGetMinY(self.bottomBar.frame) - originY);
        self.tableView.frame = frame;
    }
}

- (SemiCircleEndsSegmentedView *)segmentedView
{
    if (_segmentedView == nil)
    {
        NSMutableArray *items = [NSMutableArray array];
        for (NSInteger index = CartTypeStart; index < CartTypeTotal; index++)
        {
            switch (index) {
                case CartTypeCommonDelivery:
                {
                    [items addObject:[LocalizedString CommonDelivery]];
                }
                    break;
                case CartTypeFastDelivery:
                {
                    [items addObject:[LocalizedString FastDelivery]];
                }
                    break;
                case CartTypeStorePickup:
                {
                    [items addObject:[LocalizedString StorePickUp]];
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
    }
    return _tableView;
}

- (LabelButtonView *)bottomBar
{
    if (_bottomBar == nil)
    {
        _bottomBar = [[LabelButtonView alloc] initWithFrame:CGRectZero];
    }
    return _bottomBar;
}

#pragma mark - Private Methods

- (void)checkCartForType:(CartType)type
{
    NSArray *array = [[TMInfoManager sharedManager] productArrayForCartType:type];
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
        NSMutableDictionary *dictionaryCheck = [NSMutableDictionary dictionary];
        [dictionaryCheck setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        [dictionaryCheck setObject:quantity forKey:SymphoxAPIParam_qty];
        [arrayCheck addObject:dictionaryCheck];
    }
    [self requestResultForCheckingProducts:arrayCheck ofCartType:type];
}

- (void)requestResultForCheckingProducts:(NSArray *)products ofCartType:(CartType)type
{
    __weak CartViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_checkProductAvailable];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSString *stringCartType = [[NSNumber numberWithInteger:type] stringValue];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:products, SymphoxAPIParam_cart_item_order, stringCartType, SymphoxAPIParam_cart_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"requestResultForCheckingProducts:\n%@", string);
                if ([weakSelf processCheckingResult:data inCart:type])
                {
                    // Should start calculate product promotion according to quantity
                    
                }
                else
                {
                    NSLog(@"requestResultForCheckingProducts - Cannot process data");
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
    }];
}

- (BOOL)processCheckingResult:(id)result inCart:(CartType)type
{
    BOOL success = NO;
    if ([result isKindOfClass:[NSData class]] == NO)
        return success;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:result options:0 error:&error];
    if ([jsonObject isKindOfClass:[NSArray class]])
    {
        NSArray *array = (NSArray *)jsonObject;
        NSMutableString *notifyString = [NSMutableString string];
        for (NSDictionary *dictionary in array)
        {
            NSString *stringError = nil;
            NSNumber *numberStatus = [dictionary objectForKey:SymphoxAPIParam_status];
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
            }
        }
        if ([notifyString length] > 0)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString ProductsRemovedFromCart] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }];
            [alertController addAction:actionConfirm];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        success = YES;
    }
    return success;
}

- (void)renewConditionsForCartType:(CartType)type
{
    NSArray *array = [[TMInfoManager sharedManager] productArrayForCartType:type];
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
        
        NSMutableDictionary *dictionaryCheck = [NSMutableDictionary dictionary];
        [dictionaryCheck setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        [dictionaryCheck setObject:quantity forKey:SymphoxAPIParam_qty];
        [dictionaryCheck setObject:dictionaryMode forKey:SymphoxAPIParam_payment_mode];
        [arrayCheck addObject:dictionaryCheck];
    }
    
}

- (void)requestResultForRenewConditionsOfProducts:(NSArray *)productConditions ofCartType:(CartType)type
{
    __weak CartViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_renewProductConditions];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSString *stringCartType = [[NSNumber numberWithInteger:type] stringValue];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:productConditions, SymphoxAPIParam_cart_item_order, stringCartType, SymphoxAPIParam_cart_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"requestResultForCheckingProducts:\n%@", string);
                if ([weakSelf processRenewConditionsResult:data inCart:type])
                {
                    // Should start calculate product promotion according to quantity
                    
                }
                else
                {
                    NSLog(@"requestResultForCheckingProducts - Cannot process data");
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
        success = YES;
    }
    
    return success;
}

#pragma mark - SemiCircleEndsSegmentedViewDelegate

- (void)semiCircleEndsSegmentedView:(SemiCircleEndsSegmentedView *)view didChangeToIndex:(NSInteger)index
{
    self.currentType = index;
    [self checkCartForType:self.currentType];
}

@end
