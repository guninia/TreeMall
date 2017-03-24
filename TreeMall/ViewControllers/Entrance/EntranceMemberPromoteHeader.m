//
//  EntranceMemberPromoteHeader.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "EntranceMemberPromoteHeader.h"
#import "LocalizedString.h"
#import <math.h>

@implementation EntranceMemberPromoteHeader

#pragma mark - Constructor

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.imageViewBackground];
        [self.contentView addSubview:self.labelGreetings];
        [self.contentView addSubview:self.viewImageBackground];
        [self.contentView addSubview:self.imageViewPromotion];
        [self.contentView addSubview:self.labelPointTitle];
        [self.contentView addSubview:self.labelPointValue];
        [self.contentView addSubview:self.labelCouponTitle];
        [self.contentView addSubview:self.labelCouponValue];
        [self.contentView addSubview:self.buttonMarketing];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.buttonMarketing)
    {
        CGFloat height = 30.0;
        CGRect frame = CGRectMake(0.0, self.contentView.frame.size.height - height, self.contentView.frame.size.width, height);
        self.buttonMarketing.frame = frame;
    }
    
    if (self.imageViewBackground)
    {
        CGSize sizeImage = self.imageViewBackground.image.size;
        CGSize sizeBackground = CGSizeMake(self.contentView.frame.size.width, ceil(sizeImage.height * (self.contentView.frame.size.width / sizeImage.width)));
        CGRect frame = CGRectMake(0.0, self.buttonMarketing.frame.origin.y - sizeBackground.height, sizeBackground.width, sizeBackground.height);
        self.imageViewBackground.frame = frame;
    }
    
    if (self.viewImageBackground)
    {
        CGFloat radius = ceil(self.imageViewBackground.frame.size.height / 2);
        CGPoint center = CGPointMake(self.imageViewBackground.frame.origin.x + self.imageViewBackground.frame.size.width / 2, self.imageViewBackground.frame.origin.y + (self.imageViewBackground.frame.size.height * 1 / 3));
        CGRect frame = CGRectMake(ceil(center.x - radius), ceil(center.y - radius), radius * 2, radius * 2);
        self.viewImageBackground.frame = frame;
        self.viewImageBackground.layer.cornerRadius = radius;
    }
    
    if (self.imageViewPromotion)
    {
        CGRect frame = CGRectInset(self.viewImageBackground.frame, 5.0, 5.0);
        self.imageViewPromotion.frame = frame;
        self.imageViewPromotion.layer.cornerRadius = self.imageViewPromotion.frame.size.height / 2;
    }
    
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat intervalH = 5.0;
    CGFloat intervalV = 5.0;
    
    NSString *defaultString = @"ＸＸＸＸ";
    CGSize textTitleSize = [defaultString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelPointTitle.font, NSFontAttributeName, nil]];
    CGSize textValueSize = [defaultString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelPointValue.font, NSFontAttributeName, nil]];
    CGFloat labelTitleHeight = ceil(textTitleSize.height);
    CGFloat labelValueHeight = ceil(textValueSize.height);
    
    CGFloat labelValueOriginY = self.viewImageBackground.frame.origin.y + self.viewImageBackground.frame.size.height * 3 / 4;
    CGFloat radius = self.viewImageBackground.frame.size.height / 2;
    CGFloat imageCenterToOriginY = labelValueOriginY - self.viewImageBackground.center.y;
    CGFloat centerAngle = asin(imageCenterToOriginY / radius);
    CGFloat additionWidth = ceil(radius - radius * cos(centerAngle));
    CGFloat labelLengthL = self.viewImageBackground.frame.origin.x + additionWidth - marginL - intervalH;
    CGFloat labelROriginX = CGRectGetMaxX(self.viewImageBackground.frame) - additionWidth + intervalH;
    CGFloat labelLengthR = self.contentView.frame.size.width - labelROriginX - marginR;
    
    if (self.labelPointValue)
    {
        CGRect frame = CGRectMake(marginL, labelValueOriginY, labelLengthL, labelValueHeight);
        self.labelPointValue.frame = frame;
    }
    
    if (self.labelPointTitle)
    {
        CGFloat originY = self.labelPointValue.frame.origin.y - intervalV - labelTitleHeight;
        CGRect frame = CGRectMake(marginL, originY, labelLengthL, labelTitleHeight);
        self.labelPointTitle.frame = frame;
    }
    
    if (self.labelCouponValue)
    {
        CGRect frame = CGRectMake(labelROriginX, labelValueOriginY, labelLengthR, labelValueHeight);
        self.labelCouponValue.frame = frame;
    }
    if (self.labelCouponTitle)
    {
        CGFloat originY = self.labelCouponValue.frame.origin.y - intervalV - labelTitleHeight;
        CGRect frame = CGRectMake(labelROriginX, originY, labelLengthR, labelTitleHeight);
        self.labelCouponTitle.frame = frame;
    }
    
    if (self.labelGreetings)
    {
        CGRect frame = CGRectMake(marginL, 0.0, self.contentView.frame.size.width - (marginL + marginR), self.viewImageBackground.frame.origin.y);
        self.labelGreetings.frame = frame;
    }
}

