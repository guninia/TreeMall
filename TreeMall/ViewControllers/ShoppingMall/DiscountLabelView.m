//
//  DiscountLabelView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/7.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DiscountLabelView.h"

@implementation DiscountLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _edgeInsets = UIEdgeInsetsMake(3.0, 5.0, 8.0, 12.0);
        [self addSubview:self.imageViewTag];
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
    if (self.imageViewTag)
    {
        self.imageViewTag.frame = self.bounds;
    }
    if (self.labelText)
    {
        CGRect frame = CGRectMake(_edgeInsets.left, _edgeInsets.top, self.bounds.size.width - (_edgeInsets.left + _edgeInsets.right), self.bounds.size.height - (_edgeInsets.top + _edgeInsets.bottom));
        self.labelText.frame = frame;
    }
}

- (UIImageView *)imageViewTag
{
    if (_imageViewTag == nil)
    {
        _imageViewTag = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_ico_sales"];
        if (image)
        {
            [_imageViewTag setImage:image];
        }
    }
    return _imageViewTag;
}

- (UILabel *)labelText
{
    if (_labelText == nil)
    {
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelText setFont:font];
        [_labelText setBackgroundColor:[UIColor clearColor]];
        [_labelText setTextColor:[UIColor whiteColor]];
    }
    return _labelText;
}

- (void)setText:(NSString *)text
{
    if ([_text isEqualToString:text])
        return;
    self.labelText.text = _text;
}

@end
