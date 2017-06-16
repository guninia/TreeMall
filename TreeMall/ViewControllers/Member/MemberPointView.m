//
//  MemberPointView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/22.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "MemberPointView.h"
#import "LocalizedString.h"

@implementation MemberPointView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.imageViewIcon];
        [self addSubview:self.labelTitle];
        [self addSubview:self.labelPoint];
        [self addSubview:self.labelDividend];
        [self addSubview:self.viewTotalPoint];
        [self addSubview:self.viewExpired];
        self.numberPoint = nil;
        self.numberDividend = nil;
        self.numberTotal = nil;
        self.numberExpired = nil;
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
    CGFloat marginT = 5.0;
//    CGFloat marginB = 10.0;
    CGFloat originX = marginL;
    CGFloat originY = marginT;
    CGFloat intervalH = 5.0;
    CGFloat intervalV = 5.0;
    
    if (self.imageViewIcon)
    {
        CGSize imageSize = CGSizeMake(30.0, 30.0);
        if (self.imageViewIcon.image)
        {
            imageSize = self.imageViewIcon.image.size;
        }
        CGRect frame = CGRectMake(originX, originY, imageSize.width, imageSize.height);
        self.imageViewIcon.frame = frame;
        originX = self.imageViewIcon.frame.origin.x + self.imageViewIcon.frame.size.width + intervalH;
        originY = self.imageViewIcon.frame.origin.y + self.imageViewIcon.frame.size.height + intervalV;
    }
    if (self.labelTitle)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelTitle.font, NSFontAttributeName, nil];
        CGSize sizeText = [self.labelTitle.text sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, self.imageViewIcon.frame.origin.y + (self.imageViewIcon.frame.size.height - sizeLabel.height)/2, sizeLabel.width, sizeLabel.height);
        self.labelTitle.frame = frame;
    }
    
    originX = marginL;
    CGFloat labelWidth = ceil((self.frame.size.width - (marginL + marginR + intervalV))/2);
    CGFloat labelHeight = 70.0;
    if (self.labelPoint)
    {
        CGRect frame = CGRectMake(originX, originY, labelWidth, labelHeight);
        self.labelPoint.frame = frame;
        originX = self.labelPoint.frame.origin.x + self.labelPoint.frame.size.width + intervalH;
    }
    if (self.labelDividend)
    {
        CGRect frame = CGRectMake(originX, originY, labelWidth, labelHeight);
        self.labelDividend.frame = frame;
        originX = self.labelDividend.frame.origin.x + self.labelDividend.frame.size.width + intervalH;
        originY = self.labelDividend.frame.origin.y + self.labelDividend.frame.size.height + intervalV;
    }
    originX = marginL;
    if (self.viewTotalPoint)
    {
        CGRect frame = CGRectMake(0.0, originY, self.frame.size.width, 30.0);
        self.viewTotalPoint.frame = frame;
        
        originY = self.viewTotalPoint.frame.origin.y + self.viewTotalPoint.frame.size.height;
    }
    if (self.viewExpired)
    {
        CGRect frame = CGRectMake(0.0, originY, self.frame.size.width, 30.0);
        self.viewExpired.frame = frame;
    }
}

- (UIImageView *)imageViewIcon
{
    if (_imageViewIcon == nil)
    {
        _imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_icon2"];
        if (image)
        {
            _imageViewIcon.image = image;
        }
    }
    return _imageViewIcon;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor colorWithRed:(152.0/255.0) green:(192.0/255.0) blue:(67.0/255.0) alpha:1.0]];
        [_labelTitle setText:[LocalizedString MyPoints]];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelTitle setFont:font];
    }
    return _labelTitle;
}

- (UILabel *)labelPoint
{
    if (_labelPoint == nil)
    {
        _labelPoint = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPoint setBackgroundColor:[UIColor clearColor]];
        [_labelPoint setTextColor:[UIColor colorWithRed:(71.0/255.0) green:(158.0/255.0) blue:(135.0/255.0) alpha:1.0]];
        [_labelPoint.layer setBorderWidth:2.0];
        [_labelPoint.layer setBorderColor:_labelPoint.textColor.CGColor];
        [_labelPoint.layer setCornerRadius:5.0];
        [_labelPoint setNumberOfLines:0];
        [_labelPoint setTextAlignment:NSTextAlignmentCenter];
        [_labelPoint setLineBreakMode:NSLineBreakByWordWrapping];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelPoint setFont:font];
    }
    return _labelPoint;
}

