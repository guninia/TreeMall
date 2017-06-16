//
//  BorderedDoubleLabelView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "BorderedDoubleLabelView.h"

@interface BorderedDoubleLabelView ()

- (void)initialize;

- (void)buttonPressed:(id)sender;

@end

@implementation BorderedDoubleLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
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
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    [self.buttonTransparent setHidden:!self.userInteractionEnabled];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    NSInteger intervalH = 5.0;
    CGFloat originX = marginL;
    if (self.labelL)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelL.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelL.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, (self.frame.size.height - sizeLabel.height)/2, sizeLabel.width, sizeLabel.height);
        self.labelL.frame = frame;
        originX = self.labelL.frame.origin.x + self.labelL.frame.size.width + intervalH;
    }
    
    if (self.labelR)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelR.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelR.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGFloat labelOriginX = originX;
        sizeLabel.width = self.frame.size.width - marginR - originX;
        CGRect frame = CGRectMake(labelOriginX, (self.frame.size.height - sizeLabel.height)/2, sizeLabel.width, sizeLabel.height);
        self.labelR.frame = frame;
    }
    
    if (self.buttonTransparent)
    {
        self.buttonTransparent.frame = self.bounds;
    }
}

- (UILabel *)labelL
{
    if (_labelL == nil)
    {
        _labelL = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelL setFont:font];
        [_labelL setBackgroundColor:[UIColor clearColor]];
        [_labelL setTextAlignment:NSTextAlignmentLeft];
        [_labelL setTextColor:[UIColor lightGrayColor]];
    }
    return _labelL;
}

- (UILabel *)labelR
{
    if (_labelR == nil)
    {
        _labelR = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelR setBackgroundColor:[UIColor redColor]];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelR setFont:font];
        [_labelR setBackgroundColor:[UIColor clearColor]];
        [_labelR setTextAlignment:NSTextAlignmentRight];
        [_labelR setAdjustsFontSizeToFitWidth:YES];
        [_labelR setTextColor:[UIColor lightGrayColor]];
    }
    return _labelR;
}

- (UIButton *)buttonTransparent
{
    if (_buttonTransparent == nil)
    {
        _buttonTransparent = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonTransparent setBackgroundColor:[UIColor clearColor]];
        [_buttonTransparent addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonTransparent;
}

#pragma mark - Private Methods

- (void)initialize
{
    [self.layer setBorderWidth:1.0];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self addSubview:self.labelL];
    [self addSubview:self.labelR];
    [self addSubview:self.buttonTransparent];
    [self setUserInteractionEnabled:NO];
}

#pragma mark - Actions

- (void)buttonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTouchUpInsideBorderedDoubleView:)])
    {
        [_delegate didTouchUpInsideBorderedDoubleView:self];
    }
}

@end
