//
//  CouponDetailDescriptionView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

@class CouponDetailDescriptionView;

@protocol CouponDetailDescriptionViewDelegate <NSObject>

- (void)couponDetailDescriptionView:(CouponDetailDescriptionView *)view didPressActionBySender:(id)sender;

@end

@interface CouponDetailDescriptionView : UIView
{
    CGSize referenceSize;
}

@property (nonatomic, weak) id <CouponDetailDescriptionViewDelegate> delegate;
@property (nonatomic, strong) TTTAttributedLabel *labelTitle;
@property (nonatomic, strong) TTTAttributedLabel *labelCondition;
@property (nonatomic, strong) UILabel *labelDateStart;
@property (nonatomic, strong) UILabel *labelDateGoodThru;
@property (nonatomic, strong) UIImageView *imageViewCoupon;
@property (nonatomic, strong) UILabel *labelValue;
@property (nonatomic, strong) UIButton *buttonAction;
@property (nonatomic, strong) NSDictionary *attributesTitle;
@property (nonatomic, strong) NSDictionary *attributesCondition;


// Before calling this method, please make sure the data been already set to the UI elements.
- (CGFloat)referenceHeightForFixedWidth:(CGFloat)width;

@end
