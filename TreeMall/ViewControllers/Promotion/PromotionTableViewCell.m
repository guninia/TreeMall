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
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.contentView addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_subtitleLabel setBackgroundColor:[UIColor clearColor]];
        [_subtitleLabel setTextColor:[UIColor blackColor]];
        [_subtitleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.contentView addSubview:_subtitleLabel];
        
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setTextColor:[UIColor grayColor]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:_contentLabel];
        
        [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailTextLabel setTextColor:[UIColor blackColor]];
        [self.detailTextLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        
        _viewMask = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewMask setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        [_viewMask setHidden:YES];
        [self.contentView addSubview:_viewMask];
        
        titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:_titleLabel.font, NSFontAttributeName, style, NSParagraphStyleAttributeName, _titleLabel.textColor, NSForegroundColorAttributeName, nil];
        subtitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:_subtitleLabel.font, NSFontAttributeName, _subtitleLabel.textColor, NSForegroundColorAttributeName, nil];
        contentAttributes = [NSDictionary dictionaryWithObjectsAndKeys:_contentLabel.font, NSFontAttributeName, style, NSParagraphStyleAttributeName, _contentLabel.textColor, NSForegroundColorAttributeName, nil];
        
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
    
    CGFloat hInterval = 5.0;
    CGFloat vInterval = 5.0;
    CGFloat originX = 0.0;
    CGFloat originY = 5.0;
    
    CGSize imageViewSize = CGSizeMake(40.0, 40.0);
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x = originX;
    imageViewFrame.origin.y = ceil((self.contentView.frame.size.height - imageViewSize.height)/2);
    imageViewFrame.size = imageViewSize;
    originX = imageViewFrame.origin.x + imageViewFrame.size.width + hInterval;
    CGFloat labelMaxWidth = self.contentView.frame.size.width - originX - hInterval;
    
    NSString *defaultTowLineString = @"XXXXX\nXXXXX";
    NSString *defaultOneLineString = @"XXXXX";
    
    if ([_title length] > 0)
    {
        CGRect titleRect = [defaultTowLineString boundingRectWithSize:CGSizeMake(labelMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil];
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
    
    CGRect contentFrame = _contentLabel.frame;
    contentFrame.origin.x = originX;
    contentFrame.origin.y = originY;
    contentFrame.size.width = labelMaxWidth;
    contentFrame.size.height = self.contentView.frame.size.height - originY - vInterval;
    _contentLabel.frame = contentFrame;
}

#pragma mark - Override

- (void)setTitle:(NSString *)title
{
    if ([_title isEqualToString:title])
    {
        return;
    }
    _title = title;
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:_title attributes:titleAttributes];
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
    NSAttributedString *attrSubtitle = [[NSAttributedString alloc] initWithString:_subtitle attributes:subtitleAttributes];
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
//    NSAttributedString *attrTail = [[NSAttributedString alloc] initWithString:@"..." attributes:contentAttributes];
//    [_contentLabel setAttributedTruncationToken:attrTail];
    [self setNeedsLayout];
}

#pragma mark - Actions

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Private Methods

@end
