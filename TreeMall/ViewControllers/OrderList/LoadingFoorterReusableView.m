//
//  LoadingFoorterReusableView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "LoadingFoorterReusableView.h"

@implementation LoadingFoorterReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
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
        CGRect frame = self.activityIndicator.frame;
        frame.origin.x = (self.frame.size.width - frame.size.width)/2;
        frame.origin.y = (self.frame.size.height - frame.size.height)/2;
        self.activityIndicator.frame = frame;
    }
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setBackgroundColor:[UIColor clearColor]];
        [_activityIndicator setHidesWhenStopped:YES];
    }
    return _activityIndicator;
}

@end
