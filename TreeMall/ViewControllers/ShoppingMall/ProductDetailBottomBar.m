//
//  ProductDetailBottomBar.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/20.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductDetailBottomBar.h"
#import "LocalizedString.h"

@interface ProductDetailBottomBar ()

- (void)buttonFavoritePressed:(id)sender;
- (void)buttonAddToCartPressed:(id)sender;
- (void)buttonPurchasePressed:(id)sender;

@end

@implementation ProductDetailBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgorundColorValid = [UIColor colorWithRed:(242.0/255.0) green:(157.0/255.0) blue:(56.0/255.0) alpha:1.0];
        self.backgroundColorInvalid = [UIColor lightGrayColor];
        [self setBackgroundColor:self.backgorundColorValid];
        [self addSubview:self.buttonFavorite];
        [self addSubview:self.buttonAddToCart];
        [self addSubview:self.buttonPurchase];
        [self addSubview:self.separator];
        [self addSubview:self.labelInvalid];
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
    
    
    CGFloat originX = 0.0;
    CGFloat originY = 0.0;
    CGFloat separatorWidth = 1.0;
    if (self.buttonFavorite)
    {
        CGSize size = CGSizeMake(self.frame.size.height, self.frame.size.height);
        CGRect frame = CGRectMake(originX, originY, size.width, size.height);
        self.buttonFavorite.frame = frame;
        originX = self.buttonFavorite.frame.origin.x + self.buttonFavorite.frame.size.width;
    }
    CGFloat maxButtonWidth = ceil((self.frame.size.width - originX)/2);
    if (self.buttonAddToCart)
    {
        CGRect frame = CGRectMake(originX, originY, maxButtonWidth, self.frame.size.height);
        self.buttonAddToCart.frame = frame;
        originX = self.buttonAddToCart.frame.origin.x + self.buttonAddToCart.frame.size.width;
    }
    if (self.separator && [self.separator isHidden] == NO)
    {
        CGSize size = CGSizeMake(separatorWidth, ceil(self.frame.size.height * 3 / 5));
        CGRect frame = CGRectMake(originX, (self.frame.size.height - size.height)/2, size.width, size.height);
        self.separator.frame = frame;
        originX = self.separator.frame.origin.x + self.separator.frame.size.width;
    }
    if (self.buttonPurchase)
    {
        CGRect frame = CGRectMake(originX, originY, maxButtonWidth, self.frame.size.height);
        self.buttonPurchase.frame = frame;
        originX = self.buttonPurchase.frame.origin.x + self.buttonPurchase.frame.size.width;
    }
    if (self.separator && [self.separator isHidden] == NO)
    {
        
    }
    if (self.labelInvalid && [self.labelInvalid isHidden] == NO)
    {
        CGFloat labelOriginX = CGRectGetMaxX(self.buttonFavorite.frame);
        CGRect frame = CGRectMake(labelOriginX, 0.0, self.frame.size.width - labelOriginX, self.frame.size.height);
        self.labelInvalid.frame = frame;
    }
}

- (UIButton *)buttonFavorite
{
    if (_buttonFavorite == nil)
    {
        _buttonFavorite = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonFavorite setBackgroundColor:[UIColor colorWithRed:(230.0/255.0) green:(114.0/255.0) blue:(46.0/255.0) alpha:1.0]];
        UIImage *image = [UIImage imageNamed:@"sho_h_btn_fa"];
        if (image)
        {
            [_buttonFavorite setImage:image forState:UIControlStateNormal];
        }
        [_buttonFavorite addTarget:self action:@selector(buttonFavoritePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonFavorite;
}

- (UIButton *)buttonAddToCart
{
    if (_buttonAddToCart == nil)
    {
        _buttonAddToCart = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonAddToCart setBackgroundColor:[UIColor clearColor]];
        UIImage *image = [UIImage imageNamed:@"sho_info_bnt_cat"];
        if (image)
        {
            [_buttonAddToCart setImage:image forState:UIControlStateNormal];
        }
        [_buttonAddToCart setTitle:[LocalizedString AddToCart] forState:UIControlStateNormal];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_buttonAddToCart.titleLabel setFont:font];
        [_buttonAddToCart addTarget:self action:@selector(buttonAddToCartPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonAddToCart;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor whiteColor]];
    }
    return _separator;
}

- (UIButton *)buttonPurchase
{
    if (_buttonPurchase == nil)
    {
        _buttonPurchase = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonPurchase setBackgroundColor:[UIColor clearColor]];
        UIImage *image = [UIImage imageNamed:@"sho_info_bnt_pay"];
        if (image)
        {
            [_buttonPurchase setImage:image forState:UIControlStateNormal];
        }
        [_buttonPurchase setTitle:[LocalizedString Purchase] forState:UIControlStateNormal];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_buttonPurchase.titleLabel setFont:font];
        [_buttonPurchase addTarget:self action:@selector(buttonPurchasePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonPurchase;
}

- (UILabel *)labelInvalid
{
    if (_labelInvalid == nil)
    {
        _labelInvalid = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelInvalid setTextColor:[UIColor whiteColor]];
        [_labelInvalid setBackgroundColor:[UIColor grayColor]];
        [_labelInvalid setAdjustsFontSizeToFitWidth:YES];
        [_labelInvalid setText:[LocalizedString SoldOut]];
        [_labelInvalid setHidden:YES];
    }
    return _labelInvalid;
}

#pragma mark - Actions

- (void)buttonFavoritePressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productDetailBottomBar:didSelectFavoriteBySender:)])
    {
        [_delegate productDetailBottomBar:self didSelectFavoriteBySender:sender];
    }
}

- (void)buttonAddToCartPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productDetailBottomBar:didSelectAddToCartBySender:)])
    {
        [_delegate productDetailBottomBar:self didSelectAddToCartBySender:sender];
    }
}

- (void)buttonPurchasePressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productDetailBottomBar:didSelectPurchaseBySender:)])
    {
        [_delegate productDetailBottomBar:self didSelectPurchaseBySender:sender];
    }
}

@end
