//
//  ProductListToolView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductListToolView.h"

@interface ProductListToolView ()

- (void)initialize;

- (void)buttonSortPressed:(id)sender;
- (void)buttonFilterPressed:(id)sender;

@end

@implementation ProductListToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
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
    
    CGFloat originX = self.frame.size.width;
    if (self.buttonFilter)
    {
        CGSize size = CGSizeMake(self.frame.size.height, self.frame.size.height);
        originX = originX - size.width;
        CGRect frame = CGRectMake(originX, 0.0, size.width, size.height);
        self.buttonFilter.frame = frame;
    }
    if (self.separator)
    {
        CGSize size = CGSizeMake(1.0, ceil(self.frame.size.height * 4 / 5));
        originX = originX - size.width;
        CGRect frame = CGRectMake(originX, ceil((self.frame.size.height - size.height)/2), size.width, size.height);
        self.separator.frame = frame;
    }
    if (self.buttonSort)
    {
        CGSize size = CGSizeMake(originX, self.frame.size.height);
        originX = originX - size.width;
        CGRect frame = CGRectMake(originX, 0.0, size.width, size.height);
        self.buttonSort.frame = frame;
    }
    if (self.imageViewSort)
    {
        CGSize size = CGSizeMake(30.0, 30.0);
        if (self.imageViewSort.image)
        {
            size = self.imageViewSort.image.size;
        }
        CGRect frame = CGRectMake(self.buttonSort.frame.origin.x + self.buttonSort.frame.size.width - 10.0 - size.width, self.buttonSort.frame.origin.y + (self.buttonSort.frame.size.height - size.height)/2, size.width, size.height);
        self.imageViewSort.frame = frame;
    }
}

- (UIButton *)buttonSort
{
    if (_buttonSort == nil)
    {
        _buttonSort = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonSort setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_buttonSort setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_buttonSort setContentEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
        [_buttonSort addTarget:self action:@selector(buttonSortPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonSort;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor grayColor]];
    }
    return _separator;
}

- (UIButton *)buttonFilter
{
    if (_buttonFilter == nil)
    {
        _buttonFilter = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_ico_filter"];
        if (image)
        {
            [_buttonFilter setImage:image forState:UIControlStateNormal];
        }
        [_buttonFilter addTarget:self action:@selector(buttonFilterPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonFilter;
}

- (UIImageView *)imageViewSort
{
    if (_imageViewSort == nil)
    {
        _imageViewSort = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_ico_arr_dn_g"];
        if (image)
        {
            [_imageViewSort setImage:image];
        }
    }
    return _imageViewSort;
}

#pragma mark - Private Methods

- (void)initialize
{
    [self addSubview:self.buttonSort];
    [self addSubview:self.separator];
    [self addSubview:self.buttonFilter];
    [self addSubview:self.imageViewSort];
}

#pragma mark - Actions

- (void)buttonSortPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productListToolView:didSelectSortBySender:)])
    {
        [_delegate productListToolView:self didSelectSortBySender:sender];
    }
}

- (void)buttonFilterPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productListToolView:didSelectFilterBySender:)])
    {
        [_delegate productListToolView:self didSelectFilterBySender:sender];
    }
}

@end
