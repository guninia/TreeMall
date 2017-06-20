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
#import "StorePickupInfoViewController.h"
#import "DiscountHeaderView.h"
#import "DiscountFooterView.h"

#define kDiscountSectionTitle @"DiscountSectionTitle"
#define kDiscountSectionContent @"DiscountSectionContent"
#define kDiscountSectionContentDesc @"DiscountSectionContentText"
#define kDiscountSectionContentValue @"DiscountSectionContentValue"
#define kDiscountSectionFooterDesc @"DiscountSectionFooterDesc"
#define kDiscountSectionFooterValue @"DiscountSectionFooterValue"
#define kPaymentSectionId @"PaymentSectionId"
#define kPaymentSectionTitle @"PaymentSectionTitle"
#define kPaymentSectionContent @"PaymentSectionContent"
#define kPaymentOptionTitle @"PaymentOptionTitle"
#define kPaymentOptionActionTitle @"PaymentOptionActionTitle"

static NSString *InstallmentBankListDescription = @"分期0利率（接受14家銀行）\n\n\n國泰世華、玉山、台北富邦、台新(需消費滿3000元)、新光、花旗、遠東商銀、大眾、第一商銀、華南、萬泰、匯豐、澳盛銀行、聯邦銀行";

@interface PaymentTypeViewController ()

