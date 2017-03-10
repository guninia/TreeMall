//
//  OrderListViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "OrderListViewController.h"
#import "LocalizedString.h"
#import "TMInfoManager.h"
#import "Definition.h"
#import "OrderHeaderReusableView.h"
#import "OrderListCollectionViewCell.h"
#import "LoadingFoorterReusableView.h"

@interface OrderListViewController ()

- (void)segmentedControlStateValueChanged:(id)sender;
- (void)buttonSearchPressed:(id)sender;
- (void)buttonOrderTimePressed:(id)sender;
- (void)buttonShipTypePressed:(id)sender;

@end

@implementation OrderListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _currentPage = 0;
        _arrayDeliverTypes = DeliverTypeNoSpecific;
        _arrayOrderTimeOptions = OrderTimeNoSpecific;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString MyOrder];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    
    [self.view addSubview:self.segmentedView];
    [self.view addSubview:self.viewSearchBackground];
    [self.viewSearchBackground addSubview:self.textFieldSearch];
    [self.view addSubview:self.viewButtonBackground];
    [self.viewButtonBackground addSubview:self.buttonOrderTime];
    [self.viewButtonBackground addSubview:self.separator];
    [self.viewButtonBackground addSubview:self.buttonShipType];
    [self.view addSubview:self.viewTitle];
    [self.view addSubview:self.collectionView];
    
    if (_currentPage == 0)
    {
        [self.segmentedView.segmentedControl setSelectedSegmentIndex:0];
    }
    
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
    
    if (self.viewSearchBackground)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, 40.0);
        self.viewSearchBackground.frame = frame;
        originY = self.viewSearchBackground.frame.origin.y + self.viewSearchBackground.frame.size.height + 5.0;
        
        if (self.textFieldSearch)
        {
            CGRect frame = CGRectInset(self.viewSearchBackground.bounds, 10.0, 0.0);
            self.textFieldSearch.frame = frame;
        }
    }
    
    if (self.viewButtonBackground)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, 40.0);
        self.viewButtonBackground.frame = frame;
        originY = self.viewButtonBackground.frame.origin.y + self.viewButtonBackground.frame.size.height;
        
        CGFloat separatorWidth = 1.0;
        CGFloat buttonWidth = ceil((self.viewButtonBackground.frame.size.width - separatorWidth)/2);
        CGFloat originX = 0.0;
        if (self.buttonOrderTime)
        {
            CGRect buttonFrame = CGRectMake(originX, 0.0, buttonWidth, self.viewButtonBackground.frame.size.height);
            self.buttonOrderTime.frame = buttonFrame;
            originX = self.buttonOrderTime.frame.origin.x + self.buttonOrderTime.frame.size.width;
        }
        if (self.separator)
        {
            CGFloat height = self.viewButtonBackground.frame.size.height * 3 / 5;
            CGRect separatorFrame = CGRectMake(originX, (self.viewButtonBackground.frame.size.height - height)/2, separatorWidth, height);
            self.separator.frame = separatorFrame;
            originX = self.separator.frame.origin.x + self.separator.frame.size.width;
        }
        if (self.buttonShipType)
        {
            CGRect buttonFrame = CGRectMake(originX, 0.0, buttonWidth, self.viewButtonBackground.frame.size.height);
            self.buttonShipType.frame = buttonFrame;
        }
    }
    
    if (self.viewTitle)
    {
        CGRect frame = CGRectMake(marginL, originY, self.view.frame.size.width - marginL - marginR, 40.0);
        self.viewTitle.frame = frame;
        originY = self.viewTitle.frame.origin.y + self.viewTitle.frame.size.height;
    }
    
    if (self.collectionView)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        self.collectionView.frame = frame;
    }
}

