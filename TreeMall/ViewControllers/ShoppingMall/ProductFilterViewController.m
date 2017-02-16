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

static CGFloat kMarginTop = 10.0;
static CGFloat kMarginBot = 10.0;
static CGFloat kMarginLeft = 10.0;
static CGFloat kMarginRight = 10.0;
static CGFloat kIntervalV = 10.0;
static CGFloat kIntervalH = 10.0;

static NSInteger columnsPerRowForCategory = 2;
static NSInteger columnsPerRowForCoupon = 3;
static NSInteger columnsPerRowForDeliverType = 3;

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
- (void)resetAllSettings;
- (void)buildConditionsAndApply;

- (void)dismiss;
- (void)buttonItemClosePressed:(id)sender;
- (void)buttonResetPressed:(id)sender;
- (void)buttonConfirmPressed:(id)sender;

@end

@implementation ProductFilterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _arrayCoupon = [[NSMutableArray alloc] initWithCapacity:0];
        _deliverType = DeliverTypeTotal;
        _arrayDeliverType = [[NSMutableArray alloc] initWithCapacity:0];
        _selectIndexForCategory = NSNotFound;
        _selectIndexForCoupon = NSNotFound;
        _selectIndexForDeliverType = NSNotFound;
        _selectedRangeForPrice = NSMakeRange(0, 0);
        _selectedRangeForPoint = NSMakeRange(0, 0);
        // Prepare options
        [self prepareOptionsDefaultFromDictionary:[TMInfoManager sharedManager].dictionaryInitialFilter];
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
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.labelCategory];
    [self.scrollView addSubview:self.collectionViewCategory];
    [self.scrollView addSubview:self.labelPriceRange];
    [self.scrollView addSubview:self.sliderViewPrice];
    [self.scrollView addSubview:self.labelPointRange];
    [self.scrollView addSubview:self.sliderViewPoint];
    [self.scrollView addSubview:self.labelCoupon];
    [self.scrollView addSubview:self.collectionViewCoupon];
    [self.scrollView addSubview:self.labelDeliverType];
    [self.scrollView addSubview:self.collectionViewDeliverType];
    [self.view addSubview:self.buttonReset];
    [self.view addSubview:self.buttonConfirm];
    
    [self.collectionViewCategory reloadData];
    [self.collectionViewCoupon reloadData];
    [self.collectionViewDeliverType reloadData];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if (self.sliderViewPrice)
    {
        NSNumber *numberMinPrice = nil;
        if (self.numberMinPriceDefault)
        {
            numberMinPrice = self.numberMinPriceDefault;
        }
        else
        {
            numberMinPrice = [NSNumber numberWithInteger:0];
        }
        if (numberMinPrice)
        {
            NSString *formattedString = [formatter stringFromNumber:numberMinPrice];
            self.sliderViewPrice.textLowerBoundary = formattedString;
            self.sliderViewPrice.slider.minimumValue = [numberMinPrice floatValue];
            self.sliderViewPrice.slider.lowerValue = [numberMinPrice floatValue];
        }
        
        NSNumber *numberMaxPrice = nil;
        if (self.numberMaxPriceDefault)
        {
            if ([self.numberMinPriceDefault integerValue] == [self.numberMaxPriceDefault integerValue])
            {
                numberMaxPrice = [NSNumber numberWithInteger:([self.numberMaxPriceDefault integerValue] + 1)];
            }
            else
            {
                numberMaxPrice = self.numberMaxPriceDefault;
            }
            
            [self.sliderViewPrice setHidden:NO];
            [self.labelPriceRange setHidden:NO];
        }
        else
        {
            numberMaxPrice = [NSNumber numberWithInteger:0];
            
            [self.sliderViewPrice setHidden:YES];
            [self.labelPriceRange setHidden:YES];
        }
        if (numberMaxPrice)
        {
            NSString *formattedString = [formatter stringFromNumber:numberMaxPrice];
            self.sliderViewPrice.textHigherBoundary = formattedString;
            self.sliderViewPrice.slider.maximumValue = [numberMaxPrice floatValue];
            self.sliderViewPrice.slider.upperValue = [numberMaxPrice floatValue];
        }
        
        if ([self.numberMinPriceDefault integerValue] == [self.numberMaxPriceDefault integerValue])
        {
            [self.sliderViewPrice setHidden:YES];
            [self.labelPriceRange setHidden:YES];
        }
    }
    if (self.sliderViewPoint)
    {
        NSNumber *numberMinPoint = nil;
        if (self.numberMinPointDefault)
        {
            numberMinPoint = self.numberMinPointDefault;
        }
        else
        {
            numberMinPoint = [NSNumber numberWithInteger:0];
        }
        NSString *formattedString = [formatter stringFromNumber:numberMinPoint];
        self.sliderViewPrice.textLowerBoundary = formattedString;
        self.sliderViewPrice.slider.minimumValue = [numberMinPoint floatValue];
        self.sliderViewPrice.slider.lowerValue = [numberMinPoint floatValue];
        
        NSNumber *numberMaxPoint = nil;
        if (self.numberMaxPointDefault)
        {
            if ([self.numberMinPointDefault integerValue] == [self.numberMaxPointDefault integerValue])
            {
                numberMaxPoint = [NSNumber numberWithInteger:([self.numberMaxPointDefault integerValue] + 1)];
            }
            else
            {
                numberMaxPoint = self.numberMaxPointDefault;
            }
            
            [self.sliderViewPoint setHidden:NO];
            [self.labelPointRange setHidden:NO];
        }
        else
        {
            numberMaxPoint = [NSNumber numberWithInteger:0];
            
            [self.sliderViewPoint setHidden:YES];
            [self.labelPointRange setHidden:YES];
        }
        if (numberMaxPoint)
        {
            NSString *formattedString = [formatter stringFromNumber:numberMaxPoint];
            self.sliderViewPoint.textHigherBoundary = formattedString;
            self.sliderViewPoint.slider.maximumValue = [numberMaxPoint floatValue];
            self.sliderViewPoint.slider.upperValue = [numberMaxPoint floatValue];
        }
        if ([self.numberMinPointDefault integerValue] == [self.numberMaxPointDefault integerValue])
        {
            [self.sliderViewPoint setHidden:YES];
            [self.labelPointRange setHidden:YES];
        }
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
    
    CGFloat viewWidth = self.view.frame.size.width - (kMarginLeft + kMarginRight);
    
    CGFloat buttonWidth = (viewWidth - kIntervalH)/2;
    CGFloat buttonHeight = 40.0;
    CGFloat originX = self.view.frame.size.width - kMarginRight - buttonWidth;
    CGFloat originY = self.view.frame.size.height - kMarginBot - buttonHeight;
    if (self.buttonConfirm && [self.buttonConfirm isHidden] == NO)
    {
        CGRect frame = CGRectMake(originX, originY, buttonWidth, buttonHeight);
        self.buttonConfirm.frame = frame;
        originX = self.buttonConfirm.frame.origin.x - kIntervalV - buttonWidth;
    }
    if (self.buttonReset && [self.buttonReset isHidden] == NO)
    {
        CGRect frame = CGRectMake(originX, originY, buttonWidth, buttonHeight);
        self.buttonReset.frame = frame;
        originX = self.buttonReset.frame.origin.x - kIntervalV - buttonWidth;
    }
    originY -= kIntervalV;
    
    if (self.scrollView)
    {
        self.scrollView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, originY);
    }
    
    originX = kMarginLeft;
    originY = kMarginTop;
    
    
    if (self.labelCategory && [self.labelCategory isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelCategory.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelCategory.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, sizeLabel.width, sizeLabel.height);
        self.labelCategory.frame = frame;
        originY = self.labelCategory.frame.origin.y + self.labelCategory.frame.size.height + kIntervalV;
    }

    if (self.collectionViewCategory && [self.collectionViewCategory isHidden] == NO)
    {
        NSInteger totalCount = [self.arrayCategoryDefault count];
        NSInteger totalRow = (totalCount / columnsPerRowForCategory) + (((totalCount % columnsPerRowForCategory) > 0)?1:0);
        CGFloat heightPerRow = [self collectionView:self.collectionViewCategory layout:self.collectionViewCategory.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].height;
        CGFloat heightPerLineSpacing = [self collectionView:self.collectionViewCategory layout:self.collectionViewCategory.collectionViewLayout minimumLineSpacingForSectionAtIndex:0];
        CGFloat viewHeight = totalRow * heightPerRow + (totalRow - 1) * heightPerLineSpacing;
        CGRect frame = CGRectMake(originX, originY, viewWidth, viewHeight);
        self.collectionViewCategory.frame = frame;
        originY = self.collectionViewCategory.frame.origin.y + self.collectionViewCategory.frame.size.height + kIntervalV;
    }

    if (self.labelPriceRange && [self.labelPriceRange isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelPriceRange.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelPriceRange.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, sizeLabel.width, sizeLabel.height);
        self.labelPriceRange.frame = frame;
        originY = self.labelPriceRange.frame.origin.y + self.labelPriceRange.frame.size.height + kIntervalV;
    }
    NSLog(@"self.sliderViewPrice[%@]", [self.sliderViewPrice isHidden]?@"Hidden":@"Shown");
    if (self.sliderViewPrice && [self.sliderViewPrice isHidden] == NO)
    {
        CGRect frame = CGRectMake(originX, originY, viewWidth, 70.0);
        self.sliderViewPrice.frame = frame;
        originY = self.sliderViewPrice.frame.origin.y + self.sliderViewPrice.frame.size.height + kIntervalV;
    }

    if (self.labelPointRange && [self.labelPointRange isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelPointRange.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelPointRange.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, sizeLabel.width, sizeLabel.height);
        self.labelPointRange.frame = frame;
        originY = self.labelPointRange.frame.origin.y + self.labelPointRange.frame.size.height + kIntervalV;
    }
    
    if (self.sliderViewPoint && [self.sliderViewPoint isHidden] == NO)
    {
        CGRect frame = CGRectMake(originX, originY, viewWidth, 70.0);
        self.sliderViewPoint.frame = frame;
        originY = self.sliderViewPoint.frame.origin.y + self.sliderViewPoint.frame.size.height + kIntervalV;
    }
    
    if (self.labelCoupon && [self.labelCoupon isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelCoupon.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelCoupon.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, sizeLabel.width, sizeLabel.height);
        self.labelCoupon.frame = frame;
        originY = self.labelCoupon.frame.origin.y + self.labelCoupon.frame.size.height + kIntervalV;
    }
    
    if (self.collectionViewCoupon && [self.collectionViewCoupon isHidden] == NO)
    {
        NSInteger totalCount = [self.arrayCoupon count];
        NSInteger totalRow = (totalCount / columnsPerRowForCoupon) + (((totalCount % columnsPerRowForCoupon) > 0)?1:0);
        CGFloat heightPerRow = [self collectionView:self.collectionViewCoupon layout:self.collectionViewCoupon.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].height;
        CGFloat heightPerLineSpacing = [self collectionView:self.collectionViewCoupon layout:self.collectionViewCoupon.collectionViewLayout minimumLineSpacingForSectionAtIndex:0];
        CGFloat viewHeight = totalRow * heightPerRow + (totalRow - 1) * heightPerLineSpacing;
        CGRect frame = CGRectMake(originX, originY, viewWidth, viewHeight);
        self.collectionViewCoupon.frame = frame;
        originY = self.collectionViewCoupon.frame.origin.y + self.collectionViewCoupon.frame.size.height + kIntervalV;
    }
    
    if (self.labelDeliverType && [self.labelDeliverType isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelDeliverType.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelDeliverType.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, sizeLabel.width, sizeLabel.height);
        self.labelDeliverType.frame = frame;
        originY = self.labelDeliverType.frame.origin.y + self.labelDeliverType.frame.size.height + kIntervalV;
    }
    
    if (self.collectionViewDeliverType && [self.collectionViewDeliverType isHidden] == NO)
    {
        NSInteger totalCount = DeliverTypeTotal;
        NSInteger totalRow = (totalCount / columnsPerRowForDeliverType) + (((totalCount % columnsPerRowForDeliverType) > 0)?1:0);
        CGFloat heightPerRow = [self collectionView:self.collectionViewDeliverType layout:self.collectionViewDeliverType.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].height;
        CGFloat heightPerLineSpacing = [self collectionView:self.collectionViewDeliverType layout:self.collectionViewDeliverType.collectionViewLayout minimumLineSpacingForSectionAtIndex:0];
        CGFloat viewHeight = totalRow * heightPerRow + (totalRow - 1) * heightPerLineSpacing;
        CGRect frame = CGRectMake(originX, originY, viewWidth, viewHeight);
        self.collectionViewDeliverType.frame = frame;
        originY = self.collectionViewDeliverType.frame.origin.y + self.collectionViewDeliverType.frame.size.height + kIntervalV;
    }
    
    CGFloat scrollContentHeight = originY - kIntervalV + kMarginBot;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, scrollContentHeight)];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _scrollView;
}

