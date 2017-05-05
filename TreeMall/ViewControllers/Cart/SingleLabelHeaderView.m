//
//  SingleLabelHeaderView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/3.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SingleLabelHeaderView.h"

@implementation SingleLabelHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.label];
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
    
    if (self.label)
    {
        CGRect frame = CGRectMake(marginH, 0.0, self.contentView.frame.size.width - marginH * 2, self.contentView.frame.size.height);
        self.label.frame = frame;
    }
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setTextColor:[UIColor blackColor]];
        [_label setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_label setFont:font];
    }
    return _label;
}

@end
