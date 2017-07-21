//
//  FavoriteViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "FavoriteViewController.h"
#import "TMInfoManager.h"
#import "APIDefinition.h"
#import "LocalizedString.h"
#import "ProductDetailViewController.h"
#import "LoginViewController.h"

@interface FavoriteViewController ()

- (void)refreshData;
- (BOOL)canDirectlyPurchaseProduct:(NSDictionary *)product;
- (void)buttonEditPressed:(id)sender;

@end

@implementation FavoriteViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _shouldShowLoadingFooter = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.buttonEdit];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self.view addSubview:self.tableViewFavorites];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshData];
    if (self.arrayFavorites != nil)
    {
        _shouldShowLoadingFooter = NO;
    }
    [self.tableViewFavorites reloadData];
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
    
    if (self.tableViewFavorites)
    {
        [self.tableViewFavorites setFrame:self.view.bounds];
        if (self.labelNoContent)
        {
            CGRect frame = CGRectMake(0.0, self.tableViewFavorites.frame.size.height * 2 / 3, self.tableViewFavorites.frame.size.width, 30.0);
            self.labelNoContent.frame = frame;
        }
    }
}

- (UIButton *)buttonEdit
{
    if (_buttonEdit == nil)
    {
        _buttonEdit = [[UIButton alloc] initWithFrame:CGRectZero];;
        [_buttonEdit setTintColor:[UIColor whiteColor]];
        UIImage *image = [[UIImage imageNamed:@"ico_trash_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        CGSize size = CGSizeMake(30.0, 30.0);
        if (image)
        {
            size = image.size;
            [_buttonEdit setImage:image forState:UIControlStateNormal];
        }
        _buttonEdit.frame = CGRectMake(0.0, 0.0, size.width, size.height);
        UIImage *imageSelected = [UIImage imageNamed:@"ico_trash_on"];
        if (imageSelected)
        {
            [_buttonEdit setImage:imageSelected forState:UIControlStateSelected];
        }
        [_buttonEdit addTarget:self action:@selector(buttonEditPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonEdit;
}

- (UITableView *)tableViewFavorites
{
    if (_tableViewFavorites == nil)
    {
        _tableViewFavorites = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableViewFavorites setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        [_tableViewFavorites setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableViewFavorites setShowsVerticalScrollIndicator:NO];
        [_tableViewFavorites setShowsHorizontalScrollIndicator:NO];
        [_tableViewFavorites setDataSource:self];
        [_tableViewFavorites setDelegate:self];
        [_tableViewFavorites registerClass:[ProductTableViewCell class] forCellReuseIdentifier:ProductTableViewCellIdentifier];
        [_tableViewFavorites registerClass:[LoadingFooterView class] forHeaderFooterViewReuseIdentifier:LoadingFooterViewIdentifier];
    }
    return _tableViewFavorites;
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
        [_labelNoContent setText:[LocalizedString NoCollections]];
        [_labelNoContent setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelNoContent;
}

#pragma mark - Private Methods

- (void)refreshData
{
    self.arrayFavorites = [[TMInfoManager sharedManager] favorites];
//    NSLog(@"self.arrayFavorites[%li]:\n%@", (long)self.arrayFavorites.count, [self.arrayFavorites description]);
    
}

- (void)showCartTypeSheetForProduct:(NSDictionary *)product
{
    NSArray *arrayCartType = [self cartArrayForProduct:product];
    
    __weak FavoriteViewController *weakSelf = self;
    if ([arrayCartType count] > 1)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString AddToCart] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSDictionary *dictionary in arrayCartType)
        {
            NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
            NSNumber *cartType = [dictionary objectForKey:SymphoxAPIParam_cart_type];
            UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [weakSelf addProduct:product toCart:[cartType integerValue]];
            }];
            [alertController addAction:action];
        }
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([arrayCartType count] > 0)
    {
        NSDictionary *dictionary = [arrayCartType objectAtIndex:0];
        NSNumber *numberCartType = [dictionary objectForKey:SymphoxAPIParam_cart_type];
        [self addProduct:product toCart:[numberCartType integerValue]];
    }
}

- (NSArray *)cartArrayForProduct:(NSDictionary *)product
{
    NSMutableArray *arrayCartType = [NSMutableArray array];
    
    NSNumber *normal_cart = [product objectForKey:SymphoxAPIParam_normal_cart];
    if (normal_cart && [normal_cart isEqual:[NSNull null]] == NO && [normal_cart boolValue] == YES)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[NSNumber numberWithInteger:CartTypeCommonDelivery] forKey:SymphoxAPIParam_cart_type];
        [dictionary setObject:[LocalizedString CommonDelivery] forKey:SymphoxAPIParam_name];
        [arrayCartType addObject:dictionary];
    }
    NSNumber *to_store_cart = [product objectForKey:SymphoxAPIParam_to_store_cart];
    if (to_store_cart && [to_store_cart isEqual:[NSNull null]] == NO && [to_store_cart boolValue] == YES)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[NSNumber numberWithInteger:CartTypeStorePickup] forKey:SymphoxAPIParam_cart_type];
        [dictionary setObject:[LocalizedString StorePickUp] forKey:SymphoxAPIParam_name];
        [arrayCartType addObject:dictionary];
    }
    NSNumber *fast_delivery_cart = [product objectForKey:SymphoxAPIParam_fast_delivery_cart];
    if (fast_delivery_cart && [fast_delivery_cart isEqual:[NSNull null]] == NO && [fast_delivery_cart boolValue] == YES)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[NSNumber numberWithInteger:CartTypeFastDelivery] forKey:SymphoxAPIParam_cart_type];
        [dictionary setObject:[LocalizedString FastDelivery] forKey:SymphoxAPIParam_name];
        [arrayCartType addObject:dictionary];
    }
    return arrayCartType;
}

