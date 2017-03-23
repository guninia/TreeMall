//
//  MemberSettingsTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "MemberSettingsTableViewCell.h"

@implementation MemberSettingsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.labelView];
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
    if (self.textLabel)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.textLabel.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.textLabel.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = self.textLabel.frame;
        frame.size.width = sizeLabel.width;
        self.textLabel.frame = frame;
    }
    CGFloat intervalH = 3.0;
    CGFloat originX = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + intervalH;
    CGFloat rightEnd = self.contentView.frame.size.width - 8.0;
    if (self.accessoryView)
    {
        rightEnd = self.accessoryView.frame.origin.x;
    }
    if (self.labelView)
    {
        CGSize sizeText = [self.labelView.text sizeWithAttributes:self.labelView.attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGSize sizeView = CGSizeMake(sizeLabel.width + self.labelView.textIndent.width * 2, sizeLabel.height + self.labelView.textIndent.height * 2);
        CGRect frame = CGRectMake(originX, (self.contentView.frame.size.height - sizeView.height)/2, sizeView.width, sizeView.height);
        self.labelView.frame = frame;
        
        [self.labelView setNeedsLayout];
    }
}

- (CircularSideLabelView *)labelView
{
    if (_labelView == nil)
    {
        _labelView = [[CircularSideLabelView alloc] initWithFrame:CGRectZero];
    }
    return _labelView;
}

@end
