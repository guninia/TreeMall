//
//  PaymentTypeViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/25.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "PaymentTypeViewController.h"
#import "APIDefinition.h"
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "LocalizedString.h"
#import "ChosenDiscountTableViewCell.h"
#import "PaymentTypeHeaderView.h"
#import "ExchangeDescriptionViewController.h"
#import "ReceiverInfoViewController.h"

#define kPaymentSectionId @"PaymentSectionId"
#define kPaymentSectionTitle @"PaymentSectionTitle"
#define kPaymentSectionContent @"PaymentSectionContent"
#define kPaymentOptionTitle @"PaymentOptionTitle"
#define kPaymentOptionActionTitle @"PaymentOptionActionTitle"

@interface PaymentTypeViewController ()

- (void)prepareData;
- (void)requestBuyNowDeliveryInfo;
- (void)refreshContent;
- (void)startToCheckPayment;
- (void)requestResultOfCheckPaymentWithParams:(NSDictionary *)params;

- (void)buttonAgreePressed:(id)sender;
- (void)buttonTermsContentPressed:(id)sender;
- (void)buttonNextPressed:(id)sender;

@end

@implementation PaymentTypeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _dictionaryData = nil;
        _type = CartTypeTotal;
        _selectedIndexPathOfPayment = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = [LocalizedString PaymentType];
    [self.scrollView addSubview:self.tableViewDiscount];
    [self.scrollView addSubview:self.tableViewPayment];
    [self.scrollView addSubview:self.switchAgree];
    [self.scrollView addSubview:self.labelAgree];
    [self.scrollView addSubview:self.buttonAgree];
    [self.scrollView addSubview:self.buttonTermsContent];
    [self.scrollView addSubview:self.buttonNext];
    [self.navigationController.tabBarController.view addSubview:self.viewLoading];
    [self prepareData];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat marginH = 10.0;
    CGFloat marginV = 10.0;
    CGFloat intervalV = 10.0;
    CGFloat originY = CGRectGetMaxY(self.labelDiscountTitle.frame) + intervalV;
    if (self.tableViewDiscount)
    {
        CGRect sectionRect = [self.tableViewDiscount rectForSection:0];
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, sectionRect.size.height);
        self.tableViewDiscount.frame = frame;
        originY = self.tableViewDiscount.frame.origin.y + self.tableViewDiscount.frame.size.height + intervalV;
    }
    if (self.separator)
    {
        CGRect frame = self.separator.frame;
        frame.origin.y = originY;
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    }
    if (self.labelPaymentTitle)
    {
        CGRect frame = self.labelPaymentTitle.frame;
        frame.origin.y = originY;
        self.labelPaymentTitle.frame = frame;
        originY = self.labelPaymentTitle.frame.origin.y + self.labelPaymentTitle.frame.size.height + intervalV;
    }
    if (self.tableViewPayment)
    {
        CGFloat tableViewHeight = 0.0;
        NSInteger totalSections = [self numberOfSectionsInTableView:self.tableViewPayment];
        for (NSInteger section = 0; section < totalSections; section++)
        {
            CGRect sectionRect = [self.tableViewPayment rectForSection:section];
            tableViewHeight += sectionRect.size.height;
        }
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, tableViewHeight);
        self.tableViewPayment.frame = frame;
        originY = self.tableViewPayment.frame.origin.y + self.tableViewPayment.frame.size.height + intervalV;
    }
    if (self.switchAgree)
    {
        CGSize size = CGSizeMake(40.0, 30.0);
        CGRect frame = CGRectMake(marginH, originY, size.width, size.height);
        self.switchAgree.frame = frame;
    }
    if (self.labelAgree)
    {
        CGFloat originX = CGRectGetMaxX(self.switchAgree.frame) + 3.0;
        CGFloat maxWidth = self.scrollView.frame.size.width - marginH * 2;
        NSString *text = self.labelAgree.text;
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = self.labelAgree.lineBreakMode;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelAgree.font, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
        CGSize sizeText = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGSize sizeButton = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, self.switchAgree.frame.origin.y + (self.switchAgree.frame.size.height - sizeButton.height)/2, maxWidth, sizeButton.height);
        self.labelAgree.frame = frame;
    }
    if (self.buttonAgree)
    {
        self.buttonAgree.frame = self.labelAgree.frame;
    }
    originY = MAX(CGRectGetMaxY(self.switchAgree.frame), CGRectGetMaxY(self.labelAgree.frame)) + intervalV;
    if (self.buttonTermsContent)
    {
        CGSize size = CGSizeMake(100.0, 30.0);
        CGRect frame = CGRectMake(marginH, originY, size.width, size.height);
        self.buttonTermsContent.frame = frame;
        originY = CGRectGetMaxY(self.buttonTermsContent.frame) + intervalV;
    }
    if (self.buttonNext)
    {
        CGRect frame = CGRectMake(marginH, originY, self.scrollView.frame.size.width - marginH * 2, 40.0);
        self.buttonNext.frame = frame;
        originY = CGRectGetMaxY(self.buttonNext.frame) + marginV;
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, originY)];
    
    if (self.viewLoading)
    {
        self.viewLoading.frame = self.navigationController.tabBarController.view.bounds;
        self.viewLoading.indicatorCenter = self.viewLoading.center;
        [self.viewLoading setNeedsLayout];
    }
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

