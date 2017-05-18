//
//  CompleteOrderContentTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/15.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CompleteOrderContentTableViewCell.h"

@implementation CompleteOrderContentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.labelContent];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat marginH = 8.0;
    CGFloat intervalH = 8.0;
    CGFloat originX = marginH;
    if (self.labelTitle)
    {
//        CGSize sizeText = [self.labelTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil]];
//        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, 0.0, 120.0, self.contentView.frame.size.height);
        self.labelTitle.frame = frame;
        originX = self.labelTitle.frame.origin.x + self.labelTitle.frame.size.width + intervalH;
    }
    if (self.labelContent)
    {
        CGRect frame = CGRectMake(originX, 0.0, self.contentView.frame.size.width - originX - marginH, self.contentView.frame.size.height);
        self.labelContent.frame = frame;
    }
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelTitle setFont:font];
        [_labelTitle setTextColor:[UIColor blackColor]];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
    }
    return _labelTitle;
}

- (UILabel *)labelContent
{
    if (_labelContent == nil)
    {
        _labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelContent setFont:font];
        [_labelContent setTextColor:[UIColor grayColor]];
        [_labelContent setBackgroundColor:[UIColor clearColor]];
        [_labelContent setNumberOfLines:0];
        [_labelContent setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelContent setTextAlignment:NSTextAlignmentLeft];
    }
    return _labelContent;
}

@end
