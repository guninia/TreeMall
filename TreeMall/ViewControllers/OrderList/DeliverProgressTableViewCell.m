//
//  DeliverProgressTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DeliverProgressTableViewCell.h"

@interface DeliverProgressTableViewCell ()

@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) UILabel *labelDate;
@property (nonatomic, strong) UILabel *labelStatus;

@end

@implementation DeliverProgressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.viewContainer];
        [self.viewContainer addSubview:self.labelDate];
        [self.viewContainer addSubview:self.labelStatus];
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
    
    CGFloat marginH = 10.0;
    CGFloat marginT = 3.0;
    CGFloat marginB = 7.0;
    CGFloat intervalH = 10.0;
    
    if (self.viewContainer)
    {
        self.viewContainer.frame = CGRectMake(marginH, marginT, self.contentView.frame.size.width - marginH * 2, self.contentView.frame.size.height - marginT - marginB);
    }
    if (self.labelDate)
    {
        CGSize sizeText = [self.labelDate.text boundingRectWithSize:CGSizeMake(self.viewContainer.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelDate.font, NSFontAttributeName, nil] context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width + 20.0), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, 0.0, sizeLabel.width, self.viewContainer.frame.size.height);
        self.labelDate.frame = frame;
    }
    
    if (self.labelStatus)
    {
        CGFloat originX = CGRectGetMaxX(self.labelDate.frame) + intervalH;
        CGFloat labelWidth = self.viewContainer.frame.size.width - originX - marginH;
        CGRect frame = CGRectMake(originX, 0.0, labelWidth, self.viewContainer.frame.size.height);
        self.labelStatus.frame = frame;
    }
}

- (UIView *)viewContainer
{
    if (_viewContainer == nil)
    {
        _viewContainer = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewContainer.layer setBorderWidth:2.0];
        [_viewContainer.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }
    return _viewContainer;
}

- (UILabel *)labelDate
{
    if (_labelDate == nil)
    {
        _labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelDate setFont:font];
        [_labelDate setBackgroundColor:[UIColor clearColor]];
        [_labelDate setTextColor:[UIColor blackColor]];
        [_labelDate setNumberOfLines:0];
        [_labelDate setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelDate setTextAlignment:NSTextAlignmentLeft];
    }
    return _labelDate;
}

- (UILabel *)labelStatus
{
    if (_labelStatus == nil)
    {
        _labelStatus = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelStatus setFont:font];
        [_labelStatus setBackgroundColor:[UIColor clearColor]];
        [_labelStatus setTextColor:[UIColor blackColor]];
        [_labelStatus setTextAlignment:NSTextAlignmentRight];
    }
    return _labelStatus;
}

- (void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
    if (_timeString == nil)
    {
        [self.labelDate setText:@""];
        return;
    }
    NSString *string = [_timeString stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    [self.labelDate setText:string];
    [self setNeedsLayout];
}

- (void)setStatusString:(NSString *)statusString
{
    _statusString = statusString;
    if (_statusString == nil)
    {
        [self.labelStatus setText:@""];
        return;
    }
    [self.labelStatus setText:_statusString];
    [self setNeedsLayout];
}

@end
