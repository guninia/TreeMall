//
//  EntranceViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "EntranceViewController.h"
#import "EntranceTableViewCell.h"
#import "EntranceFunctionSectionHeader.h"
#import "EntranceMemberPromoteHeader.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "Definition.h"
#import "UIImageView+WebCache.h"

typedef enum : NSUInteger {
    TableViewSectionMemberPromotion,
    TableViewSectionProductPromotion,
    TableViewSectionTotal,
} TableViewSection;

@interface EntranceViewController ()

- (BOOL)retrieveData;
- (BOOL)processData:(id)data;
- (NSDictionary *)dictionaryForProductAtIndex:(NSInteger)index;

- (void)notificationHandlerTokenUpdated:(NSNotification *)notification;

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
    
    [_tableViewEntrance registerClass:[EntranceTableViewCell class] forCellReuseIdentifier:EntranceTableViewCellIdentifier];
    [_tableViewEntrance registerClass:[EntranceFunctionSectionHeader class] forHeaderFooterViewReuseIdentifier:EntranceFunctionSectionHeaderIdentifier];
    [_tableViewEntrance registerClass:[EntranceMemberPromoteHeader class] forHeaderFooterViewReuseIdentifier:EntranceMemberPromoteHeaderIdentifier];
    [_tableViewEntrance setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableViewEntrance setShowsVerticalScrollIndicator:NO];
    [_tableViewEntrance setShowsHorizontalScrollIndicator:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandlerTokenUpdated:) name:PostNotificationName_TokenUpdated object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"self.tableViewEntrance[%4.2f,%4.2f,%4.2f,%4.2f]", self.tableViewEntrance.frame.origin.x, self.tableViewEntrance.frame.origin.y, self.tableViewEntrance.frame.size.width, self.tableViewEntrance.frame.size.height);
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
//    NSString *postString = [NSString stringWithFormat:@"%@=%@", SymphoxAPIParam_txid, @"TM_O_01"];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_01", SymphoxAPIParam_txid, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            if ([self processData:resultObject])
            {
                [_tableViewEntrance reloadData];
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
        NSLog(@"jsonObject[%@]:\n%@", [[jsonObject class] description], [jsonObject description]);
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
            heightForHeader = 100.0;
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
            if (type == nil)
            {
                break;
            }
            switch ([type integerValue]) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    
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

@end
