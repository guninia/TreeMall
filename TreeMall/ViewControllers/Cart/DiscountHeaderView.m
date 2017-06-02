//
//  DiscountHeaderView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/24.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DiscountHeaderView.h"

@implementation DiscountHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.labelDiscountValue];
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
    if (self.labelTitle)
    {
        CGSize sizeText = [self.labelTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, 0.0, sizeLabel.width, self.contentView.frame.size.height);
        self.labelTitle.frame = frame;
        originX = CGRectGetMaxX(self.labelTitle.frame) + intervalH;
    }
    if (self.labelDiscountValue)
    {
        CGRect frame = CGRectMake(originX, 0.0, self.contentView.frame.size.width - originX, self.contentView.frame.size.height);
        self.labelDiscountValue.frame = frame;
    }
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelTitle setFont:font];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor orangeColor]];
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
