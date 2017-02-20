//
//  ProductDetailImageCollectionViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/20.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductDetailImageCollectionViewCell.h"

@implementation ProductDetailImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView)
    {
        self.imageView.frame = self.contentView.bounds;
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

@end
