//
//  ProductSubcategoryCollectionViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductSubcategoryCollectionViewCell.h"

@implementation ProductSubcategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}


#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.bounds;
//    NSLog(@"self.textLabel.frame[%4.2f,%4.2f,%4.2f,%4.2f]", self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
}

- (UILabel *)textLabel
{
    if (_textLabel == nil)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setTextColor:[UIColor colorWithRed:(95.0/255.0) green:(180.0/255.0) blue:(55.0/255.0) alpha:1.0]];
        [_textLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_textLabel setNumberOfLines:0];
        [_textLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _textLabel;
}

@end