- (UILabel *)labelDividend
{
    if (_labelDividend == nil)
    {
        _labelDividend = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDividend setBackgroundColor:[UIColor clearColor]];
        [_labelDividend setTextColor:[UIColor colorWithRed:(161.0/255.0) green:(199.0/255.0) blue:(79.0/255.0) alpha:1.0]];
        [_labelDividend.layer setBorderWidth:2.0];
        [_labelDividend.layer setBorderColor:_labelDividend.textColor.CGColor];
        [_labelDividend.layer setCornerRadius:5.0];
        [_labelDividend setNumberOfLines:0];
        [_labelDividend setTextAlignment:NSTextAlignmentCenter];
        [_labelDividend setLineBreakMode:NSLineBreakByWordWrapping];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelDividend setFont:font];
    }
    return _labelDividend;
}

- (BorderedDoubleLabelView *)viewTotalPoint
{
    if (_viewTotalPoint == nil)
    {
        _viewTotalPoint = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewTotalPoint.layer setBorderWidth:0.0];
        [_viewTotalPoint.labelL setText:[LocalizedString TotalCount]];
        [_viewTotalPoint.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewTotalPoint.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewTotalPoint.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewTotalPoint.labelR setTextColor:[UIColor darkGrayColor]];
    }
    return _viewTotalPoint;
}

- (BorderedDoubleLabelView *)viewExpired
{
    if (_viewExpired == nil)
    {
        _viewExpired = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewExpired.layer setBorderWidth:0.0];
        [_viewExpired.labelL setText:[LocalizedString ExpiredThisMonth]];
        [_viewExpired.labelL setFont:[UIFont systemFontOfSize:18.0]];
        [_viewExpired.labelL setTextColor:[UIColor darkGrayColor]];
        [_viewExpired.labelR setFont:[UIFont systemFontOfSize:18.0]];
        [_viewExpired.labelR setTextColor:[UIColor darkGrayColor]];
    }
    return _viewExpired;
}

- (void)setNumberPoint:(NSNumber *)numberPoint
{
    _numberPoint = numberPoint;
    NSString *stringPoint = @"0";
    if ([_numberPoint integerValue] > 0)
    {
        stringPoint = [self.formatter stringFromNumber:_numberPoint];
    }
    NSString *totalString = [NSString stringWithFormat:@"%@\n%@%@", [LocalizedString ThayPoint], stringPoint, [LocalizedString Point]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10.0;
    style.lineBreakMode = self.labelPoint.lineBreakMode;
    style.alignment = self.labelPoint.textAlignment;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:style, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:totalString attributes:attributes];
    [self.labelPoint setAttributedText:attrString];
}

- (void)setNumberDividend:(NSNumber *)numberDividend
{
    _numberDividend = numberDividend;
    NSString *stringDividend = @"0";
    if ([_numberDividend integerValue] > 0)
    {
        stringDividend = [self.formatter stringFromNumber:_numberDividend];
    }
    NSString *totalString = [NSString stringWithFormat:@"%@\n%@%@", [LocalizedString DancingDividend], stringDividend, [LocalizedString Point]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10.0;
    style.lineBreakMode = self.labelDividend.lineBreakMode;
    style.alignment = self.labelDividend.textAlignment;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:style, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:totalString attributes:attributes];
    [self.labelDividend setAttributedText:attrString];
}

- (void)setNumberTotal:(NSNumber *)numberTotal
{
    _numberTotal = numberTotal;
    NSString *stringTotal = @"0";
    if ([_numberTotal integerValue] > 0)
    {
        stringTotal = [self.formatter stringFromNumber:_numberTotal];
    }
    NSString *totalString = [NSString stringWithFormat:@"%@%@", stringTotal, [LocalizedString Point]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalString];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [stringTotal length])];
    [self.viewTotalPoint.labelR setAttributedText:attrString];
}

- (void)setNumberExpired:(NSNumber *)numberExpired
{
    _numberExpired = numberExpired;
    NSString *stringExpired = @"0";
    if ([_numberExpired integerValue] > 0)
    {
        stringExpired = [self.formatter stringFromNumber:_numberExpired];
    }
    NSString *totalString = [NSString stringWithFormat:@"%@%@", stringExpired, [LocalizedString Point]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalString];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [stringExpired length])];
    [self.viewExpired.labelR setAttributedText:attrString];
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

@end
