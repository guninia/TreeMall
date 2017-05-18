//
//  SeparatorLineHeaderView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/17.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SeparatorLineHeaderView.h"

@interface SeparatorLineHeaderView ()

@property (nonatomic, strong) UIView *separator;

@end

@implementation SeparatorLineHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.separator];
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
    
    CGFloat marginH = 0.0;
    
    if (self.separator)
    {
        CGFloat separatorHeight = 1.0;
        CGRect frame = CGRectMake(marginH, (self.contentView.frame.size.height - separatorHeight)/2, self.contentView.frame.size.width - marginH * 2, separatorHeight);
        self.separator.frame = frame;
    }
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
