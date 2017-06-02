//
//  ShoppingMallViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ShoppingMallViewController.h"
#import "Definition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "MainCategoryCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SubcategoryTableViewCell.h"
#import "ExtraSubcategoryTableViewCell.h"
#import "LocalizedString.h"
#import "ProductListViewController.h"
#import "ExtraSubcategorySeeAllTableViewCell.h"
#import "TMInfoManager.h"
#import "LoadingFooterView.h"

typedef enum : NSUInteger {
    ViewTagCollectionViewMainCategory,
    ViewTagTableViewSubcategory,
    ViewTagTableViewExtraSubcategory,
    ViewTagTotal
} ViewTag;

@interface ShoppingMallViewController ()

- (void)retrieveMainCategoryData;
- (BOOL)processMainCategoryData:(id)data;
- (void)setMainCategoryFromCategories:(NSArray *)categories;
- (void)retrieveSubcategoryDataForIdentifier:(NSString *)identifier andLayer:(NSNumber *)layer;
- (BOOL)processSubcategoryData:(id)data forIdentifier:(NSString *)identifier forLayerIndex:(NSInteger)layerIndex;
- (void)setSubcategoryFromCategories:(NSArray *)categories forIdentifier:(NSString *)identifier andLayerIndex:(NSInteger)layerIndex;
- (void)presentProductListViewForIdentifier:(NSString *)identifier named:(NSString *)name andLayer:(NSNumber *)layer withCategories:(NSArray *)categories andSubcategories:(NSArray *)subcategories;
- (void)clearSubcategoryTableViewForLayer:(NSNumber *)layer;

- (void)buttonItemSearchPressed:(id)sender;
- (void)notificationHandlerTokenUpdated:(NSNotification *)notification;

@end

@implementation ShoppingMallViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _selectedMainCategoryIndex = NSNotFound;
        _arrayMainCategory = [[NSMutableArray alloc] initWithCapacity:0];
        _arraySubcategory = [[NSMutableArray alloc] initWithCapacity:0];
        _arrayExtraSubcategory = [[NSMutableArray alloc] initWithCapacity:0];
        _arrayExtraSubcategorySeeAll = [[NSMutableArray alloc] initWithCapacity:0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandlerTokenUpdated:) name:PostNotificationName_TokenUpdated object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIImage *image = [UIImage imageNamed:@"sho_btn_mag"];
    if (image)
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemSearchPressed:)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_collectionViewCategory setCollectionViewLayout:flowLayout animated:NO completion:nil];
    [_collectionViewCategory registerClass:[MainCategoryCollectionViewCell class] forCellWithReuseIdentifier:MainCategoryCollectionViewCellIdentifier];
    [_collectionViewCategory setShowsVerticalScrollIndicator:NO];
    [_collectionViewCategory setShowsHorizontalScrollIndicator:NO];
    [_collectionViewCategory setPagingEnabled:YES];
    [_collectionViewCategory setTag:ViewTagCollectionViewMainCategory];
    
    [_tableViewSubcategory setBackgroundColor:[UIColor colorWithWhite:(245.0/255.0) alpha:1.0]];
    [_tableViewSubcategory setSeparatorColor:[UIColor colorWithWhite:(232.0/255.0) alpha:1.0]];
    [_tableViewSubcategory setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableViewSubcategory setShowsVerticalScrollIndicator:NO];
    [_tableViewSubcategory setShowsHorizontalScrollIndicator:NO];
    [_tableViewSubcategory registerClass:[SubcategoryTableViewCell class] forCellReuseIdentifier:SubcategoryTableViewCellIdentifier];
    [_tableViewSubcategory registerClass:[LoadingFooterView class] forHeaderFooterViewReuseIdentifier:LoadingFooterViewIdentifier];
    [_tableViewSubcategory setTag:ViewTagTableViewSubcategory];
    
    [_tableViewExtraSubcategory setBackgroundColor:[UIColor colorWithWhite:(194.0/255.0) alpha:1.0]];
    [_tableViewExtraSubcategory setSeparatorColor:[UIColor colorWithWhite:(163.0/255.0) alpha:1.0]];
    [_tableViewExtraSubcategory setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableViewExtraSubcategory setShowsVerticalScrollIndicator:NO];
    [_tableViewExtraSubcategory setShowsHorizontalScrollIndicator:NO];
    [_tableViewExtraSubcategory registerClass:[ExtraSubcategoryTableViewCell class] forCellReuseIdentifier:ExtraSubcategoryTableViewCellIdentifier];
    [_tableViewExtraSubcategory registerClass:[ExtraSubcategorySeeAllTableViewCell class] forCellReuseIdentifier:ExtraSubcategorySeeAllTableViewCellIdentifier];
    [_tableViewExtraSubcategory registerClass:[LoadingFooterView class] forHeaderFooterViewReuseIdentifier:LoadingFooterViewIdentifier];
    [_tableViewExtraSubcategory setTag:ViewTagTableViewExtraSubcategory];
    
    [self.view addSubview:self.imageViewLeftArrow];
    [self.view addSubview:self.imageViewRightArrow];
    self.imageViewLeftArrow.hidden = YES;
    self.imageViewRightArrow.hidden = YES;
    
    [self retrieveMainCategoryData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Should clear the product filter to prevent wrong filter options
    if ([[TMInfoManager sharedManager].dictionaryInitialFilter count] > 0)
    {
        [[TMInfoManager sharedManager].dictionaryInitialFilter removeAllObjects];
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
    
    CGFloat marginH = 5.0;
    if (self.imageViewLeftArrow)
    {
        CGSize size = self.imageViewLeftArrow.image.size;
        CGRect frame = CGRectMake(marginH, self.collectionViewCategory.frame.origin.y + (self.collectionViewCategory.frame.size.height - size.height)/2, size.width, size.height);
        self.imageViewLeftArrow.frame = frame;
    }
    if (self.imageViewRightArrow)
    {
        CGSize size = self.imageViewRightArrow.image.size;
        CGRect frame = CGRectMake(self.view.frame.size.width - size.width - marginH, self.collectionViewCategory.frame.origin.y + (self.collectionViewCategory.frame.size.height - size.height)/2, size.width, size.height);
        self.imageViewRightArrow.frame = frame;
    }
}

- (UIImageView *)imageViewLeftArrow
{
    if (_imageViewLeftArrow == nil)
    {
        _imageViewLeftArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"ico_menu_arrow_l"];
        if (image)
        {
            [_imageViewLeftArrow setImage:image];
        }
    }
    return _imageViewLeftArrow;
}

