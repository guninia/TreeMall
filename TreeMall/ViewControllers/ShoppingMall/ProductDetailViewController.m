//
//  ProductDetailViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDetailImageCollectionViewCell.h"
#import "TMInfoManager.h"
#import "LocalizedString.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _dictionaryCommon = nil;
        _dictionaryDetail = nil;
        _arrayImage = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.collectionViewImage];
    [self.scrollView addSubview:self.pageControlImage];
    [self.scrollView addSubview:self.labelMarketing];
    [self.scrollView addSubview:self.labelProductName];
    [self.scrollView addSubview:self.viewPromotion];
    [self.scrollView addSubview:self.labelPrice];
    [self.scrollView addSubview:self.labelOriginPrice];
    [self.scrollView addSubview:self.separator];
    [self.scrollView addSubview:self.viewPoint];
    [self.scrollView addSubview:self.viewPointCash];
    [self.scrollView addSubview:self.viewPointFeedback];
    [self.scrollView addSubview:self.buttonExchangeDesc];
    [self.scrollView addSubview:self.buttonInstallmentCal];
    [self.scrollView addSubview:self.viewChooseSpec];
    [self.scrollView addSubview:self.viewNotice];
    [self.scrollView addSubview:self.viewSpecTitle];
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
    
    CGFloat scrollBottom = self.view.frame.size.height;
    if (self.bottomBar)
    {
        CGFloat bottomBarHeight = 49.0;
        CGRect frame = CGRectMake(0.0, self.view.frame.size.height - bottomBarHeight, self.view.frame.size.width, bottomBarHeight);
        self.bottomBar.frame = frame;
        scrollBottom = self.bottomBar.frame.origin.y;
    }
    if (self.scrollView)
    {
        CGRect frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, scrollBottom);
        self.scrollView.frame = frame;
    }
    CGFloat originY = 0.0;
    CGFloat originX = 0.0;
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat marginB = 10.0;
    CGFloat columnWidth = self.scrollView.frame.size.width - (marginL + marginR);
    
    if (self.collectionViewImage)
    {
        CGRect frame = CGRectMake(originX, originY, self.scrollView.frame.size.width, self.scrollView.frame.size.width);
        self.collectionViewImage.frame = frame;
        originY = self.collectionViewImage.frame.origin.x + self.collectionViewImage.frame.size.height;
    }
    if (self.pageControlImage)
    {
        CGSize size = [self.pageControlImage sizeForNumberOfPages:[self.arrayImage count]];
        CGRect frame = CGRectMake((self.scrollView.frame.size.width - size.width)/2, originY, size.width, size.height);
        self.pageControlImage.frame = frame;
        originY = self.pageControlImage.frame.origin.y + self.pageControlImage.frame.size.height;
    }
    if (self.labelMarketing && [self.labelMarketing isHidden] == NO)
    {
        originX = marginL;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = self.labelMarketing.lineBreakMode;
        style.alignment = self.labelMarketing.textAlignment;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelMarketing.font, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
        CGRect boundingRect = [self.labelMarketing.text boundingRectWithSize:CGSizeMake(columnWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGRect frame = CGRectMake(originX, originY, ceil(boundingRect.size.width), ceil(boundingRect.size.height));
        self.labelMarketing.frame = frame;
        originY = self.labelMarketing.frame.origin.y + self.labelMarketing.frame.size.height + 2.0;
    }
    if (self.labelProductName && [self.labelProductName isHidden] == NO)
    {
        originX = marginL;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = self.labelProductName.lineBreakMode;
        style.alignment = self.labelProductName.textAlignment;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelProductName.font, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
        CGRect boundingRect = [self.labelProductName.text boundingRectWithSize:CGSizeMake(columnWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGRect frame = CGRectMake(originX, originY, ceil(boundingRect.size.width), ceil(boundingRect.size.height));
        self.labelProductName.frame = frame;
        originY = self.labelProductName.frame.origin.y + self.labelProductName.frame.size.height + 2.0;
    }
    if (self.viewPromotion && [self.viewPromotion isHidden] == NO)
    {
        CGFloat height = [self.viewPromotion referenceHeightForViewWidth:self.scrollView.frame.size.width];
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, height);
        self.viewPromotion.frame = frame;
        originY = self.viewPromotion.frame.origin.y + self.viewPromotion.frame.size.height + 2.0;
    }
    CGFloat priceOriginX = self.scrollView.frame.size.width - marginR;
    CGFloat priceBottomY = originY;
    if (self.labelPrice && [self.labelPrice isHidden] == NO)
    {
        CGSize size = [self.labelPrice referenceSize];
        priceOriginX -= size.width;
        if (originY + size.height > priceBottomY)
        {
            priceBottomY = originY + size.height;
        }
        CGFloat buttonOriginY = priceBottomY - size.height;
        CGRect frame = CGRectMake(priceOriginX, buttonOriginY, size.width, size.height);
        self.labelPrice.frame = frame;
        priceOriginX -= 3.0;
    }
    if (self.labelOriginPrice && [self.labelOriginPrice isHidden] == NO)
    {
        CGSize size = [self.labelOriginPrice referenceSize];
        priceOriginX -= size.width;
        if (originY + size.height > priceBottomY)
        {
            priceBottomY = originY + size.height;
        }
        CGFloat buttonOriginY = priceBottomY - size.height;
        CGRect frame = CGRectMake(priceOriginX, buttonOriginY, size.width, size.height);
        self.labelOriginPrice.frame = frame;
    }
    originY = priceBottomY + 2.0;
    if (self.separator)
    {
        CGFloat separatorHeight = 1.0;
        CGRect frame = CGRectMake(originX, originY, columnWidth, separatorHeight);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + 5.0;
    }
    CGFloat intervalH = 5.0;
    CGFloat halfColumnWidth = ceil((self.scrollView.frame.size.width - (marginL + marginR + intervalH))/2);
    CGFloat columnHeight = 40.0;
    if (self.viewPoint)
    {
        CGRect frame = CGRectMake(originX, originY, halfColumnWidth, columnHeight);
        self.viewPoint.frame = frame;
        originX = self.viewPoint.frame.origin.x + self.viewPoint.frame.size.width + intervalH;
    }
    if (self.viewPointCash)
    {
        CGRect frame = CGRectMake(originX, originY, halfColumnWidth, columnHeight);
        self.viewPointCash.frame = frame;
        originY = self.viewPointCash.frame.origin.y + self.viewPointCash.frame.size.height + 3.0;
    }
    originX = marginL;
    if (self.viewPointFeedback)
    {
        CGRect frame = CGRectMake(originX, originY, columnWidth, columnHeight);
        self.viewPointFeedback.frame = frame;
        originY = self.viewPointFeedback.frame.origin.y + self.viewPointFeedback.frame.size.height + 5.0;
    }
    if (self.buttonExchangeDesc)
    {
        CGRect frame = CGRectMake(originX, originY, halfColumnWidth, columnHeight);
        self.buttonExchangeDesc.frame = frame;
        originX = self.buttonExchangeDesc.frame.origin.x + self.buttonExchangeDesc.frame.size.width + intervalH;
    }
    if (self.buttonInstallmentCal)
    {
        CGRect frame = CGRectMake(originX, originY, halfColumnWidth, columnHeight);
        self.buttonInstallmentCal.frame = frame;
        originY = self.buttonInstallmentCal.frame.origin.y + self.buttonInstallmentCal.frame.size.height + 5.0;
    }
    originX = marginL;
    if (self.viewChooseSpec)
    {
        CGRect frame = CGRectMake(originX, originY, columnWidth, columnHeight);
        self.viewChooseSpec.frame = frame;
        originY = self.viewChooseSpec.frame.origin.y + self.viewChooseSpec.frame.size.height + 5.0;
    }
    if (self.viewNotice)
    {
        CGSize size = [self.viewNotice referenceSizeForViewWidth:columnWidth];
        CGRect frame = CGRectMake(originX, originY, size.width, size.height);
        self.viewNotice.frame = frame;
        originY = self.viewNotice.frame.origin.y + self.viewNotice.frame.size.height + 5.0;
    }
    
    if (self.viewSpecTitle)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
        self.viewSpecTitle.frame = frame;
        originY = self.viewSpecTitle.frame.origin.y + self.viewSpecTitle.frame.size.height;
    }
    
    scrollBottom = originY + marginB;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, scrollBottom)];
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

