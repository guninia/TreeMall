//
//  SingleLabelCollectionReusableView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/8/8.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#define kMarginV 8.0
#define kMarginH 8.0
#define kIntervalV 5.0
#define kTitleFont [UIFont systemFontOfSize:18.0]
#define kLabelFont [UIFont systemFontOfSize:14.0]
#define kTitleText @"快速到貨滿額超值禮"

#import "SingleLabelCollectionReusableView.h"

@implementation SingleLabelCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        [self addSubview:self.labelTitle];
        [self addSubview:self.label];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat originY = kMarginV;
    CGFloat originX = kMarginH;
    
    if (self.labelTitle)
    {
        CGSize sizeTitle = [kTitleText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTitleFont, NSFontAttributeName, nil]];
        CGSize sizeLabelTitle = CGSizeMake(ceil(sizeTitle.width), ceil(sizeTitle.height));
        CGRect frame = CGRectMake(originX, originY, self.frame.size.width - kMarginH * 2, sizeLabelTitle.height);
        self.labelTitle.frame = frame;
        originY = CGRectGetMaxY(self.labelTitle.frame) + kIntervalV;
    }
    
    if (self.label)
    {
        CGRect frame = CGRectMake(originX, originY, self.frame.size.width - kMarginH * 2, self.frame.size.height - kMarginV - originY);
        self.label.frame = frame;
    }
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor redColor]];
        [_labelTitle setFont:kTitleFont];
        [_labelTitle setText:kTitleText];
    }
    return _labelTitle;
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextColor:[UIColor darkGrayColor]];
        [_label setFont:kLabelFont];
        [_label setLineBreakMode:NSLineBreakByWordWrapping];
        [_label setNumberOfLines:0];
    }
    return _label;
}

#pragma mark - Class methods

+ (CGFloat)heightForText:(NSString *)text inViewWithWidth:(CGFloat)width
{
    CGFloat height = kMarginV;
    
    CGSize sizeTitle = [kTitleText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTitleFont, NSFontAttributeName, nil]];
    CGSize sizeLabelTitle = CGSizeMake(ceil(sizeTitle.width), ceil(sizeTitle.height));
    height += sizeLabelTitle.height + kIntervalV;
    
    if (text && [text length] > 0)
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:kLabelFont, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
        CGSize sizeText = [text boundingRectWithSize:CGSizeMake((width - kMarginH * 2), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        height += sizeLabel.height + kMarginV;
    }
    
    return height;
}

@end
