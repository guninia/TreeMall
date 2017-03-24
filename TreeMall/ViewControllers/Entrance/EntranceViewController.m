//
//  EntranceViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "EntranceViewController.h"
#import "EntranceTableViewCell.h"
#import "EntranceMemberPromoteHeader.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "Definition.h"
#import "UIImageView+WebCache.h"
#import "PromotionViewController.h"
#import "ProductListViewController.h"

typedef enum : NSUInteger {
    TableViewSectionMemberPromotion,
    TableViewSectionProductPromotion,
    TableViewSectionTotal,
} TableViewSection;

@interface EntranceViewController ()

- (BOOL)retrieveData;
- (BOOL)processData:(id)data;
- (NSDictionary *)dictionaryForProductAtIndex:(NSInteger)index;

- (void)buttonItemSearchPressed:(id)sender;
- (void)notificationHandlerTokenUpdated:(NSNotification *)notification;
- (void)handlerOfUserInformationUpdatedNotification:(NSNotification *)notification;

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
//        NSLog(@"jsonObject[%@]:\n%@", [[jsonObject class] description], [jsonObject description]);
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
            view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:EntranceMemberPromoteHeaderIdentifier];
            if (view == nil)
            {
                view = [[EntranceMemberPromoteHeader alloc] initWithReuseIdentifier:EntranceMemberPromoteHeaderIdentifier];
            }
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
            heightForHeader = 200.0;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = tableView.frame.size.width * 0.4;
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
                    if ([link isEqualToString:@"001"])
                    {
                        // Should go to Hot List page.
                    }
                }
                    break;
                case 1:
                {
                    // Should go to product detail page.
                    // "link" would be the product ID. 
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

#pragma mark - EntranceFunctionSectionHeaderDelegate

- (void)entranceFunctionSectionHeader:(EntranceFunctionSectionHeader *)header didSelectFunction:(EntranceFunction)function
{
    switch (function) {
        case EntranceFunctionExchange:
        {
            
        }
            break;
        case EntranceFunctionCoupon:
        {
            
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
