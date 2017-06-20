//
//  OrderListViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "OrderListViewController.h"
#import "LocalizedString.h"
#import "Definition.h"
#import "LoadingFoorterReusableView.h"
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "UIViewController+FTPopMenu.h"
#import "OrderDetailViewController.h"
#import "DeliverProgressViewController.h"

@interface OrderListViewController ()

@property (nonatomic, strong) UIImageView *tableBackgroundView;
@property (nonatomic, strong) UILabel *labelNoContent;

- (void)resetPreviousOrderData;
- (void)requestOrderOfPage:(NSInteger)page forOrderState:(OrderState)state atTime:(OrderTime)orderTime deliverBy:(DeliverType)deliverType;
- (BOOL)processOrderData:(id)data;
- (NSDictionary *)ordersOfCartIndex:(NSInteger)index;
- (NSInteger)numberOfOrdersOfCartIndex:(NSInteger)index;
- (NSDictionary *)orderForIndex:(NSInteger)orderIndex inCartIndex:(NSInteger)cartIndex;
- (void)startSearchFromTextField:(UITextField *)textField;
- (void)updateTitle;

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
        _deliverType = DeliverTypeNoSpecific;
        _orderTime = OrderTimeNoSpecific;
        _orderState = OrderStateNoSpecific;
        _shouldShowLoadingView = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = [LocalizedString MyOrder];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    
    [self.view addSubview:self.segmentedView];
    [self.view addSubview:self.viewSearchBackground];
    [self.viewSearchBackground addSubview:self.textFieldProductName];
    [self.view addSubview:self.viewButtonBackground];
    [self.viewButtonBackground addSubview:self.buttonOrderTime];
    [self.viewButtonBackground addSubview:self.separator];
    [self.viewButtonBackground addSubview:self.buttonShipType];
    [self.view addSubview:self.viewTitle];
    [self.view addSubview:self.collectionView];
    
    if (self.currentPage == 0)
    {
        [self.segmentedView.segmentedControl setSelectedSegmentIndex:self.orderState];
        
        NSInteger nextPage = self.currentPage + 1;
        [self requestOrderOfPage:nextPage forOrderState:self.orderState atTime:self.orderTime deliverBy:self.deliverType];
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
        
        if (self.textFieldProductName)
        {
            CGRect frame = CGRectInset(self.viewSearchBackground.bounds, 10.0, 0.0);
            self.textFieldProductName.frame = frame;
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
        
        if (self.labelNoContent)
        {
            CGRect frame = CGRectMake(0.0, self.collectionView.frame.size.height * 2 / 3, self.collectionView.frame.size.width, 30.0);
            self.labelNoContent.frame = frame;
        }
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
                    [items addObject:[LocalizedString Shipped]];
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

- (UITextField *)textFieldProductName
{
    if (_textFieldProductName == nil)
    {
        _textFieldProductName = [[UITextField alloc] initWithFrame:CGRectZero];
        [_textFieldProductName setBackgroundColor:[UIColor clearColor]];
        [_textFieldProductName setPlaceholder:[LocalizedString PleaseInputProductName]];
        [_textFieldProductName setDelegate:self];
        UIImage *image = [[UIImage imageNamed:@"sho_btn_mag"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (image)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
            [button setTintColor:[UIColor grayColor]];
            button.backgroundColor = [UIColor clearColor];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonSearchPressed:) forControlEvents:UIControlEventTouchUpInside];
            _textFieldProductName.rightView = button;
            _textFieldProductName.rightViewMode = UITextFieldViewModeAlways;
        }
        [_textFieldProductName setKeyboardType:UIKeyboardTypeDefault];
        [_textFieldProductName setReturnKeyType:UIReturnKeySearch];
    }
    return _textFieldProductName;
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

- (void)setOrderTime:(OrderTime)orderTime
{
    _orderTime = orderTime;
    
    if (_orderTime < [self.arrayOrderTimeOptions count])
    {
        NSString *string = [self.arrayOrderTimeOptions objectAtIndex:_orderTime];
        self.buttonOrderTime.label.text = string;
    }
}

- (void)setDeliverType:(DeliverType)deliverType
{
    _deliverType = deliverType;
    
    if (_deliverType < [self.arrayDeliverTypes count])
    {
        NSString *string = [self.arrayDeliverTypes objectAtIndex:_deliverType];
        self.buttonShipType.label.text = string;
    }
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    [self.segmentedView.segmentedControl setEnabled:!_isLoading];
    [self.textFieldProductName setEnabled:!_isLoading];
    [self.buttonOrderTime setEnabled:!_isLoading];
    [self.buttonShipType setEnabled:!_isLoading];
}

- (NSMutableArray *)arrayCarts
{
    if (_arrayCarts == nil)
    {
        _arrayCarts = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCarts;
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
        [_labelNoContent setText:[LocalizedString CurrentlyNoOrder]];
        [_labelNoContent setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelNoContent;
}

#pragma mark - Private Methods

- (void)resetPreviousOrderData
{
    self.currentPage = 0;
    self.totalOrder = 0;
    self.shouldShowLoadingView = YES;
    if ([self.arrayCarts count] > 0)
    {
        [self.arrayCarts removeAllObjects];
    }
    __weak OrderListViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateTitle];
        [weakSelf.collectionView reloadData];
        weakSelf.collectionView.backgroundView = nil;
    });
}

- (void)requestOrderOfPage:(NSInteger)page forOrderState:(OrderState)state atTime:(OrderTime)orderTime deliverBy:(DeliverType)deliverType
{
    if (self.isLoading)
    {
        return;
    }
    NSNumber *userIndentifier = [TMInfoManager sharedManager].userIdentifier;
    if (userIndentifier == nil)
        return;
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:userIndentifier forKey:SymphoxAPIParam_user_num];
    
    NSString *productName = [self.textFieldProductName text];
    if (productName && [productName length] > 0)
    {
        [options setObject:productName forKey:SymphoxAPIParam_name];
    }
    NSNumber *numberState = [NSNumber numberWithInteger:state];
    if (numberState)
    {
        [options setObject:numberState forKey:SymphoxAPIParam_status];
    }
    NSNumber *numberOrderTime = [NSNumber numberWithInteger:orderTime];
    if (numberOrderTime)
    {
        [options setObject:numberOrderTime forKey:SymphoxAPIParam_time];
    }
    NSNumber *numberDeliverType = [NSNumber numberWithInteger:deliverType];
    if (numberDeliverType)
    {
        [options setObject:numberDeliverType forKey:SymphoxAPIParam_delivery_type];
    }
    NSNumber *numberPage = [NSNumber numberWithInteger:page];
    if (numberPage)
    {
        [options setObject:numberPage forKey:SymphoxAPIParam_page];
    }
    NSNumber *numberPageCount = [NSNumber numberWithInteger:25];
    if (numberPageCount)
    {
        [options setObject:numberPageCount forKey:SymphoxAPIParam_page_count];
    }
    
    if (page == 1)
    {
        [self resetPreviousOrderData];
    }
    self.isLoading = YES;
    __weak OrderListViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_memberOrder];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSLog(@"requestOrder - options:\n%@", [options description]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
//                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"requestOrder:\n%@", string);
                if ([self processOrderData:data])
                {
                    weakSelf.currentPage = page;
                    [weakSelf updateTitle];
                }
                else
                {
                    NSLog(@"requestOrderOfPage - Cannot process data");
                }
            }
            else
            {
                NSLog(@"requestOrderOfPage - Unexpected data format.");
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString CannotLoadData];
            NSDictionary *userInfo = error.userInfo;
            BOOL errorProductNotFound = NO;
            if (userInfo)
            {
                NSString *errorId = [userInfo objectForKey:SymphoxAPIParam_id];
                if ([errorId compare:SymphoxAPIError_E301 options:NSCaseInsensitiveSearch] == NSOrderedSame)
                {
                    errorProductNotFound = YES;
                }
                if (errorProductNotFound)
                {
                    NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                    if (serverMessage)
                    {
                        errorMessage = serverMessage;
                    }
                }
            }
            NSLog(@"requestOrderOfPage - error:\n%@", [error description]);
        }
        if ([self.arrayCarts count] == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView setBackgroundView:weakSelf.tableBackgroundView];
            });
        }
        weakSelf.isLoading = NO;
    }];
}

