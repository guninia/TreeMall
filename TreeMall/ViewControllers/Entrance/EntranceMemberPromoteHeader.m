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
#import <UIImageView+WebCache.h>

@interface EntranceMemberPromoteHeader ()

- (void)buttonPromotionPressed:(id)sender;
- (void)buttonMarketingPressed:(id)sender;
- (void)buttonPointPressed:(id)sender;
- (void)buttonCouponPressed:(id)sender;

@end

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
        [self.contentView addSubview:self.buttonPromotion];
        [self.contentView addSubview:self.labelPointTitle];
        [self.contentView addSubview:self.labelPointValue];
        [self.contentView addSubview:self.labelCouponTitle];
        [self.contentView addSubview:self.labelCouponValue];
        [self.contentView addSubview:self.buttonMarketing];
        [self.contentView addSubview:self.buttonMarketingArrow];
        [self.contentView addSubview:self.buttonPoint];
        [self.contentView addSubview:self.buttonCoupon];
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
    
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat intervalH = 5.0;
    CGFloat intervalV = 5.0;
    
    if (self.labelGreetings)
    {
        NSString *defaultString = @"ＸＸＸＸＸＸ";
        CGSize sizeText = [defaultString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelGreetings.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginL, 0.0, self.contentView.frame.size.width - (marginL + marginR), sizeLabel.height);
        self.labelGreetings.frame = frame;
    }
    
    if (self.buttonMarketing)
    {
        self.buttonMarketing.marginR = 40.0;
        self.buttonMarketing.marginL = 20.0;
        CGFloat height = 30.0;
        CGRect frame = CGRectMake(0.0, self.contentView.frame.size.height - height, self.contentView.frame.size.width, height);
        self.buttonMarketing.frame = frame;
        if (self.buttonMarketingArrow)
        {
            CGSize size = CGSizeMake(10.0, 15.0);
            CGRect frame = CGRectMake(self.buttonMarketing.frame.origin.x + self.buttonMarketing.frame.size.width - 10.0 - size.width, (self.buttonMarketing.frame.origin.y + (self.buttonMarketing.frame.size.height - size.height)/2), size.width, size.height);
            self.buttonMarketingArrow.frame = frame;
        }
    }
    
    if (self.imageViewBackground)
    {
        CGSize sizeImage = self.imageViewBackground.image.size;
        CGSize sizeBackground = CGSizeMake(self.contentView.frame.size.width, ceil(sizeImage.height * (self.contentView.frame.size.width / sizeImage.width)));
        CGFloat maxHeight = self.buttonMarketing.frame.origin.y - (CGRectGetMaxY(self.labelGreetings.frame) + intervalV);
        if (sizeBackground.height > maxHeight)
        {
            sizeBackground.height = maxHeight;
        }
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
    
    if (self.buttonPromotion)
    {
//        CGRect frame = CGRectInset(self.viewImageBackground.frame, 5.0, 5.0);
        CGRect frame = self.viewImageBackground.frame;
        self.buttonPromotion.frame = frame;
        self.buttonPromotion.layer.cornerRadius = self.buttonPromotion.frame.size.height / 2;
    }
    
    
    
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
    if (self.buttonPoint)
    {
        CGFloat originX = CGRectGetMinX(self.labelPointTitle.frame);
        CGFloat originY = CGRectGetMinY(self.labelPointTitle.frame);
        CGFloat width = CGRectGetMaxX(self.labelPointTitle.frame) - originX;
        CGFloat height = CGRectGetMaxY(self.labelPointValue.frame) - originY;
        CGRect frame = CGRectMake(originX, originY, width, height);
        self.buttonPoint.frame = frame;
    }
    if (self.buttonCoupon)
    {
        CGFloat originX = CGRectGetMinX(self.labelCouponTitle.frame);
        CGFloat originY = CGRectGetMinY(self.labelCouponTitle.frame);
        CGFloat width = CGRectGetMaxX(self.labelCouponTitle.frame) - originX;
        CGFloat height = CGRectGetMaxY(self.labelCouponValue.frame) - originY;
        CGRect frame = CGRectMake(originX, originY, width, height);
        self.buttonCoupon.frame = frame;
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
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelGreetings setFont:font];
        [_labelGreetings setTextColor:[UIColor grayColor]];
        [_labelGreetings setBackgroundColor:[UIColor clearColor]];
        [_labelGreetings setTextAlignment:NSTextAlignmentCenter];
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

- (UIButton *)buttonPromotion
{
    if (_buttonPromotion == nil)
    {
        _buttonPromotion = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonPromotion setBackgroundColor:[UIColor clearColor]];
        [_buttonPromotion.layer setMasksToBounds:YES];
        [_buttonPromotion addTarget:self action:@selector(buttonPromotionPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonPromotion;
}

- (UILabel *)labelPointTitle
{
    if (_labelPointTitle == nil)
    {
        _labelPointTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPointTitle setBackgroundColor:[UIColor clearColor]];
        [_labelPointTitle setTextColor:[UIColor whiteColor]];
        [_labelPointTitle setTextAlignment:NSTextAlignmentCenter];
        UIFont *font = [UIFont systemFontOfSize:16.0];
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
        UIFont *font = [UIFont systemFontOfSize:18.0];
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
        UIFont *font = [UIFont systemFontOfSize:16.0];
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
        UIFont *font = [UIFont systemFontOfSize:18.0];
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
        [_buttonMarketing.labelText setTextAlignment:NSTextAlignmentCenter];
        [_buttonMarketing.labelText setFont:[UIFont systemFontOfSize:16.0]];
        [_buttonMarketing.layer setCornerRadius:0.0];
        [_buttonMarketing addTarget:self action:@selector(buttonMarketingPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonMarketing;
}

- (UIButton *)buttonMarketingArrow
{
    if (_buttonMarketingArrow == nil)
    {
        _buttonMarketingArrow = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [[UIImage imageNamed:@"men_my_ord_go"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (image)
        {
            [_buttonMarketingArrow setImage:image forState:UIControlStateNormal];
        }
        [_buttonMarketingArrow.imageView setTintColor:[UIColor whiteColor]];
        [_buttonMarketingArrow addTarget:self action:@selector(buttonMarketingPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonMarketingArrow;
}

- (NSNumberFormatter *)numberFormatter
{
    if (_numberFormatter == nil)
    {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _numberFormatter;
}

- (void)setNumberTotalPoint:(NSNumber *)numberTotalPoint
{
    _numberTotalPoint = numberTotalPoint;
    if (_numberTotalPoint == nil)
    {
        self.labelPointValue.text = [LocalizedString PleaseLogin];
        self.labelPointTitle.hidden = NO;
        self.labelPointValue.hidden = NO;
    }
    else
    {
        NSString *string = [self.numberFormatter stringFromNumber:_numberTotalPoint];
        self.labelPointValue.text = string;
        self.labelPointTitle.hidden = NO;
        self.labelPointValue.hidden = NO;
    }
}

- (void)setNumberCouponValue:(NSNumber *)numberCouponValue
{
    _numberCouponValue = numberCouponValue;
    if (_numberCouponValue == nil)
    {
        self.labelCouponValue.text = [LocalizedString PleaseLogin];
        self.labelCouponTitle.hidden = NO;
        self.labelCouponValue.hidden = NO;
    }
    else
    {
        NSString *prefix = @"＄";
        NSString *string = [self.numberFormatter stringFromNumber:_numberCouponValue];
        self.labelCouponValue.text = [NSString stringWithFormat:@"%@%@", prefix, string];
        self.labelCouponTitle.hidden = NO;
        self.labelCouponValue.hidden = NO;
    }
}

- (void)setPromotionImageUrlPath:(NSString *)promotionImageUrlPath
{
    _promotionImageUrlPath = promotionImageUrlPath;
    if (_promotionImageUrlPath == nil)
    {
        [self.buttonPromotion setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:_promotionImageUrlPath];
        if (url)
        {
            __weak EntranceMemberPromoteHeader *weakSelf = self;
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderAllowInvalidSSLCertificates progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished){
                if (error == nil && image)
                {
                    [weakSelf.buttonPromotion setBackgroundImage:image forState:UIControlStateNormal];
                }
            }];
        }
    }
}

- (UIButton *)buttonPoint
{
    if (_buttonPoint == nil)
    {
        _buttonPoint = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonPoint setBackgroundColor:[UIColor clearColor]];
        [_buttonPoint addTarget:self action:@selector(buttonPointPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonPoint;
}

- (UIButton *)buttonCoupon
{
    if (_buttonCoupon == nil)
    {
        _buttonCoupon = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonCoupon setBackgroundColor:[UIColor clearColor]];
        [_buttonCoupon addTarget:self action:@selector(buttonCouponPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonCoupon;
}

#pragma mark - Actions

- (void)buttonPromotionPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(entranceMemberPromoteHeader:didPressedPromotionBySender:)])
    {
        [_delegate entranceMemberPromoteHeader:self didPressedPromotionBySender:sender];
    }
}

- (void)buttonMarketingPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(entranceMemberPromoteHeader:didPressedMarketingBySender:)])
    {
        [_delegate entranceMemberPromoteHeader:self didPressedMarketingBySender:sender];
    }
}

- (void)buttonPointPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(entranceMemberPromoteHeader:didPressedPointBySender:)])
    {
        [_delegate entranceMemberPromoteHeader:self didPressedPointBySender:sender];
    }
}

- (void)buttonCouponPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(entranceMemberPromoteHeader:didPressedCouponBySender:)])
    {
        [_delegate entranceMemberPromoteHeader:self didPressedCouponBySender:sender];
    }
}

@end
