//
//  PromotionViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "PromotionViewController.h"
#import "PromotionTableViewCell.h"

@interface PromotionViewController ()

@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _arrayPromotion = [[NSMutableArray alloc] initWithCapacity:0];
    [_tableViewPromotion registerClass:[PromotionTableViewCell class] forCellReuseIdentifier:PromotionTableViewCellIdentifier];
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
        NSDictionary *dictionary = [_arrayPromotion objectAtIndex:indexPath.row];
        cell.dictionaryData = dictionary;
    }
    return cell;
}

#pragma mark - UITableViewDelegate


@end
