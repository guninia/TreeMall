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
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "UIImageView+WebCache.h"
#import <UIButton+WebCache.h>
#import "ExchangeDescriptionViewController.h"
#import "InstallmentDescriptionViewController.h"
#import "SingleMediaDetailViewController.h"
#import "CartViewController.h"
#import "LoginViewController.h"
#import "WebViewViewController.h"
#import "Definition.h"
#import <Social/Social.h>
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface ProductDetailViewController () {
    id<GAITracker> gaTracker;
}

- (void)retrieveDataForIdentifer:(NSNumber *)identifier;
- (BOOL)processProductData:(id)data;
- (void)layoutCustomSubviews;
- (void)refreshContent;
- (NSAttributedString *)attributedStringFromHtmlString:(NSString *)html;
- (void)retrieveTermsForType:(TermType)type;
- (BOOL)processTermsData:(id)data;
- (void)showCartTypeSheetForDirectlyPurchase:(BOOL)directlyPurchase;
- (void)addToCart:(CartType)type shouldShowAlert:(BOOL)shouldShowAlert;
- (void)addProduct:(NSDictionary *)dictionaryProduct toCartForType:(CartType)type;
- (NSMutableDictionary *)dictionaryCommonFromDetail:(NSDictionary *)dictionary;
- (NSArray *)cartsAvailableToAdd;
- (void)presentCartViewForType:(CartType)type;
- (void)requestBackToMain;
- (void)presentShareView;


- (void)buttonExchangeDescPressed:(id)sender;
- (void)buttonInstallmentCalPressed:(id)sender;
- (void)buttonLinkPressed:(id)sender;
- (void)buttonIntroImagePressed:(id)sender;
- (void)buttonSpecImagePressed:(id)sender;
- (void)buttonFunctionPressed:(id)sender;
- (void)buttonItemCartPressed:(id)sender;
- (void)linkLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@implementation ProductDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _dictionaryCommon = nil;
        _dictionaryDetail = nil;
        _arrayImagePath = nil;
        _productIdentifier = nil;
        _specIndex = NSNotFound;
        _arrayViewNotice = [[NSMutableArray alloc] initWithCapacity:0];
        self.title = [LocalizedString ProductInfo];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
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
    [self.scrollView addSubview:self.labelAdText];
    [self.scrollView addSubview:self.webViewAdText];
    [self.scrollView addSubview:self.viewIntroTitle];
    [self.scrollView addSubview:self.labelIntro];
    [self.scrollView addSubview:self.webViewIntro];
    [self.scrollView addSubview:self.viewSpecTitle];
    [self.scrollView addSubview:self.labelSpec];
    [self.scrollView addSubview:self.webViewSpec];
    [self.scrollView addSubview:self.viewRemarkTitle];
    [self.scrollView addSubview:self.labelRemark];
    [self.scrollView addSubview:self.webViewRemark];
    [self.scrollView addSubview:self.viewShippingAndWarrentyTitle];
    [self.scrollView addSubview:self.labelShippingAndWarrenty];
    [self.scrollView addSubview:self.webViewShippingAndWarrenty];
    [self.scrollView addSubview:self.labelFastDelivery];
    [self.scrollView addSubview:self.labelDiscount];
    [self.view addSubview:self.bottomBar];
    
    if (self.dictionaryCommon != nil)
    {
        if (self.productIdentifier == nil)
        {
            NSNumber *productIdentifier = [self.dictionaryCommon objectForKey:SymphoxAPIParam_cpdt_num];
            if (productIdentifier && ([productIdentifier isEqual:[NSNull null]] == NO))
            {
                self.productIdentifier = productIdentifier;
            }
        }
    }
    if (self.productIdentifier != nil)
    {
        [self retrieveDataForIdentifer:self.productIdentifier];
    }
    [self retrieveTermsForType:TermTypeShippingAndWarrenty];
    
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
    
    [self layoutCustomSubviews];
}

- (void)setSpecIndex:(NSInteger)specIndex
{
    _specIndex = specIndex;
    if (self.dictionaryDetail == nil)
    {
        return;
    }
    NSArray *array = [self.dictionaryDetail objectForKey:SymphoxAPIParam_standard];
    if (array == nil)
    {
        return;
    }
    if (_specIndex < 0 || _specIndex >= [array count])
    {
        return;
    }
    NSDictionary *dictionary = [array objectAtIndex:_specIndex];
    NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
    if (name && [name isEqual:[NSNull null]] == NO)
    {
        [self.viewChooseSpec.labelL setText:name];
    }
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

- (UILabel *)labelFastDelivery
{
    if (_labelFastDelivery == nil)
    {
        _labelFastDelivery = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelFastDelivery setBackgroundColor:[UIColor colorWithRed:(80.0/255.0) green:(185.0/255.0) blue:(182.0/255.0) alpha:1.0]];
        [_labelFastDelivery setTextColor:[UIColor whiteColor]];
        [_labelFastDelivery setTextAlignment:NSTextAlignmentCenter];
        [_labelFastDelivery setText:[LocalizedString EightHourDelivery]];
        UIFont *font = [UIFont systemFontOfSize:20.0];
        [_labelFastDelivery setFont:font];
        [_labelFastDelivery setHidden:YES];
    }
    return _labelFastDelivery;
}

- (UILabel *)labelDiscount
{
    if (_labelDiscount == nil)
    {
        _labelDiscount = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDiscount setBackgroundColor:[UIColor colorWithRed:(178.0/255.0) green:(68.0/255.0) blue:(52.0/255.0) alpha:1.0]];
        [_labelDiscount setTextColor:[UIColor whiteColor]];
        [_labelDiscount setTextAlignment:NSTextAlignmentCenter];
        UIFont *font = [UIFont systemFontOfSize:20.0];
        [_labelDiscount setFont:font];
        [_labelDiscount setHidden:YES];
    }
    return _labelDiscount;
}

- (UICollectionView *)collectionViewImage
{
    if (_collectionViewImage == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewImage = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionViewImage setBackgroundColor:[UIColor whiteColor]];
        [_collectionViewImage setShowsVerticalScrollIndicator:NO];
        [_collectionViewImage setShowsHorizontalScrollIndicator:NO];
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
        [_pageControlImage setBackgroundColor:[UIColor clearColor]];
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
        UIFont *font = [UIFont systemFontOfSize:16.0];
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
        _viewPromotion.tintColor = [UIColor orangeColor];
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
        [_labelOriginPrice setTextColor:[UIColor lightGrayColor]];
        [_labelOriginPrice.viewLine setBackgroundColor:_labelOriginPrice.textColor];
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
        [_viewPoint.labelR setTextColor:[UIColor orangeColor]];
    }
    return _viewPoint;
}

- (BorderedDoubleLabelView *)viewPointCash
{
    if (_viewPointCash == nil)
    {
        _viewPointCash = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewPointCash.labelL setText:[LocalizedString PointAddCash]];
        [_viewPointCash.labelR setTextColor:[UIColor orangeColor]];
    }
    return _viewPointCash;
}

