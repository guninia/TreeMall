//
//  PaymentTypeHeaderView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "PaymentTypeHeaderView.h"

@implementation PaymentTypeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.viewTitleBackground];
        [self.viewTitleBackground addSubview:self.labelTitle];
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
    
    CGFloat marginV = 5.0;
    CGFloat marginH = 10.0;
    CGFloat intervalV = 5.0;
    
    CGFloat originY = marginV;
    
    if (self.viewTitleBackground)
    {
        CGFloat textHeight = 20.0;
        if ([self.labelTitle.text length] > 0)
        {
            CGSize sizeText = [self.labelTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil]];
            CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
            textHeight = sizeLabel.height;
        }
        CGFloat indentH = 5.0;
        CGFloat indentV = 3.0;
        CGFloat viewHeight = textHeight + indentV * 2;
        CGRect frame = CGRectMake(marginH, originY, self.contentView.frame.size.width - marginH * 2, viewHeight);
        self.viewTitleBackground.frame = frame;
        if (self.labelTitle)
        {
            CGRect frameLabel = CGRectMake(indentH, indentV, self.viewTitleBackground.frame.size.width - indentH * 2, self.viewTitleBackground.frame.size.height - indentV * 2);
            self.labelTitle.frame = frameLabel;
        }
        originY = self.viewTitleBackground.frame.origin.y + self.viewTitleBackground.frame.size.height + intervalV;
    }
}

- (UIView *)viewTitleBackground
{
    if (_viewTitleBackground == nil)
    {
        _viewTitleBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewTitleBackground setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    }
    return _viewTitleBackground;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setTextColor:[UIColor orangeColor]];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelTitle setFont:font];
    }
    return _labelTitle;
}

@end
