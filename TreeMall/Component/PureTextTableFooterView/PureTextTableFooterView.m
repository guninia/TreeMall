//
//  PureTextTableFooterView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "PureTextTableFooterView.h"

@implementation PureTextTableFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.labelText];
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
    
    if (self.labelText)
    {
        CGRect frame = CGRectMake(marginL, 0.0, (self.frame.size.width - (marginR + marginL)), self.frame.size.height);
        self.labelText.frame = frame;
    }
}

- (UILabel *)labelText
{
    if (_labelText == nil)
    {
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelText setTextAlignment:NSTextAlignmentLeft];
        [_labelText setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelText setTextColor:[UIColor grayColor]];
        [_labelText setNumberOfLines:0];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelText setFont:font];
    }
    return _labelText;
}

@end
