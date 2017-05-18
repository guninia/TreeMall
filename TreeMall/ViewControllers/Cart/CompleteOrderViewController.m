//
//  CompleteOrderViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/15.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CompleteOrderViewController.h"
#import "LocalizedString.h"
#import "CompleteOrderContentTableViewCell.h"
#import "SingleLabelHeaderView.h"
#import "Definition.h"
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "ColorFooterView.h"

#define kSectionContentTitle @"SectionContentTitle"
#define kSectionContentText @"SectionContentText"
#define kSectionTitle @"SectionTitle"
#define kSectionIndex @"SectionIndex"
#define kSectionContent @"SectionContent"

typedef enum : NSUInteger {
    SectionIndexDiscount,
    SectionIndexPayment,
    SectionIndexReceiver,
    SectionIndexTotal
} SectionIndex;

@interface CompleteOrderViewController ()

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSMutableArray *arrayATM;
@property (nonatomic, strong) NSMutableArray *arrayDiscount;
@property (nonatomic, strong) NSMutableArray *arrayReceiver;
@property (nonatomic, strong) NSMutableArray *arraySections;

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)prepareData;
- (void)retrieveOrderDescription;
- (void)processOrderDescriptionData:(id)data;
- (void)refreshContent;
- (NSArray *)contentOfSection:(NSInteger)section;
- (NSDictionary *)cellContentAtIndexPath:(NSIndexPath *)indexPath;

- (void)buttonConfirmPressed:(id)sender;
- (void)buttonLinkPressed:(id)sender;
- (void)linkLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@implementation CompleteOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.viewLabelBackground.layer setBorderWidth:1.0];
    [self.viewLabelBackground.layer setBorderColor:TMMainColor.CGColor];
    [self.labelTotalItem setTextColor:TMMainColor];
    
    [self.scrollView addSubview:self.viewOrderId];
    [self.scrollView addSubview:self.viewCash];
    [self.scrollView addSubview:self.viewEPoint];
    [self.scrollView addSubview:self.viewPoint];
    [self.scrollView addSubview:self.separator];
    [self.scrollView addSubview:self.labelOrderDescription];
    [self.scrollView addSubview:self.tableViewOrderContent];
    [self.scrollView addSubview:self.buttonConfirm];
    
    [self.navigationController.tabBarController.view addSubview:self.viewLoading];
    [self prepareData];
    [self retrieveOrderDescription];
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
    
    CGFloat marginH = 8.0;
    CGFloat marginV = 8.0;
    CGFloat intervalV = 5.0;
    
    CGFloat originY = CGRectGetMaxY(self.viewLabelBackground.frame) + intervalV;
    
    CGFloat columnHeight = 30.0;
    CGFloat columnWidth = self.scrollView.frame.size.width - marginH * 2;
    if (self.viewOrderId)
    {
        CGRect frame = CGRectMake(marginH, originY, columnWidth, columnHeight);
        self.viewOrderId.frame = frame;
        [self.viewOrderId setNeedsLayout];
        originY = self.viewOrderId.frame.origin.y + self.viewOrderId.frame.size.height + intervalV;
    }
    if (self.viewCash)
    {
        CGRect frame = CGRectMake(marginH, originY, columnWidth, columnHeight);
        self.viewCash.frame = frame;
        [self.viewCash setNeedsLayout];
        originY = self.viewCash.frame.origin.y + self.viewCash.frame.size.height + intervalV;
    }
    if (self.viewEPoint)
    {
        CGRect frame = CGRectMake(marginH, originY, columnWidth, columnHeight);
        self.viewEPoint.frame = frame;
        [self.viewEPoint setNeedsLayout];
        originY = self.viewEPoint.frame.origin.y + self.viewEPoint.frame.size.height + intervalV;
    }
    if (self.viewPoint)
    {
        CGRect frame = CGRectMake(marginH, originY, columnWidth, columnHeight);
        self.viewPoint.frame = frame;
        [self.viewPoint setNeedsLayout];
        originY = self.viewPoint.frame.origin.y + self.viewPoint.frame.size.height + intervalV;
    }
    if (self.separator)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, ColorFooterHeight);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    }
    if (self.labelOrderDescription)
    {
        originY += 10.0;
        CGSize size = [self.labelOrderDescription suggestedFrameSizeToFitEntireStringConstraintedToWidth:columnWidth];
        CGRect frame = CGRectMake(marginH, originY, columnWidth, ceil(size.height));
        self.labelOrderDescription.frame = frame;
        originY = self.labelOrderDescription.frame.origin.y + self.labelOrderDescription.frame.size.height + intervalV;
    }
    if (self.tableViewOrderContent)
    {
        NSInteger totalSections = [self numberOfSectionsInTableView:self.tableViewOrderContent];
        CGFloat totalHeight = 0.0;
        for (NSInteger index = 0; index < totalSections; index++)
        {
            CGRect rectSection = [self.tableViewOrderContent rectForSection:index];
//            NSLog(@"rectSection[%li][%4.2f,%4.2f]", (long)index, rectSection.size.width, rectSection.size.height);
            CGFloat height = rectSection.size.height;
            totalHeight += height;
        }
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, totalHeight);
        self.tableViewOrderContent.frame = frame;
        originY = self.tableViewOrderContent.frame.origin.y + self.tableViewOrderContent.frame.size.height + intervalV;
    }
    if (self.buttonConfirm)
    {
        originY += 20.0;
        CGRect frame = CGRectMake(marginH, originY, columnWidth, 40.0);
        self.buttonConfirm.frame = frame;
        originY = self.buttonConfirm.frame.origin.y + self.buttonConfirm.frame.size.height + marginV;
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, originY)];
    
    if (self.viewLoading)
    {
        self.viewLoading.frame = self.navigationController.tabBarController.view.bounds;
        self.viewLoading.indicatorCenter = self.viewLoading.center;
        [self.viewLoading setNeedsLayout];
    }
}

