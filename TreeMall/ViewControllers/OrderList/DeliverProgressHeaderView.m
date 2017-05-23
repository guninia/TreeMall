//
//  DeliverProgressHeaderView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "DeliverProgressHeaderView.h"
#import "LocalizedString.h"

@interface DeliverProgressHeaderView ()

@property (nonatomic, strong) UILabel *labelOrderId;
@property (nonatomic, strong) UILabel *labelDeliverIdMessage;

@end

@implementation DeliverProgressHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.labelOrderId];
        [self.contentView addSubview:self.labelDeliverIdMessage];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginH = 10.0;
    CGFloat marginV = 10.0;
    CGFloat intervalV = 10.0;
    CGFloat originY = marginV;
    if (self.labelOrderId)
    {
        CGSize sizeText = [self.labelOrderId.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelOrderId.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, self.contentView.frame.size.width - marginH * 2, sizeLabel.height);
        self.labelOrderId.frame = frame;
        originY = CGRectGetMaxY(self.labelOrderId.frame) + intervalV;
    }
    if (self.labelDeliverIdMessage)
    {
        CGSize sizeText = [self.labelDeliverIdMessage.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelDeliverIdMessage.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, self.contentView.frame.size.width - marginH * 2, sizeLabel.height);
        self.labelDeliverIdMessage.frame = frame;
        originY = CGRectGetMaxY(self.labelDeliverIdMessage.frame) + intervalV;
    }
}

- (UILabel *)labelOrderId
{
    if (_labelOrderId == nil)
    {
        _labelOrderId = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelOrderId setFont:font];
        [_labelOrderId setBackgroundColor:[UIColor clearColor]];
        [_labelOrderId setTextColor:[UIColor blackColor]];
    }
    return _labelOrderId;
}

- (UILabel *)labelDeliverIdMessage
{
    if (_labelDeliverIdMessage == nil)
    {
        _labelDeliverIdMessage = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelDeliverIdMessage setFont:font];
        [_labelDeliverIdMessage setBackgroundColor:[UIColor clearColor]];
        [_labelDeliverIdMessage setTextColor:[UIColor grayColor]];
    }
    return _labelDeliverIdMessage;
}

- (void)setOrderId:(NSString *)orderId
{
    _orderId = orderId;
    if (_orderId == nil)
    {
        [self.labelOrderId setText:@""];
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@：%@", [LocalizedString OrderId], _orderId];
    [self.labelOrderId setText:string];
    [self setNeedsLayout];
}

- (void)setDeliverIdMessage:(NSString *)deliverIdMessage
{
    _deliverIdMessage = deliverIdMessage;
    if (_deliverIdMessage == nil)
    {
        [self.labelDeliverIdMessage setText:@""];
        return;
    }
    [self.labelDeliverIdMessage setText:_deliverIdMessage];
    [self setNeedsLayout];
}

@end
