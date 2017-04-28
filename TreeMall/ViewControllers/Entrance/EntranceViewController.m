//
//  EntranceViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "EntranceViewController.h"
#import "EntranceTableViewCell.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "Definition.h"
#import "UIImageView+WebCache.h"
#import "PromotionViewController.h"
#import "ProductListViewController.h"
#import "TMInfoManager.h"
#import "LocalizedString.h"
#import "Utility.h"
#import "LoginViewController.h"
#import "WebViewViewController.h"
#import "ProductDetailViewController.h"
#import "HotSaleViewController.h"

typedef enum : NSUInteger {
    TableViewSectionMemberPromotion,
    TableViewSectionProductPromotion,
    TableViewSectionTotal,
} TableViewSection;

@interface EntranceViewController ()

- (BOOL)retrieveData;
- (BOOL)processData:(id)data;
- (NSDictionary *)dictionaryForProductAtIndex:(NSInteger)index;
- (void)refreshTableView;
- (NSString *)greetingsMessage;

- (void)buttonItemSearchPressed:(id)sender;
- (void)notificationHandlerTokenUpdated:(NSNotification *)notification;
- (void)handlerOfUserInformationUpdatedNotification:(NSNotification *)notification;
- (void)handlerOfUserPointUpdatedNotification:(NSNotification *)notification;
- (void)handlerOfUserCouponUpdatedNotification:(NSNotification *)notification;
- (void)handlerOfUserLogoutNotification:(NSNotification *)notification;

@end

@implementation EntranceViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _dictionaryData = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(100.0/255.0) green:(170.0/255.0) blue:(80.0/255.0) alpha:1.0]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    if (self.navigationItem)
    {
        UIImage *image = [[UIImage imageNamed:@"ind_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setTintColor:[UIColor colorWithRed:(100.0/255.0) green:(170.0/255.0) blue:(80.0/255.0) alpha:1.0]];
        self.navigationItem.titleView = imageView;
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIImage *image = [[UIImage imageNamed:@"sho_btn_mag"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (image)
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemSearchPressed:)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    
    [_tableViewEntrance registerClass:[EntranceTableViewCell class] forCellReuseIdentifier:EntranceTableViewCellIdentifier];
    [_tableViewEntrance registerClass:[EntranceFunctionSectionHeader class] forHeaderFooterViewReuseIdentifier:EntranceFunctionSectionHeaderIdentifier];
    [_tableViewEntrance registerClass:[EntranceMemberPromoteHeader class] forHeaderFooterViewReuseIdentifier:EntranceMemberPromoteHeaderIdentifier];
    [_tableViewEntrance setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableViewEntrance setShowsVerticalScrollIndicator:NO];
    [_tableViewEntrance setShowsHorizontalScrollIndicator:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandlerTokenUpdated:) name:PostNotificationName_TokenUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfUserInformationUpdatedNotification:) name:PostNotificationName_UserInformationUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfUserPointUpdatedNotification:) name:PostNotificationName_UserPointUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfUserCouponUpdatedNotification:) name:PostNotificationName_UserCouponUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfUserLogoutNotification:) name:PostNotificationName_UserLogout object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableViewEntrance reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_TokenUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserInformationUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserPointUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserCouponUpdated object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (BOOL)retrieveData
{
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    if (apiKey == nil || token == nil)
    {
        return NO;
    }
    __weak EntranceViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_homepage];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_01", SymphoxAPIParam_txid, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            NSString *string = [[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding];
            NSLog(@"retrieveData:\n%@", string);
            if ([self processData:resultObject])
            {
                [_tableViewEntrance reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_EntranceDataPrepared object:self];
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
    return YES;
}