- (void)prepareData;
- (void)requestBuyNowDeliveryInfo;
- (void)refreshContent;
- (void)startToCheckPayment;
- (void)requestResultOfCheckPaymentWithParams:(NSDictionary *)params;
- (void)retrieveInstallmentBanksData;
- (void)processInstallmentBanksData:(id)data;
- (void)showInstallmentBanks;

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
    if (self.navigationController.tabBarController != nil)
    {
        [self.navigationController.tabBarController.view addSubview:self.viewLoading];
    }
    else if (self.navigationController != nil)
    {
        [self.navigationController.view addSubview:self.viewLoading];
    }
    [self prepareData];
    [self retrieveInstallmentBanksData];
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
    
    CGFloat marginH = 10.0;
    CGFloat marginV = 10.0;
    CGFloat intervalV = 10.0;
    CGFloat originY = 0.0;
    if (self.labelDiscountTitle && [self.labelDiscountTitle isHidden] == NO)
    {
        CGRect frame = self.labelDiscountTitle.frame;
        frame.origin.y = originY;
        self.labelDiscountTitle.frame = frame;
        originY = CGRectGetMaxY(self.labelDiscountTitle.frame) + intervalV;
    }
    if (self.tableViewDiscount && [self.tableViewDiscount isHidden] == NO)
    {
        CGFloat tableViewHeight = 0.0;
        NSInteger totalSections = [self numberOfSectionsInTableView:self.tableViewDiscount];
        for (NSInteger section = 0; section < totalSections; section++)
        {
            CGRect sectionRect = [self.tableViewDiscount rectForSection:section];
            tableViewHeight += sectionRect.size.height;
        }
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, tableViewHeight);
        self.tableViewDiscount.frame = frame;
        originY = self.tableViewDiscount.frame.origin.y + self.tableViewDiscount.frame.size.height + intervalV;
    }
    if (self.separator1 && [self.separator1 isHidden] == NO)
    {
        CGRect frame = self.separator1.frame;
        frame.origin.y = originY;
        self.separator1.frame = frame;
        originY = CGRectGetMaxY(self.separator1.frame) + intervalV;
    }
    if (self.viewTotalCost)
    {
        CGRect frame = self.viewTotalCost.frame;
        frame.origin.y = originY;
        self.viewTotalCost.frame = frame;
        originY = CGRectGetMaxY(self.viewTotalCost.frame) + intervalV;
    }
    if (self.separator2)
    {
        CGRect frame = self.separator2.frame;
        frame.origin.y = originY;
        self.separator2.frame = frame;
        originY = self.separator2.frame.origin.y + self.separator2.frame.size.height + intervalV;
    }
    if (self.labelPaymentTitle && [self.labelPaymentTitle isHidden] == NO)
    {
        CGRect frame = self.labelPaymentTitle.frame;
        frame.origin.y = originY;
        self.labelPaymentTitle.frame = frame;
        originY = self.labelPaymentTitle.frame.origin.y + self.labelPaymentTitle.frame.size.height + intervalV;
    }
    if (self.tableViewPayment && [self.tableViewPayment isHidden] == NO)
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
        CGFloat maxWidth = self.scrollView.frame.size.width - originX - marginH;
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
        if (self.navigationController.tabBarController != nil)
        {
            self.viewLoading.frame = self.navigationController.tabBarController.view.bounds;
        }
        else if (self.navigationController != nil)
        {
            self.viewLoading.frame = self.navigationController.view.bounds;
        }
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
        [_tableViewDiscount registerClass:[DiscountHeaderView class] forHeaderFooterViewReuseIdentifier:DiscountHeaderViewIdentifier];
        [_tableViewDiscount registerClass:[DiscountFooterView class] forHeaderFooterViewReuseIdentifier:DiscountFooterViewIdentifier];
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
    
    NSDictionary *account_result = [self.dictionaryData objectForKey:SymphoxAPIParam_account_result];
    
    if (account_result && [account_result isEqual:[NSNull null]] == NO)
    {
        NSNumber *totalCouponUsed = [account_result objectForKey:SymphoxAPIParam_tot_dis_coupon_qty];
        if (totalCouponUsed && [totalCouponUsed isEqual:[NSNull null]] == NO && [totalCouponUsed integerValue] > 0)
        {
            NSMutableDictionary *sectionCoupon = [NSMutableDictionary dictionary];
            NSString *sectionTitle = [LocalizedString Coupon];
            [sectionCoupon setObject:sectionTitle forKey:kDiscountSectionTitle];
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            NSString *stringQuantity = [NSString stringWithFormat:@"%li%@", (long)[totalCouponUsed integerValue], [LocalizedString Pieces]];
            [dictionary setObject:stringQuantity forKey:kDiscountSectionContentDesc];
            
            NSNumber *totalCouponValue = [account_result objectForKey:SymphoxAPIParam_tot_dis_coupon_worth];
            if (totalCouponValue && [totalCouponValue isEqual:[NSNull null]] == NO && [totalCouponValue integerValue] > 0)
            {
                NSString *couponValue = [self.formatter stringFromNumber:totalCouponValue];
                if (couponValue)
                {
                    NSString *stringValue = [NSString stringWithFormat:@"(-$%@)", couponValue];
                    [dictionary setObject:stringValue forKey:kDiscountSectionContentValue];
                }
            }
            
            NSArray *arrayCoupon = [NSArray arrayWithObject:dictionary];
            [sectionCoupon setObject:arrayCoupon forKey:kDiscountSectionContent];
            [self.arrayDiscount addObject:sectionCoupon];
        }
        NSNumber *totalOtherDiscount = [account_result objectForKey:SymphoxAPIParam_tot_dis_other_cash];
        NSMutableDictionary *sectionOtherDiscount = [NSMutableDictionary dictionary];
        if (totalOtherDiscount && [totalOtherDiscount isEqual:[NSNull null]] == NO && [totalOtherDiscount integerValue] > 0)
        {
            NSString *sectionTitle = [LocalizedString OtherDiscount];
            [sectionOtherDiscount setObject:sectionTitle forKey:kDiscountSectionTitle];
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            NSString *stringContent = [LocalizedString OtherDiscountContent];
            [dictionary setObject:stringContent forKey:kDiscountSectionContentDesc];
            
            NSString *otherDiscount = [self.formatter stringFromNumber:totalOtherDiscount];
            if (otherDiscount)
            {
                NSString *stringValue = [NSString stringWithFormat:@"(-$%@)", otherDiscount];
                [dictionary setObject:stringValue forKey:kDiscountSectionContentValue];
            }
            
            NSArray *array = [NSArray arrayWithObject:dictionary];
            [sectionOtherDiscount setObject:array forKey:kDiscountSectionContent];
            [self.arrayDiscount addObject:sectionOtherDiscount];
        }
        
        if ([self.arrayDiscount count] > 0)
        {
            NSMutableDictionary *dictionarySection = [[self.arrayDiscount lastObject] mutableCopy];
            NSNumber *totalDiscount = [account_result objectForKey:SymphoxAPIParam_tot_dis_cash];
            if (totalDiscount && [totalDiscount isEqual:[NSNull null]] == NO && [totalDiscount integerValue] > 0)
            {
                NSString *stringDesc = [LocalizedString CheckPromotionTotalDiscount];
                [dictionarySection setObject:stringDesc forKey:kDiscountSectionFooterDesc];
                
                NSString *discount = [self.formatter stringFromNumber:totalDiscount];
                if (discount)
                {
                    NSString *stringValue = [NSString stringWithFormat:@"-$%@%@", discount, [LocalizedString Dollars]];
                    [dictionarySection setObject:stringValue forKey:kDiscountSectionFooterValue];
                }
            }
            [self.arrayDiscount replaceObjectAtIndex:([self.arrayDiscount count] - 1) withObject:dictionarySection];
            self.tableViewDiscount.hidden = NO;
            self.labelDiscountTitle.hidden = NO;
            self.separator1.hidden = NO;
        }
        else
        {
            self.tableViewDiscount.hidden = YES;
            self.labelDiscountTitle.hidden = YES;
            self.separator1.hidden = YES;
        }
        [self.tableViewDiscount reloadData];
        
        
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
        if (trans_ids && [trans_ids isEqual:[NSNull null]] == NO && [trans_ids count] > 0 && [[trans_ids objectAtIndex:0] isEqualToString:@"OP"] == NO)
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
                        for (NSInteger index = 0; index < [self.arrayInstallment count]; index++)
                        {
                            NSDictionary *installment = [self.arrayInstallment objectAtIndex:index];
                            NSMutableDictionary *option = [NSMutableDictionary dictionary];
                            
                            NSNumber *installmentTerm = [installment objectForKey:SymphoxAPIParam_installment_term];
                            NSNumber *installmentAmount = [installment objectForKey:SymphoxAPIParam_installment_amount];
                            NSString *stringAmount = [self.formatter stringFromNumber:installmentAmount];
                            NSString *totalString = [[[[stringAmount stringByAppendingString:[LocalizedString Dollars]] stringByAppendingString:@"Ｘ"] stringByAppendingString:[installmentTerm stringValue]] stringByAppendingString:[LocalizedString InstallmentTerm]];
                            [option setObject:totalString forKey:kPaymentOptionTitle];
                            if (index == 0)
                            {
                                [option setObject:[LocalizedString InstallmentAvailableBank] forKey:kPaymentOptionActionTitle];
                            }
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
                        if ([TMInfoManager sharedManager].userOcbStatus != OCBStatusActivated)
                        {
                            [option setObject:[LocalizedString Activate] forKey:kPaymentOptionActionTitle];
                        }
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
                    if ([TMInfoManager sharedManager].userOcbStatus != OCBStatusActivated)
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
        else
        {
            [self.labelPaymentTitle setHidden:YES];
            [self.tableViewPayment setHidden:YES];
        }
        [self.tableViewPayment reloadData];
    }
//    [self requestBuyNowDeliveryInfo];
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
    self.labelOrderTitle.text = [LocalizedString CheckoutInfo];
    
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
    self.labelTotalTitle.text = [LocalizedString PaymentTotalCount];
    NSDictionary *account_result = [self.dictionaryData objectForKey:SymphoxAPIParam_account_result];
    NSMutableAttributedString *stringCash = nil;
    NSMutableAttributedString *stringEPoint = nil;
    NSMutableAttributedString *stringPoint = nil;
    NSMutableAttributedString *stringCathayCash = nil;
    NSDictionary *attributesOrange = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, nil];
    NSDictionary *attributesBlack = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, nil];
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
    NSDictionary *account_result = [self.dictionaryData objectForKey:SymphoxAPIParam_account_result];
    NSNumber *total_cash = [account_result objectForKey:SymphoxAPIParam_total_cash];
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
        
        // Prepare paymentDescription for view after creating order.
        NSString *paymentName = [section objectForKey:kPaymentSectionTitle];
        NSMutableString *paymentDescription = [NSMutableString string];
        if (paymentName && [paymentName length] > 0)
        {
            [paymentDescription appendString:paymentName];
        }
        NSArray *paymentContents = [section objectForKey:kPaymentSectionContent];
        if (paymentContents && self.selectedIndexPathOfPayment.row < [paymentContents count])
        {
            NSDictionary *paymentContent = [paymentContents objectAtIndex:self.selectedIndexPathOfPayment.row];
            if (paymentContent && [paymentContent count] > 0)
            {
                NSString *optionTitle = [paymentContent objectForKey:kPaymentOptionTitle];
                if ([optionTitle length] > 0)
                {
                    if ([paymentDescription length] > 0)
                    {
                        [paymentDescription appendString:@"\n"];
                    }
                    [paymentDescription appendString:optionTitle];
                }
            }
        }
        if ([paymentDescription length] > 0)
        {
            self.selectedPaymentDescription = paymentDescription;
        }
    }
    else if (total_cash == nil || [total_cash isEqual:[NSNull null]] || [total_cash integerValue] == 0)
    {
        NSArray *trade_ids = [account_result objectForKey:SymphoxAPIParam_trade_id];
        if ([trade_ids count] == 1)
        {
            paymentId = [trade_ids objectAtIndex:0];
        }
        else
        {
            paymentId = @"OP";
        }
        self.selectedPaymentDescription = [LocalizedString NoCashPayment];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString PleaseSelectPaymentType] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
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
        id paymentType = [dictionaryMode objectForKey:SymphoxAPIParam_payment_type];
        if ([paymentType isKindOfClass:[NSString class]])
        {
            [dictionaryMode setObject:paymentType forKey:SymphoxAPIParam_payment_type];
        }
        else if ([paymentType isKindOfClass:[NSNumber class]])
        {
            [dictionaryMode setObject:[((NSNumber *)paymentType) stringValue] forKey:SymphoxAPIParam_payment_type];
        }
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
        id paymentType = [dictionaryMode objectForKey:SymphoxAPIParam_payment_type];
        if ([paymentType isKindOfClass:[NSString class]])
        {
            [dictionaryMode setObject:paymentType forKey:SymphoxAPIParam_payment_type];
        }
        else if ([paymentType isKindOfClass:[NSNumber class]])
        {
            [dictionaryMode setObject:[((NSNumber *)paymentType) stringValue] forKey:SymphoxAPIParam_payment_type];
        }
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
            if (self.type == CartTypeStorePickup)
            {
                StorePickupInfoViewController *viewController = [[StorePickupInfoViewController alloc] initWithNibName:@"StorePickupInfoViewController" bundle:[NSBundle mainBundle]];
                viewController.type = weakSelf.type;
                NSMutableDictionary *dictionaryPayment = [NSMutableDictionary dictionary];
                if (weakSelf.selectedInstallment)
                {
                    [dictionaryPayment setDictionary:weakSelf.selectedInstallment];
                }
                else
                {
                    [dictionaryPayment setObject:[NSNumber numberWithInteger:0] forKey:SymphoxAPIParam_installment_term];
                    [dictionaryPayment setObject:[NSNumber numberWithInteger:0] forKey:SymphoxAPIParam_installment_amount];
                }
                NSDictionary *account_result = [self.dictionaryData objectForKey:SymphoxAPIParam_account_result];
                if (account_result && [account_result isEqual:[NSNull null]] == NO)
                {
                    NSNumber *total_cash = [account_result objectForKey:SymphoxAPIParam_total_cash];
                    if (total_cash && [total_cash isEqual:[NSNull null]] == NO)
                    {
                        [dictionaryPayment setObject:total_cash forKey:SymphoxAPIParam_auth_amount];
                    }
                }
                viewController.dictionaryTotalCost = account_result;
                viewController.dictionaryInstallment = dictionaryPayment;
                
                NSString *trade_id = [params objectForKey:SymphoxAPIParam_trade_id];
                if (trade_id)
                {
                    viewController.tradeId = trade_id;
                }
                viewController.selectedPaymentDescription = self.selectedPaymentDescription;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                ReceiverInfoViewController *viewController = [[ReceiverInfoViewController alloc] initWithNibName:@"ReceiverInfoViewController" bundle:[NSBundle mainBundle]];
                viewController.type = weakSelf.type;
                NSMutableDictionary *dictionaryPayment = [NSMutableDictionary dictionary];
                if (weakSelf.selectedInstallment)
                {
                    [dictionaryPayment setDictionary:weakSelf.selectedInstallment];
                }
                else
                {
                    [dictionaryPayment setObject:[NSNumber numberWithInteger:0] forKey:SymphoxAPIParam_installment_term];
                    [dictionaryPayment setObject:[NSNumber numberWithInteger:0] forKey:SymphoxAPIParam_installment_amount];
                }
                NSDictionary *account_result = [self.dictionaryData objectForKey:SymphoxAPIParam_account_result];
                if (account_result && [account_result isEqual:[NSNull null]] == NO)
                {
                    NSNumber *total_cash = [account_result objectForKey:SymphoxAPIParam_total_cash];
                    if (total_cash && [total_cash isEqual:[NSNull null]] == NO)
                    {
                        [dictionaryPayment setObject:total_cash forKey:SymphoxAPIParam_auth_amount];
                    }
                }
                viewController.dictionaryTotalCost = account_result;
                viewController.dictionaryInstallment = dictionaryPayment;
                
                NSString *trade_id = [params objectForKey:SymphoxAPIParam_trade_id];
                if (trade_id)
                {
                    viewController.tradeId = trade_id;
                }
                viewController.selectedPaymentDescription = self.selectedPaymentDescription;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
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
            NSLog(@"requestResultOfCheckPaymentWithParams - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:NO];
    }];
}