- (BorderedDoubleLabelView *)viewPointFeedback
{
    if (_viewPointFeedback == nil)
    {
        _viewPointFeedback = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        _viewPointFeedback.delegate = self;
        _viewPointFeedback.userInteractionEnabled = YES;
        _viewPointFeedback.backgroundColor = [UIColor clearColor];
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
        [_buttonExchangeDesc addTarget:self action:@selector(buttonExchangeDescPressed:) forControlEvents:UIControlEventTouchUpInside];
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
        [_buttonInstallmentCal addTarget:self action:@selector(buttonInstallmentCalPressed:) forControlEvents:UIControlEventTouchUpInside];
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

- (DTAttributedLabel *)labelAdText
{
    if (_labelAdText == nil)
    {
        _labelAdText = [[DTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelAdText.layoutFrameHeightIsConstrainedByBounds = NO;
        _labelAdText.shouldDrawLinks = YES;
        _labelAdText.shouldDrawImages = YES;
        _labelAdText.delegate = self;
        _labelAdText.hidden = YES;
    }
    return _labelAdText;
}

- (UIWebView *)webViewAdText
{
    if (_webViewAdText == nil)
    {
        _webViewAdText = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
        _webViewAdText.tag = 2;
        [_webViewAdText.scrollView setScrollEnabled:NO];
//        [_webViewAdText setScalesPageToFit:YES];
//        [_webViewAdText setContentMode:UIViewContentModeScaleAspectFit];
        [_webViewAdText setDelegate:self];
    }
    return _webViewAdText;
}

- (ProductDetailSectionTitleView *)viewIntroTitle
{
    if (_viewIntroTitle == nil)
    {
        _viewIntroTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_info_ico1"];
        if (image)
        {
            [_viewIntroTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewIntroTitle.viewTitle.labelText setText:[LocalizedString ProductIntroduce]];
    }
    return _viewIntroTitle;
}

- (DTAttributedLabel *)labelIntro
{
    if (_labelIntro == nil)
    {
        _labelIntro = [[DTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelIntro.layoutFrameHeightIsConstrainedByBounds = NO;
        _labelIntro.shouldDrawLinks = YES;
        _labelIntro.shouldDrawImages = YES;
        _labelIntro.delegate = self;
        _labelIntro.hidden = YES;
    }
    return _labelIntro;
}

- (UIWebView *)webViewIntro
{
    if (_webViewIntro == nil)
    {
        _webViewIntro = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
        _webViewIntro.tag = 3;
        [_webViewIntro.scrollView setScrollEnabled:NO];
//        [_webViewIntro setScalesPageToFit:YES];
//        [_webViewIntro setContentMode:UIViewContentModeScaleAspectFit];
        [_webViewIntro setDelegate:self];
    }
    return _webViewIntro;
}

- (ProductDetailSectionTitleView *)viewSpecTitle
{
    if (_viewSpecTitle == nil)
    {
        _viewSpecTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_info_ico2"];
        if (image)
        {
            [_viewSpecTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewSpecTitle.viewTitle.labelText setText:[LocalizedString ProductSpec]];
    }
    return _viewSpecTitle;
}

- (DTAttributedLabel *)labelSpec
{
    if (_labelSpec == nil)
    {
        _labelSpec = [[DTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelSpec.layoutFrameHeightIsConstrainedByBounds = NO;
        _labelSpec.shouldDrawLinks = YES;
        _labelSpec.shouldDrawImages = YES;
        _labelSpec.delegate = self;
        _labelSpec.hidden = YES;
    }
    return _labelSpec;
}

- (UIWebView *)webViewSpec
{
    if (_webViewSpec == nil)
    {
        _webViewSpec = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
        _webViewSpec.tag = 4;
        [_webViewSpec.scrollView setScrollEnabled:NO];
//        [_webViewSpec setScalesPageToFit:YES];
//        [_webViewSpec setContentMode:UIViewContentModeScaleAspectFit];
        [_webViewSpec setDelegate:self];
    }
    return _webViewSpec;
}

- (ProductDetailSectionTitleView *)viewRemarkTitle
{
    if (_viewRemarkTitle == nil)
    {
        _viewRemarkTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_info_ico4"];
        if (image)
        {
            [_viewRemarkTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewRemarkTitle.viewTitle.labelText setText:[LocalizedString Remark]];
    }
    return _viewRemarkTitle;
}

- (DTAttributedLabel *)labelRemark
{
    if (_labelRemark == nil)
    {
        _labelRemark = [[DTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelRemark.layoutFrameHeightIsConstrainedByBounds = NO;
        _labelRemark.shouldDrawLinks = YES;
        _labelRemark.shouldDrawImages = YES;
        _labelRemark.delegate = self;
        _labelRemark.hidden = YES;
    }
    return _labelRemark;
}

- (UIWebView *)webViewRemark
{
    if (_webViewRemark == nil)
    {
        _webViewRemark = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
        _webViewRemark.tag = 5;
        [_webViewRemark.scrollView setScrollEnabled:NO];
//        [_webViewRemark setScalesPageToFit:YES];
//        [_webViewRemark setContentMode:UIViewContentModeScaleAspectFit];
        [_webViewRemark setDelegate:self];
    }
    return _webViewRemark;
}

- (ProductDetailSectionTitleView *)viewShippingAndWarrentyTitle
{
    if (_viewShippingAndWarrentyTitle == nil)
    {
        _viewShippingAndWarrentyTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_info_ico3"];
        if (image)
        {
            [_viewShippingAndWarrentyTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewShippingAndWarrentyTitle.viewTitle.labelText setText:[LocalizedString ShippingAndWarrentyDescription]];
    }
    return _viewShippingAndWarrentyTitle;
}

- (DTAttributedLabel *)labelShippingAndWarrenty
{
    if (_labelShippingAndWarrenty == nil)
    {
        _labelShippingAndWarrenty = [[DTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelShippingAndWarrenty.layoutFrameHeightIsConstrainedByBounds = NO;
        _labelShippingAndWarrenty.shouldDrawLinks = YES;
        _labelShippingAndWarrenty.shouldDrawImages = YES;
        _labelShippingAndWarrenty.delegate = self;
        _labelShippingAndWarrenty.hidden = YES;
    }
    return _labelShippingAndWarrenty;
}

- (UIWebView *)webViewShippingAndWarrenty
{
    if (_webViewShippingAndWarrenty == nil)
    {
        _webViewShippingAndWarrenty = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
        _webViewShippingAndWarrenty.tag = 5;
        [_webViewShippingAndWarrenty.scrollView setScrollEnabled:NO];
//        [_webViewShippingAndWarrenty setScalesPageToFit:YES];
//        [_webViewShippingAndWarrenty setContentMode:UIViewContentModeScaleAspectFit];
        [_webViewShippingAndWarrenty setDelegate:self];
    }
    return _webViewShippingAndWarrenty;
}

- (NSMutableArray *)arrayCartType
{
    if (_arrayCartType == nil)
    {
        _arrayCartType = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCartType;
}

- (NSMutableArray *)arrayIntroImageView
{
    if (_arrayIntroImageView == nil)
    {
        _arrayIntroImageView = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayIntroImageView;
}

- (NSMutableArray *)arraySpecImageView
{
    if (_arraySpecImageView == nil)
    {
        _arraySpecImageView = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arraySpecImageView;
}

#pragma mark - Private Methods

- (void)retrieveDataForIdentifer:(NSNumber *)identifier
{
    if (identifier == nil)
    {
        return;
    }
    self.bottomBar.hidden = YES;
    __weak ProductDetailViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_productDetail];
    //    NSLog(@"retrieveDataForIdentifer - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:identifier, SymphoxAPIParam_cpdt_num, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:parameters inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"retrieveDataForIdentifer:\n%@", string);
                if ([weakSelf processProductData:data])
                {
                    // If the message exist, then pop message first.
                    NSString *message = [self.dictionaryDetail objectForKey:SymphoxAPIParam_message];
                    if (message && [message isEqual:[NSNull null]] == NO && [message length] > 0)
                    {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = nil;
                        NSNumber *cpdt_num = [self.dictionaryDetail objectForKey:SymphoxAPIParam_cpdt_num];
                        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO && [cpdt_num integerValue] > 0)
                        {
                            action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
                        }
                        else
                        {
                            action = [UIAlertAction actionWithTitle:[LocalizedString GoBack] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                if (weakSelf.navigationController)
                                {
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }
                                else if (weakSelf.presentingViewController)
                                {
                                    [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                }
                            }];
                        }
                        if (action)
                        {
                            [alertController addAction:action];
                        }
                        [weakSelf presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    // Also layout subviews.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf layoutCustomSubviews];
                        weakSelf.bottomBar.hidden = NO;
                    });
                    
                }
                else
                {
                    NSLog(@"retrieveDataForIdentifer - Cannot process data.");
                }
            }
            else
            {
                NSLog(@"retrieveDataForIdentifer - Unexpected data format.");
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString CannotLoadData];
            NSDictionary *userInfo = error.userInfo;
            BOOL errorProductNotFound = NO;
            if (userInfo)
            {
                NSString *errorId = [userInfo objectForKey:SymphoxAPIParam_id];
                if ([errorId compare:SymphoxAPIError_E301 options:NSCaseInsensitiveSearch] == NSOrderedSame)
                {
                    errorProductNotFound = YES;
                }
                if (errorProductNotFound)
                {
                    NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                    if (serverMessage)
                    {
                        errorMessage = serverMessage;
                    }
                }
            }
            NSLog(@"retrieveDataForIdentifer - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *backAction = [UIAlertAction actionWithTitle:[LocalizedString GoBack] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                if (weakSelf.navigationController)
                {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    return;
                }
                if (weakSelf.presentingViewController)
                {
                    [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            [alertController addAction:backAction];
            if (errorProductNotFound == NO)
            {
                UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:[LocalizedString Reload] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [weakSelf retrieveDataForIdentifer:identifier];
                }];
                [alertController addAction:reloadAction];
            }
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (BOOL)processProductData:(id)data
{
    BOOL success = NO;
    if (data == nil)
    {
        return success;
    }
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && jsonObject)
    {
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            self.dictionaryDetail = (NSDictionary *)jsonObject;
            [self refreshContent];
            success = YES;
        }
    }
    return success;
}

- (void)layoutCustomSubviews
{
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
    
    CGFloat tagOriginX = originX;
    if (self.labelFastDelivery && [self.labelFastDelivery isHidden] == NO)
    {
        CGSize size = CGSizeMake(100.0, 32.0);
        CGRect frame = CGRectMake(tagOriginX, originY, size.width, size.height);
        self.labelFastDelivery.frame = frame;
        tagOriginX = CGRectGetMaxX(self.labelFastDelivery.frame);
    }
    if (self.labelDiscount && [self.labelDiscount isHidden] == NO)
    {
        CGSize size = CGSizeMake(80.0, 32.0);
        CGRect frame = CGRectMake(tagOriginX, originY, size.width, size.height);
        self.labelDiscount.frame = frame;
        tagOriginX = CGRectGetMaxX(self.labelDiscount.frame);
    }
    
    if (self.collectionViewImage && [self.collectionViewImage isHidden] == NO)
    {
        CGRect frame = CGRectMake(originX, originY, self.scrollView.frame.size.width, self.scrollView.frame.size.width);
        self.collectionViewImage.frame = frame;
        originY = self.collectionViewImage.frame.origin.x + self.collectionViewImage.frame.size.height;
    }
    if (self.pageControlImage && [self.pageControlImage isHidden] == NO)
    {
        CGSize size = [self.pageControlImage sizeForNumberOfPages:[self.arrayImagePath count]];
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
        CGRect frame = CGRectMake(marginL, originY, self.scrollView.frame.size.width - (marginL + marginR), height);
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
        priceOriginX = marginL;
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
        [self.viewPoint setNeedsLayout];
    }
    if (self.viewPointCash)
    {
        CGRect frame = CGRectMake(originX, originY, halfColumnWidth, columnHeight);
        self.viewPointCash.frame = frame;
        originY = self.viewPointCash.frame.origin.y + self.viewPointCash.frame.size.height + 3.0;
        [self.viewPointCash setNeedsLayout];
    }
    originX = marginL;
    if (self.viewPointFeedback && [self.viewPointFeedback isHidden] == NO)
    {
        CGRect frame = CGRectMake(originX, originY, columnWidth, columnHeight);
        self.viewPointFeedback.frame = frame;
        originY = self.viewPointFeedback.frame.origin.y + self.viewPointFeedback.frame.size.height + 5.0;
        [self.viewPointFeedback setNeedsLayout];
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
    if (self.viewChooseSpec && [self.viewChooseSpec isHidden] == NO)
    {
        CGRect frame = CGRectMake(originX, originY, columnWidth, columnHeight);
        self.viewChooseSpec.frame = frame;
        originY = self.viewChooseSpec.frame.origin.y + self.viewChooseSpec.frame.size.height + 5.0;
        [self.viewChooseSpec setNeedsLayout];
    }
    if ([self.arrayViewNotice count] > 0)
    {
        for (ImageTextView *view in self.arrayViewNotice)
        {
            CGSize size = [view referenceSizeForViewWidth:columnWidth];
            CGRect frame = CGRectMake(originX, originY, size.width, size.height);
            view.frame = frame;
            originY = view.frame.origin.y + view.frame.size.height + 5.0;
        }
    }
    
    if (self.labelAdText && [self.labelAdText isHidden] == NO)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGSize size = [self.labelAdText suggestedFrameSizeToFitEntireStringConstraintedToWidth:maxWidth];
        CGRect frame = CGRectMake(originX, originY, maxWidth, ceil(size.height));
        self.labelAdText.frame = frame;
        originY = self.labelAdText.frame.origin.y + self.labelAdText.frame.size.height + 5.0;
    }
    if (self.webViewAdText)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGRect frame = self.webViewAdText.frame;
        frame.origin.y = originY;
        frame.origin.x = originX;
        frame.size.width = maxWidth;
        self.webViewAdText.frame = frame;
//        NSLog(@"layoutCustomSubviews - webViewAdText[%4.2f,%4.2f]", frame.size.width, frame.size.height);
        originY = self.webViewAdText.frame.origin.y + self.webViewAdText.frame.size.height + 5.0;
    }
    
    if (self.viewIntroTitle && [self.viewIntroTitle isHidden] == NO)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
        self.viewIntroTitle.frame = frame;
        originY = self.viewIntroTitle.frame.origin.y + self.viewIntroTitle.frame.size.height + 5.0;
    }
    
    if (self.labelIntro && [self.labelIntro isHidden] == NO)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGSize size = [self.labelIntro suggestedFrameSizeToFitEntireStringConstraintedToWidth:maxWidth];
        CGRect frame = CGRectMake(originX, originY, maxWidth, ceil(size.height));
        self.labelIntro.frame = frame;
        originY = self.labelIntro.frame.origin.y + self.labelIntro.frame.size.height;
    }
    if (self.webViewIntro)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGRect frame = self.webViewIntro.frame;
        frame.origin.y = originY;
        frame.origin.x = originX;
        frame.size.width = maxWidth;
        self.webViewIntro.frame = frame;
        originY = self.webViewIntro.frame.origin.y + self.webViewIntro.frame.size.height;
//        NSLog(@"layoutCustomSubviews - webViewIntro[%4.2f,%4.2f]", frame.size.width, frame.size.height);
    }
    
    if ([self.arrayIntroImageView count] > 0)
    {
        CGSize size = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.width);
        for (UIButton *button in self.arrayIntroImageView)
        {
            button.frame = CGRectMake(0.0, originY, size.width, size.height);
            originY = button.frame.origin.y + button.frame.size.height;
        }
        originY += 5.0;
    }
    else
    {
        originY += 5.0;
    }
    
    if (self.viewSpecTitle && [self.viewSpecTitle isHidden] == NO)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
        self.viewSpecTitle.frame = frame;
        originY = self.viewSpecTitle.frame.origin.y + self.viewSpecTitle.frame.size.height + 5.0;
    }
    
    if (self.labelSpec && [self.labelSpec isHidden] == NO)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGSize size = [self.labelSpec suggestedFrameSizeToFitEntireStringConstraintedToWidth:maxWidth];
        CGRect frame = CGRectMake(originX, originY, maxWidth, ceil(size.height));
        self.labelSpec.frame = frame;
        originY = self.labelSpec.frame.origin.y + self.labelSpec.frame.size.height + 5.0;
    }
    if (self.webViewSpec)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGRect frame = self.webViewSpec.frame;
        frame.origin.y = originY;
        frame.origin.x = originX;
        frame.size.width = maxWidth;
        self.webViewSpec.frame = frame;
        originY = self.webViewSpec.frame.origin.y + self.webViewSpec.frame.size.height;
//        NSLog(@"layoutCustomSubviews - webViewSpec[%4.2f,%4.2f]", frame.size.width, frame.size.height);
    }
    
    if ([self.arraySpecImageView count] > 0)
    {
        CGSize size = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.width);
        for (UIButton *button in self.arraySpecImageView)
        {
            button.frame = CGRectMake(0.0, originY, size.width, size.height);
            originY = button.frame.origin.y + button.frame.size.height;
        }
        originY += 5.0;
    }
    else
    {
        originY += 5.0;
    }
    
    if (self.viewRemarkTitle && [self.viewRemarkTitle isHidden] == NO)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
        self.viewRemarkTitle.frame = frame;
        originY = self.viewRemarkTitle.frame.origin.y + self.viewRemarkTitle.frame.size.height + 5.0;
    }
    if (self.labelRemark && [self.labelRemark isHidden] == NO)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGSize size = [self.labelRemark suggestedFrameSizeToFitEntireStringConstraintedToWidth:maxWidth];
        CGRect frame = CGRectMake(originX, originY, maxWidth, ceil(size.height));
        self.labelRemark.frame = frame;
        originY = self.labelRemark.frame.origin.y + self.labelRemark.frame.size.height + 5.0;
    }
    if (self.webViewRemark)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGRect frame = self.webViewRemark.frame;
        frame.origin.y = originY;
        frame.origin.x = originX;
        frame.size.width = maxWidth;
        self.webViewRemark.frame = frame;
        originY = self.webViewRemark.frame.origin.y + self.webViewRemark.frame.size.height;
//        NSLog(@"layoutCustomSubviews - webViewRemark[%4.2f,%4.2f]", frame.size.width, frame.size.height);
    }
    
    if (self.viewShippingAndWarrentyTitle && [self.viewShippingAndWarrentyTitle isHidden] == NO)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
        self.viewShippingAndWarrentyTitle.frame = frame;
        originY = self.viewShippingAndWarrentyTitle.frame.origin.y + self.viewShippingAndWarrentyTitle.frame.size.height + 5.0;
    }
    if (self.labelShippingAndWarrenty && [self.labelShippingAndWarrenty isHidden] == NO)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGSize size = [self.labelShippingAndWarrenty suggestedFrameSizeToFitEntireStringConstraintedToWidth:maxWidth];
        CGRect frame = CGRectMake(originX, originY, maxWidth, ceil(size.height));
        self.labelShippingAndWarrenty.frame = frame;
        originY = self.labelShippingAndWarrenty.frame.origin.y + self.labelShippingAndWarrenty.frame.size.height + 5.0;
    }
    if (self.webViewShippingAndWarrenty)
    {
        CGFloat maxWidth = self.scrollView.frame.size.width - marginL - marginR;
        CGRect frame = self.webViewShippingAndWarrenty.frame;
        frame.origin.y = originY;
        frame.origin.x = originX;
        frame.size.width = maxWidth;
        self.webViewShippingAndWarrenty.frame = frame;
        originY = self.webViewShippingAndWarrenty.frame.origin.y + self.webViewShippingAndWarrenty.frame.size.height;
//        NSLog(@"layoutCustomSubviews - webViewShippingAndWarrenty[%4.2f,%4.2f]", frame.size.width, frame.size.height);
    }
    
    scrollBottom = originY + marginB;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, scrollBottom)];
}

