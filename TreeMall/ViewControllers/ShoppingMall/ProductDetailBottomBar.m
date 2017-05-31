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
        NSLog(@"self.labelInvalid.frame[%4.2f,%4.2f,%4.2f,%4.2f]", self.labelInvalid.frame.origin.x, self.labelInvalid.frame.origin.y, self.labelInvalid.frame.size.width, self.labelInvalid.frame.size.height);
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
        [_buttonAddToCart setTintColor:[UIColor whiteColor]];
        UIImage *image = [[UIImage imageNamed:@"sho_info_bnt_cat"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (image)
        {
            [_buttonAddToCart setImage:image forState:UIControlStateNormal];
        }
        UIImage *disabledImage = [UIImage imageNamed:@"ico_foot_money"];
        if (disabledImage)
        {
            [_buttonAddToCart setImage:disabledImage forState:UIControlStateDisabled];
        }
        [_buttonAddToCart setAdjustsImageWhenDisabled:YES];
        [_buttonAddToCart setTitleColor:[UIColor colorWithWhite:0.9 alpha:1.0] forState:UIControlStateDisabled];
        [_buttonAddToCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        [_labelInvalid setBackgroundColor:[UIColor lightGrayColor]];
        [_labelInvalid setAdjustsFontSizeToFitWidth:YES];
        [_labelInvalid setText:[LocalizedString SoldOut]];
        [_labelInvalid setTextAlignment:NSTextAlignmentCenter];
        [_labelInvalid setHidden:YES];
    }
    return _labelInvalid;
}

- (void)setIsProductInvalid:(BOOL)isProductInvalid
{
    _isProductInvalid = isProductInvalid;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isProductInvalid)
        {
            [self bringSubviewToFront:self.labelInvalid];
            [self.labelInvalid setHidden:NO];
        }
        else
        {
            [self.labelInvalid setHidden:YES];
        }
        [self setNeedsLayout];
    });
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