- (UIImageView *)imageViewRightArrow
{
    if (_imageViewRightArrow == nil)
    {
        _imageViewRightArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"ico_menu_arrow_r"];
        if (image)
        {
            [_imageViewRightArrow setImage:image];
        }
    }
    return _imageViewRightArrow;
}

#pragma mark - Private Methods

- (void)retrieveMainCategoryData
{
    // Check local cache first.
//    NSArray *categories = [[TMInfoManager sharedManager] subcategoriesForIdentifier:nil atLayer:[NSNumber numberWithInteger:0]];
//    if (categories)
//    {
//        [self setMainCategoryFromCategories:categories];
//        return;
//    }
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    if (apiKey == nil || token == nil)
    {
        return;
    }
    __weak ShoppingMallViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_MainCategories];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_04", SymphoxAPIParam_txid, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
//            NSLog(@"resultObject:\n%@", [resultObject description]);
//            NSString *resultString = [[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding];
//            NSLog(@"retrieveMainCategoryData - resultString:\n%@", resultString);
            if ([self processMainCategoryData:resultObject] == NO)
            {
                NSLog(@"Cannot process retrieved data from [%@]", [url absoluteString]);
            }
        }
        else
        {
            NSLog(@"error:\n%@", error);
        }
        
    }];
}

- (BOOL)processMainCategoryData:(id)data
{
    BOOL canProcess = NO;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error == nil)
    {
        //        NSLog(@"jsonObject[%@]:\n%@", [[jsonObject class] description], [jsonObject description]);
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
            if ([result integerValue] == 0)
            {
                // Normal status.
                NSArray *categories = [dictionary objectForKey:SymphoxAPIParam_mallHall];
                if (categories && [categories count] > 0)
                {
                    [self setMainCategoryFromCategories:categories];
                    [[TMInfoManager sharedManager] setSubcategories:_arrayMainCategory forIdentifier:nil atLayer:[NSNumber numberWithInteger:0]];
                }
                canProcess = YES;
            }
        }
    }
    else
    {
        NSLog(@"processData - error:\n%@", error);
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"processData - result:\n%@", resultString);
    }
    return canProcess;
}

- (void)setMainCategoryFromCategories:(NSArray *)categories
{
    [_arrayMainCategory setArray:categories];
    [_collectionViewCategory reloadData];
//    NSLog(@"contentWidth[%4.2f] frame.width[%4.2f]", self.collectionViewCategory.contentSize.width, self.collectionViewCategory.frame.size.width);
    if (self.collectionViewCategory.contentSize.width <= self.collectionViewCategory.frame.size.width)
    {
        self.imageViewRightArrow.hidden = YES;
        self.imageViewLeftArrow.hidden = YES;
    }
    else
    {
        self.imageViewRightArrow.hidden = NO;
        self.imageViewLeftArrow.hidden = YES;
    }
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionViewCategory selectItemAtIndexPath:firstIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    });
    [self collectionView:_collectionViewCategory didSelectItemAtIndexPath:firstIndexPath];
}