- (UITableView *)tableViewDiscount
{
    if (_tableViewDiscount == nil)
    {
        _tableViewDiscount = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableViewDiscount setDataSource:self];
        [_tableViewDiscount setDelegate:self];
        [_tableViewDiscount registerClass:[ChosenDiscountTableViewCell class] forCellReuseIdentifier:ChosenDiscountTableViewCellIdentifier];
        [_tableViewDiscount setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableViewDiscount;
}

- (UITableView *)tableViewPayment
{
    if (_tableViewPayment == nil)
    {
        _tableViewPayment = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableViewPayment setDataSource:self];
        [_tableViewPayment setDelegate:self];
        [_tableViewPayment registerClass:[PaymentTypeTableViewCell class] forCellReuseIdentifier:PaymentTypeTableViewCellIdentifier];
        [_tableViewPayment registerClass:[PaymentTypeHeaderView class] forHeaderFooterViewReuseIdentifier:PaymentTypeHeaderViewIdentifier];
    }
    return _tableViewPayment;
}

- (UISwitch *)switchAgree
{
    if (_switchAgree == nil)
    {
        _switchAgree = [[UISwitch alloc] initWithFrame:CGRectZero];
    }
    return _switchAgree;
}

- (UILabel *)labelAgree
{
    if (_labelAgree == nil)
    {
        _labelAgree = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelAgree setBackgroundColor:[UIColor clearColor]];
        [_labelAgree setTextColor:[UIColor blackColor]];
        [_labelAgree setText:[LocalizedString AgreeTreeMallBusinessTerm]];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelAgree setFont:font];
        [_labelAgree setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelAgree setTextAlignment:NSTextAlignmentLeft];
        [_labelAgree setNumberOfLines:0];
    }
    return _labelAgree;
}

