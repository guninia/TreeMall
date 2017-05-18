//
//  SingleLabelHeaderView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/3.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SingleLabelHeaderView.h"
#import "Definition.h"

@interface SingleLabelHeaderView ()

- (void)buttonPressed:(id)sender;

@end

@implementation SingleLabelHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        _marginH = 10.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.label];
        [self addSubview:self.button];
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
    
    CGFloat marginH = self.marginH;
    
    if (self.label)
    {
        CGRect frame = CGRectMake(marginH, 0.0, self.contentView.frame.size.width - marginH * 2, self.contentView.frame.size.height);
        self.label.frame = frame;
    }
    if (self.button)
    {
        CGSize buttonSize = CGSizeMake(60.0, 30.0);
        CGRect frame = CGRectMake(self.contentView.frame.size.width - marginH - buttonSize.width, (self.contentView.frame.size.height - buttonSize.height)/2, buttonSize.width, buttonSize.height);
        self.button.frame = frame;
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

- (UIButton *)button
{
    if (_button == nil)
    {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        [_button setBackgroundColor:TMMainColor];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_button.titleLabel setFont:font];
        [_button.layer setCornerRadius:5.0];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_button setHidden:YES];
    }
    return _button;
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    if (_buttonTitle == nil)
    {
        if ([self.button isHidden] == NO)
        {
            self.button.hidden = YES;
        }
        return;
    }
    [self.button setTitle:_buttonTitle forState:UIControlStateNormal];
    self.button.hidden = NO;
}

#pragma mark - Actions

- (void)buttonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(singleLabelHeaderView:didPressButton:)])
    {
        [_delegate singleLabelHeaderView:self didPressButton:sender];
    }
}

@end
