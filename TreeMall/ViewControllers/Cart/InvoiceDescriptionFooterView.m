//
//  InvoiceDescriptionFooterView.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/8.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "InvoiceDescriptionFooterView.h"

@interface InvoiceDescriptionFooterView ()

@property (nonatomic, assign) CGFloat marginH;
@property (nonatomic, assign) CGFloat marginV;

@end

@implementation InvoiceDescriptionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        _marginH = kInvoiceDescriptionFooterViewMarginH;
        _marginV = kInvoiceDescriptionFooterViewMarginV;
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

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    if (self.labelDescription)
//    {
//        CGRect frame = CGRectMake(self.marginH, self.marginV, self.contentView.frame.size.width - self.marginH * 2, self.contentView.frame.size.height - self.marginV * 2);
//        self.labelDescription.frame = frame;
//        NSLog(@"layoutSubviews - self.labelDescription[%4.2f,%4.2f]", self.labelDescription.frame.size.width, self.labelDescription.frame.size.height);
//    }
//}

//- (void)setLabelDescription:(DTAttributedLabel *)labelDescription
//{
//    if (_labelDescription == labelDescription)
//    {
//        return;
//    }
//    if (_labelDescription)
//    {
//        [_labelDescription removeFromSuperview];
//        _labelDescription = nil;
//    }
//    _labelDescription = labelDescription;
//    if (_labelDescription)
//    {
//        [self.contentView addSubview:_labelDescription];
//    }
//}

@end
