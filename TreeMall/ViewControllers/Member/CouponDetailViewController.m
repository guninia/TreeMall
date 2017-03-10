//
//  CouponDetailViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/3.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "LocalizedString.h"
#import "TopSeparatedTitleCollectionReusableView.h"
#import "SearchCollectionViewCell.h"
#import "APIDefinition.h"
#import "WebViewViewController.h"
#import "ProductListViewController.h"
#import "ProductDetailViewController.h"

typedef enum : NSUInteger {
    SectionTypeCategory,
    SectionTypeProduct,
    SectionTypeTotal,
} SectionType;

@interface CouponDetailViewController ()

- (void)presentHallNamed:(NSString *)name forIdentifier:(NSString *)hallId atLayer:(NSNumber *)layer;
- (void)presentProductNamed:(NSString *)name forIdentifier:(NSNumber *)productId;

@end

@implementation CouponDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _arraySectionType = [[NSMutableArray alloc] initWithCapacity:0];
        marginL = 10.0;
        marginR = 10.0;
        intervalV = 10.0;
        intervalH = 10.0;
        columnForCategory = 2;
        columnForProduct = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setTitle:[LocalizedString CouponDetail]];
    
    // Prepare section
    NSArray *arrayHall = [self.dictionaryData objectForKey:SymphoxAPIParam_hall];
    NSArray *arrayProduct = [self.dictionaryData objectForKey:SymphoxAPIParam_product];
    if (arrayHall && ([arrayHall isEqual:[NSNull null]] == NO) && [arrayHall count] > 0)
    {
        [self.arraySectionType addObject:[NSNumber numberWithUnsignedInteger:SectionTypeCategory]];
    }
    if (arrayProduct && ([arrayProduct isEqual:[NSNull null]] == NO) && [arrayProduct count] > 0)
    {
        [self.arraySectionType addObject:[NSNumber numberWithUnsignedInteger:SectionTypeProduct]];
    }
    
    [self.view addSubview:self.viewDescription];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView reloadData];
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
    
    CGFloat originY = 0.0;
    
    if (self.viewDescription)
    {
        CGFloat referenceHeight = [self.viewDescription referenceHeightForFixedWidth:self.view.frame.size.width];
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, referenceHeight);
        self.viewDescription.frame = frame;
        originY = self.viewDescription.frame.origin.y + self.viewDescription.frame.size.height;
    }
    if (self.collectionView)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        self.collectionView.frame = frame;
    }
}

- (void)setDictionaryData:(NSDictionary *)dictionaryData
{
    _dictionaryData = dictionaryData;
    if (_dictionaryData == nil)
    {
        [self.viewDescription setHidden:YES];
        return;
    }
    [self.viewDescription setHidden:NO];
    NSString *name = [dictionaryData objectForKey:SymphoxAPIParam_name];
    if (name == nil || [name isEqual:[NSNull null]] || [name length] == 0)
    {
        [self.viewDescription.labelTitle setHidden:YES];
        self.viewDescription.labelTitle.text = @"";
    }
    else
    {
        [self.viewDescription.labelTitle setHidden:NO];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:name attributes:self.viewDescription.attributesTitle];
        [self.viewDescription.labelTitle setAttributedText:attrString];
    }
    NSString *description = [dictionaryData objectForKey:SymphoxAPIParam_description];
    if (description == nil || [description isEqual:[NSNull null]] || [description length] == 0)
    {
        [self.viewDescription.labelCondition setHidden:YES];
        self.viewDescription.labelCondition.text = @"";
    }
    else
    {
        [self.viewDescription.labelCondition setHidden:NO];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:description attributes:self.viewDescription.attributesCondition];
        [self.viewDescription.labelCondition setAttributedText:attrString];
    }
    NSString *campaignUrl = [dictionaryData objectForKey:SymphoxAPIParam_campaign_url];
    if (campaignUrl == nil || [campaignUrl isEqual:[NSNull null]] || [campaignUrl length] == 0)
    {
        [self.viewDescription.buttonAction setHidden:YES];
    }
    else
    {
        [self.viewDescription.buttonAction setHidden:NO];
    }
}