- (UIButton *)buttonAgree
{
    if (_buttonAgree == nil)
    {
        _buttonAgree = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonAgree setBackgroundColor:[UIColor clearColor]];
        [_buttonAgree addTarget:self action:@selector(buttonAgreePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonAgree;
}

- (UIButton *)buttonTermsContent
{
    if (_buttonTermsContent == nil)
    {
        _buttonTermsContent = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonTermsContent setTitle:[LocalizedString TermsDetail] forState:UIControlStateNormal];
        [_buttonTermsContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonTermsContent addTarget:self action:@selector(buttonTermsContentPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonTermsContent setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:165.0/255.0 blue:65.0/255.0 alpha:1.0]];
        [_buttonTermsContent.layer setCornerRadius:5.0];
    }
    return _buttonTermsContent;
}

- (UIButton *)buttonNext
{
    if (_buttonNext == nil)
    {
        _buttonNext = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonNext setBackgroundColor:[UIColor orangeColor]];
        [_buttonNext.layer setCornerRadius:5.0];
        [_buttonNext setTitle:[LocalizedString NextStep] forState:UIControlStateNormal];
        [_buttonNext addTarget:self action:@selector(buttonNextPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonNext;
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

- (NSMutableArray *)arrayDiscount
{
    if (_arrayDiscount == nil)
    {
        _arrayDiscount = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayDiscount;
}

- (NSMutableArray *)arrayInstallment
{
    if (_arrayInstallment == nil)
    {
        _arrayInstallment = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayInstallment;
}

- (NSMutableArray *)arrayPaymentSections
{
    if (_arrayPaymentSections == nil)
    {
        _arrayPaymentSections = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayPaymentSections;
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

- (void)prepareData
{
    if (self.dictionaryData == nil)
        return;
    
    NSArray *productArray = [[TMInfoManager sharedManager] productArrayForCartType:self.type];
    NSDictionary *dictionaryPurchaseInfo = [[TMInfoManager sharedManager] purchaseInfoForCartType:self.type];
    
    for (NSDictionary *product in productArray)
    {
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId == nil || [productId isEqual:[NSNull null]])
            continue;
        NSDictionary *purchaseInfo = [dictionaryPurchaseInfo objectForKey:productId];
        if (purchaseInfo == nil)
            continue;
        NSString *discount_type = [purchaseInfo objectForKey:SymphoxAPIParam_discount_type_desc];
        NSString *discount_detail = [purchaseInfo objectForKey:SymphoxAPIParam_discount_detail_desc];
        if (discount_type || discount_detail)
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            if (discount_type)
            {
                [dictionary setObject:discount_type forKey:SymphoxAPIParam_discount_type_desc];
            }
            if (discount_detail)
            {
                [dictionary setObject:discount_detail forKey:SymphoxAPIParam_discount_detail_desc];
            }
            [self.arrayDiscount addObject:dictionary];
        }
    }
    
    
    NSArray *additionProductArray = [[TMInfoManager sharedManager] productArrayForAdditionalCartType:self.type];
    NSDictionary *dictionaryAdditionPurchaseInfo = [[TMInfoManager sharedManager] purchaseInfoForAdditionalCartType:self.type];
    
    for (NSDictionary *product in additionProductArray)
    {
        NSNumber *productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId == nil || [productId isEqual:[NSNull null]])
            continue;
        NSDictionary *purchaseInfo = [dictionaryAdditionPurchaseInfo objectForKey:productId];
        if (purchaseInfo == nil)
            continue;
        NSString *discount_type = [purchaseInfo objectForKey:SymphoxAPIParam_discount_type_desc];
        NSString *discount_detail = [purchaseInfo objectForKey:SymphoxAPIParam_discount_detail_desc];
        if (discount_type || discount_detail)
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            if (discount_type)
            {
                [dictionary setObject:discount_type forKey:SymphoxAPIParam_discount_type_desc];
            }
            if (discount_detail)
            {
                [dictionary setObject:discount_detail forKey:SymphoxAPIParam_discount_detail_desc];
            }
            [self.arrayDiscount addObject:dictionary];
        }
    }
    
    [self.tableViewDiscount reloadData];
    
    NSLog(@"purchaseInfoForCartType:\n%@", [dictionaryPurchaseInfo description]);
    
    NSDictionary *account_result = [self.dictionaryData objectForKey:SymphoxAPIParam_account_result];
    if (account_result && [account_result isEqual:[NSNull null]] == NO)
    {
        NSDictionary *installmentMap = [account_result objectForKey:SymphoxAPIParam_installment_map];
        if (installmentMap && [installmentMap isEqual:[NSNull null]] == NO)
        {
            NSArray *allkeys = [installmentMap allKeys];
            
            // Sort by ascending
            NSArray *sortedArray = [allkeys sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2){
                NSComparisonResult comparisonResult = NSOrderedSame;
                NSInteger key1Value = [key1 integerValue];
                NSInteger key2Value = [key2 integerValue];
                if (key1Value < key2Value)
                {
                    comparisonResult = NSOrderedAscending;
                }
                else if (key1Value > key2Value)
                {
                    comparisonResult = NSOrderedDescending;
                }
                return comparisonResult;
            }];
            for (NSString *key in sortedArray)
            {
                NSMutableDictionary *installment = [NSMutableDictionary dictionary];
                NSNumber *installmentTerm = [NSNumber numberWithInteger:[key integerValue]];
                NSNumber *installmentAmount = [installmentMap objectForKey:key];
                if (installmentTerm && installmentAmount && [installmentAmount isEqual:[NSNull null]] == NO)
                {
                    [installment setObject:installmentTerm forKey:SymphoxAPIParam_installment_term];
                    [installment setObject:installmentAmount forKey:SymphoxAPIParam_installment_amount];
                }
                [self.arrayInstallment addObject:installment];
            }
        }
        NSLog(@"self.arrayInstallment:\n%@", [self.arrayInstallment description]);
        NSArray *trans_ids = [account_result objectForKey:SymphoxAPIParam_trade_id];
        if (trans_ids && [trans_ids isEqual:[NSNull null]] == NO)
        {
            for (NSString *paymentId in trans_ids)
            {
                NSMutableDictionary *section = [NSMutableDictionary dictionary];
                if ([paymentId isEqualToString:@"C"])
                {
                    // Credit card
                    NSString *sectionTitle = [LocalizedString CreditCard];
                    NSMutableArray *content = [NSMutableArray array];
                    if (content)
                    {
                        NSMutableDictionary *option = [NSMutableDictionary dictionary];
                        NSString *string = [LocalizedString OneTimePayment];
                        [option setObject:string forKey:kPaymentOptionTitle];
                        [content addObject:option];
                    }
                    [section setObject:paymentId forKey:kPaymentSectionId];
                    [section setObject:sectionTitle forKey:kPaymentSectionTitle];
                    [section setObject:content forKey:kPaymentSectionContent];
                }
                else if ([paymentId isEqualToString:@"A"])
                {
                    // ATM
                    NSString *sectionTitle = @"ATM";
                    NSMutableArray *content = [NSMutableArray array];
                    if (content)
                    {
                        NSMutableDictionary *option = [NSMutableDictionary dictionary];
                        NSString *string = [LocalizedString OneTimePayment];
                        [option setObject:string forKey:kPaymentOptionTitle];
                        [content addObject:option];
                    }
                    [section setObject:paymentId forKey:kPaymentSectionId];
                    [section setObject:sectionTitle forKey:kPaymentSectionTitle];
                    [section setObject:content forKey:kPaymentSectionContent];
                }
                else if ([paymentId isEqualToString:@"I"])
                {
                    if ([self.arrayInstallment count] == 0)
                    {
                        continue;
                    }
                    // Credit card installment
                    NSString *sectionTitle = [LocalizedString CreditCardInstallment];
                    NSMutableArray *content = [NSMutableArray array];
                    if (content)
                    {
                        for (NSDictionary *installment in self.arrayInstallment)
                        {
                            NSMutableDictionary *option = [NSMutableDictionary dictionary];
                            
                            NSNumber *installmentTerm = [installment objectForKey:SymphoxAPIParam_installment_term];
                            NSNumber *installmentAmount = [installment objectForKey:SymphoxAPIParam_installment_amount];
                            NSString *stringAmount = [self.formatter stringFromNumber:installmentAmount];
                            NSString *totalString = [[[[stringAmount stringByAppendingString:[LocalizedString Dollars]] stringByAppendingString:@"Ｘ"] stringByAppendingString:[installmentTerm stringValue]] stringByAppendingString:[LocalizedString InstallmentTerm]];
                            
                            [option setObject:totalString forKey:kPaymentOptionTitle];
                            [content addObject:option];
                        }
                    }
                    [section setObject:paymentId forKey:kPaymentSectionId];
                    [section setObject:sectionTitle forKey:kPaymentSectionTitle];
                    [section setObject:content forKey:kPaymentSectionContent];
                }
                else if ([paymentId isEqualToString:@"S"])
                {
                    // SmartPay
                    NSString *sectionTitle = @"Smart Pay";
                    NSMutableArray *content = [NSMutableArray array];
                    if (content)
                    {
                        NSMutableDictionary *option = [NSMutableDictionary dictionary];
                        NSString *string = [LocalizedString OneTimePayment];
                        [option setObject:string forKey:kPaymentOptionTitle];
                        [content addObject:option];
                    }
                    [section setObject:paymentId forKey:kPaymentSectionId];
                    [section setObject:sectionTitle forKey:kPaymentSectionTitle];
                    [section setObject:content forKey:kPaymentSectionContent];
                }
                else if ([paymentId isEqualToString:@"O"])
                {
                    // 立即購
                    NSString *sectionTitle = [LocalizedString BuyNow];
                    NSMutableArray *content = [NSMutableArray array];
                    if (content)
                    {
                        NSMutableDictionary *option = [NSMutableDictionary dictionary];
                        NSString *string = [LocalizedString OneTimePayment];
                        [option setObject:string forKey:kPaymentOptionTitle];
                        [option setObject:[LocalizedString Activate] forKey:kPaymentOptionActionTitle];
                        [content addObject:option];
                    }
                    [section setObject:paymentId forKey:kPaymentSectionId];
                    [section setObject:sectionTitle forKey:kPaymentSectionTitle];
                    [section setObject:content forKey:kPaymentSectionContent];
                }
                else if ([paymentId isEqualToString:@"O2"])
                {
                    if ([self.arrayInstallment count] == 0)
                    {
                        continue;
                    }
                    // 立即購分期
                    NSString *sectionTitle = [LocalizedString BuyNowInstallment];
                    NSMutableArray *content = [NSMutableArray array];
                    if (content)
                    {
                        for (NSDictionary *installment in self.arrayInstallment)
                        {
                            NSMutableDictionary *option = [NSMutableDictionary dictionary];
                            
                            NSNumber *installmentTerm = [installment objectForKey:SymphoxAPIParam_installment_term];
                            NSNumber *installmentAmount = [installment objectForKey:SymphoxAPIParam_installment_amount];
                            NSString *stringAmount = [self.formatter stringFromNumber:installmentAmount];
                            NSString *totalString = [[[[stringAmount stringByAppendingString:[LocalizedString Dollars]] stringByAppendingString:@"Ｘ"] stringByAppendingString:[installmentTerm stringValue]] stringByAppendingString:[LocalizedString InstallmentTerm]];
                            
                            [option setObject:totalString forKey:kPaymentOptionTitle];
                            [content addObject:option];
                        }
                    }
                    [section setObject:paymentId forKey:kPaymentSectionId];
                    [section setObject:sectionTitle forKey:kPaymentSectionTitle];
                    [section setObject:content forKey:kPaymentSectionContent];
                }
                else if ([paymentId isEqualToString:@"I"])
                {
                    if ([self.arrayInstallment count] == 0)
                    {
                        continue;
                    }
                    // 一點折一元信用卡分期
                    NSString *sectionTitle = [LocalizedString PointAsDollarCreditCardInstallment];
                    NSMutableArray *content = [NSMutableArray array];
                    if (content)
                    {
                        for (NSDictionary *installment in self.arrayInstallment)
                        {
                            NSMutableDictionary *option = [NSMutableDictionary dictionary];
                            
                            NSNumber *installmentTerm = [installment objectForKey:SymphoxAPIParam_installment_term];
                            NSNumber *installmentAmount = [installment objectForKey:SymphoxAPIParam_installment_amount];
                            NSString *stringAmount = [self.formatter stringFromNumber:installmentAmount];
                            NSString *totalString = [[[[stringAmount stringByAppendingString:[LocalizedString Dollars]] stringByAppendingString:@"Ｘ"] stringByAppendingString:[installmentTerm stringValue]] stringByAppendingString:[LocalizedString InstallmentTerm]];
                            
                            [option setObject:totalString forKey:kPaymentOptionTitle];
                            [content addObject:option];
                        }
                    }
                    [section setObject:paymentId forKey:kPaymentSectionId];
                    [section setObject:sectionTitle forKey:kPaymentSectionTitle];
                    [section setObject:content forKey:kPaymentSectionContent];
                }
                else if ([paymentId isEqualToString:@"P"])
                {
                    // 貨到付款
                    NSString *sectionTitle = [LocalizedString PayAfterDelivery];
                    NSMutableArray *content = [NSMutableArray array];
                    if (content)
                    {
                        NSMutableDictionary *option = [NSMutableDictionary dictionary];
                        NSString *string = [LocalizedString OneTimePayment];
                        [option setObject:string forKey:kPaymentOptionTitle];
                        [content addObject:option];
                    }
                    [section setObject:paymentId forKey:kPaymentSectionId];
                    [section setObject:sectionTitle forKey:kPaymentSectionTitle];
                    [section setObject:content forKey:kPaymentSectionContent];
                }
                else if ([paymentId isEqualToString:@"L"])
                {
                    // LinePay
                    NSString *sectionTitle = @"Line Pay";
                    NSMutableArray *content = [NSMutableArray array];
                    if (content)
                    {
                        NSMutableDictionary *option = [NSMutableDictionary dictionary];
                        NSString *string = [LocalizedString OneTimePayment];
                        [option setObject:string forKey:kPaymentOptionTitle];
                        [content addObject:option];
                    }
                    [section setObject:paymentId forKey:kPaymentSectionId];
                    [section setObject:sectionTitle forKey:kPaymentSectionTitle];
                    [section setObject:content forKey:kPaymentSectionContent];
                }
                [self.arrayPaymentSections addObject:section];
            }
        }
        [self.tableViewPayment reloadData];
    }
    [self requestBuyNowDeliveryInfo];
    [self refreshContent];
}

- (void)requestBuyNowDeliveryInfo
{
    __weak PaymentTypeViewController *weakSelf = self;
    if ([TMInfoManager sharedManager].userIdentifier == nil)
        return;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_getBuyNowDeliveryInfo];
    NSLog(@"login url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[TMInfoManager sharedManager].userIdentifier, SymphoxAPIParam_user_num, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        NSString *errorDescription = nil;
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"string[%@]", string);
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error == nil && array && [array isEqual:[NSNull null]] == NO)
                {
                    self.arrayBuyNowDelivery = array;
                    [self.tableViewPayment reloadData];
                }
            }
            else
            {
                NSLog(@"Unexpected data format.");
                errorDescription = [LocalizedString UnexpectedFormatFromNetwork];
            }
        }
        else
        {
            NSLog(@"error:\n%@", [error description]);
        }
    }];
}