- (UIImageView *)imageViewBackground
{
    if (_imageViewBackground == nil)
    {
        _imageViewBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"bg_ind_up"];
        if (image)
        {
            [_imageViewBackground setImage:image];
        }
    }
    return _imageViewBackground;
}

- (UILabel *)labelGreetings
{
    if (_labelGreetings == nil)
    {
        _labelGreetings = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelGreetings setFont:font];
        [_labelGreetings setTextColor:[UIColor grayColor]];
        [_labelGreetings setBackgroundColor:[UIColor clearColor]];
    }
    return _labelGreetings;
}

- (UIView *)viewImageBackground
{
    if (_viewImageBackground == nil)
    {
        _viewImageBackground = [[UIView alloc] initWithFrame:CGRectZero];
        _viewImageBackground.backgroundColor = [UIColor whiteColor];
        [_viewImageBackground.layer setMasksToBounds:YES];
    }
    return _viewImageBackground;
}

- (UIImageView *)imageViewPromotion
{
    if (_imageViewPromotion == nil)
    {
        _imageViewPromotion = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageViewPromotion;
}

- (UILabel *)labelPointTitle
{
    if (_labelPointTitle == nil)
    {
        _labelPointTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPointTitle setBackgroundColor:[UIColor clearColor]];
        [_labelPointTitle setTextColor:[UIColor whiteColor]];
        [_labelPointTitle setTextAlignment:NSTextAlignmentCenter];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelPointTitle setFont:font];
        [_labelPointTitle setText:[LocalizedString MyPoints]];
    }
    return _labelPointTitle;
}

- (UILabel *)labelPointValue
{
    if (_labelPointValue == nil)
    {
        _labelPointValue = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPointValue setBackgroundColor:[UIColor clearColor]];
        [_labelPointValue setTextColor:[UIColor whiteColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelPointValue setFont:font];
        [_labelPointValue setAdjustsFontSizeToFitWidth:YES];
        [_labelPointValue setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelPointValue;
}

- (UILabel *)labelCouponTitle
{
    if (_labelCouponTitle == nil)
    {
        _labelCouponTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelCouponTitle setBackgroundColor:[UIColor clearColor]];
        [_labelCouponTitle setTextColor:[UIColor whiteColor]];
        [_labelCouponTitle setTextAlignment:NSTextAlignmentCenter];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelCouponTitle setFont:font];
        [_labelCouponTitle setText:[LocalizedString MyCoupon]];
    }
    return _labelCouponTitle;
}

- (UILabel *)labelCouponValue
{
    if (_labelCouponValue == nil)
    {
        _labelCouponValue = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelCouponValue setBackgroundColor:[UIColor clearColor]];
        [_labelCouponValue setTextColor:[UIColor whiteColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelCouponValue setFont:font];
        [_labelCouponValue setAdjustsFontSizeToFitWidth:YES];
        [_labelCouponValue setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelCouponValue;
}

- (ImageTitleButton *)buttonMarketing
{
    if (_buttonMarketing == nil)
    {
        _buttonMarketing = [[ImageTitleButton alloc] initWithFrame:CGRectZero];
        [_buttonMarketing setBackgroundColor:[UIColor colorWithRed:(100.0/255.0) green:(160.0/255.0) blue:(60.0/255.0) alpha:1.0]];
        UIImage *image = [UIImage imageNamed:@"ico_ind_announ"];
        if (image)
        {
            [_buttonMarketing.imageViewIcon setImage:image];
        }
        
    }
    return _buttonMarketing;
}

@end
