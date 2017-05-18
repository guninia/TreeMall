//
//  HotSaleTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/28.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "HotSaleTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "LocalizedString.h"

@interface HotSaleTableViewCell ()

- (void)checkPriceAndPointSeparatorState;

- (void)buttonAddToCartPressed:(id)sender;
- (void)buttonFavoritePressed:(id)sender;

@end

@implementation HotSaleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1.0]];
        [self.contentView addSubview:self.viewContainer];
        [self.viewContainer addSubview:self.imageViewProduct];
        [self.viewContainer addSubview:self.imageViewTag];
        [self.imageViewTag addSubview:self.labelTag];
        [self.viewContainer addSubview:self.labelTitle];
        [self.viewContainer addSubview:self.separator];
        [self.viewContainer addSubview:self.labelPrice];
        [self.viewContainer addSubview:self.buttonAddToCart];
        [self.viewContainer addSubview:self.buttonFavorite];
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

#pragma mark - Overiide

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.viewContainer)
    {
        CGFloat marginH = 10.0;
        CGFloat marginV = 5.0;
        CGRect frame = CGRectMake(marginH, marginV, self.contentView.frame.size.width - marginH * 2, self.contentView.frame.size.height - marginV * 2);
        self.viewContainer.frame = frame;
    }
    
    CGFloat marginH = 10.0;
    CGFloat marginV = 10.0;
    CGFloat intervalH = 5.0;
    CGFloat intervalV = 5.0;
    
    CGFloat originX = marginH;
    CGFloat originY = marginV;
    
    if (self.imageViewProduct)
    {
        CGSize imageSize = CGSizeMake(100.0, 100.0);
        CGRect frame = CGRectMake(originX, originY, imageSize.width, imageSize.height);
        self.imageViewProduct.frame = frame;
        originX = self.imageViewProduct.frame.origin.x + self.imageViewProduct.frame.size.width + intervalH;
        originY = self.imageViewProduct.frame.origin.y + self.imageViewProduct.frame.size.height + intervalV;
    }
    if (self.imageViewTag)
    {
        CGSize imageSize = CGSizeMake(40.0, 40.0);
        if (self.imageViewTag.image)
        {
            imageSize = self.imageViewTag.image.size;
        }
        CGRect frame = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        self.imageViewTag.frame = frame;
        
        if (self.labelTag)
        {
            CGFloat indentH = 2.0;
            CGFloat indentV = 3.0;
            CGSize sizeText = [self.labelTag.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelTag.font, NSFontAttributeName, nil]];
            CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
            CGRect frame = CGRectMake(indentH, indentV, self.imageViewTag.frame.size.width - indentH * 2, sizeLabel.height);
            self.labelTag.frame = frame;
        }
    }
    if (self.separator)
    {
        CGRect frame = CGRectMake(0.0, originY, self.viewContainer.frame.size.width, 1.0);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    }
    if (self.labelTitle)
    {
        CGFloat height = self.separator.frame.origin.y - intervalV - marginV;
        CGFloat width = self.viewContainer.frame.size.width - marginH - originX;
        CGRect frame = CGRectMake(originX, marginV, width, height);
        self.labelTitle.frame = frame;
    }
    
    CGFloat priceBottom = originY;
    CGFloat labelOriginX = marginH;
    if (self.labelPrice && [self.labelPrice isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelPrice.font, NSFontAttributeName, nil];
        CGSize textSize = [self.labelPrice.text sizeWithAttributes:attributes];
        CGSize labelSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
        CGRect frame = CGRectMake(labelOriginX, originY, labelSize.width, labelSize.height);
        self.labelPrice.frame = frame;
        labelOriginX = self.labelPrice.frame.origin.x + self.labelPrice.frame.size.width + intervalH;
        priceBottom = self.labelPrice.frame.origin.y + self.labelPrice.frame.size.height;
    }
    if (self.labelSeparator && [self.labelSeparator isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelSeparator.font, NSFontAttributeName, nil];
        CGSize textSize = [self.labelSeparator.text sizeWithAttributes:attributes];
        CGSize labelSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
        CGRect frame = CGRectMake(labelOriginX, ((priceBottom > originY)?(priceBottom - labelSize.height - 4.0):originY), labelSize.width, labelSize.height);
        self.labelSeparator.frame = frame;
        labelOriginX = self.labelSeparator.frame.origin.x + self.labelSeparator.frame.size.width + intervalH;
    }
    if (self.labelPoint && [self.labelPoint isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelPoint.font, NSFontAttributeName, nil];
        CGSize textSize = [self.labelPoint.text sizeWithAttributes:attributes];
        CGSize labelSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
        CGRect frame = CGRectMake(labelOriginX, ((priceBottom > originY)?(priceBottom - labelSize.height - 4.0):originY), labelSize.width, labelSize.height);
        self.labelPoint.frame = frame;
        labelOriginX = self.labelPoint.frame.origin.x + self.labelPoint.frame.size.width + intervalH;
    }
    
    if (self.buttonAddToCart && [self.buttonAddToCart isHidden] == NO)
    {
        CGSize size = CGSizeMake(30.0, 30.0);
        UIImage *image = [self.buttonAddToCart imageForState:UIControlStateNormal];
        if (image)
        {
            size = image.size;
        }
        CGRect frame = CGRectMake((self.viewContainer.frame.size.width - marginH - size.width), originY, size.width, size.height);
        self.buttonAddToCart.frame = frame;
    }
    if (self.buttonFavorite && [self.buttonFavorite isHidden] == NO)
    {
        CGSize size = CGSizeMake(30.0, 30.0);
        UIImage *image = [self.buttonFavorite imageForState:UIControlStateNormal];
        if (image)
        {
            size = image.size;
        }
        CGRect frame = CGRectMake((CGRectGetMinX(self.buttonAddToCart.frame) - intervalH - size.width), originY, size.width, size.height);
        self.buttonFavorite.frame = frame;
    }
}

