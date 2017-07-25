//
//  SearchViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/16.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SearchViewController.h"
#import "LocalizedString.h"
#import "TMInfoManager.h"
#import "SearchCollectionViewCell.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

typedef enum : NSUInteger {
    CollectionViewSectionSearchLatest,
    CollectionViewSectionSearchHot,
    CollectionViewSectionTotal,
} CollectionViewSection;

@interface SearchViewController () {
    id<GAITracker> gaTracker;
}

- (void)dismiss;
- (void)retrieveLatestSearchData;
- (void)retrieveHotSearchData;
- (BOOL)processHotSearchData:(id)data;
- (BOOL)confirmAndSearchKeyword:(NSString *)text;
- (void)buttonItemClosePressed:(id)sender;
- (void)buttonSearchPressed:(id)sender;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"car_popup_close"];
    if (image)
    {
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:image style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemClosePressed:)];
        self.navigationItem.leftBarButtonItem = buttonItem;
    }
    self.title = [LocalizedString Search];
    
    [self.view addSubview:self.textFieldSearch];
    [self.view addSubview:self.collectionViewKeyword];
    
    [self retrieveLatestSearchData];
    if ([[TMInfoManager sharedManager].arrayKeywords count] > 0)
    {
        self.arraySearchHot = [TMInfoManager sharedManager].arrayKeywords;
        [self.collectionViewKeyword reloadSections:[NSIndexSet indexSetWithIndex:CollectionViewSectionSearchHot]];
    }
    else
    {
        [self retrieveHotSearchData];
    }

    gaTracker = [GAI sharedInstance].defaultTracker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // GA screen log
    [gaTracker set:kGAIScreenName value:self.title];
    [gaTracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat originX = marginL;
    
    if (self.textFieldSearch)
    {
        self.textFieldSearch.frame = CGRectMake(originX, originY, self.view.frame.size.width - (marginL + marginR), 40.0);
        originY = self.textFieldSearch.frame.origin.y + self.textFieldSearch.frame.size.height;
    }
    if (self.collectionViewKeyword)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        self.collectionViewKeyword.frame = frame;
        [self.collectionViewKeyword reloadData];
    }
}

- (UITextField *)textFieldSearch
{
    if (_textFieldSearch == nil)
    {
        _textFieldSearch = [[UITextField alloc] initWithFrame:CGRectZero];
        [_textFieldSearch setBackgroundColor:[UIColor clearColor]];
        [_textFieldSearch setPlaceholder:[LocalizedString KeywordSearch]];
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

- (UICollectionView *)collectionViewKeyword
{
    if (_collectionViewKeyword == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionViewKeyword = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionViewKeyword registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:SearchCollectionViewCellIdentifier];
        [_collectionViewKeyword registerClass:[SearchHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchHeaderCollectionReusableViewIdentifier];
        [_collectionViewKeyword setShowsVerticalScrollIndicator:NO];
        [_collectionViewKeyword setShowsHorizontalScrollIndicator:NO];
        [_collectionViewKeyword setDelegate:self];
        [_collectionViewKeyword setDataSource:self];
        [_collectionViewKeyword setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1.0]];
    }
    return _collectionViewKeyword;
}

#pragma mark - Private Methods

- (void)dismiss
{
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

- (void)retrieveLatestSearchData
{
    self.arraySearchLatest = [[TMInfoManager sharedManager] keywords];
    [self.collectionViewKeyword reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
}

- (void)retrieveHotSearchData
{
    __weak SearchViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_hotKeywords];
    NSLog(@"retrieveHotSearchData [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:nil inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        NSString *errorDescription = nil;
        if (error == nil)
        {
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"string[%@]", string);
                // Should continue to process data.
                if ([self processHotSearchData:data] == NO)
                {
                    NSLog(@"Cannot process hot search data...");
                }
            }
            else
            {
                NSLog(@"Unexpected data format.");
                errorDescription = [LocalizedString UnexpectedFormatFromNetwork];
            }
        }
        else
        {
            NSLog(@"error:\n%@", [error description]);
        }
    }];
}

- (BOOL)processHotSearchData:(id)data
{
    BOOL success = NO;
    if ([data isKindOfClass:[NSData class]])
    {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error == nil && jsonObject)
        {
            if ([jsonObject isKindOfClass:[NSArray class]])
            {
                self.arraySearchHot = jsonObject;
                [self.collectionViewKeyword reloadSections:[NSIndexSet indexSetWithIndex:CollectionViewSectionSearchHot]];
                success = YES;
            }
        }
    }
    return success;
}

- (BOOL)confirmAndSearchKeyword:(NSString *)text
{
    if (text == nil || [text length] == 0)
    {
        return NO;
    }
    [[TMInfoManager sharedManager] addKeyword:text];
    if (_delegate == nil || [_delegate respondsToSelector:@selector(searchViewController:didSelectToSearchKeyword:)] == NO)
    {
        return NO;
    }
    NSString *urlEncoded = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_delegate searchViewController:self didSelectToSearchKeyword:urlEncoded];
    [self dismiss];
    return YES;
}

#pragma mark - Actions

- (void)buttonItemClosePressed:(id)sender
{
    [self dismiss];
}

