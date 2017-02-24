//
//  MemberTitleView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/22.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "MemberTitleView.h"
#import "LocalizedString.h"

@interface MemberTitleView ()

- (void)buttonModifyPressed:(id)sender;

@end

@implementation MemberTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [self addSubview:self.labelWelcome];
        [self addSubview:self.buttonModify];
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
    
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    
    if (self.labelWelcome)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelWelcome.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelWelcome.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginL, (self.frame.size.height - sizeLabel.height)/2, sizeLabel.width, sizeLabel.height);
        self.labelWelcome.frame = frame;
    }
    
    if (self.buttonModify)
    {
        CGFloat marginH = 5.0;
        CGFloat marginV = 2.0;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.buttonModify.titleLabel.font, NSFontAttributeName, nil];
        CGSize sizeText = [[self.buttonModify titleForState:UIControlStateNormal] sizeWithAttributes:attributes];
        CGSize sizeButton = CGSizeMake(ceil(sizeText.width + marginH * 2), ceil(sizeText.height + marginV * 2));
        CGRect frame = CGRectMake((self.frame.size.width - marginR - sizeButton.width), (self.frame.size.height - sizeButton.height)/2, sizeButton.width, sizeButton.height);
        self.buttonModify.frame = frame;
    }
}

- (UILabel *)labelWelcome
{
    if (_labelWelcome == nil)
    {
        _labelWelcome = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelWelcome setTextColor:[UIColor darkGrayColor]];
        [_labelWelcome setBackgroundColor:[UIColor clearColor]];
        [_labelWelcome setFont:[UIFont systemFontOfSize:12.0]];
    }
    return _labelWelcome;
}

- (UIButton *)buttonModify
{
    if (_buttonModify == nil)
    {
        _buttonModify = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonModify setTitle:[LocalizedString PersonalDataModify] forState:UIControlStateNormal];
        [_buttonModify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonModify setBackgroundColor:[UIColor colorWithWhite:0.45 alpha:1.0]];
        [_buttonModify.layer setCornerRadius:3.0];
        UIFont *font = [UIFont systemFontOfSize:10.0];
        [_buttonModify.titleLabel setFont:font];
        [_buttonModify addTarget:self action:@selector(buttonModifyPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonModify;
}

#pragma mark - Actions

- (void)buttonModifyPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(memberTitleView:didSelectToModifyPersonalInformationBySender:)])
    {
        [_delegate memberTitleView:self didSelectToModifyPersonalInformationBySender:sender];
    }
}

@end
