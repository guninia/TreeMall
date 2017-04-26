//
//  LabelButtonView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "LabelButtonView.h"
#import "LocalizedString.h"

@interface LabelButtonView ()

- (void)buttonPressed:(id)sender;

@end

@implementation LabelButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.label];
        [self addSubview:self.button];
        
        [self.layer setMasksToBounds:NO];
        [self.layer setShadowOffset:CGSizeMake(0.0, -2.0)];
        [self.layer setShadowColor:[UIColor grayColor].CGColor];
        [self setBackgroundColor:[UIColor colorWithWhite:(250.0/255.0) alpha:1.0]];
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
    CGFloat intervalH = 5.0;
    
    if (self.button)
    {
        CGFloat height = ceil(self.frame.size.height * 4 / 5);
        CGFloat width = height * 2;
        CGRect frame = CGRectMake(self.frame.size.width - marginH - width, (self.frame.size.height - height)/2, width, height);
        self.button.frame = frame;
    }
    
    if (self.label)
    {
        CGRect frame = CGRectMake(marginH, 0.0, CGRectGetMinX(self.button.frame) - intervalH - marginH, self.frame.size.height);
        self.label.frame = frame;
    }
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setAdjustsFontSizeToFitWidth:YES];
        [_label setTextAlignment:NSTextAlignmentLeft];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_label setFont:font];
    }
    return _label;
}

- (UIButton *)button
{
    if (_button == nil)
    {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        [_button setBackgroundColor:[UIColor orangeColor]];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:[LocalizedString NextStep] forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_button.layer setCornerRadius:5.0];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark - Actions

- (void)buttonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(labelButtonView:didPressButton:)])
    {
        [_delegate labelButtonView:self didPressButton:sender];
    }
}

@end
