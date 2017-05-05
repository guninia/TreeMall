//
//  ReceiverInfoCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ReceiverInfoCell.h"
#import "Definition.h"

@interface ReceiverInfoCell ()

- (void)buttonPressed:(id)sender;

@end

@implementation ReceiverInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.labelContent];
        [self.contentView addSubview:self.button];
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
    
    CGFloat marginR = 10.0;
    CGFloat marginL = 10.0;
    CGFloat intervalH = 5.0;
    
    CGFloat originX = marginL;
    if (self.button != nil && [self.button isHidden] == NO)
    {
        CGSize size = CGSizeMake(60.0, 30.0);
        CGRect frame = CGRectMake(self.contentView.frame.size.width - marginR - size.width, (self.contentView.frame.size.height - size.height)/2, size.width, size.height);
        self.button.frame = frame;
        marginR = self.contentView.frame.size.width - CGRectGetMinX(self.button.frame) + intervalH;
    }
    if (self.labelTitle)
    {
        CGSize sizeText = [self.labelTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, 0.0, sizeLabel.width, self.contentView.frame.size.height);
        self.labelTitle.frame = frame;
        originX = self.labelTitle.frame.origin.x + self.labelTitle.frame.size.width + intervalH;
    }
    if (self.labelContent)
    {
        CGRect frame = CGRectMake(originX, 0.0, self.contentView.frame.size.width - originX - marginR, self.contentView.frame.size.height);
        self.labelContent.frame = frame;
    }
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setTextColor:[UIColor darkGrayColor]];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelTitle setFont:font];
        [_labelTitle setTextAlignment:NSTextAlignmentLeft];
    }
    return _labelTitle;
}

- (UILabel *)labelContent
{
    if (_labelContent == nil)
    {
        _labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelContent setTextColor:[UIColor grayColor]];
        [_labelContent setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelContent setFont:font];
        [_labelContent setTextAlignment:NSTextAlignmentRight];
        [_labelContent setLineBreakMode:NSLineBreakByTruncatingMiddle];
    }
    return _labelContent;
}

- (UIButton *)button
{
    if (_button == nil)
    {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        [_button setBackgroundColor:TMMainColor];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_button.titleLabel setFont:font];
        [_button.layer setCornerRadius:5.0];
    }
    return _button;
}

- (void)setAccessoryTitle:(NSString *)accessoryTitle
{
    _accessoryTitle = accessoryTitle;
    if (_accessoryTitle == nil)
    {
        [self.button setTitle:@"" forState:UIControlStateNormal];
        [self.button setHidden:YES];
        return;
    }
    [self.button setTitle:_accessoryTitle forState:UIControlStateNormal];
    [self.button setHidden:NO];
}

#pragma mark - Actions

- (void)buttonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(receiverInfoCell:didPressAccessoryView:)])
    {
        [_delegate receiverInfoCell:self didPressAccessoryView:sender];
    }
}

@end