- (UICollectionView *)collectionViewImage
{
    if (_collectionViewImage == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewImage = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionViewImage setBackgroundColor:[UIColor grayColor]];
        [_collectionViewImage setDelegate:self];
        [_collectionViewImage setDataSource:self];
        [_collectionViewImage setPagingEnabled:YES];
        [_collectionViewImage registerClass:[ProductDetailImageCollectionViewCell class] forCellWithReuseIdentifier:ProductDetailImageCollectionViewCellIdentifier];
    }
    return _collectionViewImage;
}

- (UIPageControl *)pageControlImage
{
    if (_pageControlImage == nil)
    {
        _pageControlImage = [[UIPageControl alloc] initWithFrame:CGRectZero];
        [_pageControlImage setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControlImage setCurrentPageIndicatorTintColor:[UIColor colorWithRed:(130.0/255.0) green:(193.0/255.0) blue:(88.0/255.0) alpha:1.0]];
    }
    return _pageControlImage;
}

- (UILabel *)labelMarketing
{
    if (_labelMarketing == nil)
    {
        _labelMarketing = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelMarketing setBackgroundColor:[UIColor clearColor]];
        [_labelMarketing setTextColor:[UIColor colorWithRed:(241.0/255.0) green:(158.0/255.0) blue:(57.0/255.0) alpha:1.0]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelMarketing setFont:font];
        [_labelMarketing setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelMarketing setTextAlignment:NSTextAlignmentLeft];
        [_labelMarketing setNumberOfLines:0];
    }
    return _labelMarketing;
}

