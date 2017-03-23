//
//  OrderDeliverProgressView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/14.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDeliverProgressView : UIView

@property (nonatomic, strong) NSMutableArray *arrayProgressBar;
@property (nonatomic, strong) NSMutableArray *arrayLabelStatus;
@property (nonatomic, strong) NSMutableArray *arrayLabelDateTime;
@property (nonatomic, strong) NSArray *arrayProgress;
@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic, strong) UIFont *fontStatus;
@property (nonatomic, strong) UIFont *fontDateTime;

@end
