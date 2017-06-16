//
//  VerticalImageTextButton.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/24.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "VerticalImageTextButton.h"

@implementation VerticalImageTextButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.imageViewIcon];
        [self addSubview:self.labelText];
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
    
    CGFloat marginB = 2.0;
    CGFloat marginT = 2.0;
    CGFloat marginL = 2.0;
    CGFloat marginR = 2.0;
    CGFloat intervalV = 5.0;
    if (self.labelText)
    {
        NSString *defaultString = @"ＸＸＸＸ";
        CGSize sizeText = [defaultString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelText.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(self.frame.size.width - (marginL + marginR), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginL, self.frame.size.height - marginB - sizeLabel.height, sizeLabel.width, sizeLabel.height);
        self.labelText.frame = frame;
    }
    if (self.imageViewIcon)
    {
        CGRect frame = CGRectMake(marginL, marginT, self.frame.size.width - (marginL + marginR), self.labelText.frame.origin.y - intervalV - marginT);
        self.imageViewIcon.frame = frame;
    }
}

- (UIImageView *)imageViewIcon
{
    if (_imageViewIcon == nil)
    {
        _imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageViewIcon setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _imageViewIcon;
}

- (UILabel *)labelText
{
    if (_labelText == nil)
    {
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelText setBackgroundColor:[UIColor clearColor]];
        [_labelText setTextColor:[UIColor darkGrayColor]];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelText setFont:font];
        [_labelText setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelText;
}

@end