- (void)refreshContent
{
    NSString *orderTitle = nil;
    switch (self.type) {
        case CartTypeCommonDelivery:
        {
            orderTitle = [[LocalizedString CommonDelivery] stringByAppendingString:[LocalizedString Order]];
        }
            break;
        case CartTypeStorePickup:
        {
            orderTitle = [[LocalizedString StorePickUp] stringByAppendingString:[LocalizedString Order]];
        }
            break;
        case CartTypeFastDelivery:
        {
            orderTitle = [[LocalizedString FastDelivery] stringByAppendingString:[LocalizedString Order]];
        }
            break;
        default:
            break;
    }
    self.labelOrderTitle.text = orderTitle;
    
    NSArray *cartItems = [self.dictionaryData objectForKey:SymphoxAPIParam_cart_item];
    NSInteger totalPieces = 0;
    if (cartItems && [cartItems isEqual:[NSNull null]] == NO)
    {
        for (NSDictionary *product in cartItems)
        {
            NSNumber *quantity = [product objectForKey:SymphoxAPIParam_qty];
            if (quantity && [quantity isEqual:[NSNull null]] == NO)
            {
                totalPieces += [quantity integerValue];
            }
        }
    }
    NSInteger totalProducts = [cartItems count];
    
    NSString *orderTotal = [NSString stringWithFormat:[LocalizedString Total_I_ProductAnd_I_Pieces], (long)totalProducts, (long)totalPieces];
    self.labelOrderTotal.text = orderTotal;
    self.labelTotalTitle.text = [LocalizedString TotalCount];
    NSDictionary *account_result = [self.dictionaryData objectForKey:SymphoxAPIParam_account_result];
    NSMutableAttributedString *stringCash = nil;
    NSMutableAttributedString *stringEPoint = nil;
    NSMutableAttributedString *stringPoint = nil;
    NSMutableAttributedString *stringCathayCash = nil;
    NSDictionary *attributesOrange = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName, nil];
    NSDictionary *attributesBlack = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil];
    if (account_result && [account_result isEqual:[NSNull null]] == NO)
    {
        NSNumber *total_cash = [account_result objectForKey:SymphoxAPIParam_total_cash];
        if (total_cash && [total_cash isEqual:[NSNull null]] == NO && [total_cash integerValue] > 0)
        {
            NSString *cash = [self.formatter stringFromNumber:total_cash];
            NSAttributedString *dolloars = [[NSAttributedString alloc] initWithString:[LocalizedString Dollars] attributes:attributesBlack];
            stringCash = [[NSMutableAttributedString alloc] initWithString:cash attributes:attributesOrange];
            [stringCash appendAttributedString:dolloars];
        }
        NSNumber *total_ePoint = [account_result objectForKey:SymphoxAPIParam_total_ePoint];
        if (total_ePoint && [total_ePoint isEqual:[NSNull null]] == NO && [total_ePoint integerValue] > 0)
        {
            NSString *ePoint = [self.formatter stringFromNumber:total_ePoint];
            NSAttributedString *point = [[NSAttributedString alloc] initWithString:[LocalizedString Point] attributes:attributesBlack];
            stringEPoint = [[NSMutableAttributedString alloc] initWithString:ePoint attributes:attributesOrange];
            [stringEPoint appendAttributedString:point];
        }
        NSNumber *total_point = [account_result objectForKey:SymphoxAPIParam_total_point];
        if (total_point && [total_point isEqual:[NSNull null]] == NO && [total_point integerValue] > 0)
        {
            NSString *point = [self.formatter stringFromNumber:total_point];
            NSAttributedString *bonusPoint = [[NSAttributedString alloc] initWithString:[LocalizedString BonusPoint] attributes:attributesBlack];
            stringPoint = [[NSMutableAttributedString alloc] initWithString:point attributes:attributesOrange];
            [stringPoint appendAttributedString:bonusPoint];
        }
        NSNumber *total_cathay_cash = [account_result objectForKey:SymphoxAPIParam_total_cathay_cash];
        if (total_cathay_cash && [total_cathay_cash isEqual:[NSNull null]] == NO && [total_cathay_cash integerValue] > 0)
        {
            NSString *totalCathayCash = [self.formatter stringFromNumber:total_cathay_cash];
            NSAttributedString *cathayCash = [[NSAttributedString alloc] initWithString:[LocalizedString CathayCash] attributes:attributesOrange];
            stringCathayCash = [[NSMutableAttributedString alloc] initWithString:totalCathayCash attributes:attributesOrange];
            [stringCathayCash appendAttributedString:cathayCash];
        }
    }
    NSAttributedString *plus = [[NSAttributedString alloc] initWithString:@"＋" attributes:attributesBlack];
    NSMutableAttributedString *totalCost = [[NSMutableAttributedString alloc] init];
    if (stringCash)
    {
        [totalCost appendAttributedString:stringCash];
    }
    if (stringEPoint)
    {
        if ([totalCost length] > 0)
        {
            [totalCost appendAttributedString:plus];
        }
        [totalCost appendAttributedString:stringEPoint];
    }
    if (stringPoint)
    {
        if ([totalCost length] > 0)
        {
            [totalCost appendAttributedString:plus];
        }
        [totalCost appendAttributedString:stringPoint];
    }
    if (stringCathayCash)
    {
        if ([totalCost length] > 0)
        {
            [totalCost appendAttributedString:plus];
        }
        [totalCost appendAttributedString:stringCathayCash];
    }
    [self.labelTotalAmount setAttributedText:totalCost];
    
    self.labelDiscountTitle.text = [LocalizedString DiscountChosen];
    self.labelPaymentTitle.text = [LocalizedString PaymentType];
    [self.tableViewDiscount reloadData];
}

