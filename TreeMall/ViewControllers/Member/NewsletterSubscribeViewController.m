//
//  NewsletterSubscribeViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "NewsletterSubscribeViewController.h"
#import "NewsletterSubscribeTableViewCell.h"
#import "PureTextTableHeaderView.h"
#import "PureTextTableFooterView.h"
#import "LoadingFooterView.h"
#import "LocalizedString.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "TMInfoManager.h"

@interface NewsletterSubscribeViewController ()

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)requestNewsletter;
- (BOOL)processNewsletterData:(id)data;
- (void)subscribeNewsletters:(NSArray *)newsletters;

- (void)buttonSendPressed:(id)sender;

@end

@implementation NewsletterSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString SubscribeNewsletter];
    [self.view addSubview:self.tableViewNewsletter];
    [self.view addSubview:self.buttonSend];
    
    [self.navigationController.tabBarController.view addSubview:self.viewLoading];
    
    [self.tableViewNewsletter reloadData];
    [self requestNewsletter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.viewLoading removeFromSuperview];
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
    
    CGFloat marginB = 10.0;
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat intervalV = 5.0;
    
    if (self.buttonSend)
    {
        CGFloat buttonHeight = 40.0;
        CGRect frame = CGRectMake(marginL, self.view.frame.size.height - marginB - buttonHeight, (self.view.frame.size.width - (marginL + marginR)), buttonHeight);
        self.buttonSend.frame = frame;
    }
    
    if (self.tableViewNewsletter)
    {
        CGRect frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.buttonSend.frame.origin.y - intervalV);
        self.tableViewNewsletter.frame = frame;
    }
    
    if (self.viewLoading)
    {
        self.viewLoading.frame = self.navigationController.tabBarController.view.bounds;
        self.viewLoading.indicatorCenter = self.viewLoading.center;
        [self.viewLoading setNeedsLayout];
    }
}

- (UITableView *)tableViewNewsletter
{
    if (_tableViewNewsletter == nil)
    {
        _tableViewNewsletter = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableViewNewsletter setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableViewNewsletter setDataSource:self];
        [_tableViewNewsletter setDelegate:self];
        [_tableViewNewsletter registerClass:[NewsletterSubscribeTableViewCell class] forCellReuseIdentifier:NewsletterSubscribeTableViewCellIdentifier];
        [_tableViewNewsletter registerClass:[PureTextTableHeaderView class] forHeaderFooterViewReuseIdentifier:PureTextTableHeaderViewIdentifier];
        [_tableViewNewsletter registerClass:[PureTextTableFooterView class] forHeaderFooterViewReuseIdentifier:PureTextTableFooterViewIdentifier];
        [_tableViewNewsletter registerClass:[LoadingFooterView class] forHeaderFooterViewReuseIdentifier:LoadingFooterViewIdentifier];
    }
    return _tableViewNewsletter;
}

- (UIButton *)buttonSend
{
    if (_buttonSend == nil)
    {
        _buttonSend = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonSend setBackgroundColor:[UIColor orangeColor]];
        [_buttonSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonSend.layer setCornerRadius:5.0];
        [_buttonSend setTitle:[LocalizedString Send] forState:UIControlStateNormal];
        [_buttonSend addTarget:self action:@selector(buttonSendPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonSend;
}

- (FullScreenLoadingView *)viewLoading
{
    if (_viewLoading == nil)
    {
        _viewLoading = [[FullScreenLoadingView alloc] initWithFrame:CGRectZero];
        [_viewLoading setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        _viewLoading.alpha = 0.0;
    }
    return _viewLoading;
}

- (NSMutableArray *)arrayNewsletter
{
    if (_arrayNewsletter == nil)
    {
        _arrayNewsletter = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayNewsletter;
}

#pragma mark - Private Methods

- (void)showLoadingViewAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewLoading.activityIndicator startAnimating];
        if (animated)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                [self.viewLoading setAlpha:1.0];
            } completion:nil];
        }
        else
        {
            [self.viewLoading setAlpha:1.0];
        }
    });
}

- (void)hideLoadingViewAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewLoading.activityIndicator stopAnimating];
        if (animated)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                [self.viewLoading setAlpha:0.0];
            } completion:nil];
        }
        else
        {
            [self.viewLoading setAlpha:0.0];
        }
    });
}

- (void)requestNewsletter
{
    NSNumber *userId = [TMInfoManager sharedManager].userIdentifier;
    if (userId == nil)
    {
        return;
    }
    __weak NewsletterSubscribeViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_newsletter];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:SymphoxAPIParam_user_num];
    
    [self showLoadingViewAnimated:YES];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
            // Success
            if ([weakSelf processNewsletterData:resultObject])
            {
                [weakSelf.tableViewNewsletter reloadData];
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString AuthenticateFailed];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
                NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                if (serverMessage)
                {
                    errorMessage = serverMessage;
                }
            }
            NSLog(@"requestNewsletter - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:YES];
    }];
}

