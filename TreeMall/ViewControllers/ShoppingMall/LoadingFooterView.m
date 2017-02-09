//
//  LoadingFooterView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "LoadingFooterView.h"

@implementation LoadingFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundView:self.viewBackground];
        [self.contentView addSubview:self.activityIndicator];
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
    if (self.viewBackground)
    {
        self.viewBackground.frame = self.bounds;
    }
    if (self.activityIndicator)
    {
        CGRect frame = self.activityIndicator.frame;
        frame.origin.x = (self.contentView.frame.size.width - self.activityIndicator.frame.size.width)/2;
        frame.origin.y = (self.contentView.frame.size.height - self.activityIndicator.frame.size.height)/2;
        
        self.activityIndicator.frame = frame;
    }
}

- (UIView *)viewBackground
{
    if (_viewBackground == nil)
    {
        _viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _viewBackground;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setHidesWhenStopped:YES];
    }
    return _activityIndicator;
}

@end
