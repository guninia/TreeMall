//
//  MemberViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "MemberViewController.h"
#import "LocalizedString.h"
#import "TMInfoManager.h"
#import "Definition.h"
#import "APIDefinition.h"
#import "CouponListViewController.h"
#import "OrderListViewController.h"
#import "MemberSettingsViewController.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "WebViewViewController.h"

typedef enum : NSUInteger {
    SectionTitleTagCoupon = 1000,
    SectionTitleTagOrder,
    SectionTitleTagTotal,
} SectionTitleTag;

@interface MemberViewController ()

- (void)refreshContent;
- (void)reconfirmAndLogout;
- (void)resetAllContent;
- (void)retrieveOrderNumberOfStatus;
- (BOOL)processOrderNumberOfStatusData:(id)data;
- (NSString *)greetingsMessage;

- (void)buttonItemLogoutPressed:(id)sender;
- (void)buttonItemQAPressed:(id)sender;
- (void)buttonAdvertisementPressed:(id)sender;

- (void)handlerOfUserPointUpdatedNotification:(NSNotification *)notification;

@end

@implementation MemberViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _arrayOfOrderNumberOfStatus = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:[LocalizedString Logout] style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemLogoutPressed:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    UIImage *image = [UIImage imageNamed:@"men_my_sev_h_info"];
    if (image)
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemQAPressed:)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.viewTitle];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.buttonAdvertisement];
    [self.scrollView addSubview:self.viewPoint];
    [self.scrollView addSubview:self.viewCouponTitle];
//    [self.scrollView addSubview:self.viewTotalCoupon];
    [self.scrollView addSubview:self.viewOrderTitle];
    [self.scrollView addSubview:self.viewProcessing];
    [self.scrollView addSubview:self.viewShipped];
    [self.scrollView addSubview:self.viewReturnReplace];
    
//    NSLog(@"User:\nName: %@\nIdentifier: %li\nEmail: %@\nGender: %li\nEpoint: %li\nEcoupon: %li", [TMInfoManager sharedManager].userName, (long)[[TMInfoManager sharedManager].userIdentifier integerValue], [TMInfoManager sharedManager].userEmail, (long)([TMInfoManager sharedManager].userGender), (long)([[TMInfoManager sharedManager].userEpoint integerValue]), (long)([[TMInfoManager sharedManager].userEcoupon integerValue]));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContent) name:PostNotificationName_UserInformationUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContent) name:PostNotificationName_UserPointUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContent) name:PostNotificationName_UserCouponUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAllContent) name:PostNotificationName_UserLogout object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"MemberViewController - viewWillAppear");
    [self refreshContent];
    [self retrieveOrderNumberOfStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserInformationUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserPointUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserCouponUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserLogout object:nil];
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
    if (self.viewTitle)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, 50.0);
        self.viewTitle.frame = frame;
        originY = self.viewTitle.frame.origin.y + self.viewTitle.frame.size.height;
    }
    if (self.scrollView)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        self.scrollView.frame = frame;
    }
    CGFloat marginH = 8.0;
    originY = 0.0;
    if (self.buttonAdvertisement && [self.buttonAdvertisement isHidden] == NO)
    {
        CGSize sizeText = [[self.buttonAdvertisement titleForState:UIControlStateNormal] boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width - marginH * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.buttonAdvertisement.titleLabel.font, NSFontAttributeName, nil] context:nil].size;
        CGSize sizeButton = CGSizeMake(ceil(sizeText.width + 4), ceil(sizeText.height + 4));
        CGRect frame = CGRectMake(marginH, originY + 5.0, sizeButton.width, sizeButton.height);
        self.buttonAdvertisement.frame = frame;
        originY = self.buttonAdvertisement.frame.origin.y + self.buttonAdvertisement.frame.size.height;
    }
    if (self.viewPoint)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 230.0);
        self.viewPoint.frame = frame;
        originY = self.viewPoint.frame.origin.y + self.viewPoint.frame.size.height;
    }
    if (self.viewCouponTitle)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
        self.viewCouponTitle.frame = frame;
        originY = self.viewCouponTitle.frame.origin.y + self.viewCouponTitle.frame.size.height;
    }