- (UILabel *)labelCategory
{
    if (_labelCategory == nil)
    {
        _labelCategory = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelCategory setBackgroundColor:[UIColor clearColor]];
        [_labelCategory setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelCategory setFont:font];
        [_labelCategory setText:[LocalizedString Category]];
    }
    return _labelCategory;
}

- (UILabel *)labelPriceRange
{
    if (_labelPriceRange == nil)
    {
        _labelPriceRange = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPriceRange setBackgroundColor:[UIColor clearColor]];
        [_labelPriceRange setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelPriceRange setFont:font];
        [_labelPriceRange setText:[LocalizedString PriceRange]];
    }
    return _labelPriceRange;
}

- (UILabel *)labelPointRange
{
    if (_labelPointRange == nil)
    {
        _labelPointRange = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPointRange setBackgroundColor:[UIColor clearColor]];
        [_labelPointRange setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelPointRange setFont:font];
        [_labelPointRange setText:[LocalizedString PointRange]];
    }
    return _labelPointRange;
}

- (UILabel *)labelCoupon
{
    if (_labelCoupon == nil)
    {
        _labelCoupon = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelCoupon setBackgroundColor:[UIColor clearColor]];
        [_labelCoupon setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelCoupon setFont:font];
        [_labelCoupon setText:[LocalizedString Coupon]];
    }
    return _labelCoupon;
}

