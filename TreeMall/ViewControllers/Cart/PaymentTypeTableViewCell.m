//
//  PaymentTypeTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "PaymentTypeTableViewCell.h"

@interface PaymentTypeTableViewCell ()

- (void)buttonActionPressed:(id)sender;

@end

@implementation PaymentTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _delegate = nil;
        [self.contentView addSubview:self.buttonCheck];
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.buttonAction];
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
//    if (self.accessoryView == nil)
//    {
//        self.accessoryType = [self isSelected]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
//    }
    [self.buttonCheck setSelected:selected];
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat originX = marginL;
    CGFloat intervalH = 3.0;
//    CGFloat intervalH = 5.0;
    if (self.buttonAction && [self.buttonAction isHidden] == NO)
    {
        if (self.accessoryView == nil)
        {
            // Should show accessory type
            marginR = 30.0;
        }
    }
    if (self.buttonCheck)
    {
        CGSize buttonSize = CGSizeMake(30.0, 30.0);
        UIImage *image = [self.buttonCheck imageForState:UIControlStateNormal];
        if (image)
        {
            buttonSize = image.size;
        }
        CGRect frame = CGRectMake(originX, (self.contentView.frame.size.height - buttonSize.height)/2, buttonSize.width, buttonSize.height);
        self.buttonCheck.frame = frame;
        originX = CGRectGetMaxX(self.buttonCheck.frame) + intervalH;
    }
    if (self.labelTitle)
    {
        CGRect frame = CGRectMake(originX, 0.0, self.contentView.frame.size.width - marginR - marginL, self.contentView.frame.size.height);
        self.labelTitle.frame = frame;
    }
}

- (UIButton *)buttonCheck
{
    if (_buttonCheck == nil)
    {
        _buttonCheck = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"ico_car_list_line"];
        if (image)
        {
            [_buttonCheck setImage:image forState:UIControlStateNormal];
        }
        UIImage *selectedImage = [UIImage imageNamed:@"ico_car_list"];
        if (selectedImage)
        {
            [_buttonCheck setImage:selectedImage forState:UIControlStateSelected];
        }
    }
    return _buttonCheck;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelTitle setFont:font];
    }
    return _labelTitle;
}

- (UIButton *)buttonAction
{
    if (_buttonAction == nil)
    {
        _buttonAction = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonAction setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:165.0/255.0 blue:65.0/255.0 alpha:1.0]];
        [_buttonAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonAction.layer setCornerRadius:5.0];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_buttonAction.titleLabel setFont:font];
        [self.buttonAction addTarget:self action:@selector(buttonActionPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonAction;
}

- (void)setActionTitle:(NSString *)actionTitle
{
    _actionTitle = actionTitle;
    if (_actionTitle == nil || [_actionTitle length] == 0)
    {
        [self.buttonAction setHidden:YES];
        return;
    }
    [self.buttonAction setTitle:_actionTitle forState:UIControlStateNormal];
    NSString *title = [self.buttonAction titleForState:UIControlStateNormal];
    CGSize sizeText = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.buttonAction.titleLabel.font, NSFontAttributeName, nil]];
    CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
    CGSize sizeButton = CGSizeMake(sizeLabel.width + 12.0, sizeLabel.height + 10.0);
    CGRect frame = CGRectMake(0.0, 0.0, sizeButton.width, sizeButton.height);
    self.buttonAction.frame = frame;
    [self.buttonAction setHidden:NO];
}

#pragma mark - Actions

- (void)buttonActionPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(PaymentTypeTableViewCell:didSelectActionBySender:)])
    {
        [_delegate PaymentTypeTableViewCell:self didSelectActionBySender:sender];
    }
}

@end
