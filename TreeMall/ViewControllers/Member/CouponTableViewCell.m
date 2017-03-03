//
//  CouponTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/3.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.imageViewArrowR];
        [self.contentView addSubview:self.imageViewCoupon];
        [self.contentView addSubview:self.labelValue];
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.labelDateStart];
        [self.contentView addSubview:self.labelDateGoodThru];
        [self.contentView addSubview:self.labelOrderId];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat marginT = 10.0;
    CGFloat intervalH = 5.0;
    CGFloat intervalV = 5.0;
    CGFloat originY = marginT;
    CGFloat positionRightEnd = self.contentView.frame.size.width - marginR;
    
    if (self.imageViewArrowR)
    {
        CGSize sizeImage = self.imageViewArrowR.image.size;
        CGRect frame = CGRectMake(positionRightEnd - sizeImage.width, (self.contentView.frame.size.height - sizeImage.height)/2, sizeImage.width, sizeImage.height);
        self.imageViewArrowR.frame = frame;
        positionRightEnd = self.imageViewArrowR.frame.origin.x - intervalH;
    }
    if (self.imageViewCoupon)
    {
        CGSize sizeImage = self.imageViewCoupon.image.size;
        CGRect frame = CGRectMake(positionRightEnd - sizeImage.width, originY, sizeImage.width, sizeImage.height);
        self.imageViewCoupon.frame = frame;
        positionRightEnd = self.imageViewCoupon.frame.origin.x - intervalH;
        
        if (self.labelValue && [self.labelValue isHidden] == NO)
        {
            CGRect frame = CGRectMake(self.imageViewCoupon.frame.origin.x + 25.0, self.imageViewCoupon.frame.origin.y, 65.0, self.imageViewCoupon.frame.size.height);
            self.labelValue.frame = frame;
        }
        originY = self.imageViewCoupon.frame.origin.y + self.imageViewCoupon.frame.size.height + intervalV;
        
        if (self.labelOrderId)
        {
            CGRect frame = CGRectMake(positionRightEnd + intervalH, originY, self.imageViewCoupon.frame.size.width, self.contentView.frame.size.height - originY);
            self.labelOrderId.frame = frame;
        }
    }
    originY = marginT * 2;
    CGFloat originX = marginL;
    if (self.labelTitle)
    {
        NSString *defaultString = @"XXXXXXXXX\nXXXXXXXX";
        CGSize sizeText = [defaultString sizeWithAttributes:self.attributeTitle];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY, positionRightEnd - originX, sizeLabel.height);
        self.labelTitle.frame = frame;
        originY = self.labelTitle.frame.origin.y + self.labelTitle.frame.size.height + intervalV;
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
}

- (UIImageView *)imageViewArrowR
{
    if (_imageViewArrowR == nil)
    {
        _imageViewArrowR = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_ord_go"];
        if (image)
        {
            [_imageViewArrowR setImage:image];
        }
    }
    return _imageViewArrowR;
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

- (TTTAttributedLabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelTitle.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor darkGrayColor]];
        [_labelTitle setNumberOfLines:0];
        NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:self.attributeTitle];
        [_labelTitle setAttributedTruncationToken:truncationToken];
    }
    return _labelTitle;
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

- (UILabel *)labelOrderId
{
    if (_labelOrderId == nil)
    {
        _labelOrderId = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelOrderId setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:10.0];
        [_labelOrderId setFont:font];
        [_labelOrderId setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelOrderId setTextAlignment:NSTextAlignmentLeft];
        [_labelOrderId setNumberOfLines:0];
        [_labelOrderId setText:@"訂單編號\nAX12345676568"];
    }
    return _labelOrderId;
}

- (NSNumberFormatter *)formatter
{
    if (_formatter == nil)
    {
        _formatter = [[NSNumberFormatter alloc] init];
        [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _formatter;
}

- (void)setNumberValue:(NSNumber *)numberValue
{
    if ([_numberValue integerValue] != [numberValue integerValue])
    {
        _numberValue = numberValue;
    }
    NSString *stringValue = @"0";
    if (_numberValue != nil)
    {
        stringValue = [self.formatter stringFromNumber:_numberValue];
        [self.labelValue setHidden:NO];
    }
    else
    {
        [self.labelValue setHidden:YES];
    }
    NSString *totalString = [NSString stringWithFormat:@"＄%@", stringValue];
    [self.labelValue setText:totalString];
}

- (NSDictionary *)attributeTitle
{
    if (_attributeTitle == nil)
    {
        UIFont *font = [UIFont systemFontOfSize:14.0];
        _attributeTitle = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, nil];
    }
    return _attributeTitle;
}

@end