- (void)retrieveSubcategoryDataForIdentifier:(NSString *)identifier andLayer:(NSNumber *)layer
{
    [self clearSubcategoryTableViewForLayer:layer];
    NSArray *categories = [[TMInfoManager sharedManager] subcategoriesForIdentifier:identifier atLayer:layer];
    NSInteger layerIndex = [layer integerValue];
    if (categories)
    {
        [self setSubcategoryFromCategories:categories forIdentifier:identifier andLayerIndex:layerIndex];
        return;
    }
    if (identifier == nil || layer == nil)
        return;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:identifier, SymphoxAPIParam_hall_id, layer, SymphoxAPIParam_layer, nil];
    
    __weak ShoppingMallViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_Subcategories];
//    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
//                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"retrieveSubcategoryDataForIdentifier[%@] - string[%@]", identifier, string);
                
                if ([weakSelf processSubcategoryData:data forIdentifier:identifier forLayerIndex:layerIndex] == NO)
                {
                    NSLog(@"retrieveSubcategoryDataForIdentifier - Cannot process data.");
                }
            }
            else
            {
                NSLog(@"retrieveSubcategoryDataForIdentifier - Unexpected data format.");
            }
        }
        else
        {
            NSLog(@"retrieveSubcategoryDataForIdentifier - error:\n%@", [error description]);
        }
    }];
}

- (BOOL)processSubcategoryData:(id)data forIdentifier:(NSString *)identifier forLayerIndex:(NSInteger)layerIndex
{
//    NSLog(@"processSubcategoryData - layerIndex[%li]", (long)layerIndex);
    BOOL canProcess = NO;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error == nil)
    {
//        NSLog(@"jsonObject[%@]:\n%@", [[jsonObject class] description], [jsonObject description]);
        if ([jsonObject isKindOfClass:[NSArray class]])
        {
            NSArray *categories = (NSArray *)jsonObject;
            // Normal status.
            [self setSubcategoryFromCategories:categories forIdentifier:identifier andLayerIndex:layerIndex];
            [[TMInfoManager sharedManager] setSubcategories:categories forIdentifier:identifier atLayer:[NSNumber numberWithInteger:layerIndex]];
            canProcess = YES;
        }
    }
    else
    {
        NSLog(@"processData - error:\n%@", error);
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"processData - result:\n%@", resultString);
    }
    return canProcess;
}

- (void)setSubcategoryFromCategories:(NSArray *)categories forIdentifier:(NSString *)identifier andLayerIndex:(NSInteger)layerIndex
{
    UITableView *targetTableView = nil;
    NSArray *targetArray = nil;
    NSIndexPath *firstIndexPath = nil;
    BOOL shouldReload = NO;
    switch (layerIndex) {
        case 1:
        {
            if (_selectedMainCategoryIndex >= [_arrayMainCategory count])
                break;
            NSDictionary *dictionary = [_arrayMainCategory objectAtIndex:_selectedMainCategoryIndex];
            NSString *hallId = [dictionary objectForKey:SymphoxAPIParam_hall_id];
            if (hallId == nil || ([hallId isEqualToString:identifier] == NO))
                break;
            
            [_arraySubcategory setArray:categories];
            
            targetTableView = _tableViewSubcategory;
            targetArray = _arraySubcategory;
            
            if ([targetArray count] > 0)
            {
                firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }
            shouldReload = YES;
        }
            break;
        case 2:
        {
            if (_selectedSubcategoryIndex >= [_arraySubcategory count])
                break;
            NSDictionary *dictionary = [_arraySubcategory objectAtIndex:_selectedSubcategoryIndex];
            NSString *hallId = [dictionary objectForKey:SymphoxAPIParam_hall_id];
            if (hallId == nil || ([hallId isEqualToString:identifier] == NO))
                break;
            
            [_arrayExtraSubcategory setArray:categories];
            
            targetTableView = _tableViewExtraSubcategory;
            targetArray = _arrayExtraSubcategory;
            shouldReload = YES;
        }
            break;
        default:
            break;
    }
    
    if (shouldReload && targetTableView)
    {
        __weak ShoppingMallViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [targetTableView reloadData];
            if (firstIndexPath)
            {
                [targetTableView selectRowAtIndexPath:firstIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                [weakSelf tableView:targetTableView didSelectRowAtIndexPath:firstIndexPath];
            }
        });
    }
}

