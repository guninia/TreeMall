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

@interface FavoriteViewController ()

- (void)refreshData;
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
        UIImage *image = [UIImage imageNamed:@"ico_trash_off"];
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
        UIImage *image = [UIImage imageNamed:@"ico_default"];
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
    NSLog(@"self.arrayFavorites[%li]:\n%@", (long)self.arrayFavorites.count, [self.arrayFavorites description]);
    
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
        cell.price = price;
        
        NSNumber *point = [dictionary objectForKey:SymphoxAPIParam_point01];
        cell.point = point;
        
        NSNumber *discount = [dictionary objectForKey:SymphoxAPIParam_discount_hall_percentage];
        cell.discount = discount;
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

@end
