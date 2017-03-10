//
//  CouponDetailDescriptionView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CouponDetailDescriptionView.h"
#import "APIDefinition.h"
#import "LocalizedString.h"

@interface CouponDetailDescriptionView ()

- (void)buttonActionPressed:(id)sender;

@end

@implementation CouponDetailDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        referenceSize = CGSizeZero;
        [self addSubview:self.imageViewCoupon];
        [self addSubview:self.labelValue];
        [self addSubview:self.labelTitle];
        [self addSubview:self.labelCondition];
        [self addSubview:self.labelDateStart];
        [self addSubview:self.labelDateGoodThru];
        [self addSubview:self.buttonAction];
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
    
    [self referenceHeightForFixedWidth:self.frame.size.width];
}

- (TTTAttributedLabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelTitle.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor darkGrayColor]];
        [_labelTitle setNumberOfLines:0];
        NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:self.attributesTitle];
        [_labelTitle setAttributedTruncationToken:truncationToken];
    }
    return _labelTitle;
}

- (TTTAttributedLabel *)labelCondition
{
    if (_labelCondition == nil)
    {
        _labelCondition = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelCondition.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        [_labelCondition setBackgroundColor:[UIColor clearColor]];
        [_labelCondition setTextColor:[UIColor darkGrayColor]];
        [_labelCondition setNumberOfLines:0];
        NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:self.attributesCondition];
        [_labelCondition setAttributedTruncationToken:truncationToken];
    }
    return _labelCondition;
}

- (UILabel *)labelDateStart
{
    if (_labelDateStart == nil)
    {
        _labelDateStart = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelDateStart setFont:font];
        [_labelDateStart setBackgroundColor:[UIColor clearColor]];
        [_labelDateStart setTextColor:[UIColor grayColor]];
    }
    return _labelDateStart;
}

- (UILabel *)labelDateGoodThru
{
    if (_labelDateGoodThru == nil)
    {
        _labelDateGoodThru = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelDateGoodThru setFont:font];
        [_labelDateGoodThru setBackgroundColor:[UIColor clearColor]];
        [_labelDateGoodThru setTextColor:[UIColor grayColor]];
    }
    return _labelDateGoodThru;
}

- (UIImageView *)imageViewCoupon
{
    if (_imageViewCoupon == nil)
    {
        _imageViewCoupon = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_coupon"];
        if (image)
        {
            [_imageViewCoupon setImage:image];
        }
    }
    return _imageViewCoupon;
}

- (UILabel *)labelValue
{
    if (_labelValue == nil)
    {
        _labelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelValue setFont:font];
        [_labelValue setBackgroundColor:[UIColor clearColor]];
        [_labelValue setTextColor:[UIColor redColor]];
        [_labelValue setTextAlignment:NSTextAlignmentCenter];
        [_labelValue setAdjustsFontSizeToFitWidth:YES];
    }
    return _labelValue;
}

- (UIButton *)buttonAction
{
    if (_buttonAction == nil)
    {
        _buttonAction = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonAction setTitle:[LocalizedString CampaignLink] forState:UIControlStateNormal];
        [_buttonAction setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_buttonAction.layer setBorderWidth:1.0];
        [_buttonAction.layer setBorderColor:[_buttonAction titleColorForState:UIControlStateNormal].CGColor];
        [_buttonAction.layer setCornerRadius:3.0];
        [_buttonAction addTarget:self action:@selector(buttonActionPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonAction;
}

- (NSDictionary *)attributesTitle
{
    if (_attributesTitle == nil)
    {
        UIFont *font = [UIFont boldSystemFontOfSize:16.0];
        _attributesTitle = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, nil];
    }
    return _attributesTitle;
}

- (NSDictionary *)attributesCondition
{
    if (_attributesCondition == nil)
    {
        UIFont *font = [UIFont systemFontOfSize:12.0];
        _attributesCondition = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, nil];
    }
    return _attributesCondition;
}

#pragma mark - Actions

- (void)buttonActionPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(couponDetailDescriptionView:didPressActionBySender:)])
    {
        [_delegate couponDetailDescriptionView:self didPressActionBySender:sender];
    }
}

#pragma mark - Public Methods

