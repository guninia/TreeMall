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

@interface CartViewController ()

- (void)checkCartForType:(CartType)type;
- (void)requestResultForCheckingProducts:(NSArray *)products ofCartType:(CartType)type;
- (BOOL)processCheckingResult:(id)result inCart:(CartType)type;
- (void)renewConditionsForCartType:(CartType)type;
- (void)requestResultForRenewConditionsOfProducts:(NSArray *)productConditions ofCartType:(CartType)type;
- (BOOL)processRenewConditionsResult:(id)result inCart:(CartType)type;
- (void)refreshContent;
- (void)refreshBottomBar;

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
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, CGRectGetMinY(self.bottomBar.frame) - originY);
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

- (NSNumberFormatter *)numberFormatter
{
    if (_numberFormatter == nil)
    {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _numberFormatter;
}

#pragma mark - Private Methods

- (void)checkCartForType:(CartType)type
{
    NSArray *array = [[TMInfoManager sharedManager] productArrayForCartType:type];
    if (array == nil || [array count] == 0)
    {
        [self.arrayProducts removeAllObjects];
        [self.tableView reloadData];
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
                    [weakSelf renewConditionsForCartType:type];
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
    }];
}

- (BOOL)processCheckingResult:(id)result inCart:(CartType)type
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
                }
            }
            if ([notifyString length] > 0)
            {
                __weak CartViewController *weakSelf = self;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString ProductsRemovedFromCart] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [weakSelf renewConditionsForCartType:type];
                }];
                [alertController addAction:actionConfirm];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }
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
    [self requestResultForRenewConditionsOfProducts:arrayCheck ofCartType:type];
}

- (void)requestResultForRenewConditionsOfProducts:(NSArray *)productConditions ofCartType:(CartType)type
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
        NSDictionary *summary = [resultDictionary objectForKey:SymphoxAPIParam_account_result];
        if (summary)
        {
            [self.dictionaryTotal setDictionary:summary];
        }
        NSArray *array = [resultDictionary objectForKey:SymphoxAPIParam_cart_item];
        if (array)
        {
            [self.arrayProducts setArray:array];
        }
        success = YES;
    }
    
    return success;
}

- (void)refreshContent
{
    [self.tableView reloadData];
    
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

#pragma mark - SemiCircleEndsSegmentedViewDelegate

- (void)semiCircleEndsSegmentedView:(SemiCircleEndsSegmentedView *)view didChangeToIndex:(NSInteger)index
{
    self.currentType = index;
    [self checkCartForType:self.currentType];
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
            numberCash = nil;
        }
        NSNumber *numberPoint = [dictionary objectForKey:SymphoxAPIParam_ori_point];
        if ([numberPoint isEqual:[NSNull null]])
        {
            numberPoint = nil;
        }
        
        NSMutableAttributedString *totalCostString = [[NSMutableAttributedString alloc] init];
        NSInteger originLength = [totalCostString length];
        NSDictionary *attributeGray = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil];
        NSDictionary *attributeRed = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, nil];
        NSAttributedString *plusString = [[NSAttributedString alloc] initWithString:@"＋" attributes:attributeGray];
        if (numberCash != nil && [numberCash integerValue] > 0)
        {
            NSString *stringTotal = [self.numberFormatter stringFromNumber:numberCash];
            NSString *string = [NSString stringWithFormat:@"＄%@", stringTotal];
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributeRed];
            [totalCostString appendAttributedString:attrString];
        }
        if (numberPoint != nil && [numberPoint integerValue] > 0)
        {
            if ([totalCostString length] > originLength)
            {
                [totalCostString appendAttributedString:plusString];
            }
            NSString *stringTotal = [self.numberFormatter stringFromNumber:numberPoint];
            NSString *string = [NSString stringWithFormat:@"%@%@", stringTotal, [LocalizedString Point]];
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributeGray];
            [totalCostString appendAttributedString:attrString];
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
            cell.labelName.hidden = YES;
        }
        
        NSString *remark = [dictionary objectForKey:SymphoxAPIParam_remark];
        if (remark != nil && ([remark isEqual:[NSNull null]] == NO) && [remark length] > 0)
        {
            cell.labelDetail.text = remark;
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
        
        NSNumber *quantity = [dictionary objectForKey:SymphoxAPIParam_qty];
        if (quantity == nil || [quantity isEqual:[NSNull null]])
        {
            quantity = [NSNumber numberWithInteger:0];
        }
        NSString *quantityString = [NSString stringWithFormat:@"%@%li", [LocalizedString Quantity], (long)[quantity integerValue]];
        cell.labelQuantity.text = quantityString;
        
        NSNumber *productIdentifier = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        NSString *paymentDiscription = nil;
        if (productIdentifier != nil && ([productIdentifier isEqual:[NSNull null]] == NO))
        {
            NSDictionary *purchaseInfos = [[TMInfoManager sharedManager] purchaseInfoForCartType:self.currentType];
            NSDictionary *purchaseInfo = [purchaseInfos objectForKey:productIdentifier];
            paymentDiscription = [purchaseInfo objectForKey:SymphoxAPIParam_discount_detail_desc];
        }
        if (paymentDiscription != nil && ([paymentDiscription isEqual:[NSNull null]] == NO))
        {
            cell.labelPayment.text = paymentDiscription;
        }
        else
        {
            cell.labelPayment.text = @"";
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

#pragma mark - CartProductTableViewCellDelegate

- (void)cartProductTableViewCell:(CartProductTableViewCell *)cell didPressedConditionBySender:(id)sender
{
    
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
        NSString *name = [[TMInfoManager sharedManager] nameOfRemovedProductId:productId inCart:weakSelf.currentType];
        if (name)
        {
            [self checkCartForType:weakSelf.currentType];
        }
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionConfirm];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