- (BorderedDoubleLabelView *)viewOrderId
{
    if (_viewOrderId == nil)
    {
        _viewOrderId = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewOrderId.layer setBorderWidth:0.0];
        [_viewOrderId.labelL setText:[LocalizedString OrderId]];
        [_viewOrderId.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewOrderId.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewOrderId.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewOrderId.labelR setTextColor:[UIColor orangeColor]];
    }
    return _viewOrderId;
}

- (BorderedDoubleLabelView *)viewCash
{
    if (_viewCash == nil)
    {
        _viewCash = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewCash.layer setBorderWidth:0.0];
        [_viewCash.labelL setText:[LocalizedString CashToPay]];
        [_viewCash.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewCash.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewCash.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewCash.labelR setTextColor:[UIColor darkGrayColor]];
    }
    return _viewCash;
}

- (BorderedDoubleLabelView *)viewEPoint
{
    if (_viewEPoint == nil)
    {
        _viewEPoint = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewEPoint.layer setBorderWidth:0.0];
        [_viewEPoint.labelL setText:[LocalizedString DiscountByEPoint]];
        [_viewEPoint.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewEPoint.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewEPoint.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewEPoint.labelR setTextColor:[UIColor darkGrayColor]];
    }
    return _viewEPoint;
}

- (BorderedDoubleLabelView *)viewPoint
{
    if (_viewPoint == nil)
    {
        _viewPoint = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewPoint.layer setBorderWidth:0.0];
        [_viewPoint.labelL setText:[LocalizedString DiscountByPoint]];
        [_viewPoint.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewPoint.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewPoint.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewPoint.labelR setTextColor:[UIColor darkGrayColor]];
    }
    return _viewPoint;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1.0]];
    }
    return _separator;
}