- (void)presentProductListViewForIdentifier:(NSString *)identifier named:(NSString *)name andLayer:(NSNumber *)layer withCategories:(NSArray *)categories andSubcategories:(NSArray *)subcategories
{
    if (identifier == nil || layer == nil)
        return;
    
    ProductListViewController *viewController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:[NSBundle mainBundle]];
    viewController.hallId = identifier;
    viewController.layer = layer;
    viewController.name = name;
    viewController.arrayCategory = categories;
    viewController.arraySubcategory = subcategories;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)clearSubcategoryTableViewForLayer:(NSNumber *)layer
{
    NSInteger layerIndex = [layer integerValue];
    switch (layerIndex) {
        case 1:
        {
            [self.arraySubcategory removeAllObjects];
            [self.tableViewSubcategory reloadData];
            [self.arrayExtraSubcategory removeAllObjects];
            [self.tableViewExtraSubcategory reloadData];
        }
            break;
        case 2:
        {
            [self.arrayExtraSubcategory removeAllObjects];
            [self.tableViewExtraSubcategory reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Public Methods

- (void)presentProductListViewForIdentifier:(NSString *)identifier named:(NSString *)name andLayer:(NSNumber *)layer
{
    [self presentProductListViewForIdentifier:identifier named:name andLayer:layer withCategories:nil andSubcategories:nil];
}

#pragma mark - Actions

- (void)buttonItemSearchPressed:(id)sender
{
    SearchViewController *viewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Notification Handler

- (void)notificationHandlerTokenUpdated:(NSNotification *)notification
{
    if ([_arrayMainCategory count] == 0)
    {
        [self retrieveMainCategoryData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = [_arrayMainCategory count];
    return numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainCategoryCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    if (indexPath.row < [_arrayMainCategory count])
    {
        NSDictionary *dictionary = [_arrayMainCategory objectAtIndex:indexPath.row];
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        NSString *imagePath = [dictionary objectForKey:SymphoxAPIParam_img];
//        NSLog(@"cell[%li/%li][%@][%@]", (long)indexPath.section, (long)indexPath.row, name, imagePath);
        if (name)
        {
            cell.textLabel.text = name;
        }
        if (imagePath)
        {
            NSURL *url = [NSURL URLWithString:imagePath];
            UIImage *placeHolder = [UIImage imageNamed:@"transparent"];
            [cell.imageView sd_setImageWithURL:url placeholderImage:placeHolder options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
                
            }];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [_arrayMainCategory count] || indexPath.row < 0)
        return;
    _selectedMainCategoryIndex = indexPath.row;
    
    // Should update subcategory.
    NSDictionary *dictionary = [_arrayMainCategory objectAtIndex:_selectedMainCategoryIndex];
    NSString *identifier = [dictionary objectForKey:SymphoxAPIParam_hall_id];
    if (identifier == nil)
        return;
    [self retrieveSubcategoryDataForIdentifier:identifier andLayer:[NSNumber numberWithInteger:1]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(collectionView.frame.size.width / 4, collectionView.frame.size.height / 2);
    return itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 2;
    switch (tableView.tag) {
        case ViewTagTableViewExtraSubcategory:
        {
            numberOfSections = 3;
        }
            break;
            
        default:
            break;
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (tableView.tag) {
        case ViewTagTableViewSubcategory:
        {
            if (section == 0)
            {
                numberOfRows = [_arraySubcategory count];
//                NSLog(@"numberOfRows - subcategory[%li]:\n%@", (unsigned long)[self.arraySubcategory count], [self.arraySubcategory description]);
            }
        }
            break;
        case ViewTagTableViewExtraSubcategory:
        {
            if (section == 0)
            {
                if ([self.arrayExtraSubcategory count] > 0)
                {
                    numberOfRows = 1;
                }
            }
            else if (section == 1)
            {
                numberOfRows = [_arrayExtraSubcategory count];
            }
        }
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *cellIdentifier = nil;
    NSArray *dataArray = nil;
    switch (tableView.tag) {
        case ViewTagTableViewSubcategory:
        {
            cellIdentifier = SubcategoryTableViewCellIdentifier;
            dataArray = _arraySubcategory;
        }
            break;
        case ViewTagTableViewExtraSubcategory:
        {
            if (indexPath.section == 0)
            {
                cellIdentifier = ExtraSubcategorySeeAllTableViewCellIdentifier;
                dataArray = _arrayExtraSubcategorySeeAll;
            }
            else
            {
                cellIdentifier = ExtraSubcategoryTableViewCellIdentifier;
                dataArray = _arrayExtraSubcategory;
            }
        }
            break;
        default:
            break;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setPreservesSuperviewLayoutMargins:NO];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if (indexPath.row < [dataArray count])
    {
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.row];
//        NSLog(@"cellForRowAtIndexPath : \n%@", [dictionary description]);
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        if (name)
        {
            cell.textLabel.text = name;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LoadingFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LoadingFooterViewIdentifier];
    return footerView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForFooter = 0.0;
    switch (tableView.tag) {
        case ViewTagTableViewSubcategory:
        {
            if (section == 1 && [self.arraySubcategory count] == 0)
            {
                heightForFooter = 40.0;
            }
        }
            break;
        case ViewTagTableViewExtraSubcategory:
        {
            if (section == 2 && [self.arrayExtraSubcategory count] == 0)
            {
                heightForFooter = 40.0;
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
    switch (tableView.tag) {
        case ViewTagTableViewSubcategory:
        {
            if (indexPath.row >= [_arraySubcategory count] || indexPath.row < 0)
                return;
            _selectedSubcategoryIndex = indexPath.row;
            NSDictionary *dictionary = [_arraySubcategory objectAtIndex:_selectedSubcategoryIndex];
            NSString *identifier = [dictionary objectForKey:SymphoxAPIParam_hall_id];
            NSNumber *layer = [dictionary objectForKey:SymphoxAPIParam_layer];
            
            // Prepare see all cell data
            NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
            NSString *totalTitle = [NSString stringWithFormat:[LocalizedString See_S_All], (name == nil)?@"":name];
            NSDictionary *dictionarySeeAll = [NSDictionary dictionaryWithObjectsAndKeys:identifier, SymphoxAPIParam_hall_id, layer, SymphoxAPIParam_layer, totalTitle, SymphoxAPIParam_name, name, SymphoxAPIParam_originName, nil];
            [_arrayExtraSubcategorySeeAll removeAllObjects];
            [_arrayExtraSubcategorySeeAll addObject:dictionarySeeAll];
            
            if (identifier && layer)
            {
                [self retrieveSubcategoryDataForIdentifier:identifier andLayer:layer];
            }
        }
            break;
        case ViewTagTableViewExtraSubcategory:
        {
            NSArray *array = nil;
            if (indexPath.section == 0)
            {
                array = _arrayExtraSubcategorySeeAll;
            }
            else if (indexPath.section == 1)
            {
                array = _arrayExtraSubcategory;
            }
            if (indexPath.row >= [array count])
                break;
            NSDictionary *dictionary = [array objectAtIndex:indexPath.row];
            NSString *hallId = [dictionary objectForKey:SymphoxAPIParam_hall_id];
            NSNumber *layer = [dictionary objectForKey:SymphoxAPIParam_layer];
            NSString *originName = [dictionary objectForKey:SymphoxAPIParam_originName];
            NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
            NSString *showName = (originName == nil)?name:originName;
            NSArray *categories = nil;
            NSArray *subcategories = nil;
            if ([layer integerValue] == 2)
            {
                categories = _arraySubcategory;
                subcategories = _arrayExtraSubcategory;
            }
            else if ([layer integerValue] == 3)
            {
                categories = _arrayExtraSubcategory;
            }
            [self presentProductListViewForIdentifier:hallId named:showName andLayer:layer withCategories:categories andSubcategories:subcategories];
        }
            break;
        default:
            break;
    }
}

#pragma mark - SearchViewControllerDelegate

- (void)searchViewController:(SearchViewController *)viewController didSelectToSearchKeyword:(NSString *)keyword
{
    NSLog(@"Should start search by keyword \"%@\"", keyword);
    ProductListViewController *listViewController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:[NSBundle mainBundle]];
    listViewController.isSearchResult = YES;
    [listViewController addKeywordToConditions:keyword];
    listViewController.hallId = nil;
    listViewController.layer = nil;
    listViewController.name = nil;
    [self.navigationController pushViewController:listViewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == self.collectionViewCategory)
    {
        if (targetContentOffset->x > 0.0)
        {
            self.imageViewLeftArrow.hidden = NO;
        }
        else
        {
            self.imageViewLeftArrow.hidden = YES;
        }
        if (targetContentOffset->x + scrollView.frame.size.width < scrollView.contentSize.width)
        {
            self.imageViewRightArrow.hidden = NO;
        }
        else
        {
            self.imageViewRightArrow.hidden = YES;
        }
    }
}

@end
