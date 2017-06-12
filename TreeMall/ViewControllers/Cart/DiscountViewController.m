//
//  DiscountViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/24.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DiscountViewController.h"
#import "DiscountTableViewCell.h"
#import "DiscountHeaderView.h"
#import "LocalizedString.h"
#import "APIDefinition.h"
#import "TMInfoManager.h"

@interface DiscountViewController ()

@property (nonatomic, assign) NSInteger currentSelectedIndex;

- (void)buttonConfirmPressed:(id)sender;

@end

@implementation DiscountViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _productId = nil;
        _arrayPaymentMode = nil;
        _currentSelectedIndex = NSNotFound;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString PleaseChooseDiscount];
    
    [self.view addSubview:self.tableViewDiscount];
    [self.view addSubview:self.buttonConfirm];
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
    
    if (self.buttonConfirm)
    {
        CGSize size = CGSizeMake(self.view.frame.size.width - marginH * 2, 40.0);
        CGRect frame = CGRectMake((self.view.frame.size.width - size.width)/2, self.view.frame.size.height - marginV - size.height, size.width, size.height);
        self.buttonConfirm.frame = frame;
    }
    if (self.tableViewDiscount)
    {
        CGRect frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, CGRectGetMinY(self.buttonConfirm.frame) - intervalV);
        self.tableViewDiscount.frame = frame;
    }
}

- (UITableView *)tableViewDiscount
{
    if (_tableViewDiscount == nil)
    {
        _tableViewDiscount = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableViewDiscount.delegate = self;
        _tableViewDiscount.dataSource = self;
        _tableViewDiscount.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableViewDiscount registerClass:[DiscountTableViewCell class] forCellReuseIdentifier:DiscountTableViewCellIdentifier];
        [_tableViewDiscount registerClass:[DiscountHeaderView class] forHeaderFooterViewReuseIdentifier:DiscountHeaderViewIdentifier];
    }
    return _tableViewDiscount;
}