- (void)buttonSearchPressed:(id)sender
{
    NSString *text = self.textFieldSearch.text;
    if ([self confirmAndSearchKeyword:text] == NO)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PleaseInputKeyword] preferredStyle:UIAlertControllerStyleAlert];
        __weak SearchViewController *weakSelf = self;
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
    [self.textFieldSearch resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = textField.text;
    if ([self confirmAndSearchKeyword:text] == NO)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PleaseInputKeyword] preferredStyle:UIAlertControllerStyleAlert];
        __weak SearchViewController *weakSelf = self;
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
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return CollectionViewSectionTotal;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = 0;
    switch (section) {
        case CollectionViewSectionSearchLatest:
        {
            if (_arraySearchLatest)
            {
                numberOfItems = [_arraySearchLatest count];
            }
        }
            break;
        case CollectionViewSectionSearchHot:
        {
            if (_arraySearchHot)
            {
                numberOfItems = [_arraySearchHot count];
            }
        }
            break;
        default:
            break;
    }
    return numberOfItems;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SearchHeaderCollectionReusableViewIdentifier forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        SearchHeaderCollectionReusableView *headerView = (SearchHeaderCollectionReusableView *)view;
        NSString *text = nil;
        BOOL shouldShowRecycleButton = NO;
        BOOL shouldShowTopSeparator = YES;
        switch (indexPath.section) {
            case CollectionViewSectionSearchLatest:
            {
                text = [LocalizedString LatestSearch__];
                shouldShowRecycleButton = YES;
                shouldShowTopSeparator = NO;
            }
                break;
            case CollectionViewSectionSearchHot:
            {
                text = [LocalizedString HotSearch__];
                if ([self.arraySearchLatest count] == 0)
                {
                    shouldShowTopSeparator = NO;
                }
            }
                break;
            default:
                break;
        }
        if (text == nil)
        {
            text = [LocalizedString Search];
        }
        headerView.tag = indexPath.section;
        headerView.label.text = text;
        headerView.shouldShowRecycle = shouldShowRecycleButton;
        headerView.delegate = self;
        headerView.tag = indexPath.section;
        headerView.separatorTop.hidden = !shouldShowTopSeparator;
    }
    return view;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchCollectionViewCellIdentifier forIndexPath:indexPath];
    NSString *text = @"";
    switch (indexPath.section) {
        case CollectionViewSectionSearchLatest:
        {
            if (indexPath.row < [_arraySearchLatest count])
            {
                text = [_arraySearchLatest objectAtIndex:indexPath.row];
            }
        }
            break;
        case CollectionViewSectionSearchHot:
        {
            if (indexPath.row < [_arraySearchHot count])
            {
                text = [_arraySearchHot objectAtIndex:indexPath.row];
            }
        }
            break;
        default:
            break;
    }
    cell.label.text = text;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = nil;
    NSString * listName = nil;
    switch (indexPath.section) {
        case CollectionViewSectionSearchLatest:
        {
            array = self.arraySearchLatest;
            listName = logPara_最近搜尋列表;
        }
            break;
        case CollectionViewSectionSearchHot:
        {
            array = self.arraySearchHot;
            listName = logPara_熱門搜尋列表;
        }
            break;
        default:
            break;
    }
    if (indexPath.row < [array count])
    {
        NSString *text = [array objectAtIndex:indexPath.row];
        [self confirmAndSearchKeyword:text];
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:self.title _:listName]
                          action:[EventLog index:indexPath.row _to_:logPara_商品列表]
                          label:nil
                          value:nil] build]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    switch (section) {
        case CollectionViewSectionSearchLatest:
        {
            if ([self.arraySearchLatest count] > 0)
            {
                insets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
            }
        }
            break;
        case CollectionViewSectionSearchHot:
        {
            if ([self.arraySearchHot count] > 0)
            {
                insets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
            }
        }
            break;
        default:
            break;
    }
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat intervalH = 10.0;
    
    CGFloat cellWidth = (collectionView.frame.size.width - marginL - marginR - intervalH)/2;
    CGSize size = CGSizeMake(cellWidth, 40.0);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeZero;
    switch (section) {
        case CollectionViewSectionSearchLatest:
        {
            if (self.arraySearchLatest != nil && [self.arraySearchLatest count] > 0)
            {
                size = CGSizeMake(collectionView.frame.size.width, 50.0);
            }
        }
            break;
        case CollectionViewSectionSearchHot:
        {
            if (self.arraySearchHot != nil && [self.arraySearchHot count] > 0)
            {
                size = CGSizeMake(collectionView.frame.size.width, 50.0);
            }
        }
            break;
        default:
            break;
    }
    return size;
}

#pragma mark - SearchHeaderCollectionReusableViewDelegate

- (void)searchHeaderCollectionReusableView:(SearchHeaderCollectionReusableView *)view didSelectRecycleBySender:(id)sender
{
    switch (view.tag) {
        case CollectionViewSectionSearchLatest:
        {
            __weak SearchViewController *weakSelf = self;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString GoingToRemoveLatestSearchList] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [[TMInfoManager sharedManager] removeAllKeywords];
                [weakSelf retrieveLatestSearchData];
                
                [gaTracker send:[[GAIDictionaryBuilder
                                  createEventWithCategory:[EventLog twoString:self.title _:logPara_刪除]
                                  action:logPara_點擊
                                                 label:nil
                                                 value:nil] build]];
            }];
            [alertController addAction:actionCancel];
            [alertController addAction:actionConfirm];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

@end
