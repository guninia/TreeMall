//
//  TextHorizontalSeparator.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "TextHorizontalSeparator.h"

@implementation TextHorizontalSeparator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lineLeft = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:lineLeft];
        lineRight = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:lineRight];
        labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [self addSubview:labelText];
        
        self.lineWidth = 1.0;
        self.font = [UIFont systemFontOfSize:14.0];
        self.text = nil;
        self.tintColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize textSize = CGSizeZero;
    CGFloat textMargin = 0.0;
    if (_text != nil)
    {
        textSize = [_text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, nil]];
        textMargin = 5.0;
    }
    CGSize labelSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    CGRect labelFrame = labelText.frame;
    labelFrame.origin.x = ceil((self.frame.size.width - labelSize.width)/2);
    labelFrame.origin.y = 0.0;
    labelFrame.size.width = labelSize.width;
    labelFrame.size.height = self.frame.size.height;
    labelText.frame = labelFrame;
    
    CGRect textArea = CGRectInset(labelFrame, -(textMargin * 2), 0.0);
    CGRect lineLeftFrame = lineLeft.frame;
    lineLeftFrame.origin.x = 0;
    lineLeftFrame.origin.y = ceil((self.frame.size.height - lineLeftFrame.size.height)/2);
    lineLeftFrame.size.width = textArea.origin.x;
    lineLeft.frame = lineLeftFrame;
    
    CGRect lineRightFrame = lineRight.frame;
    lineRightFrame.origin.x = textArea.origin.x + textArea.size.width;
    lineRightFrame.origin.y = ceil((self.frame.size.height - lineRightFrame.size.height)/2);
    lineRightFrame.size.width = ceil(self.frame.size.width - lineRightFrame.origin.x);
    lineRight.frame = lineRightFrame;
    
//    NSLog(@"TextHorizontalSeparator - leftLine[%4.2f,%4.2f,%4.2f,%4.2f] label[%4.2f,%4.2f,%4.2f,%4.2f] lineRight[%4.2f,%4.2f,%4.2f,%4.2f]", lineLeft.frame.origin.x, lineLeft.frame.origin.y, lineLeft.frame.size.width, lineLeft.frame.size.height, labelText.frame.origin.x, labelText.frame.origin.y, labelText.frame.size.width, labelText.frame.size.height, lineRight.frame.origin.x, lineRight.frame.origin.y, lineRight.frame.size.width, lineRight.frame.size.height);
}

#pragma mark - Override

- (void)setLineWidth:(CGFloat)lineWidth
{
    if (_lineWidth != lineWidth)
    {
        _lineWidth = lineWidth;
        CGRect frame = lineLeft.frame;
        frame.size.height = _lineWidth;
        lineLeft.frame = frame;
        
        frame = lineRight.frame;
        frame.size.height = _lineWidth;
        lineRight.frame = frame;
        
        [self setNeedsLayout];
    }
}

- (void)setFont:(UIFont *)font
{
    if ([[_font fontName] isEqualToString:[font fontName]] == NO || [_font pointSize] != [font pointSize])
    {
        _font = font;
        [labelText setFont:_font];
        
        [self setNeedsLayout];
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    [lineLeft setBackgroundColor:_tintColor];
    [lineRight setBackgroundColor:_tintColor];
    [labelText setTextColor:_tintColor];
}

- (void)setText:(NSString *)text
{
    if ([[labelText text] isEqualToString:text] == NO)
    {
        _text = text;
        [labelText setText:_text];
        [labelText setHidden:(text == nil)?YES:NO];
        
        [self setNeedsLayout];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