- (BOOL)processNewsletterData:(id)data
{
    BOOL success = NO;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error)
    {
        NSLog(@"processNewsletterData error:\n%@", [error description]);
        return success;
    }
    if ([jsonObject isKindOfClass:[NSArray class]])
    {
        NSArray *array = (NSArray *)jsonObject;
        [self.arrayNewsletter setArray:array];
        success = YES;
    }
    return success;
}

- (void)subscribeNewsletters:(NSArray *)newsletters
{
    NSNumber *userId = [TMInfoManager sharedManager].userIdentifier;
    if (userId == nil)
    {
        return;
    }
    __weak NewsletterSubscribeViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_subscribeNewsletter];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:SymphoxAPIParam_user_num];
    [params setObject:newsletters forKey:SymphoxAPIParam_list];
    
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        NSString *message = nil;
        if (error == nil)
        {
            // Success
            message = [LocalizedString UpdateNewsletterSubscriptionSuccess];
        }
        else
        {
            NSString *errorMessage = [LocalizedString AuthenticateFailed];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
                NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                if (serverMessage)
                {
                    errorMessage = serverMessage;
                }
            }
            NSLog(@"requestNewsletter - error:\n%@", [error description]);
            message = errorMessage;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:actionConfirm];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
}

#pragma mark - Actions

- (void)buttonSendPressed:(id)sender
{
    NSMutableArray *arraySubscribe = [NSMutableArray array];
    for (NSDictionary *dictionary in self.arrayNewsletter)
    {
        NSString *identifier = [dictionary objectForKey:SymphoxAPIParam_edm_id];
        NSString *subscribe = [dictionary objectForKey:SymphoxAPIParam_subscribe];
        NSMutableDictionary *dictionarySubscribe = [NSMutableDictionary dictionary];
        if (identifier && [identifier isEqual:[NSNull null]] == NO)
        {
            [dictionarySubscribe setObject:identifier forKey:SymphoxAPIParam_edm_id];
            if (subscribe && [subscribe isEqual:[NSNull null]] == NO)
            {
                [dictionarySubscribe setObject:subscribe forKey:SymphoxAPIParam_subscribe];
            }
        }
        [arraySubscribe addObject:dictionarySubscribe];
    }
    [self subscribeNewsletters:arraySubscribe];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.arrayNewsletter count];
    return numberOfRows;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PureTextTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PureTextTableHeaderViewIdentifier];
    if (headerView.labelText.text == nil)
    {
        headerView.labelText.text = [LocalizedString ToSubscribeNewsletterPleaseCheckAndSend];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = nil;
    if ([self.arrayNewsletter count] == 0)
    {
        LoadingFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LoadingFooterViewIdentifier];
        view = footerView;
    }
    else
    {
        PureTextTableFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PureTextTableFooterViewIdentifier];
        NSString *stringReminder = [LocalizedString _M_Reminder_M_];
        NSString *stringDetail = [LocalizedString NewsletterSubscriptionNotation];
        NSString *stringTotal = [NSString stringWithFormat:@"%@\n%@", stringReminder, stringDetail];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringTotal];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, [stringReminder length])];
        [footerView.labelText setAttributedText:attrString];
        view = footerView;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsletterSubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsletterSubscribeTableViewCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row < [self.arrayNewsletter count])
    {
        NSDictionary *dictionary = [self.arrayNewsletter objectAtIndex:indexPath.row];
        NSString *name = [dictionary objectForKey:SymphoxAPIParam_name];
        if (name && [name isEqual:[NSNull null]] == NO)
        {
            cell.labelTitle.text = name;
        }
        else
        {
            cell.labelTitle.text = @"";
        }
        NSString *description = [dictionary objectForKey:SymphoxAPIParam_description];
        if (description && [description isEqual:[NSNull null]] == NO)
        {
            cell.labelDetail.text = description;
        }
        else
        {
            cell.labelDetail.text = @"";
        }
        NSString *subscribe = [dictionary objectForKey:SymphoxAPIParam_subscribe];
        if (subscribe && [subscribe isEqual:[NSNull null]] == NO)
        {
            BOOL subscribed = [subscribe boolValue];
            cell.subscribed = subscribed;
        }
        else
        {
            cell.subscribed = NO;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat heightForHeader = 0.0;
    if ([self.arrayNewsletter count] > 0)
    {
        heightForHeader = 60.0;
    }
    return heightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 80.0;
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForFooter = 60.0;
    return heightForFooter;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[LoadingFooterView class]])
    {
        LoadingFooterView *footerView = (LoadingFooterView *)view;
        [footerView.activityIndicator startAnimating];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[LoadingFooterView class]])
    {
        LoadingFooterView *footerView = (LoadingFooterView *)view;
        [footerView.activityIndicator stopAnimating];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.arrayNewsletter count])
        return;
    NewsletterSubscribeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.subscribed = !cell.subscribed;
    NSMutableDictionary *dictionary = [[self.arrayNewsletter objectAtIndex:indexPath.row] mutableCopy];
    [dictionary setObject:(cell.subscribed?@"Y":@"N") forKey:SymphoxAPIParam_subscribe];
    [self.arrayNewsletter replaceObjectAtIndex:indexPath.row withObject:dictionary];
}

@end