- (CGFloat)referenceHeightForFixedWidth:(CGFloat)width
{
    if (referenceSize.width == width)
    {
        return referenceSize.height;
    }
    referenceSize.width = width;
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat marginT = 10.0;
    CGFloat marginB = 10.0;
    CGFloat intervalH = 5.0;
    CGFloat intervalV = 5.0;
    CGFloat originY = marginT;
    CGFloat positionRightEnd = width - marginR;
    CGFloat bottomRight = originY;
    CGFloat bottomLeft = originY;
    
    CGSize sizeImage = CGSizeZero;
    if (self.imageViewCoupon)
    {
        sizeImage = CGSizeMake(ceil(self.imageViewCoupon.image.size.width), ceil(self.imageViewCoupon.image.size.height));
        positionRightEnd = positionRightEnd - sizeImage.width - intervalH;
        originY = originY + sizeImage.height + intervalV;
    }
    bottomRight = originY + intervalV;
    
    originY = marginT;
    CGFloat originX = marginL;
    if (self.labelTitle && [self.labelTitle isHidden] == NO)
    {
        NSString *defaultString = self.labelTitle.text;
        CGSize sizeText = [defaultString sizeWithAttributes:self.attributesTitle];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, positionRightEnd - originX, sizeLabel.height);
        self.labelTitle.frame = frame;
        originY = self.labelTitle.frame.origin.y + self.labelTitle.frame.size.height + intervalV;
    }
    if (self.labelCondition && [self.labelCondition isHidden] == NO)
    {
        NSString *defaultString = self.labelCondition.text;
        CGSize sizeText = [defaultString sizeWithAttributes:self.attributesCondition];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, positionRightEnd - originX, sizeLabel.height);
        self.labelCondition.frame = frame;
        originY = self.labelCondition.frame.origin.y + self.labelCondition.frame.size.height + intervalV;
    }
    if (self.labelDateStart && [self.labelDateStart isHidden] == NO)
    {
        NSString *defaultString = @"XXXXXXXXX";
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelDateStart.font, NSFontAttributeName, nil];
        CGSize sizeText = [defaultString sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, positionRightEnd - originX, sizeLabel.height);
        self.labelDateStart.frame = frame;
        originY = self.labelDateStart.frame.origin.y + self.labelDateStart.frame.size.height + intervalV;
    }
    if (self.labelDateGoodThru && [self.labelDateStart isHidden] == NO)
    {
        NSString *defaultString = @"XXXXXXXXX";
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelDateGoodThru.font, NSFontAttributeName, nil];
        CGSize sizeText = [defaultString sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, positionRightEnd - originX, sizeLabel.height);
        self.labelDateGoodThru.frame = frame;
        originY = self.labelDateGoodThru.frame.origin.y + self.labelDateGoodThru.frame.size.height + intervalV;
    }
    bottomLeft = originY + intervalV;
    
    originY = MAX(bottomLeft, bottomRight);
    
    // Move the imageView
    if (self.imageViewCoupon)
    {
        CGFloat imageViewOriginX = positionRightEnd + intervalH;
        CGRect frame = CGRectMake(imageViewOriginX, (originY - sizeImage.height)/2, sizeImage.width, sizeImage.height);
        self.imageViewCoupon.frame = frame;
        if (self.labelValue && [self.labelValue isHidden] == NO)
        {
            CGRect frame = CGRectMake(self.imageViewCoupon.frame.origin.x + 25.0, self.imageViewCoupon.frame.origin.y, 65.0, self.imageViewCoupon.frame.size.height);
            self.labelValue.frame = frame;
        }
    }
    
    NSLog(@"referenceHeightForFixedWidth[%4.2f] - originY[%4.2f] --- 1", width, originY);
    if (self.buttonAction && [self.buttonAction isHidden] == NO)
    {
        CGSize buttonSize = CGSizeMake(200.0, 40.0);
        CGRect frame = CGRectMake((width - buttonSize.width)/2, originY, buttonSize.width, buttonSize.height);
        self.buttonAction.frame = frame;
        originY = self.buttonAction.frame.origin.y + self.buttonAction.frame.size.height + marginB;
    }
    else
    {
        originY = originY + marginB;
    }
    NSLog(@"referenceHeightForFixedWidth[%4.2f] - originY[%4.2f] --- 2", width, originY);
    referenceSize.height = originY;
    return referenceSize.height;
}

@end
