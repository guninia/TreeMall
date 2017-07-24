//
//  DeliverProgressViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DeliverProgressViewController.h"
#import "CryptoModule.h"
#import "APIDefinition.h"
#import "SHAPIAdapter.h"
#import "TMInfoManager.h"
#import "LocalizedString.h"
#import "DeliverProgressTableViewCell.h"
#import "DeliverProgressHeaderView.h"
#import "LoadingFooterView.h"

@interface DeliverProgressViewController ()

@property (nonatomic, assign) BOOL shouldShowOperator;
@property (nonatomic, strong) NSString *deliverIdMessage;
@property (nonatomic, strong) NSArray *arrayProgress;
@property (nonatomic, strong) UITableView *tableView;

- (void)requestDeliveryProgress;
- (BOOL)processDeliveryProgressData:(id)data;
- (void)refreshContent;

@end

@implementation DeliverProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString DeliverProgress];
    
    [self.view addSubview:self.tableView];
    
    if (self.orderId != nil)
    {
        [self requestDeliveryProgress];
    }
    [self.tableView reloadData];
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
    if (self.tableView)
    {
        self.tableView.frame = self.view.bounds;
    }
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DeliverProgressTableViewCell class] forCellReuseIdentifier:DeliverProgressTableViewCellIdentifier];
        [_tableView registerClass:[DeliverProgressHeaderView class] forHeaderFooterViewReuseIdentifier:DeliverProgressHeaderViewIdentifier];
        [_tableView registerClass:[LoadingFooterView class] forHeaderFooterViewReuseIdentifier:LoadingFooterViewIdentifier];
    }
    return _tableView;
}

#pragma mark - Private Methods

- (void)requestDeliveryProgress
{
    NSNumber *userIdentifier = [TMInfoManager sharedManager].userIdentifier;
    if (userIdentifier == nil)
        return;
    if (self.orderId == nil)
        return;
    
    __weak DeliverProgressViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_getDeliveryProgress];
//    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userIdentifier, SymphoxAPIParam_user_num, self.orderId, SymphoxAPIParam_order_id, nil];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"retrieveProductsForConditions:\n%@", string);
                if ([self processDeliveryProgressData:data])
                {
                    [weakSelf refreshContent];
                }
                else
                {
                    NSLog(@"requestOrderOfPage - Cannot process data");
                }
            }
            else
            {
                NSLog(@"requestOrderOfPage - Unexpected data format.");
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString CannotLoadData];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
                NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                if (serverMessage)
                {
                    errorMessage = serverMessage;
                }
            }
            NSLog(@"requestOrderOfPage - error:\n%@", [error description]);
        }
    }];
}

- (BOOL)processDeliveryProgressData:(id)data
{
    BOOL success = NO;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil && jsonObject && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        NSNumber *is_wh = [dictionary objectForKey:SymphoxAPIParam_is_wh];
        if (is_wh && [is_wh isEqual:[NSNull null]] == NO)
        {
            self.shouldShowOperator = [is_wh boolValue];
        }
        NSString *message = [dictionary objectForKey:SymphoxAPIParam_message];
        if (message && [message isEqual:[NSNull null]] == NO && [message length] > 0)
        {
            self.deliverIdMessage = message;
        }
        NSArray *array = [dictionary objectForKey:SymphoxAPIParam_list];
        if (array && [array isEqual:[NSNull null]] == NO)
        {
            self.arrayProgress = array;
        }
        success = YES;
    }
    return success;
}

- (void)refreshContent
{
    __weak DeliverProgressViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.arrayProgress count];
    return numberOfRows;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DeliverProgressHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:DeliverProgressHeaderViewIdentifier];
    if (headerView == nil)
    {
        headerView = [[DeliverProgressHeaderView alloc] initWithReuseIdentifier:DeliverProgressHeaderViewIdentifier];
    }
    headerView.orderId = self.orderId;
    headerView.deliverIdMessage = self.deliverIdMessage;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliverProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeliverProgressTableViewCellIdentifier forIndexPath:indexPath];
    NSString *stringTime = @"";
    NSString *stringStatus = @"";
    BOOL isLatest = NO;
    if (indexPath.row < [self.arrayProgress count])
    {
        NSDictionary *dictionary = [self.arrayProgress objectAtIndex:indexPath.row];
        NSString *time = [dictionary objectForKey:SymphoxAPIParam_time];
        if (time && [time isEqual:[NSNull null]] == NO)
        {
            NSArray *components = [time componentsSeparatedByString:@" "];
            for (NSString *component in components)
            {
                if ([component length] > 0)
                {
                    if ([stringTime length] > 0)
                    {
                        stringTime = [stringTime stringByAppendingString:@"\n"];
                    }
                    stringTime = [stringTime stringByAppendingString:component];
                }
            }
        }
        NSString *status = [dictionary objectForKey:SymphoxAPIParam_status];
        if (status && [status isEqual:[NSNull null]] == NO)
        {
            stringStatus = status;
        }
        if (indexPath.row == 0)
        {
            isLatest = YES;
            if (self.shouldShowOperator)
            {
                NSString *location = [dictionary objectForKey:SymphoxAPIParam_location];
                if (location && [location isEqual:[NSNull null]] == NO)
                {
                    stringStatus = location;
                }
            }
        }
    }
    cell.latest = isLatest;
    cell.timeString = stringTime;
    cell.statusString = stringStatus;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LoadingFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LoadingFooterViewIdentifier];
    if (footerView == nil)
    {
        footerView = [[LoadingFooterView alloc] initWithReuseIdentifier:LoadingFooterViewIdentifier];
    }
    return footerView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat heightForHeader = 70.0;
    return heightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 70.0;
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForFooter = 0.0;
    if (self.deliverIdMessage == nil)
    {
        heightForFooter = 50.0;
    }
    return heightForFooter;
}

@end
