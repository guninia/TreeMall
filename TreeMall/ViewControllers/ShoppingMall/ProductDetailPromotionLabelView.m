//
//  ProductDetailPromotionLabelView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/18.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductDetailPromotionLabelView.h"
#import "LocalizedString.h"

static CGFloat kTextIndent = 3.0;
static CGFloat marginL = 10.0;
static CGFloat marginR = 10.0;

@interface ProductDetailPromotionLabelView ()

- (void)initialize;

@end

@implementation ProductDetailPromotionLabelView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
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
    
    CGFloat originX = marginL;
    
    CGSize titleLabelSize = CGSizeZero;
    if (self.labelTitle)
    {
        CGSize titleSize = [self.labelTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil]];
        titleLabelSize = CGSizeMake(ceil(titleSize.width + kTextIndent * 2), ceil(titleSize.height));
    }
    
    CGFloat maxPromotionWidth = self.frame.size.width - (marginL + marginR - titleLabelSize.width);
    CGSize promotionLabelSize = CGSizeZero;
    if (self.labelPromotion)
    {
        CGSize size = [self.labelPromotion.text boundingRectWithSize:CGSizeMake(maxPromotionWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributesPromotion context:nil].size;
        promotionLabelSize = CGSizeMake(ceil(size.width), ceil(size.height));
        titleLabelSize.height = promotionLabelSize.height;
    }
    if (self.labelTitle)
    {
        CGRect frame = CGRectMake(originX, (self.frame.size.height - titleLabelSize.height)/2, titleLabelSize.width, titleLabelSize.height);
        self.labelTitle.frame = frame;
        originX = self.labelTitle.frame.origin.x + self.labelTitle.frame.size.width;
    }
    if (self.labelPromotion)
    {
        CGRect frame = CGRectMake(originX, (self.frame.size.height - promotionLabelSize.height)/2, promotionLabelSize.width, promotionLabelSize.height);
        self.labelPromotion.frame = frame;
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    self.labelTitle.backgroundColor = tintColor;
    [self.labelPromotion.layer setBorderColor:tintColor.CGColor];
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setBackgroundColor:self.tintColor];
        [_labelTitle setTextColor:[UIColor whiteColor]];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setText:[LocalizedString Promotions]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelTitle setFont:font];
    }
    return _labelTitle;
}

- (UILabel *)labelPromotion
{
    if (_labelPromotion == nil)
    {
        _labelPromotion = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPromotion setBackgroundColor:[UIColor clearColor]];
        [_labelPromotion setTextColor:self.tintColor];
        [_labelPromotion setTextAlignment:NSTextAlignmentLeft];
        [_labelPromotion.layer setBorderWidth:1.0];
        [_labelPromotion.layer setBorderColor:self.tintColor.CGColor];
        [_labelPromotion setNumberOfLines:0];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelPromotion setFont:font];
    }
    return _labelPromotion;
}

- (void)setPromotion:(NSString *)promotion
{
    _promotion = promotion;
    if (_promotion == nil)
    {
        self.labelPromotion.text = @"";
        return;
    }
    // Should try NSAttributedString
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_promotion attributes:self.attributesPromotion];
    [self.labelPromotion setAttributedText:attrString];
}

- (NSDictionary *)attributesPromotion
{
    if (_attributesPromotion == nil)
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.firstLineHeadIndent = kTextIndent;
        style.headIndent = kTextIndent;
        style.tailIndent = kTextIndent;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        _attributesPromotion = [[NSDictionary alloc] initWithObjectsAndKeys:style, NSParagraphStyleAttributeName, nil];
    }
    return _attributesPromotion;
}

#pragma mark - Private Methods

- (void)initialize
{
    [self addSubview:self.labelTitle];
    [self addSubview:self.labelPromotion];
}

#pragma mark - Public Methods

- (CGFloat)referenceHeightForViewWidth:(CGFloat)viewWidth
{
    CGFloat referenceHeight = [self referenceHeightForPromotion:self.labelPromotion.text withViewWidth:viewWidth];
    return referenceHeight;
}

- (CGFloat)referenceHeightForPromotion:(NSString *)promotion withViewWidth:(CGFloat)viewWidth
{
    CGFloat referenceHeight = 0.0;
    if (promotion == nil)
    {
        return referenceHeight;
    }
    CGFloat marginV = 8.0;
    CGSize titleSize = [self.labelTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil]];
    CGSize titleLabelSize = CGSizeMake(ceil(titleSize.width + kTextIndent * 2), ceil(titleSize.height));
    CGFloat maxPromotionWidth = viewWidth - (marginL + marginR - titleLabelSize.width);
    CGSize size = [promotion boundingRectWithSize:CGSizeMake(maxPromotionWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributesPromotion context:nil].size;
    CGSize promotionLabelSize = CGSizeMake(ceil(size.width), ceil(size.height));
    
    referenceHeight = promotionLabelSize.height + marginV * 2;
    
    return referenceHeight;
}

@end