- (SemiCircleEndsSegmentedView *)segmentedView
{
    if (_segmentedView == nil)
    {
        NSMutableArray *items = [NSMutableArray array];
        for (NSInteger index = OrderStateStart; index < OrderStateTotal; index++)
        {
            switch (index) {
                case OrderStateNoSpecific:
                {
                    [items addObject:[LocalizedString All]];
                }
                    break;
                case OrderStateProcessing:
                {
                    [items addObject:[LocalizedString Processing]];
                }
                    break;
                case OrderStateShipping:
                {
                    [items addObject:[LocalizedString Shipping]];
                }
                    break;
                case OrderStateReturnOrReplace:
                {
                    [items addObject:[LocalizedString Return]];
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

- (UIView *)viewSearchBackground
{
    if (_viewSearchBackground == nil)
    {
        _viewSearchBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewSearchBackground setBackgroundColor:[UIColor whiteColor]];
    }
    return _viewSearchBackground;
}

- (UITextField *)textFieldSearch
{
    if (_textFieldSearch == nil)
    {
        _textFieldSearch = [[UITextField alloc] initWithFrame:CGRectZero];
        [_textFieldSearch setBackgroundColor:[UIColor clearColor]];
        [_textFieldSearch setPlaceholder:[LocalizedString PleaseInputProductName]];
        [_textFieldSearch setDelegate:self];
        UIImage *image = [[UIImage imageNamed:@"sho_btn_mag"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (image)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
            [button setTintColor:[UIColor grayColor]];
            button.backgroundColor = [UIColor clearColor];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonSearchPressed:) forControlEvents:UIControlEventTouchUpInside];
            _textFieldSearch.rightView = button;
            _textFieldSearch.rightViewMode = UITextFieldViewModeAlways;
        }
        [_textFieldSearch setKeyboardType:UIKeyboardTypeDefault];
        [_textFieldSearch setReturnKeyType:UIReturnKeySearch];
    }
    return _textFieldSearch;
}

- (UIView *)viewButtonBackground
{
    if (_viewButtonBackground == nil)
    {
        _viewButtonBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewButtonBackground setBackgroundColor:[UIColor whiteColor]];
    }
    return _viewButtonBackground;
}

- (DropdownListButton *)buttonOrderTime
{
    if (_buttonOrderTime == nil)
    {
        _buttonOrderTime = [[DropdownListButton alloc] initWithFrame:CGRectZero];
        _buttonOrderTime.label.text = [LocalizedString OrderTime];
        [_buttonOrderTime addTarget:self action:@selector(buttonOrderTimePressed:) forControlEvents:UIControlEventTouchUpInside];
        _buttonOrderTime.marginLeft = 10.0;
        _buttonOrderTime.marginRight = 10.0;
    }
    return _buttonOrderTime;
}

- (DropdownListButton *)buttonShipType
{
    if (_buttonShipType == nil)
    {
        _buttonShipType = [[DropdownListButton alloc] initWithFrame:CGRectZero];
        _buttonShipType.label.text = [LocalizedString ShipType];
        [_buttonShipType addTarget:self action:@selector(buttonShipTypePressed:) forControlEvents:UIControlEventTouchUpInside];
        _buttonShipType.marginLeft = 10.0;
        _buttonShipType.marginRight = 10.0;
    }
    return _buttonShipType;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor grayColor]];
    }
    return _separator;
}

