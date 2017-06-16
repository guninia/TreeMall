//
//  ProductDetailSectionTitleView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductDetailSectionTitleView.h"

@interface ProductDetailSectionTitleView ()

- (void)buttonPressed:(id)sender;

@end

@implementation ProductDetailSectionTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _delegate = nil;
        _topSeparatorHeight = 10.0;
        self.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
        [self addSubview:self.viewBackground];
        [self addSubview:self.viewTitle];
        [self addSubview:self.bottomLine];
        [self addSubview:self.buttonRight];
        [self addSubview:self.buttonTransparent];
        self.userInteractionEnabled = NO;
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

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    [self.buttonTransparent setHidden:!userInteractionEnabled];
    [self.buttonRight setHidden:!userInteractionEnabled];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginT = self.topSeparatorHeight;
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat originY = marginT;
    CGFloat viewBottom = self.frame.size.height;
    if (self.viewBackground)
    {
        CGRect frame = CGRectMake(0.0, originY, self.frame.size.width, self.frame.size.height - marginT);
        self.viewBackground.frame = frame;
    }
    if (self.bottomLine)
    {
        CGFloat lineHeight = 1.0;
        CGFloat originX = 1.0;
        CGRect frame = CGRectMake(originX, self.frame.size.height - lineHeight, self.frame.size.width - originX, lineHeight);
        self.bottomLine.frame = frame;
        viewBottom = self.bottomLine.frame.origin.y;
    }
    if (self.viewTitle)
    {
        CGRect frame = CGRectMake(marginL, originY, self.frame.size.width - (marginL + marginR), viewBottom - originY);
        self.viewTitle.frame = frame;
        
        if (self.buttonRight)
        {
            CGFloat buttonSideLength = self.viewTitle.frame.size.height;
            CGRect frame = CGRectMake(self.frame.size.width - marginR - buttonSideLength, self.viewTitle.frame.origin.y, buttonSideLength, buttonSideLength);
            self.buttonRight.frame = frame;
//            NSLog(@"self.buttonRight[%4.2f,%4.2f,%4.2f,%4.2f]", self.buttonRight.frame.origin.x, self.buttonRight.frame.origin.y, self.buttonRight.frame.size.width, self.buttonRight.frame.size.height);
        }
    }
    
    if (self.buttonTransparent)
    {
        self.buttonTransparent.frame = self.bounds;
    }
}

- (UIView *)viewBackground
{
    if (_viewBackground == nil)
    {
        _viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewBackground setBackgroundColor:[UIColor whiteColor]];
    }
    return _viewBackground;
}

- (ImageTextView *)viewTitle
{
    if (_viewTitle == nil)
    {
        _viewTitle = [[ImageTextView alloc] initWithFrame:CGRectZero];
        [_viewTitle setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont boldSystemFontOfSize:20.0];
        _viewTitle.labelText.font = font;
    }
    return _viewTitle;
}

- (UIView *)bottomLine
{
    if (_bottomLine == nil)
    {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_bottomLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _bottomLine;
}

- (UIButton *)buttonTransparent
{
    if (_buttonTransparent == nil)
    {
        _buttonTransparent = [[UIButton alloc] initWithFrame:CGRectZero];
        _buttonTransparent.backgroundColor = [UIColor clearColor];
        [_buttonTransparent addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonTransparent;
}

- (UIButton *)buttonRight
{
    if (_buttonRight == nil)
    {
        _buttonRight = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_ord_go"];
        if (image)
        {
            [_buttonRight setImage:image forState:UIControlStateNormal];
        }
        [_buttonRight addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonRight;
}

- (void)setTopSeparatorHeight:(CGFloat)topSeparatorHeight
{
    if (topSeparatorHeight < 0.0)
        topSeparatorHeight = 0.0;
    if (_topSeparatorHeight == topSeparatorHeight)
        return;
    _topSeparatorHeight = topSeparatorHeight;
    [self setNeedsLayout];
}

#pragma mark - Actions

- (void)buttonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productDetailSectionTitleView:didPressButtonBySender:)])
    {
        [_delegate productDetailSectionTitleView:self didPressButtonBySender:sender];
    }
}

@end