- (DTAttributedLabel *)labelOrderDescription
{
    if (_labelOrderDescription == nil)
    {
        _labelOrderDescription = [[DTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelOrderDescription.layoutFrameHeightIsConstrainedByBounds = NO;
        _labelOrderDescription.shouldDrawLinks = YES;
        _labelOrderDescription.shouldDrawImages = YES;
        _labelOrderDescription.delegate = self;
        _labelOrderDescription.backgroundColor = [UIColor clearColor];
    }
    return _labelOrderDescription;
}

- (UITableView *)tableViewOrderContent
{
    if (_tableViewOrderContent == nil)
    {
        _tableViewOrderContent = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableViewOrderContent setShowsVerticalScrollIndicator:NO];
        [_tableViewOrderContent setShowsVerticalScrollIndicator:NO];
        [_tableViewOrderContent setDataSource:self];
        [_tableViewOrderContent setDelegate:self];
        [_tableViewOrderContent registerClass:[CompleteOrderContentTableViewCell class] forCellReuseIdentifier:CompleteOrderContentTableViewCellIdentifier];
        [_tableViewOrderContent registerClass:[SingleLabelHeaderView class] forHeaderFooterViewReuseIdentifier:SingleLabelHeaderViewIdentifier];
        [_tableViewOrderContent registerClass:[ColorFooterView class] forHeaderFooterViewReuseIdentifier:ColorFooterViewIdentifier];
    }
    return _tableViewOrderContent;
}

- (UIButton *)buttonConfirm
{
    if (_buttonConfirm == nil)
    {
        _buttonConfirm = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonConfirm setBackgroundColor:[UIColor orangeColor]];
        [_buttonConfirm.layer setCornerRadius:5.0];
        [_buttonConfirm setTitle:[LocalizedString Confirm] forState:UIControlStateNormal];
        [_buttonConfirm addTarget:self action:@selector(buttonConfirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonConfirm;
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

- (NSNumberFormatter *)numberFormatter
{
    if (_numberFormatter == nil)
    {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _numberFormatter;
}

- (NSMutableArray *)arrayATM
{
    if (_arrayATM == nil)
    {
        _arrayATM = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayATM;
}

- (NSMutableArray *)arrayDiscount
{
    if (_arrayDiscount == nil)
    {
        _arrayDiscount = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayDiscount;
}

- (NSMutableArray *)arrayReceiver
{
    if (_arrayReceiver == nil)
    {
        _arrayReceiver = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayReceiver;
}

- (NSMutableArray *)arraySections
{
    if (_arraySections == nil)
    {
        _arraySections = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arraySections;
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
    NSNumber *totalCash = [NSNumber numberWithInteger:0];
    NSNumber *totalEPoint = [NSNumber numberWithInteger:0];
    NSNumber *totalPoint = [NSNumber numberWithInteger:0];
    if (self.dictionaryTotalCost)
    {
        NSNumber *number_total_cash = [self.dictionaryTotalCost objectForKey:SymphoxAPIParam_total_cash];
        if (number_total_cash && [number_total_cash isEqual:[NSNull null]] == NO)
        {
            totalCash = number_total_cash;
        }
        NSNumber *number_total_ePoint = [self.dictionaryTotalCost objectForKey:SymphoxAPIParam_total_ePoint];
        if (number_total_ePoint && [number_total_ePoint isEqual:[NSNull null]] == NO)
        {
            totalEPoint = number_total_ePoint;
        }
        NSNumber *number_total_Point = [self.dictionaryTotalCost objectForKey:SymphoxAPIParam_total_Point];
        if (number_total_Point && [number_total_Point isEqual:[NSNull null]] == NO)
        {
            totalPoint = number_total_Point;
        }
    }
    NSDictionary *attributesOrange = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName, nil];
    NSDictionary *attributesBlack = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil];
    NSAttributedString *stringDollar = [[NSAttributedString alloc] initWithString:[LocalizedString Dollars] attributes:attributesBlack];
    NSAttributedString *stringPoint = [[NSAttributedString alloc] initWithString:[LocalizedString Point] attributes:attributesBlack];
    NSString *stringCash = nil;
    if (self.viewCash)
    {
        stringCash = [self.numberFormatter stringFromNumber:totalCash];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringCash attributes:attributesOrange];
        [attrString appendAttributedString:stringDollar];
        [self.viewCash.labelR setAttributedText:attrString];
    }
    if (self.viewEPoint)
    {
        NSString *stringPoints = [self.numberFormatter stringFromNumber:totalEPoint];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringPoints attributes:attributesOrange];
        [attrString appendAttributedString:stringPoint];
        [self.viewEPoint.labelR setAttributedText:attrString];
    }
    if (self.viewPoint)
    {
        NSString *stringPoints = [self.numberFormatter stringFromNumber:totalPoint];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringPoints attributes:attributesOrange];
        [attrString appendAttributedString:stringPoint];
        [self.viewPoint.labelR setAttributedText:attrString];
    }
    
    if (self.dictionaryOrderData)
    {
        NSInteger itemCount = 0;
        NSArray *items = [self.dictionaryOrderData objectForKey:SymphoxAPIParam_items];
        if (items && [items isEqual:[NSNull null]] == NO)
        {
            itemCount = [items count];
            
            NSDictionary *purchaseInfos = [[TMInfoManager sharedManager] purchaseInfoForCartType:self.type];
            NSDictionary *additionalPurchaseInfos = [[TMInfoManager sharedManager] purchaseInfoForAdditionalCartType:self.type];
            
            for (NSDictionary *item in items)
            {
                NSNumber *productIdentifier = [item objectForKey:SymphoxAPIParam_cpdt_num];
                NSDictionary *purchaseInfo = [purchaseInfos objectForKey:productIdentifier];
                if (purchaseInfo == nil)
                {
                    purchaseInfo = [additionalPurchaseInfos objectForKey:productIdentifier];
                }
                if (purchaseInfo == nil)
                {
                    continue;
                }
                NSString *paymentTypeDescription = [purchaseInfo objectForKey:SymphoxAPIParam_discount_type_desc];
                NSString *paymentDiscription = [purchaseInfo objectForKey:SymphoxAPIParam_discount_detail_desc];
                NSMutableString *totalDescription = [NSMutableString string];
                if (paymentTypeDescription && [paymentTypeDescription isEqual:[NSNull null]] == NO && [paymentTypeDescription length] > 0)
                {
                    [totalDescription appendString:paymentTypeDescription];
                }
                if (paymentDiscription && [paymentDiscription isEqual:[NSNull null]] == NO && [paymentDiscription length] > 0)
                {
                    if ([totalDescription length] > 0)
                    {
                        [totalDescription appendString:@"\n"];
                    }
                    [totalDescription appendString:paymentDiscription];
                }
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [dictionary setObject:[LocalizedString DiscountPreferencial] forKey:kSectionContentTitle];
                [dictionary setObject:totalDescription forKey:kSectionContentText];
                [self.arrayDiscount addObject:dictionary];
            }
        }
        NSString *stringTotalItem = [NSString stringWithFormat:[LocalizedString Total_I_product], (long)itemCount];
        self.labelTotalItem.text = stringTotalItem;
        
        NSString *cart_id = [self.dictionaryOrderData objectForKey:SymphoxAPIParam_cart_id];
        if (cart_id && [cart_id isEqual:[NSNull null]] == NO)
        {
            self.viewOrderId.labelR.text = cart_id;
        }
        
        if ([self.tradeId isEqualToString:@"A"])
        {
            NSString *atm_deadline = [self.dictionaryOrderData objectForKey:SymphoxAPIParam_atm_deadline];
            if (atm_deadline && [atm_deadline isEqual:[NSNull null]] == NO)
            {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [dictionary setObject:[LocalizedString PaymentDeadline] forKey:kSectionContentTitle];
                [dictionary setObject:atm_deadline forKey:kSectionContentText];
                [self.arrayATM addObject:dictionary];
            }
            
            NSString *atm_bk_code = [self.dictionaryOrderData objectForKey:SymphoxAPIParam_atm_bk_code];
            if (atm_bk_code && [atm_bk_code isEqual:[NSNull null]] == NO)
            {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [dictionary setObject:[LocalizedString BankCode] forKey:kSectionContentTitle];
                [dictionary setObject:atm_bk_code forKey:kSectionContentText];
                [self.arrayATM addObject:dictionary];
            }
            
            NSString *atm_code = [self.dictionaryOrderData objectForKey:SymphoxAPIParam_atm_code];
            if (atm_code && [atm_code isEqual:[NSNull null]] == NO)
            {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [dictionary setObject:[LocalizedString BankAccountToPay] forKey:kSectionContentTitle];
                [dictionary setObject:atm_code forKey:kSectionContentText];
                [self.arrayATM addObject:dictionary];
            }
            
            if (stringCash)
            {
                NSString *stringDueOfPay = [NSString stringWithFormat:@"＄%@", stringCash];
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [dictionary setObject:[LocalizedString CashShouldPay] forKey:kSectionContentTitle];
                [dictionary setObject:stringDueOfPay forKey:kSectionContentText];
                [self.arrayATM addObject:dictionary];
            }
            
        }
        
    }
    
    if (self.selectedPaymentDescription)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[LocalizedString PaymentType] forKey:kSectionContentTitle];
        [dictionary setObject:self.selectedPaymentDescription forKey:kSectionContentText];
        [self.arrayDiscount addObject:dictionary];
    }
    
    if (self.dictionaryDelivery)
    {
        NSString *name = [self.dictionaryDelivery objectForKey:SymphoxAPIParam_name];
        if (name)
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:[LocalizedString Receiver] forKey:kSectionContentTitle];
            [dictionary setObject:name forKey:kSectionContentText];
            [self.arrayReceiver addObject:dictionary];
        }
        NSString *day_tel = [self.dictionaryDelivery objectForKey:SymphoxAPIParam_day_tel];
        if (day_tel)
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:[LocalizedString DayPhone] forKey:kSectionContentTitle];
            [dictionary setObject:day_tel forKey:kSectionContentText];
            [self.arrayReceiver addObject:dictionary];
        }
        NSString *cellphone = [self.dictionaryDelivery objectForKey:SymphoxAPIParam_cellphone];
        if (cellphone)
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:[LocalizedString CellPhone] forKey:kSectionContentTitle];
            [dictionary setObject:cellphone forKey:kSectionContentText];
            [self.arrayReceiver addObject:dictionary];
        }
        NSString *address = [self.dictionaryDelivery objectForKey:SymphoxAPIParam_address];
        if (address)
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:[LocalizedString ReceiverAddress] forKey:kSectionContentTitle];
            [dictionary setObject:address forKey:kSectionContentText];
            [self.arrayReceiver addObject:dictionary];
        }
    }
    
    if ([self.arrayDiscount count] > 0)
    {
        NSMutableDictionary *section = [NSMutableDictionary dictionary];
        [section setObject:[NSNumber numberWithInteger:SectionIndexDiscount] forKey:kSectionIndex];
        [section setObject:[LocalizedString PaymentInfo] forKey:kSectionTitle];
        [section setObject:self.arrayDiscount forKey:kSectionContent];
        [self.arraySections addObject:section];
    }
    if ([self.arrayATM count] > 0)
    {
        NSMutableDictionary *section = [NSMutableDictionary dictionary];
        [section setObject:[NSNumber numberWithInteger:SectionIndexPayment] forKey:kSectionIndex];
        [section setObject:[LocalizedString AccountTransferInfo] forKey:kSectionTitle];
        [section setObject:self.arrayATM forKey:kSectionContent];
        [self.arraySections addObject:section];
    }
    if ([self.arrayReceiver count] > 0)
    {
        NSMutableDictionary *section = [NSMutableDictionary dictionary];
        [section setObject:[NSNumber numberWithInteger:SectionIndexReceiver] forKey:kSectionIndex];
        [section setObject:[LocalizedString ReceiverInfo] forKey:kSectionTitle];
        [section setObject:self.arrayReceiver forKey:kSectionContent];
        [self.arraySections addObject:section];
    }
    [self refreshContent];
}

