//
//  AdditionalPurchaseViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "AdditionalPurchaseViewController.h"
#import "APIDefinition.h"

@interface AdditionalPurchaseViewController ()

@end

@implementation AdditionalPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomBar];
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
    
    if (self.bottomBar)
    {
        CGFloat height = 50.0;
        CGRect frame = CGRectMake(0.0, self.view.frame.size.height - height, self.view.frame.size.width, height);
        self.bottomBar.frame = frame;
    }
    
    if (self.collectionView)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, CGRectGetMinY(self.bottomBar.frame) - originY);
        self.collectionView.frame = frame;
        [self.collectionView reloadData];
    }
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        [_collectionView registerClass:[AdditionalProductCollectionViewCell class] forCellWithReuseIdentifier:AdditionalProductCollectionViewCellIdentifier];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
    }
    return _collectionView;
}

- (LabelButtonView *)bottomBar
{
    if (_bottomBar == nil)
    {
        _bottomBar = [[LabelButtonView alloc] initWithFrame:CGRectZero];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = [self.arrayProducts count];
    return numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AdditionalProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AdditionalProductCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (cell.delegate == nil)
    {
        cell.delegate = self;
    }
    
    NSString *textName = @"";
    NSString *textMarketing = @"";
    NSURL *url = nil;
    NSString *textPrice = @"";
    if (indexPath.row < [self.arrayProducts count])
    {
        NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        if (name && [name isEqual:[NSNull null]] == NO)
        {
            textName = name;
        }
        NSString *marketing = [dictionary objectForKey:SymphoxAPIParam_market_name];
        if (marketing && [marketing isEqual:[NSNull null]] == NO)
        {
            textMarketing = marketing;
        }
        NSString *imagePath = [dictionary objectForKey:SymphoxAPIParam_img_url];
        if (imagePath && [imagePath isEqual:[NSNull null]] == NO)
        {
            url = [NSURL URLWithString:imagePath];
        }
        NSNumber *price = [dictionary objectForKey:SymphoxAPIParam_price];
        if (price && [price isEqual:[NSNull null]] == NO)
        {
            NSString *stringPrice = [self.formatter stringFromNumber:price];
            if (stringPrice)
            {
                textPrice = [NSString stringWithFormat:@"＄%@", stringPrice];
            }
        }
    }
    
    cell.labelMarketing.text = [[NSAttributedString alloc] initWithString:textMarketing attributes:cell.attributesText];
    cell.labelName.text = [[NSAttributedString alloc] initWithString:textName attributes:cell.attributesText];
    cell.imageUrl = url;
    cell.labelPrice.text = textPrice;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    return edgeInsets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(150.0, 310.0);
    return cellSize;
}

#pragma mark - AdditionalProductCollectionViewCellDelegate

- (void)additionalProductCollectionViewCell:(AdditionalProductCollectionViewCell *)cell didSelectPurchaseBySender:(id)sender
{
    
}

#pragma mark - LabelButtonViewDelegate

- (void)labelButtonView:(LabelButtonView *)view didPressButton:(id)sender
{
    
}

@end
