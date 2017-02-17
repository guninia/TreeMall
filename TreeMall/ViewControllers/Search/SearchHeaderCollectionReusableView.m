//
//  SearchHeaderCollectionReusableView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/17.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SearchHeaderCollectionReusableView.h"

@interface SearchHeaderCollectionReusableView ()

- (void)buttonRecylclePressed:(id)sender;

@end

@implementation SearchHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.label];
        [self addSubview:self.button];
        [self addSubview:self.separatorTop];
        [self addSubview:self.separatorBot];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat intervalH = 10.0;
    
    CGFloat buttonOriginX = self.frame.size.width - marginR;
    
    if ([self.button isHidden] == NO)
    {
        CGSize size = CGSizeMake(40.0, 40.0);
        UIImage *image = [self.button imageForState:UIControlStateNormal];
        if (image)
        {
            size = image.size;
        }
        buttonOriginX = buttonOriginX - size.width;
        
        CGRect frame = CGRectMake(buttonOriginX, (self.frame.size.height - size.height)/2, size.width, size.height);
        self.button.frame = frame;
        buttonOriginX -= intervalH;
    }
    if (self.label)
    {
        CGRect frame = CGRectMake(marginL, 0.0, buttonOriginX - marginL, self.frame.size.height);
        self.label.frame = frame;
    }
    
    CGFloat separatorHeight = 1.0;
    
    if ([self.separatorTop isHidden] == NO)
    {
        self.separatorTop.frame = CGRectMake(0.0, 0.0, self.frame.size.width, separatorHeight);
    }
    if ([self.separatorBot isHidden] == NO)
    {
        self.separatorBot.frame = CGRectMake(0.0, self.frame.size.height - separatorHeight, self.frame.size.width, separatorHeight);
    }
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setTextColor:[UIColor darkGrayColor]];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_label setFont:font];
        [_label setAdjustsFontSizeToFitWidth:YES];
        [_label setTextAlignment:NSTextAlignmentLeft];
    }
    return _label;
}

- (UIButton *)button
{
    if (_button == nil)
    {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_btn_trash_g"];
        if (image)
        {
            [_button setImage:image forState:UIControlStateNormal];
            UIImage *highlightImage = [UIImage imageNamed:@"sho_btn_trash"];
            if (highlightImage)
            {
                [_button setImage:highlightImage forState:UIControlStateHighlighted];
            }
        }
        [_button addTarget:self action:@selector(buttonRecylclePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)setShouldShowRecycle:(BOOL)shouldShowRecycle
{
    _shouldShowRecycle = shouldShowRecycle;
    [self.button setHidden:!_shouldShowRecycle];
    [self setNeedsLayout];
}

- (UIView *)separatorTop
{
    if (_separatorTop == nil)
    {
        _separatorTop = [[UIView alloc] initWithFrame:CGRectZero];
        [_separatorTop setBackgroundColor:[UIColor colorWithWhite:0.89 alpha:1.0]];
    }
    return _separatorTop;
}

- (UIView *)separatorBot
{
    if (_separatorBot == nil)
    {
        _separatorBot = [[UIView alloc] initWithFrame:CGRectZero];
        [_separatorBot setBackgroundColor:[UIColor colorWithWhite:0.89 alpha:1.0]];
    }
    return _separatorBot;
}

#pragma mark - Actions

- (void)buttonRecylclePressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(searchHeaderCollectionReusableView:didSelectRecycleBySender:)])
    {
        [_delegate searchHeaderCollectionReusableView:self didSelectRecycleBySender:sender];
    }
}

@end
