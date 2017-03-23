//
//  CircularSideLabelView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/22.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CircularSideLabelView.h"

@interface CircularSideLabelView ()

- (void)setAttributedText:(NSAttributedString *)attributedText;

@end

@implementation CircularSideLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textIndent = CGSizeMake(6.0, 4.0);
        [self addSubview:self.label];
        self.label.hidden = YES;
        [self.layer setBorderWidth:1.0];
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
    self.layer.cornerRadius = self.frame.size.height / 2;
//    NSLog(@"self.frame.size[%4.2f,%4.2f]", self.frame.size.width, self.frame.size.height);
    
    CGRect labelRect = CGRectInset(self.bounds, self.textIndent.width, self.textIndent.height);
//    NSLog(@"labelRect[%4.2f,%4.2f]", labelRect.size.width, labelRect.size.height);
    self.label.frame = labelRect;
}

- (UILabel *)label
{
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_label setFont:font];
        [_label setLineBreakMode:NSLineBreakByTruncatingTail];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setNumberOfLines:1];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextColor:[UIColor blackColor]];
    }
    return _label;
}

- (void)setText:(NSString *)text
{
    if ([_text isEqualToString:text])
        return;
    _text = text;
    if (_text == nil)
    {
        _label.text = @"";
        _label.hidden = YES;
        return;
    }
    _label.hidden = NO;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_text attributes:self.attributes];
    [self setAttributedText:attrString];
}

- (NSDictionary *)attributes
{
    if (_attributes == nil)
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = self.label.lineBreakMode;
        style.alignment = self.label.textAlignment;
        _attributes = [[NSDictionary alloc] initWithObjectsAndKeys:style, NSParagraphStyleAttributeName, self.label.textColor, NSForegroundColorAttributeName, self.label.backgroundColor, NSBackgroundColorAttributeName, self.label.font, NSFontAttributeName, nil];
    }
    return _attributes;
}

#pragma mark - Public Methods

- (void)setText:(NSString *)text withAttributes:(NSDictionary *)attributes
{
    self.attributes = attributes;
    self.text = text;
}

#pragma mark - Private Methods

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [self.label setAttributedText:attributedText];
    __weak CircularSideLabelView *weakSelf = self;
    [attributedText enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, [attributedText length]) options:0 usingBlock:^(id _Nullable value, NSRange range, BOOL *stop){
        if (value != nil && [value isKindOfClass:[UIColor class]])
        {
            UIColor *color = (UIColor *)value;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.layer setBorderColor:color.CGColor];
            });
            *stop = YES;
        }
    }];
}

@end
