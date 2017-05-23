//
//  DeliverProgressTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *DeliverProgressTableViewCellIdentifier = @"DeliverProgressTableViewCell";

@interface DeliverProgressTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *statusString;

@end