- (BOOL)processData:(id)data
{
    BOOL canProcess = NO;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error == nil)
    {
//        NSLog(@"processData - jsonObject[%@]:\n%@", [[jsonObject class] description], [jsonObject description]);
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            NSString *result = [dictionary objectForKey:SymphoxAPIParam_result];
            if ([result integerValue] == 0)
            {
                // Normal status.
                [_dictionaryData setDictionary:dictionary];
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

- (NSDictionary *)dictionaryForProductAtIndex:(NSInteger)index
{
    NSDictionary *dictionary = nil;
    NSArray *array = [_dictionaryData objectForKey:SymphoxAPIParam_productBanner];
    if (array && index < [array count])
    {
        dictionary = [array objectAtIndex:index];
    }
    return dictionary;
}

- (void)refreshTableView
{
    __weak EntranceViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.tableViewEntrance reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionMemberPromotion] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.tableViewEntrance reloadData];
    });
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
    
    return stringGreetingsTime;
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
    [self retrieveData];
}

- (void)handlerOfUserInformationUpdatedNotification:(NSNotification *)notification
{
    [self refreshTableView];
}

- (void)handlerOfUserPointUpdatedNotification:(NSNotification *)notification
{
    [self refreshTableView];
}

- (void)handlerOfUserCouponUpdatedNotification:(NSNotification *)notification
{
    [self refreshTableView];
}

