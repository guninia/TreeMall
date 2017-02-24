//
//  DropdownListButton.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DropdownListButton.h"

@implementation DropdownListButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.label];
        [self addSubview:self.imageViewIcon];
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
    
    CGFloat marginL = 5.0;
    CGFloat marginR = 5.0;
    
    if (self.imageViewIcon.image)
    {
        CGRect frame = CGRectMake(self.frame.size.width - marginR - self.imageViewIcon.image.size.width, (self.frame.size.height - self.imageViewIcon.image.size.height)/2, self.imageViewIcon.image.size.width, self.imageViewIcon.image.size.height);
        self.imageViewIcon.frame = frame;
    }
    if (self.label)
    {
        CGRect frame = CGRectMake(marginL, 0.0, self.imageViewIcon.frame.origin.x - marginL, self.frame.size.height);
        self.label.frame = frame;
    }
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextColor:[UIColor lightGrayColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_label setFont: font];
    }
    return _label;
}

- (UIImageView *)imageViewIcon
{
    if (_imageViewIcon == nil)
    {
        _imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_ico_arr_dn_g"];
        if (image)
        {
            [_imageViewIcon setImage:image];
        }
    }
    return _imageViewIcon;
}

@end