//    if (self.viewTotalCoupon)
//    {
//        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
//        self.viewTotalCoupon.frame = frame;
//        originY = self.viewTotalCoupon.frame.origin.y + self.viewTotalCoupon.frame.size.height;
//    }
    if (self.viewOrderTitle)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
        self.viewOrderTitle.frame = frame;
        originY = self.viewOrderTitle.frame.origin.y + self.viewOrderTitle.frame.size.height + 10.0;;
    }
    NSArray *array = [NSArray arrayWithObjects:self.viewProcessing, self.viewShipped, self.viewReturnReplace, nil];
    NSInteger totalCount = [array count];
    CGFloat viewWidth = ceil(self.scrollView.frame.size.width / totalCount);
    CGFloat maxViewHeight = 0.0;
    for (IconLabelView *view in array)
    {
        CGSize referenceSize = [view referenceSizeForMaxWidth:viewWidth];
        if (referenceSize.height > maxViewHeight)
        {
            maxViewHeight = referenceSize.height;
        }
    }
    for (NSInteger index = 0; index < totalCount; index++)
    {
        IconLabelView *view = [array objectAtIndex:index];
        CGRect frame = CGRectMake(viewWidth * index, originY, viewWidth, maxViewHeight);
        view.frame = frame;
    }
    CGFloat scrollBottom = originY + maxViewHeight + 20.0;
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

- (MemberTitleView *)viewTitle
{
    if (_viewTitle == nil)
    {
        _viewTitle = [[MemberTitleView alloc] initWithFrame:CGRectZero];
        _viewTitle.delegate = self;
    }
    return _viewTitle;
}

