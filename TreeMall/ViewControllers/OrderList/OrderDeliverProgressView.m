//
//  OrderDeliverProgressView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/14.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "OrderDeliverProgressView.h"
#import "APIDefinition.h"

@interface OrderDeliverProgressView ()

- (void)refreshSubviews;

@end

@implementation OrderDeliverProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _arrayProgress = nil;
        _stepCount = 0;
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
    
    CGFloat intervalH = 10.0;
    CGFloat intervalV = 5.0;
    CGFloat stepWidth = (self.frame.size.width - (intervalH * (self.stepCount + 1))) / self.stepCount;
    
    NSString *stringDefaultStatus = @"ＸＸＸＸ";
    CGSize sizeTextStatus = [stringDefaultStatus sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.fontStatus, NSFontAttributeName, nil]];
    CGSize sizeLabelStatus = CGSizeMake(ceil(sizeTextStatus.width), ceil(sizeTextStatus.height));
    
    NSString *stringDefaultDateTime = @"XXXXXXXX\nXXXXX";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.fontDateTime, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
    CGSize sizeTextDateTime = [stringDefaultDateTime boundingRectWithSize:CGSizeMake(stepWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGSize sizeLabelDateTime = CGSizeMake(ceil(sizeTextDateTime.width), ceil(sizeTextDateTime.height));
    
    for (NSInteger index = 0; index < self.stepCount; index++)
    {
        CGFloat originY = 0.0;
        if (index < [self.arrayProgressBar count])
        {
            UIView *view = [self.arrayProgressBar objectAtIndex:index];
            CGRect frame = CGRectMake(intervalH + (stepWidth + intervalH) * index, originY, stepWidth, 5.0);
            view.frame = frame;
            originY = view.frame.origin.y + view.frame.size.height + intervalV;
        }
        if (index < [self.arrayLabelStatus count])
        {
            UILabel *label = [self.arrayLabelStatus objectAtIndex:index];
            CGRect frame = CGRectMake(intervalH + (stepWidth + intervalH) * index, originY, stepWidth, sizeLabelStatus.height);
            label.frame = frame;
            originY = label.frame.origin.y + label.frame.size.height + intervalV;
        }
        if (index < [self.arrayLabelDateTime count])
        {
            UILabel *label = [self.arrayLabelDateTime objectAtIndex:index];
            CGRect frame = CGRectMake(intervalH + (stepWidth + intervalH) * index, originY, stepWidth, sizeLabelDateTime.height);
            label.frame = frame;
            originY = label.frame.origin.y + label.frame.size.height + intervalV;
        }
    }
}

- (NSMutableArray *)arrayProgressBar
{
    if (_arrayProgressBar == nil)
    {
        _arrayProgressBar = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayProgressBar;
}

- (NSMutableArray *)arrayLabelStatus
{
    if (_arrayLabelStatus == nil)
    {
        _arrayLabelStatus = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayLabelStatus;
}

- (NSMutableArray *)arrayLabelDateTime
{
    if (_arrayLabelDateTime == nil)
    {
        _arrayLabelDateTime = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayLabelDateTime;
}

- (void)setArrayProgress:(NSArray *)arrayProgress
{
    _arrayProgress = arrayProgress;
    _stepCount = [_arrayProgress count];
    __weak OrderDeliverProgressView *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf refreshSubviews];
    });
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (UIFont *)fontStatus
{
    if (_fontStatus == nil)
    {
        _fontStatus = [UIFont systemFontOfSize:14.0];
    }
    return _fontStatus;
}

- (UIFont *)fontDateTime
{
    if (_fontDateTime == nil)
    {
        _fontDateTime = [UIFont systemFontOfSize:14.0];
    }
    return _fontDateTime;
}

#pragma mark - Private Methods

- (void)refreshSubviews
{
    for (UIView *view in _arrayProgressBar)
    {
        if (view.superview == nil)
            break;
        [view removeFromSuperview];
    }
    for (UILabel *label in _arrayLabelStatus)
    {
        if (label.superview == nil)
            break;
        [label setText:@""];
        [label removeFromSuperview];
    }
    for (UILabel *label in _arrayLabelDateTime)
    {
        if (label.superview == nil)
            break;
        [label setText:@""];
        [label removeFromSuperview];
    }
    if (_arrayProgress == nil || [_arrayProgress count] == 0)
    {
        return;
    }
    for (NSInteger index = 0; index < _stepCount; index++)
    {
        NSDictionary *dictionary = [_arrayProgress objectAtIndex:index];
        NSString *stringTime = [dictionary objectForKey:SymphoxAPIParam_time];
        if (stringTime == nil || [stringTime isEqual:[NSNull null]])
        {
            stringTime = @"";
        }
        stringTime = [stringTime stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
        NSString *stringStatus = [dictionary objectForKey:SymphoxAPIParam_status];
        if (stringStatus == nil || [stringStatus isEqual:[NSNull null]])
        {
            stringStatus = @"";
        }
        stringStatus = [stringStatus stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
        
        UIColor *colorProgressBar = ([stringTime length] == 0)?[UIColor colorWithWhite:0.9 alpha:1.0]:[UIColor colorWithRed:(83.0/255.0) green:(134.0/255.0) blue:(48.0/255.0) alpha:1.0];
        UIColor *colorProgressStatus = ([stringTime length] == 0)?[UIColor grayColor]:[UIColor colorWithRed:(83.0/255.0) green:(134.0/255.0) blue:(48.0/255.0) alpha:1.0];
        // Set progress bar
        if (index < [_arrayProgressBar count])
        {
            UIView *view = [_arrayProgressBar objectAtIndex:index];
            if (view.superview && view.superview != self)
            {
                [view removeFromSuperview];
            }
            if (view.superview == nil)
            {
                [self addSubview:view];
            }
            view.backgroundColor = colorProgressBar;
        }
        else
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = colorProgressBar;
            [self addSubview:view];
            [_arrayProgressBar addObject:view];
        }
        
        // Set status label
        if (index < [_arrayLabelStatus count])
        {
            UILabel *label = [_arrayLabelStatus objectAtIndex:index];
            label.text = stringStatus;
            if (label.superview && label.superview != self)
            {
                [label removeFromSuperview];
            }
            if (label.superview == nil)
            {
                [self addSubview:label];
            }
            label.textColor = colorProgressStatus;
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textColor = colorProgressStatus;
            label.backgroundColor = [UIColor clearColor];
            label.font = self.fontStatus;
            label.text = stringStatus;
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            [_arrayLabelStatus addObject:label];
        }
        
        // Set datetime label
        if (index < [_arrayLabelDateTime count])
        {
            UILabel *label = [_arrayLabelDateTime objectAtIndex:index];
            label.text = stringTime;
            if (label.superview && label.superview != self)
            {
                [label removeFromSuperview];
            }
            if (label.superview == nil)
            {
                [self addSubview:label];
            }
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textColor = [UIColor grayColor];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = self.fontDateTime;
            label.text = stringTime;
            [self addSubview:label];
            [_arrayLabelDateTime addObject:label];
        }
    }
}

@end