- (UILabel *)labelProductName
{
    if (_labelProductName == nil)
    {
        _labelProductName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelProductName setBackgroundColor:[UIColor clearColor]];
        [_labelProductName setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelProductName setFont:font];
        [_labelProductName setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelProductName setTextAlignment:NSTextAlignmentLeft];
        [_labelProductName setNumberOfLines:0];
    }
    return _labelProductName;
}

- (ProductDetailPromotionLabelView *)viewPromotion
{
    if (_viewPromotion == nil)
    {
        _viewPromotion = [[ProductDetailPromotionLabelView alloc] initWithFrame:CGRectZero];
    }
    return _viewPromotion;
}

- (ProductDetailBottomBar *)bottomBar
{
    if (_bottomBar == nil)
    {
        _bottomBar = [[ProductDetailBottomBar alloc] initWithFrame:CGRectZero];
        [_bottomBar setDelegate:self];
    }
    return _bottomBar;
}

- (ProductPriceLabel *)labelPrice
{
    if (_labelPrice == nil)
    {
        _labelPrice = [[ProductPriceLabel alloc] initWithFrame:CGRectZero];
        [_labelPrice setBackgroundColor:[UIColor clearColor]];
        [_labelPrice setTextColor:[UIColor redColor]];
        UIFont *font = [UIFont systemFontOfSize:20.0];
        [_labelPrice setFont:font];
        [_labelPrice setPrefix:@"＄"];
    }
    return _labelPrice;
}

- (ProductPriceLabel *)labelOriginPrice
{
    if (_labelOriginPrice == nil)
    {
        _labelOriginPrice = [[ProductPriceLabel alloc] initWithFrame:CGRectZero];
        [_labelOriginPrice setBackgroundColor:[UIColor clearColor]];
        [_labelOriginPrice setTextColor:[UIColor redColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelOriginPrice setFont:font];
        [_labelOriginPrice setPrefix:[LocalizedString OriginPrice_C_$]];
        _labelOriginPrice.shouldShowCutLine = YES;
    }
    return _labelOriginPrice;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    }
    return _separator;
}

- (BorderedDoubleLabelView *)viewPoint
{
    if (_viewPoint == nil)
    {
        _viewPoint = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewPoint.labelL setText:[LocalizedString PointNumber]];
    }
    return _viewPoint;
}

