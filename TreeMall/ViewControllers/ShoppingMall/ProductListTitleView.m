//
//  ProductListTitleView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductListTitleView.h"

@interface ProductListTitleView ()

- (void)buttonTitlePressed:(id)sender;

@end

@implementation ProductListTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.buttonTitle];
        [self addSubview:self.buttonArrowDown];
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
    CGFloat marginH = 20.0;
    CGFloat intervalH = 5.0;
    CGFloat labelMaxWidth = self.frame.size.width - marginH * 2;
    CGFloat originX = 0.0;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.buttonTitle.titleLabel.font, NSFontAttributeName, nil];
    CGSize sizeText = [[self.buttonTitle titleForState:UIControlStateNormal] sizeWithAttributes:attributes];
    CGSize sizeLabel = CGSizeMake(ceil((sizeText.width > labelMaxWidth)?labelMaxWidth:sizeText.width), ceil(sizeText.height));
    if (self.buttonTitle && [self.buttonTitle isHidden] == NO)
    {
        CGRect frame = CGRectMake((self.frame.size.width - sizeLabel.width)/2, (self.frame.size.height - sizeLabel.height)/2, sizeLabel.width, sizeLabel.height);
        self.buttonTitle.frame = frame;
        originX = self.buttonTitle.frame.origin.x + self.buttonTitle.frame.size.width + intervalH;
    }
    if (self.buttonArrowDown && [self.buttonArrowDown isHidden] == NO)
    {
        CGSize imageViewSize = CGSizeMake(15.0, 15.0);
        UIImage *image = [self.buttonArrowDown imageForState:UIControlStateNormal];
        if (image)
        {
            imageViewSize = image.size;
        }
        CGRect frame = CGRectMake(originX, (self.frame.size.height - imageViewSize.height)/2, imageViewSize.width, imageViewSize.height);
        self.buttonArrowDown.frame = frame;
    }
}

- (UIButton *)buttonTitle
{
    if (_buttonTitle == nil)
    {
        _buttonTitle = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonTitle setBackgroundColor:[UIColor clearColor]];
        [_buttonTitle.titleLabel setAdjustsFontSizeToFitWidth:YES];
        NSDictionary *titleTextAttributes = [[UINavigationBar appearance] titleTextAttributes];
        UIColor *color = nil;
        UIFont *font = nil;
        if (titleTextAttributes)
        {
            color = [titleTextAttributes objectForKey:NSForegroundColorAttributeName];
            font = [titleTextAttributes objectForKey:NSFontAttributeName];
        }
        if (color == nil)
        {
            color = [UIColor whiteColor];
        }
        if (font == nil)
        {
            font = [UIFont systemFontOfSize:20.0];
        }
        [_buttonTitle setTitleColor:(color == nil)?[UIColor whiteColor]:color forState:UIControlStateNormal];
        [_buttonTitle.titleLabel setFont:font];
        [_buttonTitle addTarget:self action:@selector(buttonTitlePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonTitle;
}

- (UIButton *)buttonArrowDown
{
    if (_buttonArrowDown == nil)
    {
        _buttonArrowDown = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_h_btn_down"];
        if (image)
        {
            [_buttonArrowDown setImage:image forState:UIControlStateNormal];
        }
        [_buttonArrowDown addTarget:self action:@selector(buttonTitlePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonArrowDown;
}

- (void)setTitleText:(NSString *)titleText
{
    if ([_titleText isEqualToString:titleText])
    {
        return;
    }
    _titleText = titleText;
    if (_titleText == nil)
    {
        [self.buttonTitle setHidden:YES];
        [self.buttonArrowDown setHidden:YES];
    }
    else
    {
        [self.buttonTitle setHidden:NO];
        [self.buttonArrowDown setHidden:NO];
        [self.buttonTitle setTitle:_titleText forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
}

#pragma mark - Actions

- (void)buttonTitlePressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productListTitleView:willSelectTitleBySender:)])
    {
        [_delegate productListTitleView:self willSelectTitleBySender:sender];
    }
}

@end
