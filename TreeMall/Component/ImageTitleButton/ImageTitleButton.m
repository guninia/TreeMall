//
//  ImageTitleButton.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ImageTitleButton.h"

@implementation ImageTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _marginL = 10.0;
        _marginR = 20.0;
        [self.layer setCornerRadius:3.0];
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
    
    CGFloat marginL = self.marginL;
    CGFloat marginR = self.marginR;
    CGFloat intervalH = 10.0;
    CGFloat originX = marginL;
    
    if (self.imageViewIcon)
    {
        CGSize size = CGSizeMake(self.frame.size.height, self.frame.size.height);
        UIImage *image = self.imageViewIcon.image;
        if (image)
        {
            if (image.size.height > size.height)
            {
                size.width = image.size.width * size.height / image.size.height;
            }
            else
            {
                size = image.size;
            }
        }
        CGRect frame = CGRectMake(originX, (self.frame.size.height - size.height)/2, size.width, size.height);
        self.imageViewIcon.frame = frame;
        originX = self.imageViewIcon.frame.origin.x + self.imageViewIcon.frame.size.width + intervalH;
    }
    
    if (self.labelText)
    {
        CGRect frame = CGRectMake(originX, 0.0, self.frame.size.width - marginR - originX, self.frame.size.height);
        self.labelText.frame = frame;
    }
}

- (UIImageView *)imageViewIcon
{
    if (_imageViewIcon == nil)
    {
        _imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageViewIcon;
}

- (UILabel *)labelText
{
    if (_labelText == nil)
    {
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelText setTextColor:[UIColor whiteColor]];
        [_labelText setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelText setFont:font];
        [_labelText setTextAlignment:NSTextAlignmentRight];
    }
    return _labelText;
}

@end
