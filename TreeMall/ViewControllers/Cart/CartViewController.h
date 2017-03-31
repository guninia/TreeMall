//
//  CartViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SemiCircleEndsSegmentedView.h"
#import "LabelButtonView.h"
#import "CartProductTableViewCell.h"
#import "TMInfoManager.h"

@interface CartViewController : UIViewController <SemiCircleEndsSegmentedViewDelegate>

@property (nonatomic, strong) SemiCircleEndsSegmentedView *segmentedView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LabelButtonView *bottomBar;
@property (nonatomic, assign) CartType currentType;
@property (nonatomic, strong) NSMutableDictionary *dictionaryConditions;
@end
