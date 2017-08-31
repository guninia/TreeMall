//
//  ChosenDiscountTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ChosenDiscountTableViewCell.h"

@implementation ChosenDiscountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.labelDetail];
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
    
    CGFloat marginH = 15.0;
    CGFloat intervalH = 5.0;
    CGFloat originX = marginH;
    if (self.labelTitle)
    {
        CGSize sizeText = [self.labelTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, 0.0, sizeLabel.width, self.contentView.frame.size.height);
        self.labelTitle.frame = frame;
        originX = CGRectGetMaxX(self.labelTitle.frame) + intervalH;
    }
    if (self.labelDetail)
    {
        CGRect frame = CGRectMake(originX, 0.0, self.contentView.frame.size.width - marginH - originX, self.contentView.frame.size.height);
        self.labelDetail.frame = frame;
    }
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setTextColor:[UIColor blackColor]];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelTitle setFont:font];
    }
    return _labelTitle;
}

- (UILabel *)labelDetail
{
    if (_labelDetail == nil)
    {
        _labelDetail = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDetail setTextColor:[UIColor redColor]];
        [_labelDetail setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelDetail setFont:font];
        [_labelDetail setTextAlignment:NSTextAlignmentRight];
    }
    return _labelDetail;
}

@end