- (void)startToCheckPayment
{
    NSString *paymentId = nil;
    NSNumber *installmentTerm = nil;
    NSDictionary *installment = nil;
    if (self.selectedIndexPathOfPayment && self.selectedIndexPathOfPayment.section < [self.arrayPaymentSections count])
    {
        NSDictionary *section = [self.arrayPaymentSections objectAtIndex:self.selectedIndexPathOfPayment.section];
        paymentId = [section objectForKey:kPaymentSectionId];
        if ([paymentId isEqualToString:@"I"] || [paymentId isEqualToString:@"O2"])
        {
            if (self.selectedIndexPathOfPayment.row < [self.arrayInstallment count])
            {
                installment = [self.arrayInstallment objectAtIndex:self.selectedIndexPathOfPayment.row];
                installmentTerm = [installment objectForKey:SymphoxAPIParam_installment_term];
            }
        }
    }
    if (installment)
    {
        self.selectedInstallment = installment;
    }
    
    if (paymentId == nil)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString PleaseChoosePaymentType] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSArray *array = [[TMInfoManager sharedManager] productArrayForCartType:self.type];
    if (array == nil)
        return;
    
    NSDictionary *dictionary = [[TMInfoManager sharedManager] purchaseInfoForCartType:self.type];
    
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
        NSMutableDictionary *dictionaryMode = [[purchaseInfo objectForKey:SymphoxAPIParam_payment_mode] mutableCopy];
        if (dictionaryMode == nil)
        {
            dictionaryMode = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", SymphoxAPIParam_payment_type, [NSNumber numberWithInteger:0], SymphoxAPIParam_price, nil];
        }
        NSNumber *paymentType = [dictionaryMode objectForKey:SymphoxAPIParam_payment_type];
        NSString *stringPaymentType = [paymentType stringValue];
        [dictionaryMode setObject:stringPaymentType forKey:SymphoxAPIParam_payment_type];
        [dictionaryMode setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        
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
    
    NSArray *arrayAddition = [[TMInfoManager sharedManager] productArrayForAdditionalCartType:self.type];
    NSDictionary *dictionaryAddition = [[TMInfoManager sharedManager] purchaseInfoForAdditionalCartType:self.type];
    
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
        NSMutableDictionary *dictionaryMode = [[purchaseInfo objectForKey:SymphoxAPIParam_payment_mode] mutableCopy];
        if (dictionaryMode == nil)
        {
            dictionaryMode = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", SymphoxAPIParam_payment_type, [NSNumber numberWithInteger:0], SymphoxAPIParam_price, nil];
        }
        NSNumber *paymentType = [dictionaryMode objectForKey:SymphoxAPIParam_payment_type];
        NSString *stringPaymentType = [paymentType stringValue];
        [dictionaryMode setObject:stringPaymentType forKey:SymphoxAPIParam_payment_type];
        [dictionaryMode setObject:productId forKey:SymphoxAPIParam_cpdt_num];
        
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSNumber *userId = [TMInfoManager sharedManager].userIdentifier;
    NSString *cartType = [NSString stringWithFormat:@"%li", (long)(self.type)];
    [params setObject:[userId stringValue] forKey:SymphoxAPIParam_user_num];
    [params setObject:cartType forKey:SymphoxAPIParam_cart_type];
    [params setObject:arrayCheck forKey:SymphoxAPIParam_cart_item_order];
    [params setObject:paymentId forKey:SymphoxAPIParam_trade_id];
    if (installmentTerm)
    {
        [params setObject:installmentTerm forKey:SymphoxAPIParam_installment];
    }
    [self requestResultOfCheckPaymentWithParams:params];
}

