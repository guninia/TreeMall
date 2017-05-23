//
//  DeliverProgressHeaderView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *DeliverProgressHeaderViewIdentifier = @"DeliverProgressHeaderView";

@interface DeliverProgressHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *deliverIdMessage;

@end
