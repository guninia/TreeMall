//
//  CartProductTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CartProductTableViewCell.h"
#import "LocalizedString.h"
#import <UIImageView+WebCache.h>

@interface CartProductTableViewCell ()

- (void)buttonConditionPressed:(id)sender;
- (void)buttonDeletePressed:(id)sender;

@end

@implementation CartProductTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.viewContent];
        [self.viewContent addSubview:self.imageViewProduct];
        [self.viewContent addSubview:self.labelName];
        [self.viewContent addSubview:self.labelDetail];
        [self.viewContent addSubview:self.labelPrice];
        [self.viewContent addSubview:self.buttonCondition];
        [self.viewContent addSubview:self.buttonDelete];
        [self.viewContent addSubview:self.separator];
        [self.viewContent addSubview:self.labelPayment];
        [self.viewContent addSubview:self.labelQuantity];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.viewContent)
    {
        CGFloat contentMarginH = 5.0;
        CGFloat contentMarginV = 2.0;
        CGRect frame = CGRectMake(contentMarginH, contentMarginV, self.contentView.frame.size.width - contentMarginH * 2, self.contentView.frame.size.height - contentMarginV * 2);
        self.viewContent.frame = frame;
        NSLog(@"self.contentView[%4.2f,%4.2f]", self.contentView.frame.size.width, self.contentView.frame.size.height);
        NSLog(@"self.viewContent[%4.2f,%4.2f,%4.2f,%4.2f]", self.viewContent.frame.origin.x, self.viewContent.frame.origin.y, self.viewContent.frame.size.width, self.viewContent.frame.size.height);
    }
    CGFloat marginH = 5.0;
    CGFloat marginV = 5.0;
    CGFloat intervalV = 5.0;
    CGFloat intervalH = 5.0;
    CGFloat originX = marginH;
    CGFloat originY = marginV;
    if (self.imageViewProduct)
    {
        CGSize size = CGSizeMake(100.0, 100.0);
        CGRect frame = CGRectMake(originX, originY, size.width, size.height);
        self.imageViewProduct.frame = frame;
        originY = self.imageViewProduct.frame.origin.y + self.imageViewProduct.frame.size.height + intervalV;
        originX = self.imageViewProduct.frame.origin.x + self.imageViewProduct.frame.size.width + intervalH;
        NSLog(@"self.imageViewProduct[%4.2f,%4.2f,%4.2f,%4.2f]", self.imageViewProduct.frame.origin.x, self.imageViewProduct.frame.origin.y, self.imageViewProduct.frame.size.width, self.imageViewProduct.frame.size.height);
    }
    CGFloat labelMaxWidth = self.viewContent.frame.size.width - marginH - originX;
    if (self.separator)
    {
        self.separator.frame = CGRectMake(0.0, originY, self.viewContent.frame.size.width, 1.0);
    }
    if (self.buttonDelete)
    {
        CGSize size = [self.buttonDelete imageForState:UIControlStateNormal].size;
        originY = originY - intervalV - size.height;
        CGFloat buttonOriginX = self.viewContent.frame.size.width - marginH - size.width;
        CGRect frame = CGRectMake(buttonOriginX, originY, size.width, size.height);
        self.buttonDelete.frame = frame;
    }
    if (self.buttonCondition)
    {
        CGFloat buttonWidth = self.buttonDelete.frame.origin.x - intervalH - originX;
        CGSize size = CGSizeMake(buttonWidth, self.buttonDelete.frame.size.height);
        CGRect frame = CGRectMake(originX, self.buttonDelete.frame.origin.y, size.width, size.height);
        self.buttonCondition.frame = frame;
    }
    if (self.labelPrice && [self.labelPrice isHidden] == NO)
    {
        CGSize sizeText = [self.labelPrice.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelPrice.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        originY = CGRectGetMinY(self.buttonCondition.frame)- intervalV - sizeLabel.height;
        CGRect frame = CGRectMake(originX, originY, labelMaxWidth, sizeLabel.height);
        self.labelPrice.frame = frame;
    }
    if (self.labelDetail && [self.labelDetail isHidden] == NO)
    {
        CGSize sizeText = [self.labelDetail.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelPrice.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        originY = CGRectGetMinY(self.labelPrice.frame)- intervalV - sizeLabel.height;
        CGRect frame = CGRectMake(originX, originY, labelMaxWidth, sizeLabel.height);
        self.labelDetail.frame = frame;
    }
    originY -= intervalV;
    if (self.labelName && [self.labelName isHidden] == NO)
    {
        CGRect frame = CGRectMake(originX, marginV, labelMaxWidth, originY - marginV);
        self.labelName.frame = frame;
    }
    originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    if (self.labelQuantity)
    {
        CGSize sizeText = [self.labelQuantity.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelQuantity.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGFloat labelOriginX = self.viewContent.frame.size.width - marginH - sizeLabel.width;
        CGRect frame = CGRectMake(labelOriginX, originY, sizeLabel.width, sizeLabel.height);
        self.labelQuantity.frame = frame;
    }
    if (self.labelPayment && [self.labelPayment isHidden] == NO)
    {
        CGFloat labelWidth = CGRectGetMinX(self.labelQuantity.frame) - intervalH - marginH;
        CGSize sizeText = [self.labelPayment.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelPayment.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, labelWidth, sizeLabel.height);
        self.labelPayment.frame = frame;
    }
}

- (UIView *)viewContent
{
    if (_viewContent == nil)
    {
        _viewContent = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewContent setBackgroundColor:[UIColor whiteColor]];
        [_viewContent.layer setShadowColor:[UIColor colorWithWhite:0.2 alpha:0.5].CGColor];
        [_viewContent.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
        [_viewContent.layer setShadowRadius:2.0];
        [_viewContent.layer setShadowOpacity:1.0];
        [_viewContent.layer setMasksToBounds:NO];
    }
    return _viewContent;
}

- (UIImageView *)imageViewProduct
{
    if (_imageViewProduct == nil)
    {
        _imageViewProduct = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageViewProduct setContentMode:UIViewContentModeScaleAspectFill];
        [_imageViewProduct.layer setMasksToBounds:YES];
        [_imageViewProduct setBackgroundColor:[UIColor grayColor]];
    }
    return _imageViewProduct;
}

- (TTTAttributedLabel *)labelName
{
    if (_labelName == nil)
    {
        _labelName = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelName.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        [_labelName setBackgroundColor:[UIColor clearColor]];
        [_labelName setNumberOfLines:0];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelName setFont:font];
        NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:self.attributesProductName];
        [_labelName setAttributedTruncationToken:truncationToken];
    }
    return _labelName;
}