- (void)refreshContent
{
    if (self.dictionaryDetail == nil)
    {
        return;
    }
    for (ImageTextView *view in self.arrayViewNotice)
    {
        [view removeFromSuperview];
    }
    [self.arrayViewNotice removeAllObjects];
    
    NSNumber *numberIsQuick = [self.dictionaryDetail objectForKey:SymphoxAPIParam_is_quick];
    if (numberIsQuick && [numberIsQuick isEqual:[NSNull null]] == NO && [numberIsQuick boolValue] == YES)
    {
        [self.labelFastDelivery setHidden:NO];
    }
    else
    {
        [self.labelFastDelivery setHidden:YES];
    }
    
    NSString *hall_discount = [self.dictionaryDetail objectForKey:SymphoxAPIParam_hall_discount];
    if (hall_discount && [hall_discount isEqual:[NSNull null]] == NO && [hall_discount length] > 0)
    {
        [self.labelDiscount setText:hall_discount];
        [self.labelDiscount setHidden:NO];
    }
    else
    {
        [self.labelDiscount setHidden:YES];
    }
    
    // Images and pageControl
    NSArray *imagePaths = [self.dictionaryDetail objectForKey:SymphoxAPIParam_img_url];
    if (imagePaths && [imagePaths isEqual:[NSNull null]] == NO)
    {
        self.arrayImagePath = imagePaths;
        [self.collectionViewImage reloadData];
        if ([self.arrayImagePath count] > 1)
        {
            [self.pageControlImage setNumberOfPages:[self.arrayImagePath count]];
            [self.pageControlImage setHidden:NO];
        }
        else if ([self.arrayImagePath count] > 0)
        {
            [self.pageControlImage setHidden:YES];
        }
        [self.collectionViewImage setHidden:NO];
    }
    else
    {
        [self.collectionViewImage setHidden:YES];
        [self.pageControlImage setHidden:YES];
    }
    
    NSString *marketName = [self.dictionaryDetail objectForKey:SymphoxAPIParam_market_name];
    if (marketName)
    {
        [self.labelMarketing setText:marketName];
        [self.labelMarketing setHidden:NO];
    }
    else
    {
        [self.labelMarketing setText:@""];
        [self.labelMarketing setHidden:YES];
    }
    
    NSString *productName = [self.dictionaryDetail objectForKey:SymphoxAPIParam_name];
    if (productName)
    {
        [self.labelProductName setText:productName];
        [self.labelProductName setHidden:NO];
    }
    else
    {
        [self.labelProductName setText:@""];
        [self.labelProductName setHidden:YES];
    }
    
    NSString *promotion = [self.dictionaryDetail objectForKey:SymphoxAPIParam_campaign_discount];
    if (promotion && [promotion isEqual:[NSNull null]] == NO && [promotion length] > 0)
    {
        [self.viewPromotion setPromotion:promotion];
        [self.viewPromotion setHidden:NO];
    }
    else
    {
        [self.viewPromotion.labelPromotion setText:@""];
        [self.viewPromotion setHidden:YES];
    }
    
    NSNumber *originPrice = [self.dictionaryDetail objectForKey:SymphoxAPIParam_market_price];
    if (originPrice && [originPrice isEqual:[NSNull null]] == NO)
    {
        self.labelOriginPrice.price = originPrice;
        [self.labelOriginPrice setHidden:NO];
    }
    else
    {
        self.labelOriginPrice.price = nil;
        [self.labelOriginPrice setHidden:YES];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSDictionary *dictionaryPrice = [self.dictionaryDetail objectForKey:SymphoxAPIParam_price];
    if (dictionaryPrice && [dictionaryPrice isEqual:[NSNull null]] == NO)
    {
        if (self.viewPoint)
        {
            NSString *stringPoint = nil;
            NSDictionary *dictionary = [dictionaryPrice objectForKey:SymphoxAPIParam_01];
            if (dictionary && [dictionary isEqual:[NSNull null]] == NO)
            {
                NSNumber *point = [dictionary objectForKey:SymphoxAPIParam_point];
                if (point && [point isEqual:[NSNull null]] == NO)
                {
                    stringPoint = [formatter stringFromNumber:point];
                }
            }
            if (stringPoint)
            {
                self.viewPoint.labelR.textColor = [UIColor orangeColor];
            }
            else
            {
                stringPoint = @"－－";
                self.viewPoint.labelR.textColor = [UIColor lightGrayColor];
            }
            NSString *totalString = [NSString stringWithFormat:@"%@%@", stringPoint, [LocalizedString Point]];
            self.viewPoint.labelR.text = totalString;
        }
        if (self.viewPointCash)
        {
            NSString *stringPoint = nil;
            NSString *stringCash = nil;
            NSDictionary *dictionary = [dictionaryPrice objectForKey:SymphoxAPIParam_02];
            if (dictionary && [dictionary isEqual:[NSNull null]] == NO)
            {
                NSNumber *point = [dictionary objectForKey:SymphoxAPIParam_point];
                if (point && [point isEqual:[NSNull null]] == NO)
                {
                    stringPoint = [formatter stringFromNumber:point];
                }
                NSNumber *cash = [dictionary objectForKey:SymphoxAPIParam_cash];
                if (cash && [cash isEqual:[NSNull null]] == NO)
                {
                    stringCash = [formatter stringFromNumber:cash];
                }
            }
            
            NSString *stringPointWithSuffix = nil;
            if (stringPoint)
            {
                stringPointWithSuffix = [NSString stringWithFormat:@"%@%@", stringPoint, [LocalizedString Point]];
            }
            NSString *stringCashWithPrefix = nil;
            if (stringCash)
            {
                stringCashWithPrefix = [NSString stringWithFormat:@"＄%@", stringCash];
            }
            NSString *totalString = nil;
            if (stringPoint || stringCash)
            {
                totalString = [NSString stringWithFormat:@"%@＋%@", stringPointWithSuffix, stringCashWithPrefix];
                self.viewPointCash.labelR.textColor = [UIColor orangeColor];
            }
            else
            {
                totalString = @"－－";
                self.viewPointCash.labelR.textColor = [UIColor lightGrayColor];
            }
            self.viewPointCash.labelR.text = totalString;
        }
        if (self.labelPrice)
        {
            NSNumber *cash = nil;
            NSDictionary *dictionary = [dictionaryPrice objectForKey:SymphoxAPIParam_03];
            if (dictionary && [dictionary isEqual:[NSNull null]] == NO)
            {
                cash = [dictionary objectForKey:SymphoxAPIParam_cash];
            }
            if (cash && [cash isEqual:[NSNull null]] == NO)
            {
                self.labelPrice.price = cash;
                [self.labelPrice setHidden:NO];
            }
            else
            {
                [self.labelPrice setHidden:YES];
            }
        }
    }
    
    BOOL shouldShowFreePoint = NO;
    NSDictionary *dictionaryFreePoint = [self.dictionaryDetail objectForKey:SymphoxAPIParam_free_point];
    if (dictionaryFreePoint && [dictionaryFreePoint isEqual:[NSNull null]] == NO)
    {
        NSNumber *numberFeedbackPoint = [dictionaryFreePoint objectForKey:SymphoxAPIParam_point];
        if (numberFeedbackPoint && [numberFeedbackPoint isEqual:[NSNull null]] == NO && [numberFeedbackPoint unsignedIntegerValue] > 0)
        {
            
            NSString *stringPoint = [formatter stringFromNumber:numberFeedbackPoint];
            NSString *stringDesc = [NSString stringWithFormat:[LocalizedString FeedbackPointUpTo_S], stringPoint];
            NSRange range = [stringDesc rangeOfString:stringPoint];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringDesc];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
            NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithAttributedString:attrString];
            
            NSNumber *raise = [dictionaryFreePoint objectForKey:SymphoxAPIParam_raise];
            if (raise && [raise isEqual:[NSNull null]] == NO && [raise boolValue])
            {
                NSString *string = [NSString stringWithFormat:@" %@", [LocalizedString RaiseFreePoint]];
                [totalString appendAttributedString:[[NSAttributedString alloc] initWithString:string]];
            }
            
            NSNumber *multiple = [dictionaryFreePoint objectForKey:SymphoxAPIParam_multiple];
            if (multiple && [multiple isEqual:[NSNull null]] == NO && [multiple integerValue] > 0)
            {
                NSString *string = [NSString stringWithFormat:@" %@", [NSString stringWithFormat:[LocalizedString _I_TimesFreePoint], (long)[multiple integerValue]]];
                [totalString appendAttributedString:[[NSAttributedString alloc] initWithString:string]];
            }
            [self.viewPointFeedback.labelL setAttributedText:totalString];
            shouldShowFreePoint = YES;
        }
    }
    if (shouldShowFreePoint)
    {
        [self.viewPointFeedback setHidden:NO];
    }
    else
    {
        [self.viewPointFeedback.labelL setText:@""];
        [self.viewPointFeedback setHidden:YES];
    }
    
    NSArray *arraySpec = [self.dictionaryDetail objectForKey:SymphoxAPIParam_standard];
    if (arraySpec && [arraySpec isEqual:[NSNull null]] == NO && [arraySpec count] > 0)
    {
        self.viewChooseSpec.hidden = NO;
        for (NSInteger index = 0; index < [arraySpec count]; index++)
        {
            NSDictionary *dictionary = [arraySpec objectAtIndex:index];
            NSNumber *productId = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
            if ([productId isEqualToNumber:self.productIdentifier])
            {
                self.specIndex = index;
                break;
            }
        }
    }
    else
    {
        self.viewChooseSpec.hidden = YES;
    }
    
