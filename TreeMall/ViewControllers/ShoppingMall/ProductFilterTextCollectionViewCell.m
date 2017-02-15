//
//  ProductFilterTextCollectionViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/13.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductFilterTextCollectionViewCell.h"

@implementation ProductFilterTextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setSelected:NO];
        
        [self.contentView addSubview:self.labelText];
    }
    return self;
}

#pragma mark - Override

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        [self.contentView setBackgroundColor:[UIColor orangeColor]];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
    }
}

- (void)layoutSubviews
{
    [self.labelText setFrame:self.contentView.bounds];
}

- (UILabel *)labelText
{
    if (_labelText == nil)
    {
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelText setBackgroundColor:[UIColor clearColor]];
        [_labelText setTextColor:[UIColor darkGrayColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelText setFont:font];
        [_labelText setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelText;
}

@end