- (UILabel *)labelDeliverType
{
    if (_labelDeliverType == nil)
    {
        _labelDeliverType = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDeliverType setBackgroundColor:[UIColor clearColor]];
        [_labelDeliverType setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelDeliverType setFont:font];
        [_labelDeliverType setText:[LocalizedString DeliverType]];
    }
    return _labelDeliverType;
}

- (UICollectionView *)collectionViewCategory
{
    if (_collectionViewCategory == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewCategory = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionViewCategory setBackgroundColor:self.view.backgroundColor];
        _collectionViewCategory.tag = CollectionViewTagCategory;
        [_collectionViewCategory registerClass:[ProductFilterTextCollectionViewCell class] forCellWithReuseIdentifier:ProductFilterTextCollectionViewCellIdentifier];
        _collectionViewCategory.delegate = self;
        _collectionViewCategory.dataSource = self;
    }
    return _collectionViewCategory;
}

- (LabelRangeSliderView *)sliderViewPrice
{
    if (_sliderViewPrice == nil)
    {
        _sliderViewPrice = [[LabelRangeSliderView alloc] initWithFrame:CGRectZero];
        _sliderViewPrice.textPrefix = @"$";
    }
    return _sliderViewPrice;
}

- (LabelRangeSliderView *)sliderViewPoint
{
    if (_sliderViewPoint == nil)
    {
        _sliderViewPoint = [[LabelRangeSliderView alloc] initWithFrame:CGRectZero];
    }
    return _sliderViewPoint;
}