- (BOOL)processOrderData:(id)data
{
    BOOL success = NO;
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"processOrderData:\n%@", string);

    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error)
    {
        NSLog(@"processOrderData error:\n%@", [error description]);
        return success;
    }
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        NSNumber *numberSize = [dictionary objectForKey:SymphoxAPIParam_size];
        if (numberSize)
        {
            self.totalOrder = [numberSize integerValue];
        }
        NSArray *array = [dictionary objectForKey:SymphoxAPIParam_list];
        if (array)
        {
            [self.arrayCarts addObjectsFromArray:array];
        }
        if (self.totalOrder <= [self.arrayCarts count])
        {
            self.shouldShowLoadingView = NO;
        }
        success = YES;
    }
    [self.collectionView reloadData];
    return success;
}

- (NSDictionary *)ordersOfCartIndex:(NSInteger)index
{
    NSDictionary *orders = nil;
    if (index >= [self.arrayCarts count])
    {
        return orders;
    }
    NSDictionary *dictionary = [self.arrayCarts objectAtIndex:index];
    orders = [dictionary objectForKey:SymphoxAPIParam_order];
    if ([orders isEqual:[NSNull null]])
    {
        orders = nil;
    }
    return orders;
}

- (NSInteger)numberOfOrdersOfCartIndex:(NSInteger)index
{
    NSInteger numberOfOrders = 0;
    NSDictionary *orders = [self ordersOfCartIndex:index];
    if (orders == nil)
    {
        return numberOfOrders;
    }
    numberOfOrders = [orders count];
    return numberOfOrders;
}

