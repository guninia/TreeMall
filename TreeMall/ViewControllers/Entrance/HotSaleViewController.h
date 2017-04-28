//
//  HotSaleViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/28.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HotSaleTypeHall,
    HotSaleTypePoint,
    HotSaleTypeCoupon,
} HotSaleType;

@interface HotSaleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) HotSaleType type;
@property (nonatomic, strong) NSMutableArray *arrayProducts;
@property (nonatomic, strong) NSNumberFormatter *formatter;

@end