- (UIButton *)buttonAdvertisement
{
    if (_buttonAdvertisement == nil)
    {
        _buttonAdvertisement = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonAdvertisement setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buttonAdvertisement.titleLabel setNumberOfLines:0];
        [_buttonAdvertisement.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_buttonAdvertisement.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_buttonAdvertisement.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_buttonAdvertisement setHidden:YES];
        [_buttonAdvertisement addTarget:self action:@selector(buttonAdvertisementPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonAdvertisement;
}

- (MemberPointView *)viewPoint
{
    if (_viewPoint == nil)
    {
        _viewPoint = [[MemberPointView alloc] initWithFrame:CGRectZero];
        _viewPoint.delegate = self;
    }
    return _viewPoint;
}

- (ProductDetailSectionTitleView *)viewCouponTitle
{
    if (_viewCouponTitle == nil)
    {
        _viewCouponTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_icon3"];
        if (image)
        {
            [_viewCouponTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewCouponTitle.viewTitle.labelText setText:[LocalizedString MyCoupon]];
        [_viewCouponTitle.viewTitle.labelText setFont:[UIFont systemFontOfSize:18.0]];
        [_viewCouponTitle.viewTitle.labelText setTextColor:[UIColor colorWithRed:(132.0/255.0) green:(199.0/255.0) blue:(210.0/255.0) alpha:1.0]];
        _viewCouponTitle.delegate = self;
        _viewCouponTitle.userInteractionEnabled = YES;
        _viewCouponTitle.tag = SectionTitleTagCoupon;
    }
    return _viewCouponTitle;
}

//- (BorderedDoubleLabelView *)viewTotalCoupon
//{
//    if (_viewTotalCoupon == nil)
//    {
//        _viewTotalCoupon = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
//        [_viewTotalCoupon.layer setBorderWidth:0.0];
//        [_viewTotalCoupon.labelL setText:[LocalizedString TotalCount]];
//        [_viewTotalCoupon.labelL setFont:[UIFont systemFontOfSize:18.0]];
//        [_viewTotalCoupon.labelL setTextColor:[UIColor darkGrayColor]];
//        [_viewTotalCoupon.labelR setFont:[UIFont systemFontOfSize:18.0]];
//        [_viewTotalCoupon.labelR setTextColor:[UIColor darkGrayColor]];
//    }
//    return _viewTotalCoupon;
//}

- (ProductDetailSectionTitleView *)viewOrderTitle
{
    if (_viewOrderTitle == nil)
    {
        _viewOrderTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_icon1"];
        if (image)
        {
            [_viewOrderTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewOrderTitle.viewTitle.labelText setText:[LocalizedString MyOrder]];
        [_viewOrderTitle.viewTitle.labelText setFont:[UIFont systemFontOfSize:18.0]];
        [_viewOrderTitle.viewTitle.labelText setTextColor:[UIColor colorWithRed:(142.0/255.0) green:(170.0/255.0) blue:(214.0/255.0) alpha:1.0]];
        _viewOrderTitle.delegate = self;
        _viewOrderTitle.userInteractionEnabled = YES;
        _viewOrderTitle.tag = SectionTitleTagOrder;
    }
    return _viewOrderTitle;
}

- (IconLabelView *)viewProcessing
{
    if (_viewProcessing == nil)
    {
        _viewProcessing = [[IconLabelView alloc] initWithFrame:CGRectZero];
        _viewProcessing.delegate = self;
        UIImage *image = [UIImage imageNamed:@"men_my_ord_icon2"];
        if (image)
        {
            [_viewProcessing.imageView setImage:image];
        }
        NSString *stringDefault = [NSString stringWithFormat:[LocalizedString Processing_BRA_S_BRA], @"0"];
        _viewProcessing.label.text = stringDefault;
        _viewProcessing.tag = OrderStateProcessing;
    }
    return _viewProcessing;
}

- (IconLabelView *)viewShipped
{
    if (_viewShipped == nil)
    {
        _viewShipped = [[IconLabelView alloc] initWithFrame:CGRectZero];
        _viewShipped.delegate = self;
        UIImage *image = [UIImage imageNamed:@"men_my_ord_icon1"];
        if (image)
        {
            [_viewShipped.imageView setImage:image];
        }
        NSString *stringDefault = [NSString stringWithFormat:[LocalizedString Shipped_BRA_S_BRA], @"0"];
        _viewShipped.label.text = stringDefault;
        _viewShipped.tag = OrderStateShipping;
    }
    return _viewShipped;
}

- (IconLabelView *)viewReturnReplace
{
    if (_viewReturnReplace == nil)
    {
        _viewReturnReplace = [[IconLabelView alloc] initWithFrame:CGRectZero];
        _viewReturnReplace.delegate = self;
        UIImage *image = [UIImage imageNamed:@"men_my_ord_icon3"];
        if (image)
        {
            [_viewReturnReplace.imageView setImage:image];
        }
        NSString *stringDefault = [NSString stringWithFormat:[LocalizedString ReturnReplace_BRA_S_BRA], @"0"];
        _viewReturnReplace.label.text = stringDefault;
        _viewReturnReplace.tag = OrderStateReturnOrReplace;
    }
    return _viewReturnReplace;
}

- (void)setNumberCoupon:(NSNumber *)numberCoupon
{
    _numberCoupon = numberCoupon;
    NSString *string = @"0";
    if ([_numberCoupon integerValue] > 0)
    {
        string = [self.viewPoint.formatter stringFromNumber:_numberCoupon];
    }
    NSString *totalString = [NSString stringWithFormat:@"%@%@", string, [LocalizedString Pieces]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalString];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [string length])];
    [self.viewCouponTitle.labelR setAttributedText:attrString];
}

- (void)setNumberOrderProcessing:(NSNumber *)numberOrderProcessing
{
    _numberOrderProcessing = numberOrderProcessing;
    NSString *stringValue = nil;
    if (_numberOrderProcessing == nil)
    {
        stringValue = @"0";
    }
    else
    {
        stringValue = [_numberOrderProcessing stringValue];
    }
    NSString *string = [NSString stringWithFormat:[LocalizedString Processing_BRA_S_BRA], stringValue];
    _viewProcessing.label.text = string;
}

- (void)setNumberOrderShipping:(NSNumber *)numberOrderShipping
{
    _numberOrderShipping = numberOrderShipping;
    NSString *stringValue = nil;
    if (_numberOrderShipping == nil)
    {
        stringValue = @"0";
    }
    else
    {
        stringValue = [_numberOrderShipping stringValue];
    }
    NSString *string = [NSString stringWithFormat:[LocalizedString Shipped_BRA_S_BRA], stringValue];
    _viewShipped.label.text = string;
}

- (void)setNumberOrderReturnReplace:(NSNumber *)numberOrderReturnReplace
{
    _numberOrderReturnReplace = numberOrderReturnReplace;
    NSString *stringValue = nil;
    if (_numberOrderReturnReplace == nil)
    {
        stringValue = @"0";
    }
    else
    {
        stringValue = [_numberOrderReturnReplace stringValue];
    }
    NSString *string = [NSString stringWithFormat:[LocalizedString ReturnReplace_BRA_S_BRA], stringValue];
    _viewReturnReplace.label.text = string;
}

#pragma mark - Private Methods

- (void)refreshContent
{
    NSString *ad_text = [TMInfoManager sharedManager].userPointAdText;
    if (ad_text)
    {
        [self.buttonAdvertisement setTitle:ad_text forState:UIControlStateNormal];
        [self.buttonAdvertisement setHidden:NO];
    }
    NSString *userName = [TMInfoManager sharedManager].userName;
    if (userName)
    {
        NSString *genderString = @"";
        TMGender gender = [TMInfoManager sharedManager].userGender;
        switch (gender) {
            case TMGenderMale:
            {
                genderString = [LocalizedString Mister];
            }
                break;
            case TMGenderFemale:
            {
                genderString = [LocalizedString Miss];
            }
                break;
            default:
                break;
        }
        _viewTitle.labelWelcome.text = [self greetingsMessage];
    }
    NSNumber *numberCoupon = [TMInfoManager sharedManager].userEcoupon;
    if (numberCoupon)
    {
        self.numberCoupon = numberCoupon;
    }
    else
    {
        [[TMInfoManager sharedManager] retrieveCouponDataFromObject:nil forPageIndex:1 couponState:CouponStateNotUsed sortFactor:SymphoxAPIParamValue_worth withSortOrder:SymphoxAPIParamValue_desc withCompletion:nil];
    }
    NSNumber *ePoint = [TMInfoManager sharedManager].userEpoint;
    if (ePoint)
    {
        self.viewPoint.numberPoint = ePoint;
    }
    else
    {
        [[TMInfoManager sharedManager] retrievePointDataFromObject:nil withCompletion:nil];
    }
    [self.viewPoint.buttonBonusGame setTitle:@"玩遊戲賺點數，Go！" forState:UIControlStateNormal];
    NSNumber *pointDividend = [TMInfoManager sharedManager].userPointDividend;
    if (pointDividend)
    {
        self.viewPoint.numberDividend = pointDividend;
    }
    NSNumber *pointTotal = [TMInfoManager sharedManager].userPointTotal;
    if (pointTotal)
    {
        self.viewPoint.numberTotal = pointTotal;
    }
    NSNumber *pointExpired = [TMInfoManager sharedManager].userPointExpired;
    if (pointExpired)
    {
        self.viewPoint.numberExpired = pointExpired;
    }
    [self.viewPoint setNeedsLayout];
    
    if (self.arrayOfOrderNumberOfStatus)
    {
        self.numberOrderProcessing = [NSNumber numberWithInteger:0];
        self.numberOrderShipping = [NSNumber numberWithInteger:0];
        self.numberOrderReturnReplace = [NSNumber numberWithInteger:0];
        for (NSDictionary *dictionary in self.arrayOfOrderNumberOfStatus)
        {
            NSNumber *numberStatus = [dictionary objectForKey:SymphoxAPIParam_status];
            if (numberStatus == nil)
                continue;
            NSNumber *quantity = [dictionary objectForKey:SymphoxAPIParam_qty];
            switch ([numberStatus integerValue]) {
                case 1:
                {
                    // Processing
                    self.numberOrderProcessing = quantity;
                }
                    break;
                case 2:
                {
                    // Shipping
                    self.numberOrderShipping = quantity;
                }
                    break;
                case 3:
                {
                    // Return and replace
                    self.numberOrderReturnReplace = quantity;
                }
                    break;
                default:
                    break;
            }
        }
    }
    [self.view setNeedsLayout];
}

- (void)reconfirmAndLogout
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Logout] message:[LocalizedString LogoutReconfirm] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Logout] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [[TMInfoManager sharedManager] logoutUser];
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionConfirm];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)resetAllContent
{
    __weak MemberViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.viewTitle.labelWelcome.text = @"";
        weakSelf.viewPoint.labelPoint.text = @"";
        weakSelf.viewPoint.labelDividend.text = @"";
        weakSelf.viewPoint.viewExpired.labelR.text = @"";
        weakSelf.viewPoint.viewTotalPoint.labelR.text = @"";
        
        weakSelf.viewCouponTitle.labelR.text = @"";
        weakSelf.viewProcessing.label.text = @"";
        weakSelf.viewShipped.label.text = @"";
        weakSelf.viewReturnReplace.label.text = @"";
    });
}

