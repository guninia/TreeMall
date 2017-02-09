//
//  ExtraSubcategorySeeAllTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ExtraSubcategorySeeAllTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ExtraSubcategorySeeAllTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView insertSubview:self.labelBackgroundView belowSubview:self.textLabel];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect viewFrame = CGRectInset(self.contentView.bounds, 10.0, 5.0);
    self.labelBackgroundView.frame = viewFrame;
    CGRect labelFrame = CGRectInset(self.labelBackgroundView.frame, 3.0, 2.0);
    self.textLabel.frame = labelFrame;
}

#pragma mark - Override

- (UIView *)labelBackgroundView
{
    if (_labelBackgroundView == nil)
    {
        _labelBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _labelBackgroundView.backgroundColor = [UIColor orangeColor];
        _labelBackgroundView.layer.cornerRadius = 5.0;
    }
    return _labelBackgroundView;
}

@end