- (UIView *)viewContainer
{
    if (_viewContainer == nil)
    {
        _viewContainer = [[UIView alloc] initWithFrame:CGRectZero];
        _viewContainer.backgroundColor = [UIColor whiteColor];
        [_viewContainer.layer setShadowColor:[UIColor colorWithWhite:0.2 alpha:0.5].CGColor];
        [_viewContainer.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
        [_viewContainer.layer setShadowRadius:2.0];
        [_viewContainer.layer setShadowOpacity:1.0];
        [_viewContainer.layer setMasksToBounds:NO];
    }
    return _viewContainer;
}

- (UIImageView *)imageViewProduct
{
    if (_imageViewProduct == nil)
    {
        _imageViewProduct = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageViewProduct setContentMode:UIViewContentModeScaleAspectFill];
        [_imageViewProduct.layer setMasksToBounds:YES];
    }
    return _imageViewProduct;
}

- (UIImageView *)imageViewTag
{
    if (_imageViewTag == nil)
    {
        _imageViewTag = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_ico_tri_r"];
        if (image)
        {
            [_imageViewTag setImage:image];
        }
    }
    return _imageViewTag;
}

- (UILabel *)labelTag
{
    if (_labelTag == nil)
    {
        _labelTag = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTag setBackgroundColor:[UIColor clearColor]];
        [_labelTag setTextColor:[UIColor whiteColor]];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        [_labelTag setFont:font];
    }
    return _labelTag;
}
- (UILabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor blackColor]];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelTitle setFont:font];
        [_labelTitle setNumberOfLines:0];
        [_labelTitle setLineBreakMode:NSLineBreakByWordWrapping];
    }
    return _labelTitle;
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

- (UILabel *)labelPrice
{
    if (_labelPrice == nil)
    {
        _labelPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPrice setBackgroundColor:[UIColor clearColor]];
        [_labelPrice setTextColor:[UIColor redColor]];
        UIFont *font = [UIFont systemFontOfSize:22.0];
        [_labelPrice setFont:font];
    }
    return _labelPrice;
}

- (UILabel *)labelSeparator
{
    if (_labelSeparator == nil)
    {
        _labelSeparator = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelSeparator setFont:font];
        [_labelSeparator setTextColor:[UIColor lightGrayColor]];
        [_labelSeparator setBackgroundColor:[UIColor clearColor]];
        [_labelSeparator setText:@"/"];
    }
    return _labelSeparator;
}

