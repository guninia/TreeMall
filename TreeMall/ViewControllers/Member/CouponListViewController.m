//
//  CouponListViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CouponListViewController.h"
#import "LocalizedString.h"
#import "Definition.h"
#import "APIDefinition.h"
#import "CouponTableViewCell.h"
#import "LoadingFooterView.h"
#import "UIViewController+FTPopMenu.h"
#import "CouponDetailViewController.h"

@interface CouponListViewController ()

- (void)prepareSortOptions;
- (void)resetPreviousCouponData;
- (void)retrieveCouponDataForState:(CouponState)state sortByType:(CouponSortOption)sortType atPage:(NSInteger)page;
- (void)showSortOptionMenu;
- (void)buttonSortPressed:(id)sender;

@end

@implementation CouponListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _arraySortType = [[NSMutableArray alloc] initWithCapacity:0];
        _arrayCoupon = [[NSMutableArray alloc] initWithCapacity:0];
        [self prepareSortOptions];
        _sortType = CouponSortOptionValueHighToLow;
        _stateIndex = 0;
        _currentPage = 0;
        _shouldShowLoadingView = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setTitle:[LocalizedString MyCoupon]];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    
    [self.view addSubview:self.segmentedView];
    [self.view addSubview:self.buttonSort];
    [self.view addSubview:self.tableViewCoupon];
    NSString *currentSortTypeText = [self.arraySortType objectAtIndex:0];
    self.buttonSort.label.text = currentSortTypeText;
    if (_currentPage == 0)
    {
        // Set initial value
        [self.segmentedView.segmentedControl setSelectedSegmentIndex:0];
        
        // Initial fetch
        NSInteger nextPage = _currentPage + 1;
        [self retrieveCouponDataForState:self.stateIndex sortByType:self.sortType atPage:nextPage];
    }
    [self.tableViewCoupon reloadData];
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
    if (self.buttonSort)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, 40.0);
        self.buttonSort.frame = frame;
        originY = self.buttonSort.frame.origin.y + self.buttonSort.frame.size.height + 2.0;
    }
    if (self.tableViewCoupon)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        self.tableViewCoupon.frame = frame;
    }
}