- (NSDictionary *)orderForIndex:(NSInteger)orderIndex inCartIndex:(NSInteger)cartIndex
{
    NSDictionary *order = nil;
    NSDictionary *orders = [self ordersOfCartIndex:cartIndex];
    if (orders == nil)
    {
        return order;
    }
    if (orderIndex >= [orders count])
    {
        return order;
    }
    // Server index start from 1.
    NSInteger orderIndexForServer = orderIndex + 1;
    NSString *stringIndex = [NSString stringWithFormat:@"%li", (long)orderIndexForServer];
//    NSLog(@"stringIndex[%@]", stringIndex);
    NSArray *array = [orders objectForKey:stringIndex];
    if ([array count] > 0)
    {
        order = [array objectAtIndex:0];
    }
    return order;
}

- (void)startSearchFromTextField:(UITextField *)textField
{
    if ([textField isFirstResponder])
    {
        [textField resignFirstResponder];
    }
    [self requestOrderOfPage:1 forOrderState:self.orderState atTime:self.orderTime deliverBy:self.deliverType];
}

- (void)updateTitle
{
    NSString *title = nil;
    switch (self.orderState) {
        case OrderStateNoSpecific:
        {
            title = [LocalizedString All];
        }
            break;
        case OrderStateProcessing:
        {
            title = [LocalizedString Processing];
        }
            break;
        case OrderStateShipping:
        {
            title = [LocalizedString Shipped];
        }
            break;
        case OrderStateReturnOrReplace:
        {
            title = [LocalizedString Return];
        }
            break;
        default:
            break;
    }
    if (title)
    {
        title = [title stringByAppendingFormat:@" (%li)", (long)self.totalOrder];
        __weak OrderListViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.viewTitle.viewTitle.labelText.text = title;
        });
    }
}

#pragma mark - Actions

- (void)buttonSearchPressed:(id)sender
{
    // Should start search.
    [self startSearchFromTextField:self.textFieldProductName];
}

- (void)buttonOrderTimePressed:(id)sender
{
    __weak OrderListViewController *weakSelf = self;
    [self showFTMenuFromView:self.buttonOrderTime menuArray:self.arrayOrderTimeOptions doneBlock:^(NSInteger selectedIndex){
        weakSelf.orderTime = selectedIndex;
        [weakSelf requestOrderOfPage:1 forOrderState:weakSelf.orderState atTime:weakSelf.orderTime deliverBy:weakSelf.deliverType];
    } cancelBlock:nil];
}

