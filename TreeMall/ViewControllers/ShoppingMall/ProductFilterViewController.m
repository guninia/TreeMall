//
//  ProductFilterViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductFilterViewController.h"
#import "LocalizedString.h"
#import "TMInfoManager.h"
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "ProductFilterTextCollectionViewCell.h"

typedef enum : NSUInteger {
    CollectionViewTagCategory,
    CollectionViewTagCoupon,
    CollectionViewTagDeliverType,
    CollectionViewTagTotal
} CollectionViewTag;

@interface ProductFilterViewController ()

- (void)prepareOptionsDefaultFromDictionary:(NSDictionary *)defaultDictionary;
- (void)retrieveMainCategoryNameMapping;
- (BOOL)processMainCategoryNameMappingData:(id)data;

- (void)dismiss;
- (void)buttonItemClosePressed:(id)sender;

@end

@implementation ProductFilterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _arrayCoupon = [[NSMutableArray alloc] initWithCapacity:0];
        _deliverType = DeliverTypeTotal;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString AdvanceFilter];
    
    UIImage *imageClose = [UIImage imageNamed:@"sho_h_btn_back"];
    if (imageClose)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageClose style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemClosePressed:)];
    }
    
    [self.view addSubview:self.collectionViewCategory];
    [self.view addSubview:self.sliderPrice];
    [self.view addSubview:self.sliderPoint];
    [self.view addSubview:self.collectionViewCoupon];
    [self.view addSubview:self.collectionViewDeliverType];
    
    // Prepare options
    [self prepareOptionsDefaultFromDictionary:[TMInfoManager sharedManager].dictionaryInitialFilter];
    
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

- (UICollectionView *)collectionViewCategory
{
    if (_collectionViewCategory == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewCategory = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionViewCategory.tag = CollectionViewTagCategory;
        [_collectionViewCategory registerClass:[ProductFilterTextCollectionViewCell class] forCellWithReuseIdentifier:ProductFilterTextCollectionViewCellIdentifier];
    }
    return _collectionViewCategory;
}

- (UICollectionView *)collectionViewCoupon
{
    if (_collectionViewCoupon == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewCoupon = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionViewCoupon.tag = CollectionViewTagCoupon;
        [_collectionViewCoupon registerClass:[ProductFilterTextCollectionViewCell class] forCellWithReuseIdentifier:ProductFilterTextCollectionViewCellIdentifier];
    }
    return _collectionViewCoupon;
}

- (UICollectionView *)collectionViewDeliverType
{
    if (_collectionViewDeliverType == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewDeliverType = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionViewDeliverType.tag = CollectionViewTagDeliverType;
        [_collectionViewDeliverType registerClass:[ProductFilterTextCollectionViewCell class] forCellWithReuseIdentifier:ProductFilterTextCollectionViewCellIdentifier];
    }
    return _collectionViewDeliverType;
}

#pragma mark - Private Methods

- (void)prepareOptionsDefaultFromDictionary:(NSDictionary *)defaultDictionary
{
    NSArray *arrayCategory = [defaultDictionary objectForKey:SymphoxAPIParam_categoryLv1];
    if (arrayCategory)
    {
        self.arrayCategoryDefault = arrayCategory;
        if ([[TMInfoManager sharedManager].dictionaryMainCategoryNameMapping count] == 0)
        {
            [self retrieveMainCategoryNameMapping];
        }
    }
    
    NSNumber *numberMinPrice = [defaultDictionary objectForKey:SymphoxAPIParam_min_price];
    if (numberMinPrice)
    {
        self.numberMinPriceDefault = numberMinPrice;
    }
    
    NSNumber *numberMaxPrice = [defaultDictionary objectForKey:SymphoxAPIParam_max_price];
    if (numberMaxPrice)
    {
        self.numberMaxPriceDefault = numberMaxPrice;
    }
    
    NSNumber *numberMinPoint = [defaultDictionary objectForKey:SymphoxAPIParam_min_point];
    if (numberMinPoint)
    {
        self.numberMinPointDefault = numberMinPoint;
    }
    
    NSNumber *numberMaxPoint = [defaultDictionary objectForKey:SymphoxAPIParam_max_point];
    if (numberMaxPoint)
    {
        self.numberMaxPriceDefault = numberMaxPoint;
    }
    
    
}

- (void)retrieveMainCategoryNameMapping
{
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    if (apiKey == nil || token == nil)
    {
        return;
    }
    __weak ProductFilterViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_homepage];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_05", SymphoxAPIParam_txid, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            if ([self processMainCategoryNameMappingData:resultObject])
            {
                [self.collectionViewCategory reloadData];
                
            }
            else
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
    }
}

#pragma mark - Actions

- (void)buttonItemClosePressed:(id)sender
{
    [self dismiss];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = 0;
    switch (collectionView.tag) {
        case CollectionViewTagCategory:
        {
            numberOfItems = [self.arrayCategoryDefault count];
        }
            break;
        case CollectionViewTagCoupon:
        {
            numberOfItems = [self.arrayCoupon count];
        }
            break;
        case CollectionViewTagDeliverType:
        {
            numberOfItems = DeliverTypeTotal;
        }
            break;
        default:
            break;
    }
    return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductFilterTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductFilterTextCollectionViewCellIdentifier forIndexPath:indexPath];
    switch (collectionView.tag) {
        case CollectionViewTagCategory:
        {
            
        }
            break;
        case CollectionViewTagCoupon:
        {
            
        }
            break;
        case CollectionViewTagDeliverType:
        {
            
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UICollecitonViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    switch (collectionView.tag) {
        case CollectionViewTagCategory:
        {
            
        }
            break;
        case CollectionViewTagCoupon:
        {
            
        }
            break;
        case CollectionViewTagDeliverType:
        {
            
        }
            break;
        default:
            break;
    }
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

@end