- (BorderedDoubleLabelView *)viewPointCash
{
    if (_viewPointCash == nil)
    {
        _viewPointCash = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewPointCash.labelL setText:[LocalizedString PointAddCash]];
    }
    return _viewPointCash;
}

- (BorderedDoubleLabelView *)viewPointFeedback
{
    if (_viewPointFeedback == nil)
    {
        _viewPointFeedback = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewPointFeedback.labelR setText:[LocalizedString Detail_RA_]];
    }
    return _viewPointFeedback;
}

- (ImageTitleButton *)buttonExchangeDesc
{
    if (_buttonExchangeDesc == nil)
    {
        _buttonExchangeDesc = [[ImageTitleButton alloc] initWithFrame:CGRectZero];
        [_buttonExchangeDesc setBackgroundColor:[UIColor colorWithRed:(173.0/255.0) green:(192.0/255.0) blue:(85.0/255.0) alpha:1.0]];
        UIImage *image = [UIImage imageNamed:@"sho_btn_sale"];
        if (image)
        {
            [_buttonExchangeDesc.imageViewIcon setImage:image];
        }
        [_buttonExchangeDesc.labelText setText:[LocalizedString ExchangeDescription]];
    }
    return _buttonExchangeDesc;
}

- (ImageTitleButton *)buttonInstallmentCal
{
    if (_buttonInstallmentCal == nil)
    {
        _buttonInstallmentCal = [[ImageTitleButton alloc] initWithFrame:CGRectZero];
        [_buttonInstallmentCal setBackgroundColor:[UIColor colorWithRed:(123.0/255.0) green:(108.0/255.0) blue:(92.0/255.0) alpha:1.0]];
        UIImage *image = [UIImage imageNamed:@"sho_btn_creit"];
        if (image)
        {
            [_buttonInstallmentCal.imageViewIcon setImage:image];
        }
        [_buttonInstallmentCal.labelText setText:[LocalizedString InstallmentsCalculation]];
    }
    return _buttonInstallmentCal;
}

- (BorderedDoubleLabelView *)viewChooseSpec
{
    if (_viewChooseSpec == nil)
    {
        _viewChooseSpec = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewChooseSpec.layer setCornerRadius:3.0];
        _viewChooseSpec.userInteractionEnabled = YES;
        _viewChooseSpec.delegate = self;
        [_viewChooseSpec.labelL setText:[LocalizedString ChooseSpec]];
        [_viewChooseSpec.labelR setText:@"＞"];
    }
    return _viewChooseSpec;
}

- (ImageTextView *)viewNotice
{
    if (_viewNotice == nil)
    {
        _viewNotice = [[ImageTextView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_ico_warring"];
        if (image)
        {
            _viewNotice.imageViewIcon.image = image;
        }
        [_viewNotice.labelText setText:[LocalizedString ProductDetailNotice]];
    }
    return _viewNotice;
}

- (ProductDetailSectionTitleView *)viewSpecTitle
{
    if (_viewSpecTitle == nil)
    {
        _viewSpecTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_info_ico1"];
        if (image)
        {
            [_viewSpecTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewSpecTitle.viewTitle.labelText setText:[LocalizedString ProductIntroduce]];
    }
    return _viewSpecTitle;
}

#pragma mark - ProductDetailBottomBarDelegate

- (void)productDetailBottomBar:(ProductDetailBottomBar *)bar didSelectFavoriteBySender:(id)sender
{
    if (self.dictionaryCommon)
    {
        [[TMInfoManager sharedManager] addProductToFavorite:self.dictionaryCommon];
    }
}

- (void)productDetailBottomBar:(ProductDetailBottomBar *)bar didSelectAddToCartBySender:(id)sender
{
    
}

- (void)productDetailBottomBar:(ProductDetailBottomBar *)bar didSelectPurchaseBySender:(id)sender
{
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductDetailImageCollectionViewCellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - BorderedDoubleLabelViewDelegate

- (void)didTouchUpInsideBorderedDoubleView:(BorderedDoubleLabelView *)view
{
    
}

@end
