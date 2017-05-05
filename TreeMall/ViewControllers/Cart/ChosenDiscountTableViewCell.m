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
        [self.contentView addSubview:self.viewTitle];
        [self.viewTitle addSubview:self.labelTitle];
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
    CGFloat marginV = 5.0;
    CGFloat marginH = 10.0;
    CGFloat intervalV = 5.0;
    
    CGFloat originY = marginV;
    
    if (self.viewTitle)
    {
        CGFloat textHeight = 20.0;
        if ([self.labelTitle.text length] > 0)
        {
            CGSize sizeText = [self.labelTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil]];
            CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
            textHeight = sizeLabel.height;
        }
        CGFloat indentH = 5.0;
        CGFloat indentV = 3.0;
        CGFloat viewHeight = textHeight + indentV * 2;
        CGRect frame = CGRectMake(marginH, originY, self.contentView.frame.size.width - marginH * 2, viewHeight);
        self.viewTitle.frame = frame;
        if (self.labelTitle)
        {
            CGRect frameLabel = CGRectMake(indentH, indentV, self.viewTitle.frame.size.width - indentH * 2, self.viewTitle.frame.size.height - indentV * 2);
            self.labelTitle.frame = frameLabel;
        }
        originY = self.viewTitle.frame.origin.y + self.viewTitle.frame.size.height + intervalV;
    }
    if (self.labelDetail)
    {
        NSString *defaultString = @"XXXXX";
        CGSize sizeText = [defaultString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelDetail.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, self.contentView.frame.size.width - marginH * 2, sizeLabel.height);
        self.labelDetail.frame = frame;
    }
}

- (UIView *)viewTitle
{
    if (_viewTitle == nil)
    {
        _viewTitle = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewTitle setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    }
    return _viewTitle;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setTextColor:[UIColor orangeColor]];
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
        [_labelDetail setTextColor:[UIColor colorWithRed:(176.0/255.0) green:(206.0/255.0) blue:(106.0/255.0) alpha:1.0]];
        [_labelDetail setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelDetail setFont:font];
    }
    return _labelDetail;
}

@end