- (CouponDetailDescriptionView *)viewDescription
{
    if (_viewDescription == nil)
    {
        _viewDescription = [[CouponDetailDescriptionView alloc] initWithFrame:CGRectZero];
        _viewDescription.delegate = self;
    }
    return _viewDescription;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:SearchCollectionViewCellIdentifier];
        [_collectionView registerClass:[TopSeparatedTitleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TopSeparatedTitleCollectionReusableViewIdentifier];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
    }
    return _collectionView;
}

- (void)setStringDateStart:(NSString *)stringDateStart
{
    if ([_stringDateStart isEqualToString:stringDateStart] == NO)
    {
        _stringDateStart = stringDateStart;
    }
    if (_stringDateStart == nil)
    {
        [self.viewDescription.labelDateStart setHidden:YES];
        [self.viewDescription.labelDateStart setText:@""];
    }
    else
    {
        [self.viewDescription.labelDateStart setHidden:NO];
        [self.viewDescription.labelDateStart setText:_stringDateStart];
    }
}

- (void)setStringDateGoodThru:(NSString *)stringDateGoodThru
{
    if ([stringDateGoodThru isEqualToString:_stringDateGoodThru] == NO)
    {
        _stringDateGoodThru = stringDateGoodThru;
    }
    if (_stringDateGoodThru == nil)
    {
        [self.viewDescription.labelDateGoodThru setHidden:YES];
        [self.viewDescription.labelDateGoodThru setText:@""];
    }
    else
    {
        [self.viewDescription.labelDateGoodThru setHidden:NO];
        [self.viewDescription.labelDateGoodThru setText:_stringDateGoodThru];
    }
}

- (void)setStringCouponValue:(NSString *)stringCouponValue
{
    if ([stringCouponValue isEqualToString:_stringCouponValue] == NO)
    {
        _stringCouponValue = stringCouponValue;
    }
    if (_stringCouponValue == nil)
    {
        [self.viewDescription.labelValue setHidden:YES];
        [self.viewDescription.labelValue setText:@""];
    }
    else
    {
        [self.viewDescription.labelValue setHidden:NO];
        [self.viewDescription.labelValue setText:_stringCouponValue];
    }
}

#pragma mark - Private Methods

