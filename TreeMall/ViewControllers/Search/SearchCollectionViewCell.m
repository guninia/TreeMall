//
//  SearchCollectionViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/17.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@implementation SearchCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor colorWithWhite:0.84 alpha:1.0]];
        [self.contentView.layer setCornerRadius:3.0];
        [self.contentView addSubview:self.label];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.label setFrame:self.contentView.bounds];
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextColor:[UIColor grayColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_label setFont:font];
        [_label setAdjustsFontSizeToFitWidth:YES];
        [_label setTextAlignment:NSTextAlignmentCenter];
    }
    return _label;
}

@end