- (SemiCircleEndsSegmentedView *)segmentedView
{
    if (_segmentedView == nil)
    {
        NSMutableArray *items = [NSMutableArray array];
        for (NSInteger index = CouponStateStart; index < CouponStateTotal; index++)
        {
            switch (index) {
                case CouponStateNotUsed:
                {
                    [items addObject:[LocalizedString NotUsed]];
                }
                    break;
                case CouponStateAlreadyUsed:
                {
                    [items addObject:[LocalizedString AlreadyUsed]];
                }
                    break;
                case CouponStateExpired:
                {
                    [items addObject:[LocalizedString Expired]];
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

- (DropdownListButton *)buttonSort
{
    if (_buttonSort == nil)
    {
        _buttonSort = [[DropdownListButton alloc] initWithFrame:CGRectZero];
        [_buttonSort setBackgroundColor:[UIColor whiteColor]];
        _buttonSort.marginLeft = 10.0;
        _buttonSort.marginRight = 10.0;
        [_buttonSort.label setTextColor:[UIColor darkGrayColor]];
        [_buttonSort addTarget:self action:@selector(buttonSortPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonSort;
}

- (UITableView *)tableViewCoupon
{
    if (_tableViewCoupon == nil)
    {
        _tableViewCoupon = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableViewCoupon setBackgroundColor:[UIColor whiteColor]];
        [_tableViewCoupon setDataSource:self];
        [_tableViewCoupon setDelegate:self];
        [_tableViewCoupon setShowsVerticalScrollIndicator:NO];
        [_tableViewCoupon setShowsHorizontalScrollIndicator:NO];
        [_tableViewCoupon setSeparatorInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [_tableViewCoupon setSeparatorColor:[UIColor lightGrayColor]];
        [_tableViewCoupon setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableViewCoupon registerClass:[CouponTableViewCell class] forCellReuseIdentifier:CouponTableViewCellIdentifier];
        [_tableViewCoupon registerClass:[LoadingFooterView class] forHeaderFooterViewReuseIdentifier:LoadingFooterViewIdentifier];
    }
    return _tableViewCoupon;
}

- (void)setSortType:(CouponSortOption)sortType
{
    _sortType = sortType;
    if (_sortType < [self.arraySortType count])
    {
        NSString *sortTypeString = [self.arraySortType objectAtIndex:_sortType];
        [self.buttonSort.label setText:sortTypeString];
    }
}

#pragma mark - Private Methods

- (void)prepareSortOptions
{
    for (NSInteger index = 0; index < CouponSortOptionTotal; index++)
    {
        switch (index) {
            case CouponSortOptionValueHighToLow:
            {
                [self.arraySortType addObject:[LocalizedString ValueHighToLow]];
            }
                break;
            case CouponSortOptionValueLowToHigh:
            {
                [self.arraySortType addObject:[LocalizedString ValueLowToHigh]];
            }
                break;
            case CouponSortOptionValidDateEarlyToLate:
            {
                [self.arraySortType addObject:[LocalizedString ValidDateEarlyToLate]];
            }
                break;
            case CouponSortOptionValidDateLateToEarly:
            {
                [self.arraySortType addObject:[LocalizedString ValidDateLateToEarly]];
            }
                break;
            default:
                break;
        }
    }
}

- (void)resetPreviousCouponData
{
    self.totalCoupon = 0;
    self.currentPage = 0;
    if ([self.arrayCoupon count] > 0)
    {
        [self.arrayCoupon removeAllObjects];
        self.shouldShowLoadingView = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableViewCoupon reloadData];
        });
    }
}

- (void)retrieveCouponDataForState:(CouponState)state sortByType:(CouponSortOption)sortType atPage:(NSInteger)page
{
    // If retrieve first page, should reset all coupon data for former options.
    if (page == 1)
    {
        [self resetPreviousCouponData];
    }
    NSString *sortTypeText = nil;
    NSString *sortOrderText = nil;
    switch (sortType) {
        case CouponSortOptionValueHighToLow:
        {
            sortTypeText = SymphoxAPIParamValue_worth;
            sortOrderText = SymphoxAPIParamValue_desc;
        }
            break;
        case CouponSortOptionValueLowToHigh:
        {
            sortTypeText = SymphoxAPIParamValue_worth;
            sortOrderText = SymphoxAPIParamValue_asc;
        }
            break;
        case CouponSortOptionValidDateEarlyToLate:
        {
            sortTypeText = SymphoxAPIParamValue_end_date;
            sortOrderText = SymphoxAPIParamValue_asc;
        }
            break;
        case CouponSortOptionValidDateLateToEarly:
        {
            sortTypeText = SymphoxAPIParamValue_end_date;
            sortOrderText = SymphoxAPIParamValue_desc;
        }
            break;
        default:
            break;
    }
    if (sortOrderText && sortTypeText)
    {
        [self.segmentedView.segmentedControl setEnabled:NO];
        [self.buttonSort setEnabled:NO];
        __weak CouponListViewController *weakSelf = self;
        [[TMInfoManager sharedManager] retrieveCouponDataFromObject:weakSelf forPageIndex:page couponState:state sortFactor:sortTypeText withSortOrder:sortOrderText withCompletion:^(id resultObject, NSError *error){
//            NSLog(@"resultObject:\n%@", [resultObject description]);
            if (error == nil && resultObject)
            {
                if ([resultObject isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dictionary = (NSDictionary *)resultObject;
                    NSNumber *numberSize = [dictionary objectForKey:SymphoxAPIParam_size];
                    if (numberSize)
                    {
                        weakSelf.totalCoupon = [numberSize integerValue];
                    }
                    NSArray *array = [dictionary objectForKey:SymphoxAPIParam_list];
                    if (array)
                    {
                        [weakSelf.arrayCoupon addObjectsFromArray:array];
                    }
                    if (weakSelf.totalCoupon <= [weakSelf.arrayCoupon count])
                    {
                        weakSelf.shouldShowLoadingView = NO;
                    }
                    weakSelf.currentPage = page;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableViewCoupon reloadData];
                });
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString CannotLoadData] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionBack = [UIAlertAction actionWithTitle:[LocalizedString GoBack] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                UIAlertAction *actionReload = [UIAlertAction actionWithTitle:[LocalizedString Reload] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [weakSelf retrieveCouponDataForState:state sortByType:sortType atPage:page];
                }];
                [alertController addAction:actionBack];
                [alertController addAction:actionReload];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.segmentedView.segmentedControl setEnabled:YES];
                [weakSelf.buttonSort setEnabled:YES];
            });
        }];
    }
}

- (void)showSortOptionMenu
{
    __weak CouponListViewController *weakSelf = self;
    [self showFTMenuFromView:self.buttonSort menuArray:self.arraySortType doneBlock:^(NSInteger selectedIndex){
        [weakSelf setSortType:selectedIndex];
        [weakSelf retrieveCouponDataForState:weakSelf.stateIndex sortByType:weakSelf.sortType atPage:1];
    } cancelBlock:nil];
}

#pragma mark - Actions

- (void)buttonSortPressed:(id)sender
{
    [self showSortOptionMenu];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Second section is for the loading footerview;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
        {
            numberOfRows = [self.arrayCoupon count];
        }
            break;
            
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CouponTableViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < [self.arrayCoupon count])
    {
        NSDictionary *dictionary = [self.arrayCoupon objectAtIndex:indexPath.row];
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        if ((name != nil) && ([name isEqual:[NSNull null]] == NO) && ([name length] > 0))
        {
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:name attributes:cell.attributeTitle];
            [cell.labelTitle setAttributedText:attrString];
        }
        else
        {
            [cell.labelTitle setText:@" "];
        }
        NSNumber *numberValue = [dictionary objectForKey:SymphoxAPIParam_worth];
        if ((numberValue != nil) && ([numberValue isEqual:[NSNull null]] == NO))
        {
            cell.numberValue = numberValue;
        }
        else
        {
            cell.numberValue = nil;
        }
        NSString *orderId = [dictionary objectForKey:SymphoxAPIParam_order_id];
        if ((orderId != nil) && ([orderId isEqual:[NSNull null]] == NO) && ([orderId length] > 0))
        {
            NSString *string = [NSString stringWithFormat:@"%@\n%@", [LocalizedString OrderId], orderId];
            [cell.labelOrderId setText:string];
        }
        else
        {
            [cell.labelOrderId setText:@" "];
        }
        NSString *dateStart = [dictionary objectForKey:SymphoxAPIParam_start_date];
        if ((dateStart != nil) && ([dateStart isEqual:[NSNull null]] == NO) && ([dateStart length] > 0))
        {
            NSString *string = [NSString stringWithFormat:@"%@%@", dateStart, [LocalizedString Start]];
            [cell.labelDateStart setText:string];
            [cell.labelDateStart setHidden:NO];
        }
        else
        {
            [cell.labelDateStart setText:@""];
            [cell.labelDateStart setHidden:YES];
        }
        NSString *dateGoodThru = [dictionary objectForKey:SymphoxAPIParam_end_date];
        if ((dateGoodThru != nil) && ([dateGoodThru isEqual:[NSNull null]] == NO) && ([dateGoodThru length] > 0))
        {
            NSString *string = [NSString stringWithFormat:@"%@%@", dateGoodThru, [LocalizedString Due]];
            [cell.labelDateGoodThru setText:string];
            [cell.labelDateGoodThru setHidden:NO];
        }
        else
        {
            [cell.labelDateGoodThru setText:@""];
            [cell.labelDateGoodThru setHidden:YES];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LoadingFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LoadingFooterViewIdentifier];
    footerView.viewBackground.backgroundColor = tableView.backgroundColor;
    return footerView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 110.0;
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForFooter = 0.0;
    switch (section) {
        case 1:
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
        if (section == 1 && [self.arrayCoupon count] > 0)
        {
            NSInteger nextPage = self.currentPage + 1;
            [self retrieveCouponDataForState:self.stateIndex sortByType:self.sortType atPage:nextPage];
        }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row < [self.arrayCoupon count])
    {
        NSDictionary *dictionary = [self.arrayCoupon objectAtIndex:indexPath.row];
        CouponDetailViewController *viewController = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetailViewController" bundle:[NSBundle mainBundle]];
        viewController.dictionaryData = dictionary;
        if (cell)
        {
            NSString *stringValue = cell.labelValue.text;
            if (stringValue && [stringValue length] > 0)
            {
                viewController.stringCouponValue = stringValue;
            }
            NSString *stringDateStart = cell.labelDateStart.text;
            if (stringDateStart && [stringDateStart length] > 0)
            {
                viewController.stringDateStart = stringDateStart;
            }
            NSString *stringDateGoodThru = cell.labelDateGoodThru.text;
            if (stringDateGoodThru && [stringDateGoodThru length] > 0)
            {
                viewController.stringDateGoodThru = stringDateGoodThru;
            }
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - SemiCircleEndsSegmentedViewDelegate

- (void)semiCircleEndsSegmentedView:(SemiCircleEndsSegmentedView *)view didChangeToIndex:(NSInteger)index
{
    self.stateIndex = index;
    [self retrieveCouponDataForState:self.stateIndex sortByType:self.sortType atPage:1];
}

@end