- (void)requestResultOfCheckPaymentWithParams:(NSDictionary *)params
{
    __weak PaymentTypeViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_checkPayment];
//    NSLog(@"requestResultOfCheckPaymentWithParams - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    
    [self showLoadingViewAnimated:YES];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"requestResultOfCheckPaymentWithParams:\n%@", string);
            }
            
            else
            {
                NSLog(@"requestResultOfCheckPaymentWithParams - Unexpected data format.");
            }
            // Received result representing success. Go to next step.
            ReceiverInfoViewController *viewController = [[ReceiverInfoViewController alloc] initWithNibName:@"ReceiverInfoViewController" bundle:[NSBundle mainBundle]];
            viewController.type = weakSelf.type;
            if (weakSelf.selectedInstallment)
            {
                viewController.dictionaryInstallment = weakSelf.selectedInstallment;
            }
            [weakSelf.navigationController pushViewController:viewController animated:YES];
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
            NSLog(@"requestResultOfCheckPaymentWithParams - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:NO];
    }];
}

#pragma mark - Actions

- (void)buttonAgreePressed:(id)sender
{
    [self.switchAgree setOn:![self.switchAgree isOn] animated:YES];
}

- (void)buttonTermsContentPressed:(id)sender
{
    ExchangeDescriptionViewController *viewController = [[ExchangeDescriptionViewController alloc] initWithNibName:nil bundle:nil];
    viewController.type = DescriptionViewTypeEcommercial;
    viewController.title = [LocalizedString TermsDetail];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)buttonNextPressed:(id)sender
{
    if ([self.switchAgree isOn] == NO)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString AcceptTheTermsFirst] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