- (void)addProduct:(NSDictionary *)product toCart:(CartType)cartType
{
    [[TMInfoManager sharedManager] addProduct:product toCartForType:cartType];
    NSString *message = [NSString stringWithFormat:[LocalizedString AddedTo_S_], @""];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)canDirectlyPurchaseProduct:(NSDictionary *)product
{
    BOOL canPurchaseDirectly = NO;
    NSNumber *single_shopping_cart = [product objectForKey:SymphoxAPIParam_single_shopping_cart];
    if (single_shopping_cart && [single_shopping_cart isEqual:[NSNull null]] == NO)
    {
        canPurchaseDirectly = [single_shopping_cart boolValue];
    }
    return canPurchaseDirectly;
}

#pragma mark - Actions

- (void)buttonEditPressed:(id)sender
{
    [self.buttonEdit setSelected:![self.buttonEdit isSelected]];
    
    [self.tableViewFavorites setEditing:[self.buttonEdit isSelected] animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
        {
            numberOfRows = [_arrayFavorites count];
        }
            break;
        default:
            break;
    }
    
    //    NSLog(@"numberOfRows[%li]", (long)numberOfRows);
    if (numberOfRows == 0)
    {
        tableView.backgroundView = self.tableBackgroundView;
    }
    else
    {
        tableView.backgroundView = nil;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductTableViewCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    NSLog(@"cellForRowAtIndexPath[%li][%li]", (long)indexPath.section, (long)indexPath.row);
    if (cell.delegate == nil)
    {
        cell.delegate = self;
    }
    cell.tag = indexPath.row;
    cell.price = nil;
    cell.point = nil;
    if (indexPath.row < [_arrayFavorites count])
    {
        NSDictionary *dictionary = [_arrayFavorites objectAtIndex:indexPath.row];
        NSString *imagePath = [dictionary objectForKey:SymphoxAPIParam_prod_pic_url];
        cell.imagePath = imagePath;
        NSMutableArray *arrayTags = [NSMutableArray array];
        
        NSNumber *quick = [dictionary objectForKey:SymphoxAPIParam_quick];
        if (quick && ([quick isEqual:[NSNull null]] == NO) && [quick boolValue])
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"8H", ProductTableViewCellTagText, [UIColor colorWithRed:(152.0/255.0) green:(194.0/255.0) blue:(67.0/255.0) alpha:1.0], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        
        NSNumber *to_store_cart = [dictionary objectForKey:SymphoxAPIParam_to_store_cart];
        if (to_store_cart && [to_store_cart isEqual:[NSNull null]] == NO && [to_store_cart boolValue])
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"超取", ProductTableViewCellTagText, [UIColor colorWithRed:(152.0/255.0) green:(194.0/255.0) blue:(67.0/255.0) alpha:1.0], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        
        NSNumber *discountNow = [dictionary objectForKey:SymphoxAPIParam_chk_tactic_click];
        if (discountNow && ([discountNow isEqual:[NSNull null]] == NO) && [discountNow boolValue])
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[LocalizedString ClickToDiscount], ProductTableViewCellTagText, [UIColor colorWithRed:(134.0/255.0) green:(209.0/255.0) blue:(188.0/255.0) alpha:1.0], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        NSArray *installments = [dictionary objectForKey:SymphoxAPIParam_seekInstallmentList];
        if (installments && ([installments isEqual:[NSNull null]] == NO) && [installments count] > 0)
        {
            NSDictionary *longestPeriodInstallment = [installments lastObject];
            NSNumber *installmentNumber = [longestPeriodInstallment objectForKey:SymphoxAPIParam_installment_num];
            if (installmentNumber && [installmentNumber integerValue] > 0)
            {
                NSString *numberString = [NSString stringWithFormat:[LocalizedString S_InstallmentNumber], (long)[installmentNumber integerValue]];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:numberString, ProductTableViewCellTagText, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
                [arrayTags addObject:dictionary];
            }
        }
        NSNumber *freePoint = [dictionary objectForKey:SymphoxAPIParam_freepoint];
        if (freePoint && [freePoint integerValue] > 0)
        {
            NSString *freePointString = [NSString stringWithFormat:[LocalizedString Free_S_Point], (long)[freePoint integerValue]];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:freePointString, ProductTableViewCellTagText, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
            [arrayTags addObject:dictionary];
        }
        cell.arrayTagsData = arrayTags;
        
        NSString *marketText = [dictionary objectForKey:SymphoxAPIParam_market_name];
        cell.marketingText = marketText;
        
        NSString *productName = [dictionary objectForKey:SymphoxAPIParam_cpdt_name];
        cell.productName = productName;
        
        NSNumber *price = [dictionary objectForKey:SymphoxAPIParam_price03];
        NSNumber *point = [dictionary objectForKey:SymphoxAPIParam_point01];
        NSNumber *price1 = [dictionary objectForKey:SymphoxAPIParam_price02];
        NSNumber *point1 = [dictionary objectForKey:SymphoxAPIParam_point02];
        BOOL hasPurePrice = (price && [price isEqual:[NSNull null]] == NO && [price unsignedIntegerValue] > 0);
        BOOL hasPurePoint = (point && [point isEqual:[NSNull null]] == NO && [point unsignedIntegerValue] > 0);
        BOOL hasMixedPrice = (price1 && [price1 isEqual:[NSNull null]] == NO && [price1 unsignedIntegerValue] > 0) && (point1 && [point1 isEqual:[NSNull null]] == NO && [point1 unsignedIntegerValue] > 0);
        if (hasPurePrice)
        {
            cell.price = price;
            
            if (hasPurePoint)
            {
                cell.point = point;
            }
            
            cell.priceType = PriceTypePurePrice;
        }
        else if (hasMixedPrice)
        {
            if (price1 && [price1 isEqual:[NSNull null]] == NO)
            {
                cell.mixPrice = price1;
            }
            if (point1 && [point1 isEqual:[NSNull null]] == NO)
            {
                cell.mixPoint = point1;
            }
            
            
            if (hasPurePoint)
            {
                cell.point = point;
            }
            cell.priceType = PriceTypeMixed;
        }
        else if (hasPurePoint)
        {
            cell.point = point;
            cell.priceType = PriceTypePurePoint;
        }
        else
        {
            cell.price = price;
            cell.priceType = PriceTypePurePrice;
        }
        
        NSNumber *discount = [dictionary objectForKey:SymphoxAPIParam_discount_hall_percentage];
        cell.discount = discount;
        
        NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO)
        {
            BOOL isFavorite = [[TMInfoManager sharedManager] favoriteContainsProductWithIdentifier:cpdt_num];
            cell.favorite = isFavorite;
        }
        cell.buttonFavorite.hidden = YES;
        
        BOOL canPurchaseDirectly = [self canDirectlyPurchaseProduct:dictionary];
        
        NSArray *arrayCarts = [self cartArrayForProduct:dictionary];
        if (([arrayCarts count] > 0) || canPurchaseDirectly)
        {
            cell.buttonCart.hidden = NO;
        }
        else
        {
            cell.buttonCart.hidden = YES;
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
    CGFloat heightForRow = 168.0;
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForFooter = 0.0;
    switch (section) {
        case 1:
        {
            if (_shouldShowLoadingFooter)
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
        LoadingFooterView *loadingView = (LoadingFooterView *)view;
        [loadingView.activityIndicator startAnimating];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[LoadingFooterView class]])
    {
        LoadingFooterView *loadingView = (LoadingFooterView *)view;
        [loadingView.activityIndicator stopAnimating];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
    NSDictionary *dictionary = [self.arrayFavorites objectAtIndex:indexPath.row];
    viewController.dictionaryCommon = dictionary;
    viewController.title = [LocalizedString ProductInfo];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            [[TMInfoManager sharedManager] removeProductFromFavorite:indexPath.row];
            [self refreshData];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ProductTableViewCellDelegate

- (void)productTableViewCell:(ProductTableViewCell *)cell didSelectToAddToCartBySender:(id)sender
{
    if ([TMInfoManager sharedManager].userIdentifier == nil)
    {
        // Should login first.
        LoginViewController *viewControllerLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerLogin];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    if (cell.tag >= [self.arrayFavorites count])
        return;
    NSDictionary *product = [self.arrayFavorites objectAtIndex:cell.tag];
    [self showCartTypeSheetForProduct:product];
}

- (void)productTableViewCell:(ProductTableViewCell *)cell didSelectToAddToFavoriteBySender:(id)sender
{
    
}

@end