//    NSArray *arrayNotice = [self.dictionaryDetail objectForKey:SymphoxAPIParam_attention];
    NSArray *arrayNotice = [NSArray arrayWithObjects:[LocalizedString ProductDetailNotice], nil];
    if (arrayNotice && [arrayNotice isEqual:[NSNull null]] == NO && [arrayNotice count] > 0)
    {
        for (NSString *stringNotice in arrayNotice)
        {
            if ([stringNotice isEqual:[NSNull null]])
                continue;
            ImageTextView *view = [[ImageTextView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor clearColor];
            UIImage *image = [UIImage imageNamed:@"sho_ico_warring"];
            if (image)
            {
                view.imageViewIcon.image = image;
            }
            [view.labelText setText:stringNotice];
            [self.arrayViewNotice addObject:view];
            [self.scrollView addSubview:view];
        }
    }
    
    if (self.labelAdText)
    {
        BOOL shouldShow = NO;
        NSString *stringAdTest = [self.dictionaryDetail objectForKey:SymphoxAPIParam_ad_text];
        if (stringAdTest && [stringAdTest isEqual:[NSNull null]] == NO && [stringAdTest length] > 0)
        {
//            NSData *data = [stringAdTest dataUsingEncoding:NSUTF8StringEncoding];
//            NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
            NSAttributedString *attrString = [self attributedStringFromHtmlString:stringAdTest];
            if (attrString)
            {
                self.labelAdText.attributedString = attrString;
                shouldShow = YES;
            }
            [self.webViewAdText loadHTMLString:stringAdTest baseURL:nil];
        }
//        [self.labelAdText setHidden:!shouldShow];
        [self.labelAdText setHidden:YES];
    }
    
    if (self.viewIntroTitle && self.labelIntro)
    {
        BOOL shouldShow = NO;
        NSDictionary *dictionary = [self.dictionaryDetail objectForKey:SymphoxAPIParam_description];
        if (dictionary && [dictionary isEqual:[NSNull null]] == NO && [dictionary count] > 0)
        {
            NSString *text = [dictionary objectForKey:SymphoxAPIParam_text];
            if (text && [text isEqual:[NSNull null]] == NO && [text length] > 0)
            {
                NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
                if (attrString)
                {
                    self.labelIntro.attributedString = attrString;
                    shouldShow = YES;
                }
                [self.webViewIntro loadHTMLString:text baseURL:nil];
            }
            NSArray *arrayImage = [dictionary objectForKey:SymphoxAPIParam_img_url];
            if (arrayImage && [arrayImage isEqual:[NSNull null]] == NO && [arrayImage count] > 0)
            {
                UIImage *transparent = [UIImage imageNamed:@"transparent"];
                for (NSInteger index = 0; index < [arrayImage count]; index++)
                {
                    NSString *imagePath = [arrayImage objectAtIndex:index];
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
                    button.tag = index;
                    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
                    [button sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal placeholderImage:transparent options:SDWebImageAllowInvalidSSLCertificates];
                    [button addTarget:self action:@selector(buttonIntroImagePressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrollView addSubview:button];
                    [self.arrayIntroImageView addObject:button];
                }
            }
        }
//        [self.viewIntroTitle setHidden:!shouldShow];
//        [self.labelIntro setHidden:!shouldShow];
        [self.viewIntroTitle setHidden:!shouldShow];
        [self.labelIntro setHidden:YES];
    }
    
    if (self.viewSpecTitle && self.labelSpec)
    {
        BOOL shouldShow = NO;
        NSDictionary *dictionary = [self.dictionaryDetail objectForKey:SymphoxAPIParam_specification];
        if (dictionary && [dictionary isEqual:[NSNull null]] == NO && [dictionary count] > 0)
        {
            NSString *text = [dictionary objectForKey:SymphoxAPIParam_text];
            if (text && [text isEqual:[NSNull null]] == NO && [text length] > 0)
            {
                NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
                if (attrString)
                {
                    self.labelSpec.attributedString = attrString;
                    shouldShow = YES;
                }
                [self.webViewSpec loadHTMLString:text baseURL:nil];
            }
            NSArray *arrayImage = [dictionary objectForKey:SymphoxAPIParam_img_url];
            if (arrayImage && [arrayImage isEqual:[NSNull null]] == NO && [arrayImage count] > 0)
            {
                UIImage *transparent = [UIImage imageNamed:@"transparent"];
                for (NSInteger index = 0; index < [arrayImage count]; index++)
                {
                    NSString *imagePath = [arrayImage objectAtIndex:index];
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
                    button.tag = index;
                    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
                    [button sd_setImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal placeholderImage:transparent options:SDWebImageAllowInvalidSSLCertificates];
                    [button addTarget:self action:@selector(buttonSpecImagePressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrollView addSubview:button];
                    [self.arraySpecImageView addObject:button];
                }
            }
        }
        [self.viewSpecTitle setHidden:!shouldShow];
//        [self.labelSpec setHidden:!shouldShow];
        [self.labelSpec setHidden:YES];
    }
    
    if (self.viewRemarkTitle && self.labelRemark)
    {
        BOOL shouldShow = NO;
        NSString *text = [self.dictionaryDetail objectForKey:SymphoxAPIParam_remark];
        if (text && [text isEqual:[NSNull null]] == NO && [text length] > 0)
        {
            NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
            if (attrString)
            {
                self.labelRemark.attributedString = attrString;
                shouldShow = YES;
            }
            [self.webViewRemark loadHTMLString:text baseURL:nil];
        }
        [self.viewRemarkTitle setHidden:!shouldShow];
//        [self.labelRemark setHidden:!shouldShow];
        [self.labelRemark setHidden:YES];
    }
    
    if (self.bottomBar)
    {
        BOOL isInvalid = NO;
        NSString *textSoldOut = [LocalizedString SoldOut];
        NSString *textPurchase = [LocalizedString Purchase];
        NSArray *arrayShopping = [self.dictionaryDetail objectForKey:SymphoxAPIParam_shopping];
        if (arrayShopping && [arrayShopping isEqual:[NSNull null]] == NO)
        {
            for (NSDictionary *dictionary in arrayShopping)
            {
                NSNumber *numberType = [dictionary objectForKey:SymphoxAPIParam_type];
                if (numberType && [numberType isEqual:[NSNull null]] == NO)
                {
                    switch ([numberType integerValue]) {
                        case (-1):
                        {
                            // Sold out
                            NSString *text = [dictionary objectForKey:SymphoxAPIParam_text];
                            if (text && [text isEqual:[NSNull null]] == NO && [text length] > 0)
                            {
                                textSoldOut = text;
                            }
                            isInvalid = YES;
                        }
                            break;
                        case 3:
                        {
                            // Directly purchase
                            NSString *text = [dictionary objectForKey:SymphoxAPIParam_text];
                            if (text && [text isEqual:[NSNull null]] == NO && [text length] > 0)
                            {
                                textPurchase = text;
                            }
                        }
                            break;
                        default:
                        {
                            [self.arrayCartType addObject:dictionary];
                        }
                            break;
                    }
                }
            }
        }
        if ([self.arrayCartType count] == 0)
        {
            [self.bottomBar.buttonAddToCart setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
//            [self.bottomBar.buttonAddToCart setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.bottomBar.buttonAddToCart setEnabled:NO];
            self.bottomBar.separator.hidden = YES;
            self.bottomBar.buttonPurchaseOnly.hidden = NO;
        }
        else
        {
            [self.bottomBar.buttonAddToCart setBackgroundColor:[UIColor clearColor]];
//            [self.bottomBar.buttonAddToCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.bottomBar.buttonAddToCart setEnabled:YES];
            self.bottomBar.separator.hidden = NO;
            self.bottomBar.buttonPurchaseOnly.hidden = YES;
        }
        [self.bottomBar setIsProductInvalid:isInvalid];
        [self.bottomBar.buttonPurchase setTitle:textPurchase forState:UIControlStateNormal];
    }
}

- (NSAttributedString *)attributedStringFromHtmlString:(NSString *)html
{
    // Load HTML data
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create attributed string from HTML
    CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        // the block is being called for an entire paragraph, so we check the individual elements
        
        for (DTHTMLElement *oneChildElement in element.childNodes)
        {
            // if an element is larger than twice the font size put it in it's own block
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }
    };
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                                    @"Times New Roman", DTDefaultFontFamily,  @"purple", DTDefaultLinkColor, @"red", DTDefaultLinkHighlightColor, callBackBlock, DTWillFlushBlockCallBack, nil];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    return string;
}

- (void)retrieveTermsForType:(TermType)type
{
    __weak ProductDetailViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_terms];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_03", SymphoxAPIParam_txid, [NSString stringWithFormat:@"%lu", (unsigned long)type], SymphoxAPIParam_type, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            NSString *string = [[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding];
            NSLog(@"retrieveTermsForType - string:\n%@", string);
            if ([weakSelf processTermsData:resultObject])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf layoutCustomSubviews];
                });
            }
            else
            {
                NSLog(@"Cannot process terms data.");
            }
        }
        else
        {
            NSLog(@"error:\n%@", error);
        }
        
    }];
}