- (UIButton *)buttonConfirm
{
    if (_buttonConfirm == nil)
    {
        _buttonConfirm = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonConfirm setBackgroundColor:[UIColor orangeColor]];
        [_buttonConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonConfirm setTitle:[LocalizedString Confirm] forState:UIControlStateNormal];
        [_buttonConfirm addTarget:self action:@selector(buttonConfirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonConfirm;
}

#pragma mark - Actions

- (void)buttonConfirmPressed:(id)sender
{
    if (self.currentSelectedIndex == NSNotFound)
        return;
    NSDictionary *paymentModeSelected = [self.arrayPaymentMode objectAtIndex:self.currentSelectedIndex];
    NSLog(@"selected paymentMode:\n%@", [paymentModeSelected description]);
    
    NSMutableDictionary *paymentMode = [NSMutableDictionary dictionary];
    
    id payment_type = [paymentModeSelected objectForKey:SymphoxAPIParam_payment_type];
    if (payment_type)
    {
        [paymentMode setObject:payment_type forKey:SymphoxAPIParam_payment_type];
    }
    id price = [paymentModeSelected objectForKey:SymphoxAPIParam_price];
    if (price)
    {
        [paymentMode setObject:price forKey:SymphoxAPIParam_price];
    }
    id total_point = [paymentModeSelected objectForKey:SymphoxAPIParam_total_point];
    if (total_point)
    {
        [paymentMode setObject:total_point forKey:SymphoxAPIParam_total_point];
    }
    id point = [paymentModeSelected objectForKey:SymphoxAPIParam_point];
    if (point)
    {
        [paymentMode setObject:point forKey:SymphoxAPIParam_point];
    }
    id epoint = [paymentModeSelected objectForKey:SymphoxAPIParam_epoint];
    if (epoint)
    {
        [paymentMode setObject:epoint forKey:SymphoxAPIParam_epoint];
    }
    id cpoint = [paymentModeSelected objectForKey:SymphoxAPIParam_cpoint];
    if (cpoint)
    {
        [paymentMode setObject:cpoint forKey:SymphoxAPIParam_cpoint];
    }
    id coupon_discount = [paymentModeSelected objectForKey:SymphoxAPIParam_coupon_discount];
    if (coupon_discount)
    {
        [paymentMode setObject:coupon_discount forKey:SymphoxAPIParam_coupon_discount];
    }
    id eacc_num = [paymentModeSelected objectForKey:SymphoxAPIParam_eacc_num];
    if (eacc_num)
    {
        [paymentMode setObject:eacc_num forKey:SymphoxAPIParam_eacc_num];
    }
    id cm_id = [paymentModeSelected objectForKey:SymphoxAPIParam_cm_id];
    if (cm_id)
    {
        [paymentMode setObject:cm_id forKey:SymphoxAPIParam_cm_id];
    }
    
    if (self.isAddition)
    {
        [[TMInfoManager sharedManager] setPurchasePaymentMode:paymentMode forProduct:self.productId inAdditionalCart:self.type];
    }
    else
    {
        [[TMInfoManager sharedManager] setPurchasePaymentMode:paymentMode forProduct:self.productId inCart:self.type];
    }
    
    id discount_type_desc = [paymentModeSelected objectForKey:SymphoxAPIParam_discount_type_desc];
    id discount_detail_desc = [paymentModeSelected objectForKey:SymphoxAPIParam_discount_detail_desc];
    if ([discount_detail_desc isKindOfClass:[NSString class]])
    {
        if (self.isAddition)
        {
            [[TMInfoManager sharedManager] setDiscountTypeDescription:discount_type_desc forProduct:self.productId inAdditionalCart:self.type];
            [[TMInfoManager sharedManager] setDiscountDetailDescription:discount_detail_desc forProduct:self.productId inAdditionalCart:self.type];
        }
        else
        {
            [[TMInfoManager sharedManager] setDiscountTypeDescription:discount_type_desc forProduct:self.productId inCart:self.type];
            [[TMInfoManager sharedManager] setDiscountDetailDescription:discount_detail_desc forProduct:self.productId inCart:self.type];
        }
    }
    
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissDiscountViewController:)])
        {
            [self.delegate didDismissDiscountViewController:self];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = [self.arrayPaymentMode count];
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DiscountHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:DiscountHeaderViewIdentifier];
    if (section < [self.arrayPaymentMode count])
    {
        NSDictionary *paymentMode = [self.arrayPaymentMode objectAtIndex:section];
        NSString *discount_type_desc = [paymentMode objectForKey:SymphoxAPIParam_discount_type_desc];
        NSString *discount_cash_desc = [paymentMode objectForKey:SymphoxAPIParam_discount_cash_desc];
        if (discount_type_desc && [discount_type_desc isEqual:[NSNull null]] == NO)
        {
            headerView.labelTitle.text = discount_type_desc;
        }
        else
        {
            headerView.labelTitle.text = @"";
        }
        if (discount_cash_desc && [discount_cash_desc isEqual:[NSNull null]] == NO)
        {
            headerView.labelDiscountValue.text = discount_cash_desc;
        }
        else
        {
            headerView.labelDiscountValue.text = @"";
        }
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DiscountTableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:(154.0/255.0) green:(192.0/255.0) blue:(68.0/255.0) alpha:1.0];
    cell.tintColor = [UIColor colorWithRed:(154.0/255.0) green:(192.0/255.0) blue:(68.0/255.0) alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section < [self.arrayPaymentMode count])
    {
        NSDictionary *paymentMode = [self.arrayPaymentMode objectAtIndex:indexPath.section];
        NSString *discount_detail_desc = [paymentMode objectForKey:SymphoxAPIParam_discount_detail_desc];
        if (discount_detail_desc && [discount_detail_desc isEqual:[NSNull null]] == NO)
        {
            [cell.textLabel setText:discount_detail_desc];
        }
        else
        {
            [cell.textLabel setText:@""];
        }
        cell.accessoryView = cell.buttonCheck;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectedIndex = indexPath.section;
}

@end
