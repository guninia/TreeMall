//
//  NewsletterSubscribeTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "NewsletterSubscribeTableViewCell.h"

#define kTextNormalColor [UIColor lightGrayColor]
#define kTextSelectedColor [UIColor darkGrayColor]
#define kBorderNormalColor [UIColor lightGrayColor]
#define kBorderSelectedColor [UIColor colorWithRed:(130.0/255.0) green:(192.0/255.0) blue:(88.0/255.0) alpha:1.0]

@implementation NewsletterSubscribeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        [self.textLabel setTextColor:kTextNormalColor];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [self.textLabel setFont:font];
        [self.textLabel setTextAlignment:NSTextAlignmentLeft];
        [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        [self.contentView addSubview:self.viewBackground];
        [self.viewBackground addSubview:self.labelTitle];
        [self.viewBackground addSubview:self.labelDetail];
        [self.viewBackground addSubview:self.buttonCheck];
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
    
    CGFloat marginT = 10.0;
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    CGFloat marginB = 10.0;
    
    if (self.viewBackground)
    {
        CGFloat marginH = 10.0;
        CGFloat marginV = 3.0;
        CGRect frame = CGRectMake(marginH, marginV, self.contentView.frame.size.width - marginH * 2, self.contentView.frame.size.height - marginV * 2);
        self.viewBackground.frame = frame;
    }
    if (self.buttonCheck)
    {
        CGSize buttonSize = CGSizeMake(30.0, 30.0);
        UIImage *image = [self.buttonCheck imageForState:UIControlStateNormal];
        if (image)
        {
            buttonSize = image.size;
        }
        CGRect frame = CGRectMake(self.viewBackground.frame.size.width - marginR - buttonSize.width, marginT, buttonSize.width, buttonSize.height);
        self.buttonCheck.frame = frame;
    }
    
    if (self.labelTitle)
    {
        NSString *defaultString = @"ＸＸＸＸＸ";
        CGSize sizeText = [defaultString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginL, marginT, self.buttonCheck.frame.origin.x - marginL, sizeLabel.height);
        self.labelTitle.frame = frame;
    }
    CGFloat originY = MAX((self.buttonCheck.frame.origin.y + self.buttonCheck.frame.size.height), (self.labelTitle.frame.origin.y + self.labelTitle.frame.size.height));
    originY += 3.0;
    
    if (self.labelDetail)
    {
        CGRect frame = CGRectMake(marginL, originY, self.viewBackground.frame.size.width - (marginL + marginR), self.viewBackground.frame.size.height - marginB - originY);
        self.labelDetail.frame = frame;
    }
}

- (UIView *)viewBackground
{
    if (_viewBackground == nil)
    {
        _viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewBackground.layer setBorderWidth:1.0];
        [_viewBackground.layer setBorderColor:kBorderNormalColor.CGColor];
    }
    return _viewBackground;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:kTextNormalColor];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelTitle setFont:font];
        [_labelTitle setTextAlignment:NSTextAlignmentLeft];
        [_labelTitle setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    return _labelTitle;
}

- (UILabel *)labelDetail
{
    if (_labelDetail == nil)
    {
        _labelDetail = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDetail setBackgroundColor:[UIColor clearColor]];
        [_labelDetail setTextColor:kTextNormalColor];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelDetail setFont:font];
        [_labelDetail setTextAlignment:NSTextAlignmentLeft];
        [_labelDetail setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelDetail setNumberOfLines:0];
    }
    return _labelDetail;
}

- (UIButton *)buttonCheck
{
    if (_buttonCheck == nil)
    {
        _buttonCheck = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonCheck setUserInteractionEnabled:NO];
        UIImage *image = [UIImage imageNamed:@"ico_chick_off"];
        if (image)
        {
            [_buttonCheck setImage:image forState:UIControlStateNormal];
            UIImage *checkImage = [UIImage imageNamed:@"ico_chick_on"];
            if (checkImage)
            {
                [_buttonCheck setImage:checkImage forState:UIControlStateSelected];
            }
        }
    }
    return _buttonCheck;
}

- (void)setSubscribed:(BOOL)subscribed
{
    _subscribed = subscribed;
    
    if (self.viewBackground)
    {
        [self.viewBackground.layer setBorderColor:subscribed?kBorderSelectedColor.CGColor:kBorderNormalColor.CGColor];
    }
    if (self.labelTitle)
    {
        [self.labelTitle setTextColor:subscribed?kTextSelectedColor:kTextNormalColor];
    }
    if (self.labelDetail)
    {
        [self.labelDetail setTextColor:subscribed?kTextSelectedColor:kTextNormalColor];
    }
    if (self.buttonCheck)
    {
        [self.buttonCheck setSelected:subscribed];
    }
}

@end
