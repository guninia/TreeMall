//
//  MainCategoryCollectionViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/24.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "MainCategoryCollectionViewCell.h"

@implementation MainCategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize imageSize = CGSizeMake(40.0, 40.0);
    NSString *sampleString = @"XXXXX";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.textLabel.font, NSFontAttributeName, nil];
    CGSize textSize = [sampleString sizeWithAttributes:attributes];
    textSize.height = ceilf(textSize.height);
    CGFloat intervalV = 2.0;
    CGFloat totalHeight = imageSize.height + textSize.height + intervalV;
    CGFloat originY = (self.contentView.frame.size.height - totalHeight)/2;
    
    self.imageView.frame = CGRectMake((self.contentView.frame.size.width - imageSize.width)/2, originY, imageSize.width, imageSize.height);
    originY = self.imageView.frame.origin.y + self.imageView.frame.size.height + intervalV;
    self.textLabel.frame = CGRectMake(0.0, originY, self.contentView.frame.size.width, textSize.height);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.image = nil;
    _textLabel.text = @"";
    self.selected = NO;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setBackgroundColor:[UIColor clearColor]];
    }
    return _imageView;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setTextColor:[UIColor darkTextColor]];
    }
    return _textLabel;
}

- (void)setSelected:(BOOL)selected
{
//    NSLog(@"Cell[%li] Selected[%@]", (long)self.tag, selected?@"YES":@"NO");
    [super setSelected:selected];
//    [_textLabel setTextColor:[self isSelected]?[UIColor cyanColor]:[UIColor darkTextColor]];
}

@end