//    [self startToCheckPayment];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 0;
    if (tableView == self.tableViewDiscount)
    {
        numberOfSections = 1;
    }
    else if (tableView == self.tableViewPayment)
    {
        numberOfSections = [self.arrayPaymentSections count];
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (tableView == self.tableViewDiscount)
    {
        numberOfRows = [self.arrayDiscount count];
        NSLog(@"self.arrayDiscount[%li]", (long)self.arrayDiscount.count);
    }
    else if (tableView == self.tableViewPayment)
    {
        if (section < [self.arrayPaymentSections count])
        {
            NSDictionary *singleSection = [self.arrayPaymentSections objectAtIndex:section];
            NSArray *content = [singleSection objectForKey:kPaymentSectionContent];
            if (content)
            {
                numberOfRows = [content count];
            }
        }
    }
    return numberOfRows;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    if (tableView == self.tableViewPayment)
    {
        PaymentTypeHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PaymentTypeHeaderViewIdentifier];
        if (view == nil)
        {
            view = [[PaymentTypeHeaderView alloc] initWithReuseIdentifier:PaymentTypeHeaderViewIdentifier];
        }
        view.tag = section;
        if (section < [self.arrayPaymentSections count])
        {
            NSDictionary *dictionarySection = [self.arrayPaymentSections objectAtIndex:section];
            NSString *title = [dictionarySection objectForKey:kPaymentSectionTitle];
            if (title)
            {
                view.labelTitle.text = title;
            }
        }
        headerView = view;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.tableViewDiscount)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:ChosenDiscountTableViewCellIdentifier forIndexPath:indexPath];
        NSString *type = @"";
        NSString *detail = @"";
        if (indexPath.row < [self.arrayDiscount count])
        {
            NSDictionary *discount = [self.arrayDiscount objectAtIndex:indexPath.row];
            NSLog(@"discount:\n%@", [discount description]);
            NSString *discount_type = [discount objectForKey:SymphoxAPIParam_discount_type_desc];
            if (discount_type)
            {
                type = discount_type;
            }
            NSString *discount_detail = [discount objectForKey:SymphoxAPIParam_discount_detail_desc];
            if (discount_detail)
            {
                detail = discount_detail;
            }
        }
        ChosenDiscountTableViewCell *discountCell = (ChosenDiscountTableViewCell *)cell;
        discountCell.labelTitle.text = type;
        discountCell.labelDetail.text = detail;
    }
    else if (tableView == self.tableViewPayment)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:PaymentTypeTableViewCellIdentifier forIndexPath:indexPath];
        cell.tag = indexPath.row;
        PaymentTypeTableViewCell *paymentCell = (PaymentTypeTableViewCell *)cell;
        if (paymentCell.delegate == nil)
        {
            paymentCell.delegate = self;
        }
        NSString *title = @"";
        NSString *actionTitle = nil;
        if (indexPath.section < [self.arrayPaymentSections count])
        {
            NSDictionary *dictionarySection = [self.arrayPaymentSections objectAtIndex:indexPath.section];
            NSString *sectionId = [dictionarySection objectForKey:kPaymentSectionId];
            NSArray *content = [dictionarySection objectForKey:kPaymentSectionContent];
            if (content)
            {
                if (indexPath.row < [content count])
                {
                    NSDictionary *option = [content objectAtIndex:indexPath.row];
                    NSString *optionTitle = [option objectForKey:kPaymentOptionTitle];
                    if (optionTitle)
                    {
                        title = optionTitle;
                    }
                    NSString *optionActionTitle = [option objectForKey:kPaymentOptionActionTitle];
                    if (optionActionTitle)
                    {
                        if ([sectionId isEqualToString:@"O"] || [sectionId isEqualToString:@"O2"])
                        {
                            if ([TMInfoManager sharedManager].userOcbStatus != OCBStatusActivated)
                            {
                                actionTitle = optionActionTitle;
                                paymentCell.accessoryView = paymentCell.buttonAction;
                            }
                        }
                    }
                }
            }
        }
        paymentCell.labelTitle.text = title;
        if (actionTitle != nil)
        {
            paymentCell.buttonAction.tag = indexPath.section;
        }
        paymentCell.actionTitle = actionTitle;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat heightForHeader = 0.0;
    if (tableView == self.tableViewPayment)
    {
        heightForHeader = 30.0;
    }
    return heightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0.0;
    if (tableView == self.tableViewDiscount)
    {
        heightForRow = 50.0;
    }
    else if (tableView == self.tableViewPayment)
    {
        heightForRow = 40.0;
    }
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryView == nil)
    {
        self.selectedIndexPathOfPayment = indexPath;
    }
}

#pragma mark - PaymentTypeTableViewCellDelegate

- (void)PaymentTypeTableViewCell:(PaymentTypeTableViewCell *)cell didSelectActionBySender:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"didSelectActionBySender[%li][%li]", button.tag, cell.tag);
}

@end
