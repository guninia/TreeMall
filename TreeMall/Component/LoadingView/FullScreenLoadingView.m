//
//  FullScreenLoadingView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "FullScreenLoadingView.h"

@interface FullScreenLoadingView ()

@property (nonatomic, assign) UIActivityIndicatorViewStyle indicatorStyle;

@end

@implementation FullScreenLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _indicatorStyle = UIActivityIndicatorViewStyleWhite;
        _indicatorCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:self.activityIndicator];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _indicatorStyle = style;
        _indicatorCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:self.activityIndicator];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.activityIndicator)
    {
        self.activityIndicator.center = self.indicatorCenter;
    }
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.indicatorStyle];
        [_activityIndicator setHidesWhenStopped:YES];
    }
    return _activityIndicator;
}

- (void)setIndicatorCenter:(CGPoint)indicatorCenter
{
    if (CGPointEqualToPoint(indicatorCenter, _indicatorCenter))
        return;
    _indicatorCenter = indicatorCenter;
    
    [self setNeedsLayout];
}

@end