- (BOOL)processTermsData:(id)data
{
    BOOL success = NO;
    if ([data isKindOfClass:[NSData class]])
    {
        NSData *sourceData = (NSData *)data;
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:sourceData options:0 error:&error];
        if (error == nil && jsonObject)
        {
            if ([jsonObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *)jsonObject;
                NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
                if (result && [result integerValue] == 0)
                {
                    NSString *content = [dictionary objectForKey:SymphoxAPIParam_content];
                    if (content && [content isEqual:[NSNull null]] == NO && [content length] > 0)
                    {
                        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
                        if (attrString)
                        {
                            self.labelShippingAndWarrenty.attributedString = attrString;
                            success = YES;
                        }
                        [self.webViewShippingAndWarrenty loadHTMLString:content baseURL:nil];
                    }
                }
            }
        }
    }
    [self.viewShippingAndWarrentyTitle setHidden:!success];
//    [self.labelShippingAndWarrenty setHidden:!success];
    [self.labelShippingAndWarrenty setHidden:YES];
    return success;
}

- (void)showCartTypeSheetForDirectlyPurchase:(BOOL)directlyPurchase
{
    if ([self.arrayCartType count] == 0)
    {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString AddToCart] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *dictionary in self.arrayCartType)
    {
        CartType type = CartTypeTotal;
        NSNumber *numberType = [dictionary objectForKey:SymphoxAPIParam_type];
        NSString *title = nil;
        NSString *text = [dictionary objectForKey:SymphoxAPIParam_text];
        if (text && [text isEqual:[NSNull null]] == NO && [text length] > 0)
        {
            title = text;
        }
        switch ([numberType integerValue]) {
            case CartTypeCommonDelivery:
            {
                // Common delivery
                if (title == nil)
                {
                    title = [LocalizedString CommonDelivery];
                }
                type = CartTypeCommonDelivery;
            }
                break;
            case CartTypeStorePickup:
            {
                // Convenience Store
                if (title == nil)
                {
                    title = [LocalizedString StorePickUp];
                }
                type = CartTypeStorePickup;
            }
                break;
            case CartTypeFastDelivery:
            {
                // Fast delivery
                if (title == nil)
                {
                    title = [LocalizedString FastDelivery];
                }
                type = CartTypeFastDelivery;
            }
                break;
            default:
                break;
        }
        __weak ProductDetailViewController *weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf addToCart:type shouldShowAlert:!directlyPurchase];
            if (directlyPurchase)
            {
                [weakSelf presentCartViewForType:type];
                
                NSString * name = [self.dictionaryDetail objectForKey:SymphoxAPIParam_cpdt_name];
                NSNumber * productId = [self.dictionaryDetail objectForKey:SymphoxAPIParam_cpdt_num];
                [gaTracker send:[[GAIDictionaryBuilder
                                  createEventWithCategory:[EventLog twoString:self.title _:logPara_加入購物車]
                                  action:[EventLog threeString:[EventLog cartTypeInString:type] _:[productId stringValue] _:name]
                                  label:nil
                                  value:nil] build]];
            }
        }];
        [alertController addAction:action];
    }
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addToCart:(CartType)type shouldShowAlert:(BOOL)shouldShowAlert
{
    NSString *title = @"";
    switch (type) {
        case CartTypeCommonDelivery:
        {
            title = [LocalizedString CommonDelivery];
        }
            break;
        case CartTypeStorePickup:
        {
            title = [LocalizedString StorePickUp];
        }
            break;
        case CartTypeFastDelivery:
        {
            title = [LocalizedString FastDelivery];
        }
            break;
        default:
            break;
    }
    NSNumber *specificSpecId = nil;
    NSArray *arraySpec = [self.dictionaryDetail objectForKey:SymphoxAPIParam_standard];
    if (arraySpec && [arraySpec isEqual:[NSNull null]] == NO && self.specIndex > 0 && self.specIndex < arraySpec.count)
    {
        NSDictionary *dictionarySpec = [arraySpec objectAtIndex:self.specIndex];
        NSNumber *cpdt_num = [dictionarySpec objectForKey:SymphoxAPIParam_cpdt_num];
        if (cpdt_num && [cpdt_num isEqual:[NSNull null]] == NO)
        {
            specificSpecId = cpdt_num;
        }
    }
    NSMutableDictionary *product = [self.dictionaryCommon mutableCopy];
    if (product == nil)
    {
        product = [self dictionaryCommonFromDetail:self.dictionaryDetail];
    }
    if (product)
    {
        if (specificSpecId)
        {
            [product setObject:specificSpecId forKey:SymphoxAPIParam_cpdt_num];
        }
        [self addProduct:product toCartForType:type];
        
        NSString * name = [self.dictionaryDetail objectForKey:SymphoxAPIParam_cpdt_name];
        NSNumber * productId = [self.dictionaryDetail objectForKey:SymphoxAPIParam_cpdt_num];
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:self.title _:logPara_加入購物車]
                          action:[EventLog threeString:[EventLog cartTypeInString:type] _:[productId stringValue] _:name]
                          label:nil
                          value:nil] build]];
        
        if (shouldShowAlert)
        {
            NSString *message = [NSString stringWithFormat:[LocalizedString AddedTo_S_], title];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)addProduct:(NSDictionary *)dictionaryProduct toCartForType:(CartType)type
{
    [[TMInfoManager sharedManager] addProduct:dictionaryProduct toCartForType:type];
}

