//
//  ProductDetailSectionTitleView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductDetailSectionTitleView.h"

@implementation ProductDetailSectionTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.viewBackground];
        [self addSubview:self.viewTitle];
        [self addSubview:self.bottomLine];
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
    
    CGFloat marginT = 10.0;
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

@end