- (void)retrieveOrderNumberOfStatus
{
    NSNumber *identifier = [TMInfoManager sharedManager].userIdentifier;
    if (identifier == nil)
        return;
    __weak MemberViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_orderNumberOfStatus];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:identifier, SymphoxAPIParam_user_num, nil];
//    NSLog(@"retrieveOrderNumberOfStatus - params:\n%@", [params description]);
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"retrieveOrderNumberOfStatus:\n%@", string);
                if ([weakSelf processOrderNumberOfStatusData:data])
                {
                    [weakSelf refreshContent];
                }
                else
                {
                    NSLog(@"retrieveProductsForConditions - Cannot process data");
                }
            }
            else
            {
                NSLog(@"retrieveProductsForConditions - Unexpected data format.");
            }
        }
    }];
}

- (BOOL)processOrderNumberOfStatusData:(id)data
{
    BOOL success = NO;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && jsonObject)
    {
//        NSLog(@"processOrderNumberOfStatusData - jsonObject:\n%@", [jsonObject description]);
        if ([jsonObject isKindOfClass:[NSArray class]])
        {
            self.arrayOfOrderNumberOfStatus = (NSArray *)jsonObject;
        }
        success = YES;
    }
    return success;
}

- (NSString *)greetingsMessage
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh"];
    
    NSString *stringGreetingsTime = nil;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
    NSInteger hour = components.hour;
    if (hour >= 0 && hour < 11)
    {
        // Morning
        stringGreetingsTime = [LocalizedString GoodMorning];
    }
    else if (hour >= 11 && hour < 13)
    {
        // Noon
        stringGreetingsTime = [LocalizedString GoodNoon];
    }
    else if (hour >= 13 && hour < 17)
    {
        // Afternoon
        stringGreetingsTime = [LocalizedString GoodAfternoon];
    }
    else if (hour >= 17)
    {
        // Evening
        stringGreetingsTime = [LocalizedString GoodEvening];
    }
    
    NSString *userName = [TMInfoManager sharedManager].userName;
    if (userName)
    {
        NSString *stringGender = nil;
        switch ([TMInfoManager sharedManager].userGender) {
            case TMGenderMale:
            {
                stringGender = [LocalizedString Mister];
            }
                break;
            case TMGenderFemale:
            {
                stringGender = [LocalizedString Miss];
            }
                break;
            default:
                break;
        }
        stringGreetingsTime = [stringGreetingsTime stringByAppendingFormat:@"%@%@", userName, (stringGender == nil)?@"":stringGender];
    }
    else
    {
        stringGreetingsTime = [stringGreetingsTime stringByAppendingString:[LocalizedString Greetings]];
    }
    
    return stringGreetingsTime;
}

