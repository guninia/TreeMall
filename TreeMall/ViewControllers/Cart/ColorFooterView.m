//
//  ColorFooterView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/16.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ColorFooterView.h"

@implementation ColorFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
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

@end
