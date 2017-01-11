//
//  PromotionTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *PromotionTableViewCellIdentifier = @"PromotionTableViewCell";

@interface PromotionTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dictionaryData;
@property (nonatomic, strong) UIView *viewMask;

@end
