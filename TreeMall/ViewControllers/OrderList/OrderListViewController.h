//
//  OrderListViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownListButton.h"

@interface OrderListViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *viewSegmentedBackground;
@property (nonatomic, strong) UISegmentedControl *segmentedControlState;
@property (nonatomic, strong) UIView *viewSearchBackground;
@property (nonatomic, strong) UITextField *textFieldSearch;
@property (nonatomic, strong) UIView *viewButtonBackground;
@property (nonatomic, strong) DropdownListButton *buttonOrderTime;
@property (nonatomic, strong) DropdownListButton *buttonShipType;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UITableView *tableView;



@end
