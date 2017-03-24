//
//  EntranceMemberPromoteHeader.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTitleButton.h"

static NSString *EntranceMemberPromoteHeaderIdentifier = @"EntranceMemberPromoteHeader";

@interface EntranceMemberPromoteHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *imageViewBackground;
@property (nonatomic, strong) UILabel *labelGreetings;
@property (nonatomic, strong) UIView *viewImageBackground;
@property (nonatomic, strong) UIImageView *imageViewPromotion;
@property (nonatomic, strong) UILabel *labelPointTitle;
@property (nonatomic, strong) UILabel *labelPointValue;
@property (nonatomic, strong) UILabel *labelCouponTitle;
@property (nonatomic, strong) UILabel *labelCouponValue;
@property (nonatomic, strong) ImageTitleButton *buttonMarketing;

@end