- (void)buttonShipTypePressed:(id)sender
{
    __weak OrderListViewController *weakSelf = self;
    [self showFTMenuFromView:self.buttonShipType menuArray:self.arrayDeliverTypes doneBlock:^(NSInteger selectedIndex){
        weakSelf.deliverType = selectedIndex;
        [weakSelf requestOrderOfPage:1 forOrderState:weakSelf.orderState atTime:weakSelf.orderTime deliverBy:weakSelf.deliverType];
    } cancelBlock:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text length] > 0)
    {
        [textField selectAll:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Should start search.
    [self startSearchFromTextField:textField];
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // Add one section for loading view
    NSInteger numberOfSections = [self.arrayCarts count] + 1;
//    NSLog(@"numberOfSections[%li]", (long)numberOfSections);
    return numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = 0;
    if (section < [self.arrayCarts count])
    {
        numberOfItems = [self numberOfOrdersOfCartIndex:section];
    }
    return numberOfItems;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        OrderHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:OrderHeaderReusableViewIdentifier forIndexPath:indexPath];
        [headerView setBackgroundColor:[UIColor clearColor]];
        headerView.tag = indexPath.section;
        headerView.delegate = self;
        if (indexPath.section < [self.arrayCarts count])
        {
            NSDictionary *dictionary = [self.arrayCarts objectAtIndex:indexPath.section];
            NSString *authorizationId = [dictionary objectForKey:SymphoxAPIParam_cart_id];
            if (authorizationId)
            {
                NSString *string = [NSString stringWithFormat:@"%@%@", [LocalizedString OrderAuthrizationNumber], authorizationId];
                headerView.labelSerialNumber.text = string;
            }
            NSString *authorizationDate = [dictionary objectForKey:SymphoxAPIParam_cart_day];
            if (authorizationDate)
            {
                headerView.labelDateTime.text = authorizationDate;
            }
        }
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
    if (cell.delegate == nil)
    {
        cell.delegate = self;
    }
    [cell prepareForReuse];
    cell.indexPath = indexPath;
    NSDictionary *dictionaryOrder  =[self orderForIndex:indexPath.row inCartIndex:indexPath.section];
    if (dictionaryOrder)
    {
//        NSLog(@"cellForItemAtIndexPath:\n%@", [dictionaryOrder description]);
        NSDictionary *dictionaryDelivery = [dictionaryOrder objectForKey:SymphoxAPIParam_delivery];
        if (dictionaryDelivery && [dictionaryDelivery isEqual:[NSNull null]] == NO && [dictionaryDelivery count] > 0)
        {
            NSArray *array = [dictionaryDelivery objectForKey:SymphoxAPIParam_step];
            if (array && [array isEqual:[NSNull null]] == NO && [array count] > 0)
            {
                cell.progressView.arrayProgress = array;
                cell.progressView.hidden = NO;
            }
//            NSLog(@"cellForItemAtIndexPath[%li][%li] - cell.progressView [%@]", (long)indexPath.section, (long)indexPath.row, [cell.progressView isHidden]?@"hidden":@"shown");
            NSString *message = [dictionaryDelivery objectForKey:SymphoxAPIParam_message];
//            NSLog(@"cellForItemAtIndexPath - message[%@]", message);
            if (message && [message isEqual:[NSNull null]] == NO && [message length] > 0 && [message isEqualToString:@"無物流"] == NO)
            {
//                NSString *totalString = [NSString stringWithFormat:@"%@ %@", [LocalizedString T_CatId], message];
//                [cell.buttonDeliverId setTitle:totalString forState:UIControlStateNormal];
                [cell.buttonDeliverId setTitle:message forState:UIControlStateNormal];
                cell.buttonDeliverId.hidden = NO;
            }
//            NSLog(@"cellForItemAtIndexPath[%li][%li] - cell.buttonDeliverId [%@]", (long)indexPath.section, (long)indexPath.row, [cell.buttonDeliverId isHidden]?@"hidden":@"shown");
        }
        NSUInteger itemCount = 0;
        NSArray *arrayItem = [dictionaryOrder objectForKey:SymphoxAPIParam_item];
        if (arrayItem && [arrayItem isEqual:[NSNull null]] == NO && [arrayItem count] > 0)
        {
            NSDictionary *dictionary = [arrayItem objectAtIndex:0];
            NSString *stringImageUrl = [dictionary objectForKey:SymphoxAPIParam_img_url];
            if (stringImageUrl && [stringImageUrl isEqual:[NSNull null]] == NO && [stringImageUrl length] > 0)
            {
                NSURL *url = [NSURL URLWithString:stringImageUrl];
                cell.imageUrl = url;
            }
            NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
            if (name && [name isEqual:[NSNull null]] == NO && [name length] > 0)
            {
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:name attributes:cell.attributesTitle];
                [cell.labelTitle setAttributedText:attrString];
            }
            itemCount = [arrayItem count];
        }
        NSString *stringTotalProduct = [NSString stringWithFormat:[LocalizedString Total_N_Product], (unsigned long)itemCount];
        [cell.buttonTotalProducts setTitle:stringTotalProduct forState:UIControlStateNormal];
        
        NSString *status = [dictionaryOrder objectForKey:SymphoxAPIParam_status];
        if (status && [status isEqual:[NSNull null]] == NO && [status length] > 0)
        {
            cell.labelOrderState.text = status;
            cell.labelOrderState.hidden = NO;
        }
        [cell setNeedsDisplay];
    }
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
    CGSize referenceSize = CGSizeZero;
    if (section < [self.arrayCarts count])
    {
        referenceSize = CGSizeMake(collectionView.frame.size.width, 50.0);
    }
    return referenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize referenceSize = CGSizeZero;
    if (section == ([self numberOfSectionsInCollectionView:collectionView] - 1))
    {
        if (self.shouldShowLoadingView)
        {
            referenceSize = CGSizeMake(collectionView.frame.size.width, 50.0);
        }
    }
    return referenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets edgeInsets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    CGFloat itemWidth = collectionView.frame.size.width - edgeInsets.left - edgeInsets.right;
    NSDictionary *dictionaryDelivery = nil;
    NSDictionary *dictionaryOrder = [self orderForIndex:indexPath.row inCartIndex:indexPath.section];
    if (dictionaryOrder && [dictionaryOrder isEqual:[NSNull null]] == NO && [dictionaryOrder count] > 0)
    {
        dictionaryDelivery = [dictionaryOrder objectForKey:SymphoxAPIParam_delivery];
        if ([dictionaryDelivery isEqual:[NSNull null]])
        {
            dictionaryDelivery = nil;
        }
    }
    CGFloat itemHeight = [OrderListCollectionViewCell heightForCellWidth:itemWidth andDataDictionary:dictionaryDelivery];
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
        if ([self.arrayCarts count] > 0)
        {
            [self requestOrderOfPage:(self.currentPage + 1) forOrderState:self.orderState atTime:self.orderTime deliverBy:self.deliverType];
        }
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

