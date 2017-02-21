//
//  ImageTextView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ImageTextView.h"

@implementation ImageTextView

static CGFloat intervalH = 5.0;

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
    
    CGFloat viewWidth = self.frame.size.width;
    CGFloat maxLabelWidth = viewWidth;
    CGFloat originX = 0.0;
    if (self.imageViewIcon.image)
    {
        CGSize size = self.imageViewIcon.image.size;
        CGRect frame = CGRectMake(0.0, (self.frame.size.height - size.height)/2, size.width, size.height);
        self.imageViewIcon.frame = frame;
        maxLabelWidth = viewWidth - size.width - intervalH;
        originX = self.imageViewIcon.frame.origin.x + self.imageViewIcon.frame.size.width + intervalH;
    }
    if (self.labelText.text)
    {
        CGRect frame = CGRectMake(originX, 0.0, self.frame.size.width - originX, self.frame.size.height);
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
        [_labelText setTextColor:[UIColor lightGrayColor]];
        [_labelText setBackgroundColor:[UIColor clearColor]];
        [_labelText setTextAlignment:NSTextAlignmentLeft];
        [_labelText setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelText setNumberOfLines:0];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelText setFont:font];
    }
    return _labelText;
}

#pragma mark - Public Methods

- (CGSize)referenceSizeForViewWidth:(CGFloat)viewWidth
{
    CGSize sizeTotal = CGSizeZero;
    CGSize sizeImage = CGSizeZero;
    CGSize sizeText = CGSizeZero;
    CGFloat maxLabelWidth = viewWidth;
    if (self.imageViewIcon.image)
    {
        sizeImage = self.imageViewIcon.image.size;
        maxLabelWidth = viewWidth - sizeImage.width - intervalH;
    }
    if (self.labelText.text)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelText.font, NSFontAttributeName, nil];
        CGRect boundingRect = [self.labelText.text boundingRectWithSize:CGSizeMake(maxLabelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        sizeText = CGSizeMake(ceil(boundingRect.size.width), ceil(boundingRect.size.height));
    }
    
    sizeTotal.width = viewWidth;
    sizeTotal.height = (sizeImage.height > sizeText.height)? sizeImage.height : sizeText.height;
    
    return sizeTotal;
}

@end
