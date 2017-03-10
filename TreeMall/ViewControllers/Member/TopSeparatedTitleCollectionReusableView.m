//
//  TopSeparatedTitleCollectionReusableView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "TopSeparatedTitleCollectionReusableView.h"

@implementation TopSeparatedTitleCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _marginL = 0.0;
        _marginR = 0.0;
        [self addSubview:self.labelTitle];
        [self addSubview:self.separator];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat originY = 0.0;
    if (self.separator)
    {
        CGFloat separatorWidth = self.frame.size.width;
        CGRect frame = CGRectMake((self.frame.size.width - separatorWidth)/2, originY, separatorWidth, 2.0);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height;
    }
    if (self.labelTitle)
    {
        CGRect frame = CGRectMake(self.marginL, originY, self.frame.size.width - (self.marginL + self.marginR), self.frame.size.height - originY);
        self.labelTitle.frame = frame;
    }
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setTextColor:[UIColor darkGrayColor]];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont boldSystemFontOfSize:14.0];
        [_labelTitle setFont:font];
    }
    return _labelTitle;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _separator;
}

@end
