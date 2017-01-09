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

typedef enum : NSUInteger {
    TableViewSectionMemberPromotion,
    TableViewSectionProductPromotion,
    TableViewSectionTotal,
} TableViewSection;

@interface EntranceViewController ()

@end

@implementation EntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_tableViewEntrance registerClass:[EntranceTableViewCell class] forCellReuseIdentifier:EntranceTableViewCellIdentifier];
    [_tableViewEntrance registerClass:[EntranceFunctionSectionHeader class] forHeaderFooterViewReuseIdentifier:EntranceFunctionSectionHeaderIdentifier];
    [_tableViewEntrance registerClass:[EntranceMemberPromoteHeader class] forHeaderFooterViewReuseIdentifier:EntranceMemberPromoteHeaderIdentifier];
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
            numberOfRows = 10;
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
    cell.textLabel.text = [NSString stringWithFormat:@"Section[%li] Row[%li]", (long)indexPath.section, (long)indexPath.row];
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
    CGFloat heightForRow = 60.0;
    return heightForRow;
}

@end