- (NSMutableDictionary *)dictionaryCommonFromDetail:(NSDictionary *)dictionary
{
    if (dictionary == nil)
        return nil;
    NSMutableDictionary *dictionaryCommon = [NSMutableDictionary dictionary];
    NSNumber *cpdt_num = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
    if (cpdt_num == nil)
        return nil;
    [dictionaryCommon setObject:cpdt_num forKey:SymphoxAPIParam_cpdt_num];
    NSNumber *cpro_price = [dictionary objectForKey:SymphoxAPIParam_market_price];
    if (cpro_price)
    {
        [dictionaryCommon setObject:cpro_price forKey:SymphoxAPIParam_cpro_price];
    }
    NSString *cpdt_name = [dictionary objectForKey:SymphoxAPIParam_name];
    if (cpdt_name)
    {
        [dictionaryCommon setObject:cpdt_name forKey:SymphoxAPIParam_cpdt_name];
    }
    NSString *market_name = [dictionary objectForKey:SymphoxAPIParam_market_name];
    if (market_name)
    {
        [dictionaryCommon setObject:market_name forKey:SymphoxAPIParam_market_name];
    }
    NSString *quick = [dictionary objectForKey:SymphoxAPIParam_is_quick];
    if (quick && [quick isKindOfClass:[NSString class]])
    {
        NSNumber *numberQuick = [NSNumber numberWithBool:[quick boolValue]];
        [dictionaryCommon setObject:numberQuick forKey:SymphoxAPIParam_quick];
    }
    
    NSNumber *point01 = nil;
    NSNumber *price02 = nil;
    NSNumber *point02 = nil;
    NSNumber *price03 = nil;
    NSDictionary *price = [dictionary objectForKey:SymphoxAPIParam_price];
    if (price && [price isEqual:[NSNull null]] == NO)
    {
        NSDictionary *purePoint = [price objectForKey:SymphoxAPIParam_01];
        if (purePoint && [purePoint isEqual:[NSNull null]] == NO)
        {
            point01 = [purePoint objectForKey:SymphoxAPIParam_point];
        }
        NSDictionary *pointAndCash = [price objectForKey:SymphoxAPIParam_02];
        if (pointAndCash && [pointAndCash isEqual:[NSNull null]] == NO)
        {
            price02 = [pointAndCash objectForKey:SymphoxAPIParam_cash];
            point02 = [pointAndCash objectForKey:SymphoxAPIParam_point];
        }
        NSDictionary *pureCash = [price objectForKey:SymphoxAPIParam_03];
        if (pureCash && [pureCash isEqual:[NSNull null]] == NO)
        {
            price03 = [pureCash objectForKey:SymphoxAPIParam_cash];
        }
    }
    if (point01)
    {
        [dictionaryCommon setObject:point01 forKey:SymphoxAPIParam_point01];
    }
    if (price02)
    {
        [dictionaryCommon setObject:price02 forKey:SymphoxAPIParam_price02];
    }
    if (point02)
    {
        [dictionaryCommon setObject:point02 forKey:SymphoxAPIParam_point02];
    }
    if (price03)
    {
        [dictionaryCommon setObject:price03 forKey:SymphoxAPIParam_price03];
    }
    
    NSArray *arrayImagePath = [dictionary objectForKey:SymphoxAPIParam_img_url];
    if (arrayImagePath && [arrayImagePath isEqual:[NSNull null]] == NO && [arrayImagePath count] > 0)
    {
        NSString *prod_pic_url = [arrayImagePath objectAtIndex:0];
        [dictionaryCommon setObject:prod_pic_url forKey:SymphoxAPIParam_prod_pic_url];
    }
    
    NSString *is_delivery_store = [dictionary objectForKey:SymphoxAPIParam_is_store];
    if (is_delivery_store)
    {
        [dictionaryCommon setObject:is_delivery_store forKey:SymphoxAPIParam_is_delivery_store];
    }
    
    NSArray *shopping = [dictionary objectForKey:SymphoxAPIParam_shopping];
    NSNumber *normal_cart = [NSNumber numberWithBool:NO];
    NSNumber *to_store_cart = [NSNumber numberWithBool:NO];
    NSNumber *fast_delivery_cart = [NSNumber numberWithBool:NO];
    NSNumber *single_shopping_cart = [NSNumber numberWithBool:NO];
    if (shopping && [shopping isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *single in shopping)
        {
            NSNumber *numberType = [single objectForKey:SymphoxAPIParam_type];
            switch ([numberType integerValue]) {
                case 0:
                {
                    normal_cart = [NSNumber numberWithBool:YES];
                }
                    break;
                case 1:
                {
                    to_store_cart = [NSNumber numberWithBool:YES];
                }
                    break;
                case 2:
                {
                    fast_delivery_cart = [NSNumber numberWithBool:YES];
                }
                    break;
                case 4:
                {
                    single_shopping_cart = [NSNumber numberWithBool:YES];
                }
                    break;
                default:
                    break;
            }
        }
    }
    [dictionaryCommon setObject:normal_cart forKey:SymphoxAPIParam_normal_cart];
    [dictionaryCommon setObject:to_store_cart forKey:SymphoxAPIParam_to_store_cart];
    [dictionaryCommon setObject:fast_delivery_cart forKey:SymphoxAPIParam_fast_delivery_cart];
    [dictionaryCommon setObject:single_shopping_cart forKey:SymphoxAPIParam_single_shopping_cart];
    
    NSDictionary *freepoint = [dictionary objectForKey:SymphoxAPIParam_free_point];
    if (freepoint && [freepoint isEqual:[NSNull null]] == NO)
    {
        NSNumber *number = [freepoint objectForKey:SymphoxAPIParam_point];
        [dictionaryCommon setObject:number forKey:SymphoxAPIParam_freepoint];
    }
    
    NSMutableArray *seekInstallmentList = [NSMutableArray array];
    NSArray *installment = [dictionary objectForKey:SymphoxAPIParam_installment];
    if (installment && [installment isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *single in installment)
        {
            NSMutableDictionary *singleInstallment = [NSMutableDictionary dictionary];
            NSNumber *installment_num = [single objectForKey:SymphoxAPIParam_term];
            if (installment_num)
            {
                [singleInstallment setObject:installment_num forKey:SymphoxAPIParam_installment_num];
            }
            NSNumber *installment_price = [single objectForKey:SymphoxAPIParam_price];
            if (installment_price)
            {
                [singleInstallment setObject:installment_price forKey:SymphoxAPIParam_installment_price];
            }
            NSNumber *cathaycard_only = [single objectForKey:SymphoxAPIParam_cathay_only];
            if (cathaycard_only)
            {
                [singleInstallment setObject:cathaycard_only forKey:SymphoxAPIParam_cathaycard_only];
            }
            [seekInstallmentList addObject:singleInstallment];
        }
    }
    [dictionaryCommon setObject:seekInstallmentList forKey:SymphoxAPIParam_seekInstallmentList];
    
    return dictionaryCommon;
}