- (void)retrieveOrderDescription
{
    [self showLoadingViewAnimated:YES];
    __weak CompleteOrderViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_terms];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_03", SymphoxAPIParam_txid, @"6", SymphoxAPIParam_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            NSString *string = [[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding];
            NSLog(@"retrieveOrderDescription - string:\n%@", string);
            [weakSelf processOrderDescriptionData:resultObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf refreshContent];
            });
        }
        else
        {
            
        }
        NSLog(@"error:\n%@", error);
        [weakSelf hideLoadingViewAnimated:YES];
    }];
}

- (void)processOrderDescriptionData:(id)data
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
        if (result && [result integerValue] == 0)
        {
            // success
            NSString *content = [dictionary objectForKey:SymphoxAPIParam_content];
            if (content)
            {
                NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
                self.labelOrderDescription.attributedString = attrString;
            }
        }
    }
}

- (void)refreshContent
{
    __weak CompleteOrderViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableViewOrderContent reloadData];
        [weakSelf.view setNeedsLayout];
    });
}

- (NSArray *)contentOfSection:(NSInteger)section
{
    NSArray *content = nil;
    if (section < [self.arraySections count])
    {
        NSDictionary *dictionary = [self.arraySections objectAtIndex:section];
        content = [dictionary objectForKey:kSectionContent];
    }
    return content;
}