- (UILabel *)labelPoint
{
    if (_labelPoint == nil)
    {
        _labelPoint = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelPoint setFont:font];
        [_labelPoint setTextColor:[UIColor redColor]];
        [_labelPoint setBackgroundColor:[UIColor clearColor]];
    }
    return _labelPoint;
}

- (UIButton *)buttonAddToCart
{
    if (_buttonAddToCart == nil)
    {
        _buttonAddToCart = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_ico_car"];
        if (image)
        {
            [_buttonAddToCart setImage:image forState:UIControlStateNormal];
        }
        [_buttonAddToCart addTarget:self action:@selector(buttonAddToCartPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonAddToCart;
}

- (UIButton *)buttonFavorite
{
    if (_buttonFavorite == nil)
    {
        _buttonFavorite = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"btn_heart_off"];
        if (image)
        {
            [_buttonFavorite setImage:image forState:UIControlStateNormal];
        }
        UIImage *selectedImage = [UIImage imageNamed:@"btn_heart_on"];
        if (selectedImage)
        {
            [_buttonFavorite setImage:selectedImage forState:UIControlStateSelected];
        }
        [_buttonFavorite addTarget:self action:@selector(buttonFavoritePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonFavorite;
}

- (void)setImageUrl:(NSURL *)imageUrl
{
    _imageUrl = imageUrl;
    if (_imageUrl == nil)
    {
        self.imageViewProduct.image = nil;
        return;
    }
    __weak HotSaleTableViewCell *weakSelf = self;
    UIImage *image = [UIImage imageNamed:@"transparent"];
    [self.imageViewProduct sd_setImageWithURL:_imageUrl placeholderImage:image options:SDWebImageAvoidAutoSetImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
        if ([[imageURL absoluteString] isEqualToString:[_imageUrl absoluteString]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageViewProduct.image = image;
            });
        }
    }];
}

- (void)setPrice:(NSNumber *)price
{
    if ([price isEqual:[NSNull null]])
    {
        price = nil;
    }
    if (price == nil || [price doubleValue] == 0)
    {
        [self.labelPrice setHidden:YES];
    }
    else
    {
        [self.labelPrice setHidden:NO];
        if (_price == nil || ([price integerValue] != [_price integerValue]))
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *formattedString = [formatter stringFromNumber:price];
            NSString *priceString = [NSString stringWithFormat:@"$%@", formattedString];
            [self.labelPrice setText:priceString];
        }
    }
    _price = price;
    [self checkPriceAndPointSeparatorState];
    [self setNeedsLayout];
}

- (void)setPoint:(NSNumber *)point
{
    if ([point isEqual:[NSNull null]])
    {
        point = nil;
    }
    if (point == nil || [point doubleValue] == 0)
    {
        [self.labelPoint setHidden:YES];
    }
    else
    {
        [self.labelPoint setHidden:NO];
        if (_point == nil || ([point integerValue] != [_point integerValue]))
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *formattedString = [formatter stringFromNumber:point];
            NSString *pointString = [[NSString stringWithFormat:@"%@", formattedString] stringByAppendingString:[LocalizedString Point]];
            [self.labelPoint setText:pointString];
        }
    }
    _point = point;
    [self checkPriceAndPointSeparatorState];
    [self setNeedsLayout];
}

- (void)setFavorite:(BOOL)favorite
{
    _favorite = favorite;
    
    __weak HotSaleTableViewCell *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.buttonFavorite setSelected:_favorite];
    });
}

#pragma mark - Private Methods

- (void)checkPriceAndPointSeparatorState
{
    if ([self.labelPrice isHidden] == NO && [self.labelPoint isHidden] == NO)
    {
        [self.labelSeparator setHidden:NO];
        return;
    }
    [self.labelSeparator setHidden:YES];
}

#pragma mark - Actions

- (void)buttonAddToCartPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(hotSaleTableViewCell:didPressAddToCartBySender:)])
    {
        [_delegate hotSaleTableViewCell:self didPressAddToCartBySender:sender];
    }
}

- (void)buttonFavoritePressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(hotSaleTableViewCell:didPressFavoriteBySender:)])
    {
        [_delegate hotSaleTableViewCell:self didPressFavoriteBySender:sender];
    }
}

@end
