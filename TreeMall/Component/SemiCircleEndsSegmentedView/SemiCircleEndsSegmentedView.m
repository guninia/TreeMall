//
//  SemiCircleEndsSegmentedView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SemiCircleEndsSegmentedView.h"

@interface SemiCircleEndsSegmentedView ()

- (void)renewCorner;

- (void)segmentedControlValueChanged:(id)sender;

@end

@implementation SemiCircleEndsSegmentedView

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.items = items;
        [self addSubview:self.segmentedControl];
        [self renewCorner];
        [self.layer setBorderWidth:1.0];
        [self.layer setBorderColor:self.tintColor.CGColor];
        [self.layer setMasksToBounds:YES];
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
    if (self.segmentedControl)
    {
        self.segmentedControl.frame = self.bounds;
    }
    [self renewCorner];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    self.layer.borderColor = tintColor.CGColor;
    self.segmentedControl.tintColor = self.tintColor;
    [self setNeedsDisplay];
}

- (UISegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil)
    {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:self.items];
        [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

#pragma mark - Private Methods

- (void)renewCorner
{
    [self.layer setCornerRadius:self.frame.size.height / 2];
    [self setNeedsDisplay];
}

#pragma mark - Actions

- (void)segmentedControlValueChanged:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(semiCircleEndsSegmentedView:didChangeToIndex:)])
    {
        [_delegate semiCircleEndsSegmentedView:self didChangeToIndex:self.segmentedControl.selectedSegmentIndex];
    }
}

@end
