//
//  PromotionViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "PromotionViewController.h"
#import "PromotionTableViewCell.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "Definition.h"

@interface PromotionViewController ()

- (BOOL)retrieveData;
- (BOOL)processData:(id)data;

- (void)notificationHandlerTokenUpdated:(NSNotification *)notification;

@end

@implementation PromotionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _arrayPromotion = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableViewPromotion registerClass:[PromotionTableViewCell class] forCellReuseIdentifier:PromotionTableViewCellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandlerTokenUpdated:) name:PostNotificationName_TokenUpdated object:nil];
    [self retrieveData];
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
    
    __weak PromotionViewController *weakSelf = self;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_promotion];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"TM_O_02", SymphoxAPIParam_txid, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:nil andPostObject:postDictionary inPostFormat:SHPostFormatUrlEncoded encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        
        if (error == nil)
        {
            if ([self processData:resultObject])
            {
                [_tableViewPromotion reloadData];
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
                NSArray *array = [dictionary objectForKey:SymphoxAPIParam_serviceMessage];
                if (array)
                {
                    [_arrayPromotion setArray:array];
                }
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

#pragma mark - Notification Handler

- (void)notificationHandlerTokenUpdated:(NSNotification *)notification
{
    if (_arrayPromotion == nil)
    {
        [self retrieveData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [_arrayPromotion count];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PromotionTableViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < [_arrayPromotion count])
    {
        cell.imageView.backgroundColor = [UIColor redColor];
        NSDictionary *dictionary = [_arrayPromotion objectAtIndex:indexPath.row];
        NSString *title = [dictionary objectForKey:SymphoxAPIParam_name];
        NSString *subtitle = [dictionary objectForKey:SymphoxAPIParam_tips];
        NSString *content = [dictionary objectForKey:SymphoxAPIParam_content];
//        NSString *type = [dictionary objectForKey:SymphoxAPIParam_type];
//        NSString *identifier = [dictionary objectForKey:SymphoxAPIParam_id];
        
        cell.title = (title == nil)?@"":title;
        cell.subtitle = (subtitle == nil)?@"":subtitle;
        cell.content = (content == nil)?@"":content;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 120.0;
    return heightForRow;
}

@end