- (NSArray *)cartsAvailableToAdd
{
    NSMutableArray *arrayCarts = [NSMutableArray array];
    for (NSDictionary *dictionary in self.arrayCartType)
    {
        CartType type = CartTypeTotal;
        NSNumber *numberType = [dictionary objectForKey:SymphoxAPIParam_type];
        NSString *title = nil;
        switch ([numberType integerValue]) {
            case CartTypeCommonDelivery:
            {
                // Common delivery
                title = [LocalizedString CommonDelivery];
                type = CartTypeCommonDelivery;
                [arrayCarts addObject:numberType];
            }
                break;
            case CartTypeStorePickup:
            {
                // Convenience Store
                title = [LocalizedString StorePickUp];
                type = CartTypeStorePickup;
                [arrayCarts addObject:numberType];
            }
                break;
            case CartTypeFastDelivery:
            {
                // Fast delivery
                title = [LocalizedString FastDelivery];
                type = CartTypeFastDelivery;
                [arrayCarts addObject:numberType];
            }
                break;
            default:
                break;
        }
    }
    return arrayCarts;
}

- (void)presentCartViewForType:(CartType)type
{
    CartViewController *viewController = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:[NSBundle mainBundle]];
    if (type == CartTypeDirectlyPurchase)
    {
        viewController.title = [LocalizedString Purchase];
    }
    else
    {
        viewController.title = [LocalizedString ShoppingCart];
    }
    viewController.currentType = type;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)requestBackToMain
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_ResetRootViewController object:self];
}

- (void)presentShareView
{
    NSString *urlString = [NSString stringWithFormat:@"https://m.treemall.com.tw/goods/product?cpdtnum=%@", [self.productIdentifier stringValue]];
    NSURL *url = [NSURL URLWithString:urlString];
    UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:url] applicationActivities:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - Actions

