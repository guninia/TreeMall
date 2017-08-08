//
//  SingleLabelCollectionReusableView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/8/8.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#define kMarginV 8.0
#define kMarginH 8.0
#define kLabelFont [UIFont systemFontOfSize:18.0]

#import "SingleLabelCollectionReusableView.h"

@implementation SingleLabelCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.label];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.label)
    {
        CGRect frame = CGRectMake(kMarginH, kMarginV, self.frame.size.width - kMarginH * 2, self.frame.size.height - kMarginV * 2);
        self.label.frame = frame;
    }
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextColor:[UIColor darkGrayColor]];
        [_label setFont:kLabelFont];
    }
    return _label;
}

#pragma mark - Class methods

+ (CGFloat)heightForText:(NSString *)text inViewWithWidth:(CGFloat)width
{
    CGFloat height = 0.0;
    
    if (text && [text length] > 0)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:kLabelFont, NSFontAttributeName, nil];
        CGSize sizeText = [text boundingRectWithSize:CGSizeMake((width - kMarginH * 2), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        height = sizeLabel.height + kMarginV * 2;
    }
    
    return height;
}

@end
