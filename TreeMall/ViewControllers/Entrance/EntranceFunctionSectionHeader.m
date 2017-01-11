//
//  EntranceFunctionSectionHeader.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "EntranceFunctionSectionHeader.h"

@interface EntranceFunctionSectionHeader ()

- (void)actButtonExchangePressed:(id)sender;
- (void)actButtonCouponPressed:(id)sender;
- (void)actButtonPromotePressed:(id)sender;

@end

@implementation EntranceFunctionSectionHeader

#pragma mark - Constructor

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor greenColor]];
        _arrayButtons = [[NSMutableArray alloc] initWithCapacity:0];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectZero];
        [button1 setTitle:@"兌點推薦" forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(actButtonExchangePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        [_arrayButtons addObject:button1];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectZero];
        [button2 setTitle:@"折價券推薦" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(actButtonCouponPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        [_arrayButtons addObject:button2];
        
        UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectZero];
        [button3 setTitle:@"優惠通知" forState:UIControlStateNormal];
        [button3 addTarget:self action:@selector(actButtonPromotePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button3];
        [_arrayButtons addObject:button3];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"EntranceFunctionSectionHeader[%4.2f,%4.2f]", self.frame.size.width, self.frame.size.height);
    
    CGSize buttonSize = CGSizeMake(60.0, 60.0);
    CGFloat hInterval = ceil((self.frame.size.width - buttonSize.width * [_arrayButtons count])/([_arrayButtons count] + 1));
    for (NSInteger index = 0; index < [_arrayButtons count]; index++)
    {
        UIButton *button = [_arrayButtons objectAtIndex:index];
        [button setFrame:CGRectMake(hInterval + (buttonSize.width + hInterval) * index, (self.frame.size.height - buttonSize.height) / 2, buttonSize.width, buttonSize.height)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Actions

- (void)actButtonExchangePressed:(id)sender
{
    NSLog(@"actButtonExchangePressed");
    if (_delegate && [_delegate respondsToSelector:@selector(entranceFunctionSectionHeader:didSelectFunction:)])
    {
        [_delegate entranceFunctionSectionHeader:self didSelectFunction:EntranceFunctionExchange];
    }
}

- (void)actButtonCouponPressed:(id)sender
{
    NSLog(@"actButtonCouponPressed");
    if (_delegate && [_delegate respondsToSelector:@selector(entranceFunctionSectionHeader:didSelectFunction:)])
    {
        [_delegate entranceFunctionSectionHeader:self didSelectFunction:EntranceFunctionCoupon];
    }
}

- (void)actButtonPromotePressed:(id)sender
{
    NSLog(@"actButtonPromotePressed");
    if (_delegate && [_delegate respondsToSelector:@selector(entranceFunctionSectionHeader:didSelectFunction:)])
    {
        [_delegate entranceFunctionSectionHeader:self didSelectFunction:EntranceFunctionPromotion];
    }
}

@end