- (ProductDetailSectionTitleView *)viewTitle
{
    if (_viewTitle == nil)
    {
        _viewTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_icon1"];
        if (image)
        {
            [_viewTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewTitle.viewTitle.labelText setText:[LocalizedString MyOrder]];
        [_viewTitle.viewTitle.labelText setFont:[UIFont systemFontOfSize:18.0]];
        [_viewTitle.viewTitle.labelText setTextColor:[UIColor colorWithRed:(142.0/255.0) green:(170.0/255.0) blue:(214.0/255.0) alpha:1.0]];
        [_viewTitle setBackgroundColor:[UIColor clearColor]];
        [_viewTitle.viewBackground setBackgroundColor:[UIColor clearColor]];
        [_viewTitle.bottomLine setHidden:YES];
        _viewTitle.topSeparatorHeight = 0.0;
    }
    return _viewTitle;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setBackgroundColor:self.view.backgroundColor];
        [_collectionView registerClass:[OrderListCollectionViewCell class] forCellWithReuseIdentifier:OrderListCollectionViewCellIdentifier];
        [_collectionView registerClass:[OrderHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:OrderHeaderReusableViewIdentifier];
        [_collectionView registerClass:[LoadingFoorterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:LoadingFoorterReusableViewIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)arrayOrderTimeOptions
{
    if (_arrayOrderTimeOptions == nil)
    {
        _arrayOrderTimeOptions = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger index = OrderTimeNoSpecific; index < OrderStateTotal; index++)
        {
            switch (index) {
                case OrderStateNoSpecific:
                {
                    [_arrayOrderTimeOptions addObject:[LocalizedString All]];
                }
                    break;
                case OrderTimeLatestMonth:
                {
                    [_arrayOrderTimeOptions addObject:[LocalizedString LatestMonth]];
                }
                    break;
                case OrderTimeLatestHalfYear:
                {
                    [_arrayOrderTimeOptions addObject:[LocalizedString LatestHalfYear]];
                }
                    break;
                case OrderTimeLatestYear:
                {
                    [_arrayOrderTimeOptions addObject:[LocalizedString LatestYear]];
                }
                    break;
                default:
                    break;
            }
        }
    }
    return _arrayOrderTimeOptions;
}

- (NSMutableArray *)arrayDeliverTypes
{
    if (_arrayDeliverTypes == nil)
    {
        _arrayDeliverTypes = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger index = DeliverTypeStart; index < DeliverTypeTotal; index++)
        {
            switch (index) {
                case DeliverTypeNoSpecific:
                {
                    [_arrayDeliverTypes addObject:[LocalizedString All]];
                }
                    break;
                case DeliverTypeCommon:
                {
                    [_arrayDeliverTypes addObject:[LocalizedString CommonDelivery]];
                }
                    break;
                case DeliverTypeFastDelivery:
                {
                    [_arrayDeliverTypes addObject:[LocalizedString FastDelivery]];
                }
                    break;
                case DeliverTypeStorePickUp:
                {
                    [_arrayDeliverTypes addObject:[LocalizedString StorePickUp]];
                }
                    break;
                default:
                    break;
            }
        }
    }
    return _arrayDeliverTypes;
}

#pragma mark - Actions

- (void)segmentedControlStateValueChanged:(id)sender
{
    
}

- (void)buttonSearchPressed:(id)sender
{
    NSString *text = self.textFieldSearch.text;
    if ([text length] == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PleaseInputProductName] preferredStyle:UIAlertControllerStyleAlert];
        __weak OrderListViewController *weakSelf = self;
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf.textFieldSearch setText:@""];
            if ([weakSelf.textFieldSearch canBecomeFirstResponder])
            {
                [weakSelf.textFieldSearch becomeFirstResponder];
            }
        }];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    else
    {
        // Should start search.
    }
    [self.textFieldSearch resignFirstResponder];
}

- (void)buttonOrderTimePressed:(id)sender
{
    
}

- (void)buttonShipTypePressed:(id)sender
{
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = textField.text;
    if ([text length] == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PleaseInputProductName] preferredStyle:UIAlertControllerStyleAlert];
        __weak OrderListViewController *weakSelf = self;
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf.textFieldSearch setText:@""];
            if ([weakSelf.textFieldSearch canBecomeFirstResponder])
            {
                [weakSelf.textFieldSearch becomeFirstResponder];
            }
        }];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        // Should start search.
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        OrderHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:OrderHeaderReusableViewIdentifier forIndexPath:indexPath];
        [headerView setBackgroundColor:[UIColor clearColor]];
        view = headerView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        LoadingFoorterReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:LoadingFoorterReusableViewIdentifier forIndexPath:indexPath];
        [footerView setBackgroundColor:[UIColor clearColor]];
        view = footerView;
    }
    return view;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OrderListCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize referenceSize = CGSizeMake(collectionView.frame.size.width, 60.0);
    return referenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize referenceSize = CGSizeZero;
    if (section == ([self numberOfSectionsInCollectionView:collectionView] - 1))
    {
        referenceSize = CGSizeMake(collectionView.frame.size.width, 50.0);
    }
    return referenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets edgeInsets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    CGFloat itemWidth = collectionView.frame.size.width - edgeInsets.left - edgeInsets.right;
    CGFloat itemHeight = 200.0;
    CGSize sizeForItem = CGSizeMake(itemWidth, itemHeight);
    return sizeForItem;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 10.0, 10.0, 10.0);
    return edgeInsets;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([view isKindOfClass:[LoadingFoorterReusableView class]])
    {
        LoadingFoorterReusableView *loadingView = (LoadingFoorterReusableView *)view;
        [loadingView.activityIndicator startAnimating];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([view isKindOfClass:[LoadingFoorterReusableView class]])
    {
        LoadingFoorterReusableView *loadingView = (LoadingFoorterReusableView *)view;
        [loadingView.activityIndicator stopAnimating];
    }
}

@end
