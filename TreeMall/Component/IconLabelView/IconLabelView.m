//
//  IconLabelView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "IconLabelView.h"

static CGFloat intervalV = 5.0;

@implementation IconLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat originY = 0.0;
    CGSize sizeImageView = CGSizeMake(0.0, 0.0);
    if (self.imageView.image)
    {
        sizeImageView = self.imageView.image.size;
        CGRect frame = CGRectMake((self.frame.size.width - sizeImageView.width)/2, 0.0, sizeImageView.width, sizeImageView.height);
        self.imageView.frame = frame;
        originY = self.imageView.frame.origin.y + self.imageView.frame.size.height + intervalV;
    }
    if (self.label.text)
    {
        CGRect frame = CGRectMake(0.0, originY, self.frame.size.width, self.frame.size.height - originY);
        self.label.frame = frame;
    }
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_label setLineBreakMode:NSLineBreakByWordWrapping];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setNumberOfLines:0];
        [_label setFont:font];
    }
    return _label;
}

#pragma mark - Public Methods

- (CGSize)referenceSizeForMaxWidth:(CGFloat)maxWidth
{
    CGSize sizeImageView = CGSizeZero;
    CGSize sizeLabel = CGSizeZero;
    if (self.imageView.image)
    {
        sizeImageView = self.imageView.image.size;
    }
    if (self.label.text)
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = self.label.lineBreakMode;
        style.alignment = self.label.textAlignment;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.label.font, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
        CGRect boundingRect = [self.label.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        sizeLabel = CGSizeMake(ceil(boundingRect.size.width), ceil(boundingRect.size.height));
    }
    CGFloat totalHeight = sizeImageView.height + intervalV + sizeLabel.height;
    CGFloat width = (sizeImageView.width > sizeLabel.width)?sizeImageView.width:sizeLabel.width;
    CGSize viewSize = CGSizeMake(width, totalHeight);
    return viewSize;
}

@end
