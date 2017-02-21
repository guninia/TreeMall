//
//  ProductPriceLabel.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/18.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductPriceLabel.h"

@interface ProductPriceLabel ()

- (void)initialize;

@end

@implementation ProductPriceLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    
    CGFloat lineHeight = 1.0;
    self.viewLine.frame = CGRectMake(0.0, ceil((self.frame.size.height - lineHeight)/2), self.frame.size.width, lineHeight);
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    self.viewLine.backgroundColor = self.textColor;
}

- (void)setPrice:(NSNumber *)price
{
    _price = price;
    if (_price == nil)
    {
        self.text = @"";
        return;
    }
    
    NSString *text = @"";
    if (self.prefix)
    {
        text = [text stringByAppendingString:self.prefix];
    }
    NSString *stringPrice = [self.formatter stringFromNumber:_price];
    text = [text stringByAppendingString:stringPrice];
    self.text = text;
}

- (void)setPrefix:(NSString *)prefix
{
    _prefix = prefix;
    self.price = self.price;
}

- (UIView *)viewLine
{
    if (_viewLine == nil)
    {
        _viewLine = [[UIView alloc] initWithFrame:CGRectZero];
        _viewLine.backgroundColor = self.textColor;
    }
    return _viewLine;
}

- (void)setShouldShowCutLine:(BOOL)shouldShowCutLine
{
    _shouldShowCutLine = shouldShowCutLine;
    [self.viewLine setHidden:!shouldShowCutLine];
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
    [self addSubview:self.viewLine];
}

#pragma mark - Public Methods

- (CGSize)referenceSize
{
    NSString *targetText = self.text;
    if (targetText == nil)
    {
        return CGSizeZero;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
    CGSize sizeText = [targetText sizeWithAttributes:attributes];
    CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
    return sizeLabel;
}

@end
