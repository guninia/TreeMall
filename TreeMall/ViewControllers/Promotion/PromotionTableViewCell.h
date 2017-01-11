//
//  PromotionTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

static NSString *PromotionTableViewCellIdentifier = @"PromotionTableViewCell";

@interface PromotionTableViewCell : UITableViewCell
{
    NSDictionary *titleAttributes;
    NSDictionary *subtitleAttributes;
    NSDictionary *contentAttributes;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) TTTAttributedLabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UIView *viewMask;

@end