- (UILabel *)labelDetail
{
    if (_labelDetail == nil)
    {
        _labelDetail = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelDetail setFont:font];
        [_labelDetail setTextColor:[UIColor lightGrayColor]];
        [_labelDetail setBackgroundColor:[UIColor clearColor]];
    }
    return _labelDetail;
}

- (UILabel *)labelPrice
{
    if (_labelPrice == nil)
    {
        _labelPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelPrice setFont:font];
        [_labelPrice setTextColor:[UIColor redColor]];
        [_labelPrice setBackgroundColor:[UIColor clearColor]];
    }
    return _labelPrice;
}

- (UIButton *)buttonCondition
{
    if (_buttonCondition == nil)
    {
        _buttonCondition = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonCondition setTitle:[LocalizedString ChooseQuantityAndDiscount] forState:UIControlStateNormal];
        [_buttonCondition setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_buttonCondition setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_buttonCondition.layer setBorderWidth:1.0];
        [_buttonCondition.layer setCornerRadius:3.0];
        [_buttonCondition.layer setBorderColor:[_buttonCondition titleColorForState:UIControlStateNormal].CGColor];
        [_buttonCondition addTarget:self action:@selector(buttonConditionPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonCondition;
}

- (UIButton *)buttonDelete
{
    if (_buttonDelete == nil)
    {
        _buttonDelete = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"car_btn_trash_on"];
        if (image)
        {
            [_buttonDelete setImage:image forState:UIControlStateNormal];
        }
        UIImage *selectedImage = [UIImage imageNamed:@"car_btn_trash_out"];
        if (selectedImage)
        {
            [_buttonDelete setImage:selectedImage forState:UIControlStateSelected];
        }
        [_buttonDelete addTarget:self action:@selector(buttonDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonDelete;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _separator;
}

- (UILabel *)labelPayment
{
    if (_labelPayment == nil)
    {
        _labelPayment = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPayment setTextColor:[UIColor darkGrayColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelPayment setFont:font];
    }
    return _labelPayment;
}

- (UILabel *)labelQuantity
{
    if (_labelQuantity == nil)
    {
        _labelQuantity = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelQuantity setTextColor:[UIColor orangeColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelQuantity setFont:font];
    }
    return _labelQuantity;
}

- (NSDictionary *)attributesProductName
{
    if (_attributesProductName == nil)
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByCharWrapping;
        style.alignment = NSTextAlignmentLeft;
        UIFont *font = [UIFont systemFontOfSize:14.0];
        UIColor *textColor = [UIColor blackColor];
        _attributesProductName = [[NSDictionary alloc] initWithObjectsAndKeys:style, NSParagraphStyleAttributeName, font, NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];
    }
    return _attributesProductName;
}

- (void)setImageUrl:(NSURL *)imageUrl
{
    if ([[_imageUrl absoluteString] isEqualToString:[imageUrl absoluteString]])
        return;
    _imageUrl = imageUrl;
    if (_imageUrl == nil)
    {
        self.imageViewProduct.image = nil;
        return;
    }
    
    UIImage *transparent = [UIImage imageNamed:@"ico_default"];
    __weak CartProductTableViewCell *weakSelf = self;
    [self.imageViewProduct sd_setImageWithURL:_imageUrl placeholderImage:transparent options:SDWebImageAvoidAutoSetImage|SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
        if (error == nil)
        {
            if ([[_imageUrl absoluteString] isEqualToString:[imageURL absoluteString]])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.imageViewProduct setImage:image];
                });
            }
        }
    }];
}

- (void)setAlreadySelectQuantityAndPayment:(BOOL)alreadySelectQuantityAndPayment
{
    _alreadySelectQuantityAndPayment = alreadySelectQuantityAndPayment;
    
    [self.buttonCondition setSelected:_alreadySelectQuantityAndPayment];
    [self.buttonDelete setSelected:_alreadySelectQuantityAndPayment];
    
    UIControlState state = _alreadySelectQuantityAndPayment? UIControlStateSelected:UIControlStateNormal;
    UIColor *color = [self.buttonCondition titleColorForState:state];
    [self.buttonCondition.layer setBorderColor:color.CGColor];
}

#pragma mark - Actions

- (void)buttonConditionPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cartProductTableViewCell:didPressedConditionBySender:)])
    {
        [_delegate cartProductTableViewCell:self didPressedConditionBySender:sender];
    }
}

- (void)buttonDeletePressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cartProductTableViewCell:didPressedDeleteBySender:)])
    {
        [_delegate cartProductTableViewCell:self didPressedDeleteBySender:sender];
    }
}

@end
