//
//  PromotionTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "PromotionTableViewCell.h"
#import "APIDefinition.h"

@interface PromotionTableViewCell ()

@end

@implementation PromotionTableViewCell

#pragma mark - Constructor

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _shouldShowMask = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [_containerView setBackgroundColor:[UIColor whiteColor]];
        [_containerView.layer setShadowColor:[UIColor colorWithWhite:0.2 alpha:0.5].CGColor];
        [_containerView.layer setShadowOffset:CGSizeMake(5.0, 5.0)];
        [_containerView.layer setShadowRadius:5.0];
        [_containerView.layer setShadowOpacity:1.0];
        [_containerView.layer setMasksToBounds:NO];
//        _containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_containerView.bounds cornerRadius:5.0].CGPath;
        [self.contentView addSubview:_containerView];
        
        NSMutableParagraphStyle *titleStyle = [[NSMutableParagraphStyle alloc] init];
        titleStyle.lineBreakMode = NSLineBreakByWordWrapping;
        titleStyle.alignment = NSTextAlignmentLeft;
        NSMutableParagraphStyle *contentStyle = [[NSMutableParagraphStyle alloc] init];
        contentStyle.lineBreakMode = NSLineBreakByWordWrapping;
        contentStyle.alignment = NSTextAlignmentLeft;
        contentStyle.lineSpacing = 2.0;
        
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_containerView addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_subtitleLabel setBackgroundColor:[UIColor clearColor]];
        [_subtitleLabel setTextColor:[UIColor grayColor]];
        [_subtitleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_containerView addSubview:_subtitleLabel];
        
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setTextColor:[UIColor grayColor]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_containerView addSubview:_contentLabel];
        
        _viewMask = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewMask setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.5]];
        [_viewMask setHidden:!_shouldShowMask];
        [_containerView addSubview:_viewMask];
        
        titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16.0], NSFontAttributeName, titleStyle, NSParagraphStyleAttributeName, _titleLabel.textColor, NSForegroundColorAttributeName, nil];
        selectedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, titleStyle, NSParagraphStyleAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
        subtitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16.0], NSFontAttributeName, _subtitleLabel.textColor, NSForegroundColorAttributeName, nil];
        selectedSubtitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
        contentAttributes = [NSDictionary dictionaryWithObjectsAndKeys:_contentLabel.font, NSFontAttributeName, contentStyle, NSParagraphStyleAttributeName, _contentLabel.textColor, NSForegroundColorAttributeName, nil];
        
        
        NSAttributedString *titleTailString = [[NSAttributedString alloc] initWithString:@"..." attributes:titleAttributes];
        NSAttributedString *contentTailString = [[NSAttributedString alloc] initWithString:@"..." attributes:contentAttributes];
        [_titleLabel setAttributedTruncationToken:titleTailString];
        [_contentLabel setAttributedTruncationToken:contentTailString];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginV = 5.0;
    CGFloat marginH = 10.0;
    if (_containerView != nil)
    {
        [_containerView setFrame:CGRectMake(marginH, marginV, self.contentView.frame.size.width - marginH * 2, self.contentView.frame.size.height - marginV * 2)];
    }
    [_viewMask setFrame:_containerView.bounds];
    
    CGFloat hInterval = 5.0;
    CGFloat vInterval = 5.0;
    CGFloat leftMargin = 10.0;
    CGFloat rightMargin = 10.0;
    CGFloat topMargin = 10.0;
    CGFloat botMargin = 10.0;
    CGFloat originX = leftMargin;
    CGFloat originY = topMargin;
    
    CGSize imageViewSize = CGSizeMake(40.0, 40.0);
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x = marginH + originX;
    imageViewFrame.origin.y = marginV + topMargin;
    imageViewFrame.size = imageViewSize;
    self.imageView.frame = imageViewFrame;
    originX = imageViewFrame.origin.x + imageViewFrame.size.width + hInterval;
    CGFloat labelMaxWidth = _containerView.frame.size.width - originX - rightMargin;
    
//    NSString *defaultTowLineString = @"XXXXX\nXXXXX";
    NSString *defaultOneLineString = @"XXXXX";
    
    if ([_title length] > 0)
    {
        CGRect titleRect = [defaultOneLineString boundingRectWithSize:CGSizeMake(labelMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil];
        // Use the calculated height only.
        CGSize titleSize = CGSizeMake(labelMaxWidth, ceil(titleRect.size.height));
        CGRect titleFrame = CGRectMake(originX, originY, labelMaxWidth, titleSize.height);
        _titleLabel.frame = titleFrame;
        originY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + vInterval;
    }
    
    if ([_subtitle length] > 0)
    {
        CGRect subtitleRect = [defaultOneLineString boundingRectWithSize:CGSizeMake(labelMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:subtitleAttributes context:nil];
        CGSize subtitleSize = CGSizeMake(labelMaxWidth, ceil(subtitleRect.size.height));
        CGRect subtitleFrame = CGRectMake(originX, originY, labelMaxWidth, subtitleSize.height);
        _subtitleLabel.frame = subtitleFrame;
        originY = _subtitleLabel.frame.origin.y + _subtitleLabel.frame.size.height + vInterval;
    }
    
    if ([self.content length] > 0)
    {
        CGRect contentFrame = self.contentLabel.frame;
        contentFrame.origin.x = originX;
        contentFrame.origin.y = originY;
        contentFrame.size.width = labelMaxWidth;
        contentFrame.size.height = _containerView.frame.size.height - originY - botMargin;
        _contentLabel.frame = contentFrame;
    }
}

#pragma mark - Override

- (void)setTitle:(NSString *)title
{
    if ([_title isEqualToString:title])
    {
        return;
    }
    _title = title;
    NSDictionary *attributes = _shouldShowMask?selectedTitleAttributes:titleAttributes;
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:_title attributes:attributes];
    [_titleLabel setAttributedText:attrTitle];
    
    [self setNeedsLayout];
}

- (void)setSubtitle:(NSString *)subtitle
{
    if ([_subtitle isEqualToString:subtitle])
    {
        return;
    }
    _subtitle = subtitle;
    NSDictionary *attributes = _shouldShowMask?selectedSubtitleAttributes:subtitleAttributes;
    NSAttributedString *attrSubtitle = [[NSAttributedString alloc] initWithString:_subtitle attributes:attributes];
    [_subtitleLabel setAttributedText:attrSubtitle];
    
    [self setNeedsLayout];
}

- (void)setContent:(NSString *)content
{
    if ([_content isEqualToString:content])
    {
        return;
    }
    _content = content;
    NSAttributedString *attrContent = [[NSAttributedString alloc] initWithString:_content attributes:contentAttributes];
    [_contentLabel setText:attrContent];
    [self setNeedsLayout];
}

- (void)setShouldShowMask:(BOOL)shouldShowMask
{
    _shouldShowMask = shouldShowMask;
    if (_viewMask)
    {
        [_viewMask setHidden:!shouldShowMask];
    }
}

#pragma mark - Actions

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Private Methods

@end