- (UICollectionView *)collectionViewCoupon
{
    if (_collectionViewCoupon == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewCoupon = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionViewCoupon setBackgroundColor:self.view.backgroundColor];
        _collectionViewCoupon.tag = CollectionViewTagCoupon;
        [_collectionViewCoupon registerClass:[ProductFilterTextCollectionViewCell class] forCellWithReuseIdentifier:ProductFilterTextCollectionViewCellIdentifier];
        _collectionViewCoupon.delegate = self;
        _collectionViewCoupon.dataSource = self;
    }
    return _collectionViewCoupon;
}

- (UICollectionView *)collectionViewDeliverType
{
    if (_collectionViewDeliverType == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewDeliverType = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionViewDeliverType setBackgroundColor:self.view.backgroundColor];
        _collectionViewDeliverType.tag = CollectionViewTagDeliverType;
        [_collectionViewDeliverType registerClass:[ProductFilterTextCollectionViewCell class] forCellWithReuseIdentifier:ProductFilterTextCollectionViewCellIdentifier];
        _collectionViewDeliverType.dataSource = self;
        _collectionViewDeliverType.delegate = self;
    }
    return _collectionViewDeliverType;
}

- (UIButton *)buttonReset
{
    if (_buttonReset == nil)
    {
        _buttonReset = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonReset setTitle:[LocalizedString Reset] forState:UIControlStateNormal];
        [_buttonReset setBackgroundColor:[UIColor clearColor]];
        [_buttonReset setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_buttonReset.layer setBorderColor:[_buttonReset titleColorForState:UIControlStateNormal].CGColor];
        [_buttonReset.layer setBorderWidth:1.0];
        [_buttonReset.layer setCornerRadius:3.0];
        [_buttonReset addTarget:self action:@selector(buttonResetPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonReset;
}

- (UIButton *)buttonConfirm
{
    if (_buttonConfirm == nil)
    {
        _buttonConfirm = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonConfirm setTitle:[LocalizedString Confirm] forState:UIControlStateNormal];
        [_buttonConfirm setBackgroundColor:[UIColor orangeColor]];
        [_buttonConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonConfirm.layer setCornerRadius:3.0];
        [_buttonConfirm addTarget:self action:@selector(buttonConfirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonConfirm;
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
//    NSLog(@"prepareOptionsDefaultFromDictionary - numberMaxPrice[%li]", [numberMaxPrice integerValue]);
    if (numberMaxPrice)
    {
        self.numberMaxPriceDefault = numberMaxPrice;
    }
//    NSLog(@"prepareOptionsDefaultFromDictionary - numberMaxPriceDefault[%li]", [self.numberMaxPriceDefault integerValue]);
    NSNumber *numberMinPoint = [defaultDictionary objectForKey:SymphoxAPIParam_min_point];
    if (numberMinPoint)
    {
        self.numberMinPointDefault = numberMinPoint;
    }
    
    NSNumber *numberMaxPoint = [defaultDictionary objectForKey:SymphoxAPIParam_max_point];
    if (numberMaxPoint)
    {
        self.numberMaxPointDefault = numberMaxPoint;
    }
    
    [_arrayCoupon addObject:[NSNumber numberWithInteger:60]];
    [_arrayCoupon addObject:[NSNumber numberWithInteger:100]];
    [_arrayCoupon addObject:[NSNumber numberWithInteger:200]];
    [_arrayCoupon addObject:[NSNumber numberWithInteger:300]];
    [_arrayCoupon addObject:[NSNumber numberWithInteger:500]];
    [_arrayCoupon addObject:[NSNumber numberWithInteger:1000]];
    [_arrayCoupon addObject:[NSNumber numberWithInteger:2000]];
    [_arrayCoupon addObject:[NSNumber numberWithInteger:3000]];
    
    for (NSInteger index = 0; index < DeliverTypeTotal; index++)
    {
        switch (index) {
            case DeliverTypeNoSpecific:
            {
                [_arrayDeliverType addObject:[LocalizedString NoSpecific]];
            }
                break;
            case DeliverTypeFast:
            {
                [_arrayDeliverType addObject:[LocalizedString Fast]];
            }
                break;
            case DeliverTypeConvenienceStore:
            {
                [_arrayDeliverType addObject:[LocalizedString ReceiveAtConvenientStore]];
            }
                break;
            default:
                break;
        }
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

- (BOOL)processMainCategoryNameMappingData:(id)data
{
    BOOL success = NO;
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"processMainCategoryNameMappingData -\n%@", string);
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
        if ([result integerValue] == 0)
        {
            // Success
            NSDictionary *nameMapping = [dictionary objectForKey:SymphoxAPIParam_hallMap];
            if (nameMapping)
            {
                [[TMInfoManager sharedManager].dictionaryMainCategoryNameMapping setDictionary:nameMapping];
                success = YES;
            }
        }
    }
    return success;
}

- (void)resetAllSettings
{
    self.selectIndexForCategory = NSNotFound;
    self.selectIndexForCoupon = NSNotFound;
    self.selectIndexForDeliverType = NSNotFound;
    
    [self.collectionViewCategory reloadData];
    [self.collectionViewCoupon reloadData];
    [self.collectionViewDeliverType reloadData];
    
    self.selectedRangeForPrice = NSMakeRange(0, 0);
    self.selectedRangeForPoint = NSMakeRange(0, 0);
    
    [self.sliderViewPrice reset];
    [self.sliderViewPoint reset];
}

- (void)buildConditionsAndApply
{
    NSMutableDictionary *conditions = [NSMutableDictionary dictionary];
    if (self.selectIndexForCategory != NSNotFound && self.selectIndexForCategory < [self.arrayCategoryDefault count])
    {
        NSDictionary *category = [self.arrayCategoryDefault objectAtIndex:self.selectIndexForCategory];
        NSString *hallId = [category objectForKey:SymphoxAPIParam_display_name];
        
        // According to design, this hallId would be the main category ID.
        [conditions setObject:hallId forKey:SymphoxAPIParam_cpse_id];
    }
    if (self.selectIndexForCoupon != NSNotFound && self.selectIndexForCategory < [self.arrayCoupon count])
    {
        NSNumber *coupon = [self.arrayCoupon objectAtIndex:self.selectIndexForCoupon];
        NSString *stringCoupon = [coupon stringValue];
        if (stringCoupon)
        {
            [conditions setObject:stringCoupon forKey:SymphoxAPIParam_ecoupon_type];
        }
    }
    if (self.selectIndexForDeliverType != NSNotFound && self.selectIndexForDeliverType < [self.arrayDeliverType count])
    {
        NSString *carrierType = nil;
        NSString *deliverStore = nil;
        switch (self.selectIndexForDeliverType) {
            case DeliverTypeFast:
            {
                carrierType = SymphoxAPIParamValue_Y;
            }
                break;
            case DeliverTypeConvenienceStore:
            {
                deliverStore = SymphoxAPIParamValue_Y;
            }
                break;
            default:
                break;
        }
        if (carrierType)
        {
            [conditions setObject:carrierType forKey:SymphoxAPIParam_carrier_type];
        }
        if (deliverStore)
        {
            [conditions setObject:deliverStore forKey:SymphoxAPIParam_delivery_store];
        }
    }
    if ([self.sliderViewPrice isHidden] == NO)
    {
        if (self.sliderViewPrice.slider.lowerValue != self.sliderViewPrice.slider.minimumValue)
        {
            NSNumber *number = [NSNumber numberWithFloat:self.sliderViewPrice.slider.lowerValue];
            NSString *string = [number stringValue];
            if (string)
            {
                [conditions setObject:string forKey:SymphoxAPIParam_price_from];
            }
        }
        if (self.sliderViewPrice.slider.upperValue != self.sliderViewPrice.slider.maximumValue)
        {
            NSNumber *number = [NSNumber numberWithFloat:self.sliderViewPrice.slider.upperValue];
            NSString *string = [number stringValue];
            if (string)
            {
                [conditions setObject:string forKey:SymphoxAPIParam_price_to];
            }
        }
    }
    if ([self.sliderViewPoint isHidden] == NO)
    {
        if (self.sliderViewPoint.slider.lowerValue != self.sliderViewPoint.slider.minimumValue)
        {
            NSNumber *number = [NSNumber numberWithFloat:self.sliderViewPoint.slider.lowerValue];
            NSString *string = [number stringValue];
            if (string)
            {
                [conditions setObject:string forKey:SymphoxAPIParam_point_from];
            }
        }
        if (self.sliderViewPoint.slider.upperValue != self.sliderViewPoint.slider.maximumValue)
        {
            NSNumber *number = [NSNumber numberWithFloat:self.sliderViewPoint.slider.upperValue];
            NSString *string = [number stringValue];
            if (string)
            {
                [conditions setObject:string forKey:SymphoxAPIParam_point_to];
            }
        }
    }
    NSLog(@"set conditions as follows:\n%@", [conditions description]);
    if (_delegate && [_delegate respondsToSelector:@selector(productFilterViewController:didSelectAdvancedConditions:)])
    {
        [_delegate productFilterViewController:self didSelectAdvancedConditions:conditions];
    }
    [self dismiss];
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

- (void)buttonResetPressed:(id)sender
{
    [self resetAllSettings];
}

- (void)buttonConfirmPressed:(id)sender
{
    [self buildConditionsAndApply];
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
    NSString *text = @"";
    switch (collectionView.tag) {
        case CollectionViewTagCategory:
        {
            if (indexPath.row < [self.arrayCategoryDefault count])
            {
                NSDictionary *dictionary = [self.arrayCategoryDefault objectAtIndex:indexPath.row];
                NSLog(@"dictionary:\n%@", [dictionary description]);
                NSString *hallId = [dictionary objectForKey:SymphoxAPIParam_display_name];
                NSString *name = @"";
                if (hallId)
                {
                    name = [[TMInfoManager sharedManager].dictionaryMainCategoryNameMapping objectForKey:hallId];
                }
                NSNumber *numberTotal = [dictionary objectForKey:SymphoxAPIParam_document_num];
                NSString *stringTotal = @"";
                if (numberTotal)
                {
                    stringTotal = [NSString stringWithFormat:@"(%li)", (long)[numberTotal integerValue]];
                }
                text = [NSString stringWithFormat:@"%@%@", name, stringTotal];
            }
        }
            break;
        case CollectionViewTagCoupon:
        {
            if (indexPath.row < [_arrayCoupon count])
            {
                NSNumber *number = [_arrayCoupon objectAtIndex:indexPath.row];
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSString *stringNumber = [formatter stringFromNumber:number];
                text = [NSString stringWithFormat:@"$%@", stringNumber];
            }
        }
            break;
        case CollectionViewTagDeliverType:
        {
            if (indexPath.row < [_arrayDeliverType count])
            {
                text = [_arrayDeliverType objectAtIndex:indexPath.row];
            }
        }
            break;
        default:
            break;
    }
    cell.labelText.text = text;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (collectionView.tag) {
        case CollectionViewTagCategory:
        {
            if (indexPath.row < [self.arrayCategoryDefault count])
            {
                self.selectIndexForCategory = indexPath.row;
            }
        }
            break;
        case CollectionViewTagCoupon:
        {
            if (indexPath.row < [self.arrayCoupon count])
            {
                self.selectIndexForCoupon = indexPath.row;
            }
        }
            break;
        case CollectionViewTagDeliverType:
        {
            if (indexPath.row < [self.arrayDeliverType count])
            {
                self.selectIndexForDeliverType = indexPath.row;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollecitonViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    NSInteger column = 1;
    switch (collectionView.tag) {
        case CollectionViewTagCategory:
        {
            column = columnsPerRowForCategory;
        }
            break;
        case CollectionViewTagCoupon:
        {
            column = columnsPerRowForCoupon;
        }
            break;
        case CollectionViewTagDeliverType:
        {
            column = columnsPerRowForDeliverType;
        }
            break;
        default:
            break;
    }
    
    size = CGSizeMake(ceil((self.view.frame.size.width - (kMarginLeft + kMarginRight + ((column - 1) * kIntervalH)))/column), 40.0);
//    NSLog(@"collectionView[%li] itemsize[%4.2f,%4.2f]", (long)collectionView.tag, size.width, size.height);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kIntervalV;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

@end