#pragma mark - Actions

- (void)buttonItemLogoutPressed:(id)sender
{
    [self reconfirmAndLogout];
}

- (void)buttonItemQAPressed:(id)sender
{
//    WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
//    viewController.urlString = @"https://www.treemall.com.tw/iMember/service/serviceLogin.jsp";
//    [self.navigationController pushViewController:viewController animated:YES];
    NSURL *url = [NSURL URLWithString:@"https://www.treemall.com.tw/iMember/service/serviceLogin.jsp"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)buttonAdvertisementPressed:(id)sender
{
    NSString *urlString = [TMInfoManager sharedManager].userPointAdUrl;
    if (urlString == nil)
        return;
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil || [[UIApplication sharedApplication] canOpenURL:url] == NO)
        return;
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Notification Handler

- (void)handlerOfUserPointUpdatedNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *ad_text = nil;
    if (userInfo)
    {
        ad_text = [userInfo objectForKey:SymphoxAPIParam_ad_text];
    }
    if (ad_text)
    {
        [self.buttonAdvertisement setTitle:ad_text forState:UIControlStateNormal];
        [self.buttonAdvertisement setHidden:NO];
    }
    [self refreshContent];
}

#pragma mark - ProductDetailSectionTitleViewDelegate

- (void)productDetailSectionTitleView:(ProductDetailSectionTitleView *)view didPressButtonBySender:(id)sender
{
    switch (view.tag) {
        case SectionTitleTagCoupon:
        {
            NSLog(@"didPressButtonBySender - SectionTitleTagCoupon");
            CouponListViewController *viewController = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case SectionTitleTagOrder:
        {
            NSLog(@"didPressButtonBySender - SectionTitleTagOrder");
            OrderListViewController *viewController = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - MemberTitleViewDelegate

- (void)memberTitleView:(MemberTitleView *)view didSelectToModifyPersonalInformationBySender:(id)sender
{
    MemberSettingsViewController *viewController = [[MemberSettingsViewController alloc] initWithNibName:@"MemberSettingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - IconLabelViewDelegate

- (void)iconLabelView:(IconLabelView *)view didPressedBySender:(id)sender
{
    OrderListViewController *viewController = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:[NSBundle mainBundle]];
    viewController.orderState = view.tag;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - MemberPointViewDelegate

- (void)memberPointView:(MemberPointView *)view didPressBonusGameBySender:(id)sender
{
    WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
    viewController.title = [self.viewPoint.buttonBonusGame titleForState:UIControlStateNormal];
    viewController.urlString = @"http://www.treemall.com.tw/event/RWD/1706member/index.shtml?source=treemall&medium=AD_LOCATION&campaign=77-78-1";
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
