//
//  MemberTitleView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/22.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "MemberTitleView.h"
#import "LocalizedString.h"

@interface MemberTitleView ()

- (void)buttonModifyPressed:(id)sender;

@end

@implementation MemberTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [self addSubview:self.labelWelcome];
        [self addSubview:self.buttonModify];
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
    
    CGFloat marginL = 10.0;
    CGFloat marginR = 10.0;
    
    if (self.labelWelcome)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelWelcome.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelWelcome.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginL, (self.frame.size.height - sizeLabel.height)/2, sizeLabel.width, sizeLabel.height);
        self.labelWelcome.frame = frame;
    }
    
    if (self.buttonModify)
    {
        CGSize sizeImage = CGSizeMake(self.frame.size.height, self.frame.size.height);
        
        CGRect frame = CGRectMake((self.frame.size.width - marginR - sizeImage.width), (self.frame.size.height - sizeImage.height)/2, sizeImage.width, sizeImage.height);
        self.buttonModify.frame = frame;
    }
}

- (UILabel *)labelWelcome
{
    if (_labelWelcome == nil)
    {
        _labelWelcome = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelWelcome setTextColor:[UIColor darkGrayColor]];
        [_labelWelcome setBackgroundColor:[UIColor clearColor]];
        [_labelWelcome setFont:[UIFont systemFontOfSize:12.0]];
    }
    return _labelWelcome;
}

- (UIButton *)buttonModify
{
    if (_buttonModify == nil)
    {
        _buttonModify = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_edit"];
        if (image)
        {
            [_buttonModify setImage:image forState:UIControlStateNormal];
        }
        [_buttonModify addTarget:self action:@selector(buttonModifyPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonModify;
}

#pragma mark - Actions

- (void)buttonModifyPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(memberTitleView:didSelectToModifyPersonalInformationBySender:)])
    {
        [_delegate memberTitleView:self didSelectToModifyPersonalInformationBySender:sender];
    }
}

@end
