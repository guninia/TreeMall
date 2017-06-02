//
//  DiscountFooterView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/6/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DiscountFooterView.h"

@implementation DiscountFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.viewContainer];
        [self.viewContainer addSubview:self.labelTitle];
        [self.viewContainer addSubview:self.labelDiscountValue];
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

    CGFloat marginH = 10.0;
    CGFloat originX = marginH;
    CGFloat intervalH = 10.0;
    
    if (self.viewContainer)
    {
        CGRect frame = CGRectInset(self.contentView.frame, 10.0, 0.0);
        self.viewContainer.frame = frame;
    }
    
    if (self.labelDiscountValue)
    {
        CGSize sizeText = [self.labelDiscountValue.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelDiscountValue.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(self.viewContainer.frame.size.width - marginH - sizeLabel.width, 0.0, sizeLabel.width, self.viewContainer.frame.size.height);
        self.labelDiscountValue.frame = frame;
    }
    if (self.labelTitle)
    {
        CGRect frame = CGRectMake(originX, 0.0, CGRectGetMinX(self.labelDiscountValue.frame) - intervalH - originX, self.viewContainer.frame.size.height);
        self.labelTitle.frame = frame;
    }
}

- (UIView *)viewContainer
{
    if (_viewContainer == nil)
    {
        _viewContainer = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewContainer setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    }
    return _viewContainer;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelTitle setFont:font];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor blackColor]];
        [_labelTitle setTextAlignment:NSTextAlignmentRight];
    }
    return _labelTitle;
}

- (UILabel *)labelDiscountValue
{
    if (_labelDiscountValue == nil)
    {
        _labelDiscountValue = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelDiscountValue setFont:font];
        [_labelDiscountValue setBackgroundColor:[UIColor clearColor]];
        [_labelDiscountValue setTextColor:[UIColor redColor]];
    }
    return _labelDiscountValue;
}

@end
