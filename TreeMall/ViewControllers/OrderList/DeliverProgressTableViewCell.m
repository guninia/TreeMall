//
//  DeliverProgressTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DeliverProgressTableViewCell.h"
#import "Definition.h"

#define marginT 3.0f
#define marginB 7.0f
#define marginH 10.0f
#define marginV 5.0f
#define intervalH 10.0f
#define kLabelDateWidth 120.0f
#define kFontDate [UIFont systemFontOfSize:18.0]
#define kFontStatus [UIFont systemFontOfSize:16.0]

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
    
    if (self.viewContainer)
    {
        self.viewContainer.frame = CGRectMake(marginH, marginT, self.contentView.frame.size.width - marginH * 2, self.contentView.frame.size.height - marginT - marginB);
    }
    if (self.labelDate)
    {
        CGRect frame = CGRectMake(marginH, marginV, kLabelDateWidth, self.viewContainer.frame.size.height - marginV * 2);
        self.labelDate.frame = frame;
    }
    
    if (self.labelStatus)
    {
        CGFloat originX = CGRectGetMaxX(self.labelDate.frame) + intervalH;
        CGFloat labelWidth = self.viewContainer.frame.size.width - originX - marginH;
        CGRect frame = CGRectMake(originX, marginV, labelWidth, self.viewContainer.frame.size.height - marginV * 2);
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
        [_labelDate setFont:kFontDate];
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
        [_labelStatus setFont:kFontStatus];
        [_labelStatus setBackgroundColor:[UIColor clearColor]];
        [_labelStatus setTextColor:[UIColor lightGrayColor]];
        [_labelStatus setTextAlignment:NSTextAlignmentLeft];
//        [_labelStatus setAdjustsFontSizeToFitWidth:YES];
        [_labelStatus setNumberOfLines:0];
        [_labelStatus setLineBreakMode:NSLineBreakByCharWrapping];
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

- (void)setLatest:(BOOL)latest
{
    _latest = latest;
    [self.labelStatus setTextColor:(_latest)?TMMainColor:[UIColor lightGrayColor]];
}

#pragma mark - Class Methods

+ (CGFloat)heightForCellWidth:(CGFloat)cellWidth withContent:(NSString *)content
{
    CGFloat originX = marginH + marginH + kLabelDateWidth + intervalH;
    CGFloat labelWidth = cellWidth - originX - marginH - marginH;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:kFontStatus, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
    CGSize sizeText = [content boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
    CGFloat totalHeight = sizeLabel.height + marginV * 2 + marginT + marginB;
    return totalHeight;
}

@end