- (NSDictionary *)cellContentAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellContent = nil;
    NSArray *sectionContent = [self contentOfSection:indexPath.section];
    if (indexPath.row < [sectionContent count])
    {
        cellContent = [sectionContent objectAtIndex:indexPath.row];
    }
    return cellContent;
}

#pragma mark - Actions

- (void)buttonConfirmPressed:(id)sender
{
//     Temporarily marked for test
//    [[TMInfoManager sharedManager] resetCartForType:self.type];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)buttonLinkPressed:(id)sender
{
    if ([sender isKindOfClass:[DTLinkButton class]] == NO)
        return;
    DTLinkButton *buttonLink = (DTLinkButton *)sender;
    NSURL *url = buttonLink.URL;
    if (url == nil)
        return;
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)linkLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        DTLinkButton *button = (id)[gestureRecognizer view];
        button.highlighted = NO;
        
        if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actionOpenInSafari = [UIAlertAction actionWithTitle:[LocalizedString OpenInSafari] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [[UIApplication sharedApplication] openURL:button.URL];
            }];
            UIAlertAction *actionCopyLink = [UIAlertAction actionWithTitle:[LocalizedString CopyLink] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                NSString *urlString = [button.URL absoluteString];
                if (urlString)
                {
                    [[UIPasteboard generalPasteboard] setString:[button.URL absoluteString]];
                }
            }];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleDestructive handler:nil];
            [alertController addAction:actionOpenInSafari];
            [alertController addAction:actionCopyLink];
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = [self.arraySections count];
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    NSArray *rows = [self contentOfSection:section];
    if (rows)
    {
        numberOfRows = [rows count];
    }
    return numberOfRows;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SingleLabelHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SingleLabelHeaderViewIdentifier];
    if (headerView == nil)
    {
        headerView = [[SingleLabelHeaderView alloc] initWithReuseIdentifier:SingleLabelHeaderViewIdentifier];
    }
    headerView.marginH = 8.0;
    [headerView.label setTextColor:TMMainColor];
    [headerView.label setFont:[UIFont systemFontOfSize:18.0]];
    NSString *title = @"";
    if (section < [self.arraySections count])
    {
        NSDictionary *sectionContent = [self.arraySections objectAtIndex:section];
        NSString *sectionTitle = [sectionContent objectForKey:kSectionTitle];
        if (sectionTitle)
        {
            title = sectionTitle;
        }
    }
    [headerView.label setText:title];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompleteOrderContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CompleteOrderContentTableViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dictionaryContent = [self cellContentAtIndexPath:indexPath];
    NSString *title = @"";
    NSString *content = @"";
    if (dictionaryContent)
    {
        NSString *contentTitle = [dictionaryContent objectForKey:kSectionContentTitle];
        if (contentTitle)
        {
            title = contentTitle;
        }
        NSString *contentText = [dictionaryContent objectForKey:kSectionContentText];
        if (contentText)
        {
            content = contentText;
        }
    }
    cell.labelTitle.text = title;
    cell.labelContent.text = content;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ColorFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ColorFooterViewIdentifier];
    if (footerView == nil)
    {
        footerView = [[ColorFooterView alloc] initWithReuseIdentifier:ColorFooterViewIdentifier];
    }
    return footerView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat heightForHeader = 40.0;
    return heightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 40.0;
    if (indexPath.section < [self.arraySections count])
    {
        NSDictionary *section = [self.arraySections objectAtIndex:indexPath.section];
        NSNumber *sectionId = [section objectForKey:kSectionIndex];
        if ([sectionId integerValue] == SectionIndexDiscount)
        {
            heightForRow = 60.0;
        }
    }
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForRow = ColorFooterHeight;
    if (section == ([self.arraySections count] - 1))
    {
        heightForRow = 0.0;
    }
    return heightForRow;
}

#pragma mark - DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(buttonLinkPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
    return button;
}

@end
