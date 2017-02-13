//
//  ProductSubcategoryView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductSubcategoryView.h"
#import "LocalizedString.h"
#import <QuartzCore/QuartzCore.h>
#import "ProductSubcategoryCollectionViewCell.h"
#import "APIDefinition.h"

static CGFloat kIntervalH = 10.0;

@interface ProductSubcategoryView ()

- (void)inititalize;

- (void)buttonShowAllPressed:(id)sender;

@end

@implementation ProductSubcategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self inititalize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self inititalize];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginT = 10.0;
    CGFloat marginL = 10.0;
    CGFloat marginB = 10.0;
    CGFloat marginR = 0.0;
    CGFloat intervalV = kIntervalH;
    
    CGFloat originX = marginL;
    
    CGFloat buttonSideLength = (self.frame.size.height - (marginT + marginB));
    if (self.buttonShowAll)
    {
        CGRect buttonFrame = CGRectMake(marginL, marginT, buttonSideLength, buttonSideLength);
        self.buttonShowAll.frame = buttonFrame;
        originX = self.buttonShowAll.frame.origin.x + self.buttonShowAll.frame.size.width + intervalV;
    }
    if (self.collectionViewSubcategory)
    {
        CGRect frame = CGRectMake(originX, marginT, (self.frame.size.width - originX - marginR), buttonSideLength);
        self.collectionViewSubcategory.frame = frame;
        [self.collectionViewSubcategory.collectionViewLayout invalidateLayout];
    }
}

- (UIButton *)buttonShowAll
{
    if (_buttonShowAll == nil)
    {
        _buttonShowAll = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonShowAll addTarget:self action:@selector(buttonShowAllPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonShowAll setTitle:[LocalizedString Category_N_List] forState:UIControlStateNormal];
        [_buttonShowAll setTitleColor:[UIColor colorWithRed:(32.0/255.0) green:(89.0/255.0) blue:(6.0/255.0) alpha:1.0] forState:UIControlStateNormal];
        [_buttonShowAll.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_buttonShowAll.titleLabel setNumberOfLines:0];
        [_buttonShowAll.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_buttonShowAll.layer setCornerRadius:3.0];
        [_buttonShowAll.layer setBorderWidth:1.0];
        [_buttonShowAll.layer setBorderColor:[_buttonShowAll titleColorForState:UIControlStateNormal].CGColor];
    }
    return _buttonShowAll;
}

- (UICollectionView *)collectionViewSubcategory
{
    if (_collectionViewSubcategory == nil)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionViewSubcategory = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionViewSubcategory setBackgroundColor:[UIColor clearColor]];
        [_collectionViewSubcategory registerClass:[ProductSubcategoryCollectionViewCell class] forCellWithReuseIdentifier:ProductSubcategoryCollectionViewCellIdentifier];
        [_collectionViewSubcategory setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, kIntervalH)];
        [_collectionViewSubcategory setShowsVerticalScrollIndicator:NO];
        [_collectionViewSubcategory setShowsHorizontalScrollIndicator:NO];
        [_collectionViewSubcategory setDataSource:self];
        [_collectionViewSubcategory setDelegate:self];
    }
    return _collectionViewSubcategory;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [_collectionViewSubcategory reloadData];
}

#pragma mark - Private Methods

- (void)inititalize
{
    _dataArray = nil;
    [self addSubview:self.buttonShowAll];
    [self addSubview:self.collectionViewSubcategory];
    [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
}

#pragma mark - Actions

- (void)buttonShowAllPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productSubcategoryView:didSelectShowAllBySender:)])
    {
        [_delegate productSubcategoryView:self didSelectShowAllBySender:sender];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = [_dataArray count];
//    NSLog(@"_dataArray[%p][%li]", _dataArray, (long)[_dataArray count]);
    return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductSubcategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductSubcategoryCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    NSString *name = nil;
    if (indexPath.row < [_dataArray count])
    {
        NSDictionary *dictionary = [_dataArray objectAtIndex:indexPath.row];
        name = [dictionary objectForKey:SymphoxAPIParam_name];
    }
//    NSLog(@"cellForItemAtIndexPath - name[%@]", name);
    cell.textLabel.text = (name == nil)?@"":name;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(productSubcategoryView:didSelectSubcategoryAtIndex:)])
    {
        [_delegate productSubcategoryView:self didSelectSubcategoryAtIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kIntervalH;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kIntervalH;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeForItem = CGSizeMake(140.0, collectionView.frame.size.height);
    return sizeForItem;
}

@end
