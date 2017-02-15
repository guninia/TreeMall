//
//  LabelRangeSliderView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/14.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "LabelRangeSliderView.h"

@interface LabelRangeSliderView ()

- (void)initialize;
- (void)updateValueLabel;

- (void)sliderValueChanged:(id)sender;

@end

@implementation LabelRangeSliderView

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat originY = 0.0;
    if (self.labelLowerValue && [self.labelLowerValue isHidden] == NO)
    {
        CGRect frame = self.labelLowerValue.frame;
        if (CGRectEqualToRect(frame, CGRectZero))
        {
            if (self.textHigherBoundary != nil)
            {
                NSString *totalString = [NSString stringWithFormat:@"%@%@", ((_textPrefix == nil)?@"":_textPrefix), self.textHigherBoundary];
                NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelLowerValue.font, NSFontAttributeName, nil];
                CGSize sizeText = [totalString sizeWithAttributes:attributes];
                CGSize sizeLabel = CGSizeMake(ceil((sizeText.width > self.maxLabelWidth)?self.maxLabelWidth:sizeText.width), ceil(sizeText.height));
                frame.size = sizeLabel;
            }
        }
        self.labelLowerValue.frame = frame;
    }
    if (self.labelHigherValue && [self.labelHigherValue isHidden] == NO)
    {
        CGRect frame = self.labelHigherValue.frame;
        if (CGRectEqualToRect(frame, CGRectZero))
        {
            if (self.textHigherBoundary != nil)
            {
                NSString *totalString = [NSString stringWithFormat:@"%@%@", ((_textPrefix == nil)?@"":_textPrefix), self.textHigherBoundary];
                NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelHigherValue.font, NSFontAttributeName, nil];
                CGSize sizeText = [totalString sizeWithAttributes:attributes];
                CGSize sizeLabel = CGSizeMake(ceil((sizeText.width > self.maxLabelWidth)?self.maxLabelWidth:sizeText.width), ceil(sizeText.height));
                frame.size = sizeLabel;
            }
        }
        self.labelHigherValue.frame = frame;
    }
    originY = self.labelLowerValue.frame.origin.y + self.labelLowerValue.frame.size.height + 2.0;
    
    if (self.labelLowerBoundary && [self.labelLowerBoundary isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelLowerBoundary.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelLowerBoundary.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil((sizeText.width > self.maxLabelWidth)?self.maxLabelWidth:sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(0.0, self.frame.size.height - sizeLabel.height, sizeLabel.width, sizeLabel.height);
        self.labelLowerBoundary.frame = frame;
    }
    if (self.labelHigherBoundary && [self.labelHigherBoundary isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelHigherBoundary.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelHigherBoundary.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil((sizeText.width > self.maxLabelWidth)?self.maxLabelWidth:sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(self.frame.size.width - sizeLabel.width, self.frame.size.height - sizeLabel.height, sizeLabel.width, sizeLabel.height);
        self.labelHigherBoundary.frame = frame;
    }
    CGFloat bottomY = self.labelLowerBoundary.frame.origin.y;
    if (self.slider)
    {
        CGRect frame = CGRectMake(0.0, originY, self.bounds.size.width, bottomY - originY);
        self.slider.frame = frame;
    }
    [self updateValueLabel];
}

- (NMRangeSlider *)slider
{
    if (_slider == nil)
    {
        _slider = [[NMRangeSlider alloc] initWithFrame:CGRectZero];
        _slider.minimumRange = 1.0;
        _slider.stepValue = 1.0;
        _slider.stepValueContinuously = YES;
//        _slider.trackColor = [UIColor orangeColor];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)labelLowerValue
{
    if (_labelLowerValue == nil)
    {
        _labelLowerValue = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelLowerValue setBackgroundColor:[UIColor clearColor]];
        [_labelLowerValue setTextColor:[UIColor orangeColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelLowerValue setFont:font];
        [_labelLowerValue setAdjustsFontSizeToFitWidth:YES];
    }
    return _labelLowerValue;
}

- (UILabel *)labelHigherValue
{
    if (_labelHigherValue == nil)
    {
        _labelHigherValue = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelHigherValue setBackgroundColor:[UIColor clearColor]];
        [_labelHigherValue setTextColor:[UIColor orangeColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelHigherValue setFont:font];
        [_labelHigherValue setAdjustsFontSizeToFitWidth:YES];
    }
    return _labelHigherValue;
}

- (UILabel *)labelLowerBoundary
{
    if (_labelLowerBoundary == nil)
    {
        _labelLowerBoundary = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelLowerBoundary setBackgroundColor:[UIColor clearColor]];
        [_labelLowerBoundary setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelLowerBoundary setFont:font];
        [_labelLowerBoundary setTextAlignment:NSTextAlignmentCenter];
        [_labelLowerBoundary setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [_labelLowerBoundary setAdjustsFontSizeToFitWidth:YES];
    }
    return _labelLowerBoundary;
}

- (UILabel *)labelHigherBoundary
{
    if (_labelHigherBoundary == nil)
    {
        _labelHigherBoundary = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelHigherBoundary setBackgroundColor:[UIColor clearColor]];
        [_labelHigherBoundary setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelHigherBoundary setFont:font];
        [_labelHigherBoundary setTextAlignment:NSTextAlignmentCenter];
        [_labelHigherBoundary setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [_labelHigherBoundary setAdjustsFontSizeToFitWidth:YES];
    }
    return _labelHigherBoundary;
}

- (void)setTextLowerBoundary:(NSString *)textLowerBoundary
{
    if ([textLowerBoundary isEqualToString:_textLowerBoundary])
    {
        return;
    }
    _textLowerBoundary = textLowerBoundary;
    if (_textLowerBoundary == nil || [_textLowerBoundary isEqual:[NSNull null]] || [_textLowerBoundary length] == 0)
    {
        [self.labelLowerBoundary setHidden:YES];
    }
    else
    {
        [self.labelLowerBoundary setHidden:NO];
        self.labelLowerBoundary.text = [NSString stringWithFormat:@"%@%@", ((_textPrefix == nil)?@"":_textPrefix), _textLowerBoundary];
    }
    [self setNeedsLayout];
}

- (void)setTextHigherBoundary:(NSString *)textHigherBoundary
{
    if ([textHigherBoundary isEqualToString:_textHigherBoundary])
    {
        return;
    }
    _textHigherBoundary = textHigherBoundary;
    if (_textHigherBoundary == nil || [_textHigherBoundary isEqual:[NSNull null]] || [_textHigherBoundary length] == 0)
    {
        [self.labelHigherBoundary setHidden:YES];
    }
    else
    {
        [self.labelHigherBoundary setHidden:NO];
        self.labelHigherBoundary.text = [NSString stringWithFormat:@"%@%@", ((_textPrefix == nil)?@"":_textPrefix), _textHigherBoundary];
    }
    [self setNeedsLayout];
}

- (NSNumberFormatter *)formatter
{
    if (_formatter == nil)
    {
        _formatter = [[NSNumberFormatter alloc] init];
        [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return _formatter;
}

#pragma mark - Private Methods

- (void)initialize
{
    self.maxLabelWidth = 150.0;
    [self.layer setMasksToBounds:NO];
    [self addSubview:self.slider];
    [self addSubview:self.labelLowerBoundary];
    [self addSubview:self.labelHigherBoundary];
    [self addSubview:self.labelLowerValue];
    [self addSubview:self.labelHigherValue];
}

- (void)updateValueLabel
{
//    NSLog(@"updateValueLabel - self.labelLowerValue[%4.2f,%4.2f,%4.2f,%4.2f]", self.labelLowerValue.frame.origin.x, self.labelLowerValue.frame.origin.y, self.labelLowerValue.frame.size.width, self.labelLowerValue.frame.size.height);
    if (self.labelLowerValue && [self.labelLowerValue isHidden] == NO)
    {
        CGRect frame = self.labelLowerValue.frame;
        CGPoint center = CGPointZero;
        center.x = self.slider.frame.origin.x + self.slider.lowerCenter.x;
        center.y = self.slider.frame.origin.y - frame.size.height / 2;
        self.labelLowerValue.center = center;
//        NSLog(@"self.labelLowerValue[%4.2f,%4.2f,%4.2f,%4.2f]", self.labelLowerValue.frame.origin.x, self.labelLowerValue.frame.origin.y, self.labelLowerValue.frame.size.width, self.labelLowerValue.frame.size.height);
        
        NSString *formattedString = [self.formatter stringFromNumber:[NSNumber numberWithFloat:self.slider.lowerValue]];
        NSString *string = [NSString stringWithFormat:@"%@%@", ((_textPrefix == nil)?@"":_textPrefix), formattedString];
        self.labelLowerValue.text = string;
    }
    if (self.labelHigherValue && [self.labelHigherValue isHidden] == NO)
    {
        CGRect frame = self.labelHigherValue.frame;
        CGPoint center = CGPointZero;
        center.x = self.slider.frame.origin.x + self.slider.upperCenter.x;
        center.y = self.slider.frame.origin.y - frame.size.height / 2;
        self.labelHigherValue.center = center;
        
        NSString *formattedString = [self.formatter stringFromNumber:[NSNumber numberWithFloat:self.slider.upperValue]];
        NSString *string = [NSString stringWithFormat:@"%@%@", ((_textPrefix == nil)?@"":_textPrefix), formattedString];
        self.labelHigherValue.text = string;
    }
}

#pragma mark - Actions

- (void)sliderValueChanged:(id)sender
{
    [self updateValueLabel];
}

@end
