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

@class EntranceMemberPromoteHeader;

@protocol EntranceMemberPromoteHeaderDelegate <NSObject>

- (void)entranceMemberPromoteHeader:(EntranceMemberPromoteHeader *)header didPressedPromotionBySender:(id)sender;
- (void)entranceMemberPromoteHeader:(EntranceMemberPromoteHeader *)header didPressedMarketingBySender:(id)sender;

@end

@interface EntranceMemberPromoteHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id <EntranceMemberPromoteHeaderDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageViewBackground;
@property (nonatomic, strong) UILabel *labelGreetings;
@property (nonatomic, strong) UIView *viewImageBackground;
@property (nonatomic, strong) UIButton *buttonPromotion;
@property (nonatomic, strong) UILabel *labelPointTitle;
@property (nonatomic, strong) UILabel *labelPointValue;
@property (nonatomic, strong) UILabel *labelCouponTitle;
@property (nonatomic, strong) UILabel *labelCouponValue;
@property (nonatomic, strong) ImageTitleButton *buttonMarketing;
@property (nonatomic, strong) UIButton *buttonMarketingArrow;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSNumber *numberTotalPoint;
@property (nonatomic, strong) NSNumber *numberCouponValue;
@property (nonatomic, strong) NSString *promotionImageUrlPath;

@end
