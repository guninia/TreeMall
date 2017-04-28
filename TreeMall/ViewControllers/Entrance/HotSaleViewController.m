//
//  HotSaleViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/28.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "HotSaleViewController.h"
#import "HotSaleTableViewCell.h"
#import "CryptoModule.h"
#import "APIDefinition.h"
#import "SHAPIAdapter.h"
#import "ProductDetailViewController.h"
#import "LocalizedString.h"

@interface HotSaleViewController ()

- (void)retrieveDataForType:(HotSaleType)type;
- (BOOL)processData:(id)data;
- (void)buttonItemPressed:(id)sender;
@end

@implementation HotSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIImage *image = [[UIImage imageNamed:@"car_popup_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemPressed:)];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
    [self.view addSubview:self.tableView];
    
    [self retrieveDataForType:self.type];
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
        [_tableView setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1.0]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[HotSaleTableViewCell class] forCellReuseIdentifier:HotSaleTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)arrayProducts
{
    if (_arrayProducts == nil)
    {
        _arrayProducts = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayProducts;
}

- (NSNumberFormatter *)formatter
{
    if (_formatter == nil)
    {
        _formatter = [[NSNumberFormatter alloc] init];
        [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _formatter;
}

#pragma mark - Private Methods

- (void)retrieveDataForType:(HotSaleType)type
{
    __weak HotSaleViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSString *stringType = nil;
    switch (type) {
        case HotSaleTypePoint:
        {
            stringType = @"aquariusHomePointOrderRank";
        }
            break;
        case HotSaleTypeCoupon:
        {
            stringType = @"aquariusHomeEcouponOrderRank";
        }
            break;
        default:
        {
            stringType = @"aquariusHomeOrderRank";
        }
            break;
    }
    NSString *totalUrlString = [SymphoxAPI_getHotSaleProducts stringByAppendingFormat:@"?type=%@", stringType];
    NSLog(@"totalUrlString[%@]", totalUrlString);
    NSURL *url = [NSURL URLWithString:totalUrlString];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:stringType, SymphoxAPIParam_type, nil];
    NSLog(@"retrieveDataForType [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:nil inPostFormat:SHPostFormatNone encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"string[%@]", string);
                // Should continue to process data.
                if ([weakSelf processData:data])
                {
                    [weakSelf.tableView reloadData];
                }
            }
            else
            {
                NSLog(@"Unexpected data format.");
            }
        }
        else
        {
            NSLog(@"error:\n%@", [error description]);
        }
    }];
}

- (BOOL)processData:(id)data
{
    BOOL success = NO;
    
    NSError *error = nil;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil)
    {
        if ([resultObject isKindOfClass:[NSArray class]])
        {
            NSArray *arrayResult = (NSArray *)resultObject;
            [self.arrayProducts setArray:arrayResult];
            success = YES;
        }
    }
    
    return success;
}

#pragma mark - Actions

- (void)buttonItemPressed:(id)sender
{
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.arrayProducts count];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HotSaleTableViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *textRank = @"";
    NSString *title = @"";
    NSString *textPrice = @"";
    NSURL *imageUrl = nil;
    if (indexPath.row < [self.arrayProducts count])
    {
        NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
        NSNumber *rank = [dictionary objectForKey:SymphoxAPIParam_rank];
        if (rank && [rank isEqual:[NSNull null]] == NO)
        {
            NSString *stringRank = [rank stringValue];
            if (stringRank)
            {
                textRank = [NSString stringWithFormat:@"NO.%@", stringRank];
            }
        }
        NSString *cpdt_name = [dictionary objectForKey:SymphoxAPIParam_cpdt_name];
        if (cpdt_name && [cpdt_name isEqual:[NSNull null]] == NO && [cpdt_name length] > 0)
        {
            title = cpdt_name;
        }
        NSNumber *cpdt_price = [dictionary objectForKey:SymphoxAPIParam_cpdt_price];
        if (cpdt_price && [cpdt_price isEqual:[NSNull null]] == NO)
        {
            NSString *stringPrice = [self.formatter stringFromNumber:cpdt_price];
            if (stringPrice)
            {
                textPrice = [NSString stringWithFormat:@"＄%@", stringPrice];
            }
        }
        NSString *pic_link = [dictionary objectForKey:SymphoxAPIParam_pic_link];
        if (pic_link && [pic_link isEqual:[NSNull null]] == NO && [pic_link length] > 0)
        {
            NSURL *url = [NSURL URLWithString:pic_link];
            if (url)
            {
                imageUrl = url;
            }
        }
    }
    cell.labelTag.text = textRank;
    cell.labelTitle.text = title;
    cell.labelPrice.text = textPrice;
    cell.imageUrl = imageUrl;
    return cell;
}

#pragma mark - UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 160.0;
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.arrayProducts count])
    {
        NSDictionary *dictionary = [self.arrayProducts objectAtIndex:indexPath.row];
        NSNumber *productId = [dictionary objectForKey:SymphoxAPIParam_cpdt_num];
        if (productId && [productId isEqual:[NSNull null]] == NO)
        {
            ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
            viewController.productIdentifier = productId;
            viewController.title = [LocalizedString ProductInfo];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end
