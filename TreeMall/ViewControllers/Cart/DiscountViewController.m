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
@property (nonatomic, strong) UIButton *closeButton;

- (void)buttonConfirmPressed:(id)sender;
- (void)buttonClosePresesd:(id)sender;

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
    UIBarButtonItem *buttonItemClose = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    [self.navigationItem setLeftBarButtonItem:buttonItemClose];
    
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

- (UIButton *)closeButton
{
    if (_closeButton == nil)
    {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [[UIImage imageNamed:@"car_popup_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        CGSize size = CGSizeMake(40.0, 40.0);
        if (image)
        {
            [_closeButton setImage:image forState:UIControlStateNormal];
            size = image.size;
        }
        CGRect frame = CGRectMake(0.0, 0.0, size.width, size.height);
        _closeButton.frame = frame;
        [_closeButton addTarget:self action:@selector(buttonClosePresesd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - Actions

- (void)buttonConfirmPressed:(id)sender
{
    if (self.currentSelectedIndex == NSNotFound)
        return;
    NSDictionary *paymentModeSelected = [self.arrayPaymentMode objectAtIndex:self.currentSelectedIndex];
    NSLog(@"selected paymentMode:\n%@", [paymentModeSelected description]);
    NSNumber *cpdt_num = [paymentModeSelected objectForKey:SymphoxAPIParam_cpdt_num];
    if (self.productId == nil || cpdt_num == nil)
        return;
    [[TMInfoManager sharedManager] setPurchaseInfoFromSelectedPaymentMode:paymentModeSelected forProductId:self.productId withRealProductId:cpdt_num inCart:self.type asAdditional:self.isAddition];
    
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissDiscountViewController:)])
        {
            [self.delegate didDismissDiscountViewController:self];
        }
    }
}

- (void)buttonClosePresesd:(id)sender
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