- (void)retrieveInstallmentBanksData
{
    __weak PaymentTypeViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_terms];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_03", SymphoxAPIParam_txid, @"2", SymphoxAPIParam_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            NSString *string = [[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding];
            NSLog(@"retrieveData - string:\n%@", string);
            [self processInstallmentBanksData:resultObject];
        }
        else
        {
            NSLog(@"error:\n%@", error);
        }
        
    }];
}

- (void)processInstallmentBanksData:(id)data
{
    if ([data isKindOfClass:[NSData class]])
    {
        NSData *sourceData = (NSData *)data;
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:sourceData options:0 error:&error];
        if (error == nil && jsonObject)
        {
            if ([jsonObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *)jsonObject;
                NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
                if (result && [result integerValue] == 0)
                {
                    NSString *content = [dictionary objectForKey:SymphoxAPIParam_content];
                    if (content && [content isEqual:[NSNull null]] == NO && [content length] > 0)
                    {
                        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
                        if (attrString)
                        {
                            self.stringBanks = attrString;
                        }
                    }
                }
            }
        }
    }
}

- (void)showInstallmentBanks
{
    NSString *message = nil;
    if (self.stringBanks)
    {
        message = [self.stringBanks string];
    }
    else
    {
        message = [LocalizedString InstallmentAvailableBank];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString InstallmentAvailableBank] message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    __weak PaymentTypeViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    });
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
    NSString *stringDate = [[TMInfoManager sharedManager] formattedStringFromDate:[NSDate date]];
    [TMInfoManager sharedManager].userPressAgreementDate = stringDate;
    
    [self startToCheckPayment];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 0;
    if (tableView == self.tableViewDiscount)
    {
        numberOfSections = [self.arrayDiscount count];
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
        if (section < [self.arrayDiscount count])
        {
            NSDictionary *dictionarySection = [self.arrayDiscount objectAtIndex:section];
            NSArray *array = [dictionarySection objectForKey:kDiscountSectionContent];
            if (array)
            {
                numberOfRows = [array count];
            }
        }
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
    if (tableView == self.tableViewDiscount)
    {
        DiscountHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:DiscountHeaderViewIdentifier];
        if (view == nil)
        {
            view = [[DiscountHeaderView alloc] initWithReuseIdentifier:DiscountHeaderViewIdentifier];
        }
        [view.contentView setBackgroundColor:[UIColor whiteColor]];
        if (section < [self.arrayDiscount count])
        {
            NSDictionary *dictionarySection = [self.arrayDiscount objectAtIndex:section];
            NSString *title = [dictionarySection objectForKey:kDiscountSectionTitle];
            if (title)
            {
                view.labelTitle.text = title;
            }
        }
        headerView = view;
    }
    else if (tableView == self.tableViewPayment)
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = nil;
    if (tableView == self.tableViewDiscount)
    {
        DiscountFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:DiscountFooterViewIdentifier];
        if (view == nil)
        {
            view = [[DiscountFooterView alloc] initWithReuseIdentifier:DiscountFooterViewIdentifier];
        }
        if (section < [self.arrayDiscount count])
        {
            NSDictionary *dictionarySection = [self.arrayDiscount objectAtIndex:section];
            NSString *title = [dictionarySection objectForKey:kDiscountSectionFooterDesc];
            if (title)
            {
                view.labelTitle.text = title;
            }
            NSString *value = [dictionarySection objectForKey:kDiscountSectionFooterValue];
            if (value)
            {
                view.labelDiscountValue.text = value;
            }
        }
        footerView = view;
    }
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.tableViewDiscount)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:ChosenDiscountTableViewCellIdentifier forIndexPath:indexPath];
        NSString *type = @"";
        NSString *detail = @"";
        if (indexPath.section < [self.arrayDiscount count])
        {
            NSDictionary *dictionarySection = [self.arrayDiscount objectAtIndex:indexPath.section];
            NSArray *array = [dictionarySection objectForKey:kDiscountSectionContent];
            if (array && indexPath.row < [array count])
            {
                NSDictionary *dictionaryContent = [array objectAtIndex:indexPath.row];
                NSString *desc = [dictionaryContent objectForKey:kDiscountSectionContentDesc];
                if (desc)
                {
                    type = desc;
                }
                NSString *value = [dictionaryContent objectForKey:kDiscountSectionContentValue];
                if (value)
                {
                    detail = value;
                }
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
        cell.tintColor = [UIColor colorWithRed:(154.0/255.0) green:(192.0/255.0) blue:(68.0/255.0) alpha:1.0];
        PaymentTypeTableViewCell *paymentCell = (PaymentTypeTableViewCell *)cell;
        if (paymentCell.delegate == nil)
        {
            paymentCell.delegate = self;
        }
        [paymentCell.buttonCheck setHidden:NO];
        NSString *title = @"";
        NSString *actionTitle = nil;
        if (indexPath.section < [self.arrayPaymentSections count])
        {
            NSDictionary *dictionarySection = [self.arrayPaymentSections objectAtIndex:indexPath.section];
            NSArray *content = [dictionarySection objectForKey:kPaymentSectionContent];
            NSString *paymentId = [dictionarySection objectForKey:kPaymentSectionId];
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
                        actionTitle = optionActionTitle;
                        paymentCell.accessoryView = paymentCell.buttonAction;
                        if ([paymentId isEqualToString:@"O"] || [paymentId isEqualToString:@"O2"])
                        {
                            [paymentCell.buttonCheck setHidden:YES];
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
    if (tableView == self.tableViewDiscount)
    {
        heightForHeader = 30.0;
    }
    else if (tableView == self.tableViewPayment)
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
        heightForRow = 30.0;
    }
    else if (tableView == self.tableViewPayment)
    {
        heightForRow = 40.0;
    }
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForFooter = 0.0;
    if (tableView == self.tableViewDiscount)
    {
        if (section < [self.arrayDiscount count])
        {
            NSDictionary *dictionarySection = [self.arrayDiscount objectAtIndex:section];
            NSString *footerValue = [dictionarySection objectForKey:kDiscountSectionFooterValue];
            if (footerValue)
            {
                heightForFooter = 30.0;
            }
        }
    }
    return heightForFooter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dictionarySection = [self.arrayPaymentSections objectAtIndex:indexPath.section];
    NSString *paymentId = [dictionarySection objectForKey:kPaymentSectionId];
    BOOL isOCB = ([paymentId isEqualToString:@"O"] || [paymentId isEqualToString:@"O2"]);
    if (isOCB)
    {
        if (cell.accessoryView == nil)
        {
            self.selectedIndexPathOfPayment = indexPath;
        }
    }
    else
    {
        self.selectedIndexPathOfPayment = indexPath;
    }
    
}

#pragma mark - PaymentTypeTableViewCellDelegate

- (void)PaymentTypeTableViewCell:(PaymentTypeTableViewCell *)cell didSelectActionBySender:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"didSelectActionBySender[%li][%li]", (long)button.tag, (long)cell.tag);
    NSInteger section = button.tag;
    NSDictionary *dictionarySection = [self.arrayPaymentSections objectAtIndex:section];
    NSString *paymentId = [dictionarySection objectForKey:kPaymentSectionId];
    if ([paymentId isEqualToString:@"I"])
    {
        [self showInstallmentBanks];
    }
    else if ([paymentId isEqualToString:@"O"] || [paymentId isEqualToString:@"O2"])
    {
        // One click buy
        OCBStatus status = [TMInfoManager sharedManager].userOcbStatus;
        switch (status) {
            case OCBStatusShouldActivateInBank:
            case OCBStatusShouldActivateInTreeMall:
            case OCBStatusExpired:
            {
                NSURL *url = [NSURL URLWithString:SymphoxAPI_activateOCB];
                if ([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
                break;
            default:
                break;
        }
    }
}

@end