- (void)handlerOfUserLogoutNotification:(NSNotification *)notification
{
    [self refreshTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TableViewSectionTotal;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case TableViewSectionProductPromotion:
        {
            NSArray *dictionaryProduct = [_dictionaryData objectForKey:SymphoxAPIParam_productBanner];
            if (dictionaryProduct)
            {
                numberOfRows = [dictionaryProduct count];
            }
        }
            break;
            
        default:
            break;
    }
    return numberOfRows;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    switch (section) {
        case TableViewSectionMemberPromotion:
        {
            EntranceMemberPromoteHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:EntranceMemberPromoteHeaderIdentifier];
            if (header == nil)
            {
                header = [[EntranceMemberPromoteHeader alloc] initWithReuseIdentifier:EntranceMemberPromoteHeaderIdentifier];
            }
            header.delegate = self;
            NSString *message = [self greetingsMessage];
            header.labelGreetings.text = message;
            NSNumber *pointTotal = [TMInfoManager sharedManager].userPointTotal;
            header.numberTotalPoint = pointTotal;
            NSNumber *couponAmount = [TMInfoManager sharedManager].userCouponAmount;
            header.numberCouponValue = couponAmount;
            NSDictionary *dictionaryMarketing = [self.dictionaryData objectForKey:SymphoxAPIParam_serviceText];
            if (dictionaryMarketing && [dictionaryMarketing isEqual:[NSNull null]] == NO)
            {
                NSString *string = [dictionaryMarketing objectForKey:SymphoxAPIParam_message];
                if (string && [string isEqual:[NSNull null]] == NO && [string length] > 0)
                {
                    header.buttonMarketing.labelText.text = string;
                }
            }
            NSDictionary *dictionaryFocus = [self.dictionaryData objectForKey:SymphoxAPIParam_toDayFocus];
            if (dictionaryFocus && [dictionaryFocus isEqual:[NSNull null]] == NO)
            {
                NSString *imageUrlPath = [dictionaryFocus objectForKey:SymphoxAPIParam_img];
                if (imageUrlPath && [imageUrlPath isEqual:[NSNull null]] == NO && [imageUrlPath length] > 0)
                {
                    header.promotionImageUrlPath = imageUrlPath;
                }
            }
            view = header;
        }
            break;
        case TableViewSectionProductPromotion:
        {
            view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:EntranceFunctionSectionHeaderIdentifier];
            if (view == nil)
            {
                view = [[EntranceFunctionSectionHeader alloc] initWithReuseIdentifier:EntranceFunctionSectionHeaderIdentifier];
            }
            ((EntranceFunctionSectionHeader *)view).delegate = self;
        }
            break;
        default:
            break;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EntranceTableViewCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dictionary = [self dictionaryForProductAtIndex:indexPath.row];
    if (dictionary != nil)
    {
        NSString *imagePath = [dictionary objectForKey:SymphoxAPIParam_img];
        if (imagePath != nil)
        {
            NSURL *url = [NSURL URLWithString:imagePath];
            
            // This placeholder image is to force SDWebImage to show image immediately after loading.
            UIImage *placeholderImage = [UIImage imageNamed:@"transparent"];
            [cell.imageView sd_setImageWithURL:url placeholderImage:placeholderImage options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
//                NSLog(@"image[%4.2f,%4.2f]", image.size.width, image.size.height);
                return;
            }];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat heightForHeader = 0.0;
    switch (section) {
        case TableViewSectionMemberPromotion:
        {
            UIImage *image = [UIImage imageNamed:@"bg_ind_up"];
            CGFloat referenceHeightDiffRatio = [Utility sizeRatioAccordingTo320x480].height - 1;
            heightForHeader = ceil(190.0 + image.size.height * referenceHeightDiffRatio);
        }
            break;
        case TableViewSectionProductPromotion:
        {
            heightForHeader = 80.0;
        }
            break;
        default:
            break;
    }
    return heightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return [self tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self dictionaryForProductAtIndex:indexPath.row];
    NSString *stringSize = [dictionary objectForKey:SymphoxAPIParam_size];
    CGFloat heightForRow = tableView.frame.size.width * 0.4;
    if (stringSize)
    {
        switch ([stringSize integerValue]) {
            case 0:
            {
                // 900 X 360
                heightForRow = tableView.frame.size.width * 432 / 888;
            }
                break;
            case 1:
            {
                // 900 X 240
                heightForRow = tableView.frame.size.width * 288 / 888;
            }
                break;
            case 2:
            {
                // 900 X 120
                heightForRow = tableView.frame.size.width * 144 / 888;
            }
                break;
            default:
                break;
        }
    }
    
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case TableViewSectionProductPromotion:
        {
            NSDictionary *dictionary = [self dictionaryForProductAtIndex:indexPath.row];
            NSString *type = [dictionary objectForKey:SymphoxAPIParam_type];
            NSString *link = [dictionary objectForKey:SymphoxAPIParam_link];
            if (type == nil)
            {
                break;
            }
            switch ([type integerValue]) {
                case 0:
                {
                    // Hot sale
                    if (link != nil && [link length] > 0)
                    {
                        NSInteger type = [link integerValue];
                        HotSaleViewController *viewController = [[HotSaleViewController alloc] initWithNibName:@"HotSaleViewController" bundle:[NSBundle mainBundle]];
                        viewController.type = type;
                        viewController.title = [LocalizedString HotSaleRanking];
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                        [self presentViewController:navigationController animated:YES completion:nil];
                    }
                }
                    break;
                case 1:
                {
                    // Product detail
                    if (link != nil && [link length] > 0)
                    {
                        ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
                        NSNumber *productId = [NSNumber numberWithInteger:[link integerValue]];
                        viewController.productIdentifier = productId;
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                }
                    break;
                case 2:
                {
                    // Sub category. Currently impossible since there is no layer information.
                }
                    break;
                case 3:
                {
                    // Web page
                    if (link != nil && [link length] > 0)
                    {
                        WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
                        viewController.title = [LocalizedString TodayFocus];
                        viewController.urlString = link;
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - EntranceMemberPromoteHeaderDelegate

- (void)entranceMemberPromoteHeader:(EntranceMemberPromoteHeader *)header didPressedPromotionBySender:(id)sender
{
    NSDictionary *dictionaryFocus = [self.dictionaryData objectForKey:SymphoxAPIParam_toDayFocus];
    if (dictionaryFocus && [dictionaryFocus isEqual:[NSNull null]] == NO)
    {
        NSString *type = [dictionaryFocus objectForKey:SymphoxAPIParam_type];
        NSString *stringLink = [dictionaryFocus objectForKey:SymphoxAPIParam_link];
        if (stringLink && [stringLink isEqual:[NSNull null]] == NO && [stringLink length] > 0)
        {
            switch ([type integerValue]) {
                case 0:
                {
                    // Hot sale
                    NSInteger type = [stringLink integerValue];
                    HotSaleViewController *viewController = [[HotSaleViewController alloc] initWithNibName:@"HotSaleViewController" bundle:[NSBundle mainBundle]];
                    viewController.type = type;
                    viewController.title = [LocalizedString HotSaleRanking];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                    [self presentViewController:navigationController animated:YES completion:nil];
                }
                    break;
                case 1:
                {
                    // Product detail
                    if (stringLink != nil && [stringLink length] > 0)
                    {
                        ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
                        NSNumber *productId = [NSNumber numberWithInteger:[stringLink integerValue]];
                        viewController.productIdentifier = productId;
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                }
                    break;
                case 2:
                {
                    // Sub category. Currently impossible since there is no layer information.
                }
                    break;
                case 3:
                {
                    // Web page
                    if (stringLink != nil && [stringLink length] > 0)
                    {
                        WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
                        viewController.title = [LocalizedString TodayFocus];
                        viewController.urlString = stringLink;
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)entranceMemberPromoteHeader:(EntranceMemberPromoteHeader *)header didPressedMarketingBySender:(id)sender
{
    NSDictionary *dictionaryMarketing = [self.dictionaryData objectForKey:SymphoxAPIParam_serviceText];
    if (dictionaryMarketing && [dictionaryMarketing isEqual:[NSNull null]] == NO)
    {
        NSString *type = [dictionaryMarketing objectForKey:SymphoxAPIParam_type];
        NSString *stringLink = [dictionaryMarketing objectForKey:SymphoxAPIParam_link];
        if (stringLink && [stringLink isEqual:[NSNull null]] == NO && [stringLink length] > 0)
        {
            switch ([type integerValue]) {
                case 0:
                {
                    // Hot sale
                    NSInteger type = [stringLink integerValue];
                    HotSaleViewController *viewController = [[HotSaleViewController alloc] initWithNibName:@"HotSaleViewController" bundle:[NSBundle mainBundle]];
                    viewController.type = type;
                    viewController.title = [LocalizedString HotSaleRanking];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                    [self presentViewController:navigationController animated:YES completion:nil];
                }
                    break;
                case 1:
                {
                    // Product detail
                    if (stringLink != nil && [stringLink length] > 0)
                    {
                        ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
                        NSNumber *productId = [NSNumber numberWithInteger:[stringLink integerValue]];
                        viewController.productIdentifier = productId;
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                }
                    break;
                case 2:
                {
                    // Sub category. Currently impossible since there is no layer information.
                }
                    break;
                case 3:
                {
                    // Web page
                    if (stringLink != nil && [stringLink length] > 0)
                    {
                        WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
                        viewController.title = [LocalizedString SpecialService];
                        viewController.urlString = stringLink;
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)entranceMemberPromoteHeader:(EntranceMemberPromoteHeader *)header didPressedPointBySender:(id)sender
{
    NSLog(@"entranceMemberPromoteHeader - didPressedPointBySender");
    if ([TMInfoManager sharedManager].userIdentifier == nil)
    {
        // Should pop up login view
        LoginViewController *viewControllerLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerLogin];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_JumpToMemberTab object:self];
    }
}

- (void)entranceMemberPromoteHeader:(EntranceMemberPromoteHeader *)header didPressedCouponBySender:(id)sender
{
    NSLog(@"entranceMemberPromoteHeader - didPressedCouponBySender");
    if ([TMInfoManager sharedManager].userIdentifier == nil)
    {
        // Should pop up login view
        LoginViewController *viewControllerLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerLogin];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_JumpToMemberTabAndPresentCoupon object:self];
    }
}

#pragma mark - EntranceFunctionSectionHeaderDelegate

- (void)entranceFunctionSectionHeader:(EntranceFunctionSectionHeader *)header didSelectFunction:(EntranceFunction)function
{
    switch (function) {
        case EntranceFunctionExchange:
        {
            HotSaleViewController *viewController = [[HotSaleViewController alloc] initWithNibName:@"HotSaleViewController" bundle:[NSBundle mainBundle]];
            viewController.type = HotSaleTypePoint;
            viewController.title = [LocalizedString HotSaleRanking];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
            break;
        case EntranceFunctionCoupon:
        {
            HotSaleViewController *viewController = [[HotSaleViewController alloc] initWithNibName:@"HotSaleViewController" bundle:[NSBundle mainBundle]];
            viewController.type = HotSaleTypeCoupon;
            viewController.title = [LocalizedString HotSaleRanking];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
            break;
        case EntranceFunctionPromotion:
        {
            PromotionViewController *promotionViewController = [[PromotionViewController alloc] initWithNibName:@"PromotionViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:promotionViewController animated:YES];
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

@end
