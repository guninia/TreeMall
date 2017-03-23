//
//  OrderHeaderReusableView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "OrderHeaderReusableView.h"

@interface OrderHeaderReusableView ()

- (void)buttonPressed:(id)sender;

@end

@implementation OrderHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.viewBackground];
        [self.viewBackground addSubview:self.viewTopLine];
        [self.viewBackground addSubview:self.button];
        [self.viewBackground addSubview:self.labelDateTime];
        [self.viewBackground addSubview:self.labelSerialNumber];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat marginT = 5.0;
    CGFloat intervalH = 10.0;
    CGFloat intervalV = 3.0;
    
    CGFloat originY = 0.0;
    CGFloat contentHeight = self.frame.size.height;
    
    if (self.viewBackground)
    {
        CGRect frame = CGRectMake(marginL, 0.0, self.frame.size.width - (marginL + marginR), self.frame.size.height);
        self.viewBackground.frame = frame;
    }
    
    if (self.viewTopLine)
    {
        CGRect frame = CGRectMake(0.0, originY, self.viewBackground.frame.size.width, 3.0);
        self.viewTopLine.frame = frame;
        originY = self.viewTopLine.frame.origin.y + self.viewTopLine.frame.size.height;
        contentHeight = self.frame.size.height - originY;
    }
    
    CGFloat labelMaxLength = self.viewBackground.frame.size.width - marginR - marginL;
    if (self.button)
    {
        CGSize buttonSize = CGSizeMake(self.frame.size.height, self.frame.size.height);
        UIImage *image = [self.button imageForState:UIControlStateNormal];
        if (image)
        {
            buttonSize.width = image.size.width;
        }
        CGRect frame = CGRectMake(self.viewBackground.frame.size.width - marginR - buttonSize.width, originY + (contentHeight - buttonSize.height)/2, buttonSize.width, buttonSize.height);
        self.button.frame = frame;
        labelMaxLength = labelMaxLength - buttonSize.width - intervalH;
    }
    
    originY += marginT;
    
    if (self.labelDateTime)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelDateTime.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelDateTime.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(labelMaxLength, ceil(sizeText.height));
        CGRect frame = CGRectMake(marginL, originY, sizeLabel.width, sizeLabel.height);
        self.labelDateTime.frame = frame;
        originY = self.labelDateTime.frame.origin.y + self.labelDateTime.frame.size.height + intervalV;
    }
    if (self.labelSerialNumber)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelSerialNumber.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelSerialNumber.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(labelMaxLength, ceil(sizeText.height));
        CGRect frame = CGRectMake(marginL, originY, sizeLabel.width, sizeLabel.height);
        self.labelSerialNumber.frame = frame;
        originY = self.labelSerialNumber.frame.origin.y + self.labelSerialNumber.frame.size.height + intervalV;
    }
}

- (UIView *)viewBackground
{
    if (_viewBackground == nil)
    {
        _viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewBackground.layer setBorderWidth:1.0];
        [_viewBackground.layer setBorderColor:self.viewTopLine.backgroundColor.CGColor];
        [_viewBackground setBackgroundColor:[UIColor whiteColor]];
    }
    return _viewBackground;
}

- (UIView *)viewTopLine
{
    if (_viewTopLine == nil)
    {
        _viewTopLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewTopLine setBackgroundColor:[UIColor colorWithRed:(142.0/255.0) green:(170.0/255.0) blue:(214.0/255.0) alpha:1.0]];
    }
    return _viewTopLine;
}

- (UIButton *)button
{
    if (_button == nil)
    {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_list_more"];
        if (image)
        {
            [_button setImage:image forState:UIControlStateNormal];
        }
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)labelDateTime
{
    if (_labelDateTime == nil)
    {
        _labelDateTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDateTime setBackgroundColor:[UIColor clearColor]];
        [_labelDateTime setTextColor:[UIColor colorWithRed:(142.0/255.0) green:(170.0/255.0) blue:(214.0/255.0) alpha:1.0]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelDateTime setFont:font];
    }
    return _labelDateTime;
}

- (UILabel *)labelSerialNumber
{
    if (_labelSerialNumber == nil)
    {
        _labelSerialNumber = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelSerialNumber setBackgroundColor:[UIColor clearColor]];
        [_labelSerialNumber setTextColor:[UIColor grayColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelSerialNumber setFont:font];
    }
    return _labelSerialNumber;
}

#pragma mark - Actions

- (void)buttonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(orderHeaderReusableView:didPressButtonBySender:)])
    {
        [_delegate orderHeaderReusableView:self didPressButtonBySender:sender];
    }
}

@end
