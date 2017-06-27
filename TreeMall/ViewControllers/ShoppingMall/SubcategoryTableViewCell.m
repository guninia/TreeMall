//
//  SubcategoryTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/25.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SubcategoryTableViewCell.h"

@implementation SubcategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor darkTextColor];
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.contentView.bounds;
    frame = CGRectInset(frame, 5.0, 0.0);
    self.textLabel.frame = frame;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.contentView setBackgroundColor:[self isSelected]?[UIColor colorWithWhite:(194.0/255.0) alpha:1.0]:[UIColor clearColor]];
}

@end