- (void)presentHallNamed:(NSString *)name forIdentifier:(NSString *)hallId atLayer:(NSNumber *)layer
{
    ProductListViewController *viewController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:[NSBundle mainBundle]];
    viewController.hallId = hallId;
    viewController.layer = layer;
    viewController.name = name;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentProductNamed:(NSString *)name forIdentifier:(NSNumber *)productId
{
    ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - CouponDetailDescriptionViewDelegate

- (void)couponDetailDescriptionView:(CouponDetailDescriptionView *)view didPressActionBySender:(id)sender
{
    NSString *stringCampaignUrl = [self.dictionaryData objectForKey:SymphoxAPIParam_campaign_url];
    if (stringCampaignUrl == nil || [stringCampaignUrl isEqual:[NSNull null]] || [stringCampaignUrl length] == 0)
    {
        return;
    }
    // Should Pop webview
    WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
    viewController.urlString = @"http://www.treemall.com.tw/";
    viewController.title = [LocalizedString CampaignLink];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numberOfSections = [self.arraySectionType count];
    return numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = 0;
    if (section >= [self.arraySectionType count])
    {
        return numberOfItems;
    }
    NSNumber *numberSectionType = [self.arraySectionType objectAtIndex:section];
    NSArray *array = nil;
    switch ([numberSectionType unsignedIntegerValue]) {
        case SectionTypeCategory:
        {
            array = [self.dictionaryData objectForKey:SymphoxAPIParam_hall];
        }
            break;
        case SectionTypeProduct:
        {
            array = [self.dictionaryData objectForKey:SymphoxAPIParam_product];
        }
            break;
        default:
            break;
    }
    if (array == nil)
    {
        return numberOfItems;
    }
    numberOfItems = [array count];
    return numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.label.text = @"";
    if (indexPath.section >= [self.arraySectionType count])
    {
        return cell;
    }
    SectionType type = SectionTypeTotal;
    NSNumber *numberSectionType = [self.arraySectionType objectAtIndex:indexPath.section];
    type = [numberSectionType integerValue];
    NSArray *array = nil;
    switch (type) {
        case SectionTypeCategory:
        {
            array = [self.dictionaryData objectForKey:SymphoxAPIParam_hall];
        }
            break;
        case SectionTypeProduct:
        {
            array = [self.dictionaryData objectForKey:SymphoxAPIParam_product];
        }
            break;
        default:
            break;
    }
    if (array == nil || indexPath.row >= [array count])
    {
        return cell;
    }
    NSDictionary *dictionary = [array objectAtIndex:indexPath.row];
    NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
    if (name)
    {
        [cell.label setText:name];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TopSeparatedTitleCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TopSeparatedTitleCollectionReusableViewIdentifier forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        if (indexPath.section < [self.arraySectionType count])
        {
            NSNumber *numberSectionType = [self.arraySectionType objectAtIndex:indexPath.section];
            SectionType type = [numberSectionType integerValue];
            switch (type) {
                case SectionTypeCategory:
                {
                    headerView.labelTitle.text = [LocalizedString AvailableHall];
                }
                    break;
                case SectionTypeProduct:
                {
                    headerView.labelTitle.text = [LocalizedString AvailableProduct];
                }
                    break;
                default:
                {
                    headerView.labelTitle.text = @"";
                }
                    break;
            }
        }
        headerView.marginL = marginL;
        headerView.marginR = marginR;
    }
    return headerView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SectionType type = SectionTypeTotal;
    NSNumber *numberSectionType = [self.arraySectionType objectAtIndex:indexPath.section];
    type = [numberSectionType integerValue];
    switch (type) {
        case SectionTypeCategory:
        {
            NSArray *array = [self.dictionaryData objectForKey:SymphoxAPIParam_hall];
            NSDictionary *dictionary = [array objectAtIndex:indexPath.row];
            NSString *hallId = [dictionary objectForKey:SymphoxAPIParam_hall_id];
            if (hallId == nil || [hallId isEqual:[NSNull null]] || [hallId length] == 0)
                break;
            NSNumber *layer = [dictionary objectForKey:SymphoxAPIParam_layer];
            if (layer == nil || [layer isEqual:[NSNull null]] || [layer integerValue] == 0)
                break;
            NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
            if (name == nil || [name isEqual:[NSNull null]] || [name length] == 0)
                break;
            [self presentHallNamed:name forIdentifier:hallId atLayer:layer];
        }
            break;
        case SectionTypeProduct:
        {
            NSArray *array = [self.dictionaryData objectForKey:SymphoxAPIParam_product];
            NSDictionary *dictionary = [array objectAtIndex:indexPath.row];
            NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
            if (name == nil || [name isEqual:[NSNull null]] || [name length] == 0)
                break;
            NSNumber *productId = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
            if (productId == nil || [productId isEqual:[NSNull null]] || [productId integerValue] == 0)
                break;
            [self presentProductNamed:name forIdentifier:productId];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize referenceSize = CGSizeZero;
    if (section < [self.arraySectionType count])
    {
        referenceSize = CGSizeMake(collectionView.frame.size.width, 50.0);
    }
    return referenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeForItem = CGSizeZero;
    if (indexPath.section >= [self.arraySectionType count])
    {
        return sizeForItem;
    }
    SectionType type = SectionTypeTotal;
    NSNumber *numberSectionType = [self.arraySectionType objectAtIndex:indexPath.section];
    type = [numberSectionType integerValue];
    NSInteger column = columnForCategory;
    switch (type) {
        case SectionTypeCategory:
        {
            column = columnForCategory;
        }
            break;
        case SectionTypeProduct:
        {
            column = columnForProduct;
        }
            break;
        default:
            break;
    }
    CGFloat cellWidth = ceil((collectionView.frame.size.width - marginL - marginR - (intervalH * (column - 1)))/column);
    sizeForItem = CGSizeMake(cellWidth, 40.0);
    return sizeForItem;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, marginL, 0.0, marginR);
    return edgeInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat minimumLineSpacing = intervalV;
    return minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}
@end