- (void)buttonExchangeDescPressed:(id)sender
{
    ExchangeDescriptionViewController *viewController = [[ExchangeDescriptionViewController alloc] initWithNibName:nil bundle:nil];
    viewController.preferredContentSize = CGSizeMake(280.0, 300.0);
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *presentationController = viewController.popoverPresentationController;
    presentationController.sourceView = self.view;
    presentationController.sourceRect = CGRectMake((self.view.frame.size.width - viewController.preferredContentSize.width - 20)/2, (self.view.frame.size.height)/2, 1.0, 1.0);
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    presentationController.delegate = self;
    
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:self.title _:logPara_兌換說明]
                      action:logPara_點擊
                      label:nil
                      value:nil] build]];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)buttonInstallmentCalPressed:(id)sender
{
    NSArray *arrayInstallment = [self.dictionaryDetail objectForKey:SymphoxAPIParam_installment];
    if (arrayInstallment == nil || [arrayInstallment isEqual:[NSNull null]] || [arrayInstallment count] == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString ThisProductNoInstallment] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    InstallmentDescriptionViewController *viewController = [[InstallmentDescriptionViewController alloc] initWithNibName:nil bundle:nil];
    viewController.arrayInstallment = arrayInstallment;
    viewController.preferredContentSize = CGSizeMake(280.0, 320.0);
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *presentationController = viewController.popoverPresentationController;
    presentationController.sourceView = self.view;
    presentationController.sourceRect = CGRectMake((self.view.frame.size.width - viewController.preferredContentSize.width - 20)/2, (self.view.frame.size.height)/2, 1.0, 1.0);
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    presentationController.delegate = self;
    
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:self.title _:logPara_分期試算]
                      action:logPara_點擊
                      label:nil
                      value:nil] build]];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)buttonLinkPressed:(id)sender
{
    if ([sender isKindOfClass:[DTLinkButton class]] == NO)
        return;
    DTLinkButton *buttonLink = (DTLinkButton *)sender;
    NSURL *url = buttonLink.URL;
    if (url == nil)
        return;
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)buttonIntroImagePressed:(id)sender
{
    if (sender == nil)
        return;
    UIButton *button = (UIButton *)sender;
    NSInteger imageIndex = button.tag;
    NSDictionary *dictionary = [self.dictionaryDetail objectForKey:SymphoxAPIParam_description];
    if (dictionary && [dictionary isEqual:[NSNull null]] == NO && [dictionary count] > 0)
    {
        NSArray *arrayImage = [dictionary objectForKey:SymphoxAPIParam_img_url];
        if (arrayImage && [arrayImage isEqual:[NSNull null]] == NO && [arrayImage count] > 0)
        {
            SingleMediaDetailViewController *viewController = [[SingleMediaDetailViewController alloc] initWithNibName:@"SingleMediaDetailViewController" bundle:[NSBundle mainBundle]];
            viewController.aryData = [NSMutableArray arrayWithArray:arrayImage];
            [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            if (imageIndex < [arrayImage count])
            {
                viewController.idxStart = imageIndex;
            }
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}

- (void)buttonSpecImagePressed:(id)sender
{
    if (sender == nil)
        return;
    UIButton *button = (UIButton *)sender;
    NSInteger imageIndex = button.tag;
    NSDictionary *dictionary = [self.dictionaryDetail objectForKey:SymphoxAPIParam_specification];
    if (dictionary && [dictionary isEqual:[NSNull null]] == NO && [dictionary count] > 0)
    {
        NSArray *arrayImage = [dictionary objectForKey:SymphoxAPIParam_img_url];
        if (arrayImage && [arrayImage isEqual:[NSNull null]] == NO && [arrayImage count] > 0)
        {
            SingleMediaDetailViewController *viewController = [[SingleMediaDetailViewController alloc] initWithNibName:@"SingleMediaDetailViewController" bundle:[NSBundle mainBundle]];
            viewController.aryData = [NSMutableArray arrayWithArray:arrayImage];
            [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            if (imageIndex < [arrayImage count])
            {
                viewController.idxStart = imageIndex;
            }
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}

- (void)buttonFunctionPressed:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak ProductDetailViewController *weakSelf = self;
    UIAlertAction *actionBackToMain = [UIAlertAction actionWithTitle:[LocalizedString BackToMain] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf requestBackToMain];
    }];
    UIAlertAction *actionShare = [UIAlertAction actionWithTitle:[LocalizedString Share] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf presentShareView];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionBackToMain];
    [alertController addAction:actionShare];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)buttonItemCartPressed:(id)sender
{
    // Should check user state here.
    if ([TMInfoManager sharedManager].userIdentifier == nil)
    {
        LoginViewController *viewControllerLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerLogin];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    CartViewController *viewController = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:[NSBundle mainBundle]];
    viewController.title = [LocalizedString ShoppingCart];
    viewController.currentType = CartTypeCommonDelivery;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)linkLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        DTLinkButton *button = (id)[gestureRecognizer view];
        button.highlighted = NO;
        
        if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actionOpenInSafari = [UIAlertAction actionWithTitle:[LocalizedString OpenInSafari] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [[UIApplication sharedApplication] openURL:button.URL];
            }];
            UIAlertAction *actionCopyLink = [UIAlertAction actionWithTitle:[LocalizedString CopyLink] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                NSString *urlString = [button.URL absoluteString];
                if (urlString)
                {
                    [[UIPasteboard generalPasteboard] setString:[button.URL absoluteString]];
                }
            }];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleDestructive handler:nil];
            [alertController addAction:actionOpenInSafari];
            [alertController addAction:actionCopyLink];
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - ProductDetailBottomBarDelegate

- (void)productDetailBottomBar:(ProductDetailBottomBar *)bar didSelectFavoriteBySender:(id)sender
{
    NSString *message = nil;
    NSDictionary *product = self.dictionaryCommon;
    if (product == nil)
    {
        product = [self dictionaryCommonFromDetail:self.dictionaryDetail];
    }
    if (product)
    {
        message = [[TMInfoManager sharedManager] addProductToFavorite:product];
    }
    if (message)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
        NSString * name = [product objectForKey:SymphoxAPIParam_cpdt_name];
        NSNumber * productId = [product objectForKey:SymphoxAPIParam_cpdt_num];
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:self.title _:logPara_加入我的最愛]
                          action:[EventLog twoString:[productId stringValue] _:name]
                          label:nil
                          value:nil] build]];
    }
}

- (void)productDetailBottomBar:(ProductDetailBottomBar *)bar didSelectAddToCartBySender:(id)sender
{
    if ([TMInfoManager sharedManager].userIdentifier == nil)
    {
        // Should login first.
        LoginViewController *viewControllerLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerLogin];
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:self.title _:logPara_加入購物車]
                          action:[EventLog to_:logPara_登入]
                          label:nil
                          value:nil] build]];
        
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    NSArray *arrayCarts = [self cartsAvailableToAdd];
    if ([arrayCarts count] == 1)
    {
        NSNumber *numberType = [arrayCarts objectAtIndex:0];
        NSInteger type = [numberType integerValue];
        [self addToCart:type shouldShowAlert:YES];
    }
    else
    {
        [self showCartTypeSheetForDirectlyPurchase:NO];
    }
}

- (void)productDetailBottomBar:(ProductDetailBottomBar *)bar didSelectPurchaseBySender:(id)sender
{
    if ([TMInfoManager sharedManager].userIdentifier == nil)
    {
        // Should login first.
        LoginViewController *viewControllerLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerLogin];
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:self.title _:logPara_直接購買]
                          action:[EventLog to_:logPara_登入]
                          label:nil
                          value:nil] build]];
        
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    NSArray *arrayCarts = [self cartsAvailableToAdd];
    if ([arrayCarts count] == 0)
    {
        [[TMInfoManager sharedManager] resetCartForType:CartTypeDirectlyPurchase];
        [self addToCart:CartTypeDirectlyPurchase shouldShowAlert:NO];
        [self presentCartViewForType:CartTypeDirectlyPurchase];
    }
    else if ([arrayCarts count] == 1)
    {
        NSNumber *numberType = [arrayCarts objectAtIndex:0];
        NSInteger type = [numberType integerValue];
        [self addToCart:type shouldShowAlert:NO];
        [self presentCartViewForType:type];
    }
    else
    {
        [self showCartTypeSheetForDirectlyPurchase:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = [self.arrayImagePath count];
    return numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductDetailImageCollectionViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < [self.arrayImagePath count])
    {
        NSString *imagePath = [self.arrayImagePath objectAtIndex:indexPath.row];
        cell.imagePath = imagePath;
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat value = targetContentOffset->x / scrollView.frame.size.width;
//    NSLog(@"scrollViewWillEndDragging to [%4.2f]", value);
    NSInteger pageIndex = [[NSNumber numberWithDouble:value] integerValue];
    [self.pageControlImage setCurrentPage:pageIndex];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = collectionView.frame.size;
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

#pragma mark - BorderedDoubleLabelViewDelegate

- (void)didTouchUpInsideBorderedDoubleView:(BorderedDoubleLabelView *)view
{
    if (view == self.viewChooseSpec)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString ChooseSpec] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *arraySpec = [_dictionaryDetail objectForKey:SymphoxAPIParam_standard];
        if (arraySpec == nil || [arraySpec isEqual:[NSNull null]] || [arraySpec count] == 0)
            return;
        __weak ProductDetailViewController *weakSelf = self;
        for (NSInteger index = 0; index < arraySpec.count; index++)
        {
            NSDictionary *dictionary = [arraySpec objectAtIndex:index];
            NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
            if (name == nil || [name isEqual:[NSNull null]])
            {
                name = @"";
            }
            UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                weakSelf.specIndex = index;
            }];
            [alertController addAction:action];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (view == self.viewPointFeedback)
    {
//        NSString *urlString = SymphoxAPI_feedbackPointDetailPage;
        NSString *urlStringFromServer = [[TMInfoManager sharedManager].dictionaryDocuments objectForKey:@"7"];
        if ([urlStringFromServer length] > 0)
        {
            WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
            viewController.title = [LocalizedString FreepointDescription];
            viewController.htmlString = urlStringFromServer;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(buttonLinkPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
    return button;
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL])
        {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    
    CGFloat height = [result integerValue];
    CGRect frame = webView.frame;
    NSLog(@"webViewDidFinishLoad - webView[%li][%4.2f,%4.2f][%@]", (long)webView.tag, webView.frame.size.width, webView.frame.size.height, result);
    frame.size.height = height;
    webView.frame = frame;
    
    [self.view setNeedsLayout];
}

@end