#pragma mark - SemiCircleEndsSegmentedViewDelegate

- (void)semiCircleEndsSegmentedView:(SemiCircleEndsSegmentedView *)view didChangeToIndex:(NSInteger)index
{
    self.orderState = index;
    [self requestOrderOfPage:1 forOrderState:self.orderState atTime:self.orderTime deliverBy:self.deliverType];
}

#pragma mark - OrderHeaderReusableViewDelegate

- (void)orderHeaderReusableView:(OrderHeaderReusableView *)view didPressButtonBySender:(id)sender
{
//    NSInteger section = view.tag;
//    if (section >= [self.arrayCarts count])
//        return;
//    
//    id orders = [self.arrayCarts objectAtIndex:section];
//    NSLog(@"orders:\n%@", [orders description]);
//    OrderDetailViewController *viewController = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:[NSBundle mainBundle]];
//    if ([orders isKindOfClass:[NSDictionary class]])
//    {
//        viewController.dictionaryOrder = orders;
//    }
//    [self.navigationController pushViewController:viewController animated:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[LocalizedString OrderDetailAlert] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionOpen = [UIAlertAction actionWithTitle:[LocalizedString OpenInSafari] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *urlString = SymphoxAPI_OrderDetailWebpage;
        NSURL *url = [NSURL URLWithString:urlString];
        if (url == nil)
            return;
        if ([[UIApplication sharedApplication] canOpenURL:url] == NO)
            return;
        [[UIApplication sharedApplication] openURL:url];
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionOpen];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - OrderListCollectionViewCellDelegate

- (void)orderListCollectionViewCell:(OrderListCollectionViewCell *)cell didSelectDeliverInfoBySender:(id)sender
{
    NSIndexPath *indexPath = cell.indexPath;
    if (indexPath == nil)
        return;
    NSDictionary *dictionaryOrder = [self orderForIndex:indexPath.row inCartIndex:indexPath.section];
    if (dictionaryOrder == nil)
        return;
    NSLog(@"dictionaryOrder:\n%@", [dictionaryOrder description]);
    NSString *orderId = [dictionaryOrder objectForKey:SymphoxAPIParam_order_id];
    if (orderId == nil || [orderId isEqual:[NSNull null]] || [orderId length] == 0)
        return;
    NSDictionary *dictionaryDelivery = [dictionaryOrder objectForKey:SymphoxAPIParam_delivery];
    if (dictionaryDelivery == nil || [dictionaryDelivery isEqual:[NSNull null]])
        return;
    NSString *urlString = [dictionaryDelivery objectForKey:SymphoxAPIParam_url];
    if (urlString == nil || [urlString isEqual:[NSNull null]] || [urlString length] == 0)
        return;
    if ([urlString isEqualToString:orderId])
    {
        DeliverProgressViewController *viewController = [[DeliverProgressViewController alloc] initWithNibName:@"DeliverProgressViewController" bundle:[NSBundle mainBundle]];
        viewController.orderId = orderId;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)orderListCollectionViewCell:(OrderListCollectionViewCell *)cell didSelectTotalProductsBySender:(id)sender
{
    
}

@end
