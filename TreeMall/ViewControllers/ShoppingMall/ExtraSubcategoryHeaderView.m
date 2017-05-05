//
//  ExtraSubcategoryHeaderView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ExtraSubcategoryHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface ExtraSubcategoryHeaderView ()

- (void)buttonPressed:(id)sender;

@end

@implementation ExtraSubcategoryHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSLog(@"self.contentView[%p]", self.contentView);
        [self.contentView addSubview:self.button];
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
//    NSLog(@"layoutSubviews[%4.2f,%4.2f]", self.contentView.frame.size.width, self.contentView.frame.size.height);
    CGRect buttonFrame = CGRectInset(self.contentView.bounds, 10.0, 5.0);
    self.button.frame = buttonFrame;
//    NSLog(@"self.button[%p].frame[%4.2f,%4.2f,%4.2f,%4.2f]", self.button, self.button.frame.origin.x, self.button.frame.origin.y, self.button.frame.size.width, self.button.frame.size.height);
}

- (UIButton *)button
{
    if (_button == nil)
    {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        [_button setBackgroundColor:[UIColor orangeColor]];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[_button titleLabel] setFont:[UIFont systemFontOfSize:12.0]];
        [_button.layer setCornerRadius:5.0];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark - Actions

- (void)buttonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(extraSubcategoryHeaderView:didSelectBySender:)])
    {
        [_delegate extraSubcategoryHeaderView:self didSelectBySender:sender];
    }
}

@end
