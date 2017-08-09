//
//  AdditionalProductCollectionViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "AdditionalProductCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "LocalizedString.h"

#define kMarginV 10.0f
#define kMarginH 10.0f
#define kIntervalV 5.0f
#define kImageSideLength 130.0f
#define kSeparatorHeight 1.0f
#define kMarketNameFont [UIFont boldSystemFontOfSize:12.0]
#define kNameFont [UIFont boldSystemFontOfSize:12.0]
#define kPriceFont [UIFont systemFontOfSize:18.0]
#define kPurchaseButtonHeight 40.0f

@interface AdditionalProductCollectionViewCell ()

- (void)buttonPurchasePressed:(id)sender;

@end

@implementation AdditionalProductCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView.layer setShadowColor:[UIColor colorWithWhite:0.2 alpha:0.5].CGColor];
        [self.contentView.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
        [self.contentView.layer setShadowRadius:2.0];
        [self.contentView.layer setShadowOpacity:1.0];
        [self.contentView.layer setMasksToBounds:NO];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.labelMarketing];
        [self.contentView addSubview:self.labelName];
        [self.contentView addSubview:self.separator];
        [self.contentView addSubview:self.labelPrice];
        [self.contentView addSubview:self.buttonPurchase];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginH = kMarginH;
    CGFloat marginV = kMarginV;
    
    CGFloat intervalV = kIntervalV;
    
    CGFloat originY = marginV;
    
    if (self.imageView)
    {
        CGFloat imageSideLength = kImageSideLength;
        CGRect frame = CGRectMake(marginH, originY, imageSideLength, imageSideLength);
        self.imageView.frame = frame;
        originY = self.imageView.frame.origin.y + self.imageView.frame.size.height + intervalV;
    }
    if (self.labelMarketing)
    {
        NSString *defaultString = @"ＸＸＸＸ\nＸＸＸＸ";
        CGSize sizeText = [defaultString boundingRectWithSize:CGSizeMake(self.imageView.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributesText context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(self.imageView.frame.size.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, sizeLabel.width, sizeLabel.height);
        self.labelMarketing.frame = frame;
        originY = self.labelMarketing.frame.origin.y + self.labelMarketing.frame.size.height + intervalV;
    }
    if (self.labelName)
    {
        NSString *defaultString = @"ＸＸＸＸ\nＸＸＸＸ\nＸＸＸＸ";
        CGSize sizeText = [defaultString boundingRectWithSize:CGSizeMake(self.imageView.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributesText context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(self.imageView.frame.size.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, sizeLabel.width, sizeLabel.height);
        self.labelName.frame = frame;
        originY = self.labelName.frame.origin.y + self.labelName.frame.size.height + intervalV;
    }
    if (self.separator)
    {
        CGRect frame = CGRectMake(0.0, originY, self.contentView.frame.size.width, kSeparatorHeight);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    }
    if (self.labelPrice)
    {
        CGSize sizeText = [self.labelPrice.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelPrice.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, (self.imageView.frame.size.width), sizeLabel.height);
        self.labelPrice.frame = frame;
        originY = self.labelPrice.frame.origin.y + self.labelPrice.frame.size.height + intervalV;
    }
    if (self.buttonPurchase)
    {
        CGRect frame = CGRectMake(marginH, originY, self.imageView.frame.size.width, kPurchaseButtonHeight);
        self.buttonPurchase.frame = frame;
    }
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView.layer setMasksToBounds:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _imageView;
}

- (TTTAttributedLabel *)labelMarketing
{
    if (_labelMarketing == nil)
    {
        _labelMarketing = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelMarketing.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        [_labelMarketing setBackgroundColor:[UIColor clearColor]];
        [_labelMarketing setTextColor:[UIColor darkGrayColor]];
        [_labelMarketing setNumberOfLines:0];
        NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:self.attributesMarketName];
        [_labelMarketing setAttributedTruncationToken:truncationToken];
    }
    return _labelMarketing;
}

- (TTTAttributedLabel *)labelName
{
    if (_labelName == nil)
    {
        _labelName = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelName.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        [_labelName setBackgroundColor:[UIColor clearColor]];
        [_labelName setTextColor:[UIColor darkGrayColor]];
        [_labelName setNumberOfLines:0];
        NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:self.attributesText];
        [_labelName setAttributedTruncationToken:truncationToken];
    }
    return _labelName;
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
        UIFont *font = kPriceFont;
        [_labelPrice setFont:font];
        [_labelPrice setTextColor:[UIColor redColor]];
        [_labelPrice setBackgroundColor:[UIColor clearColor]];
    }
    return _labelPrice;
}

- (UIButton *)buttonPurchase
{
    if (_buttonPurchase == nil)
    {
        _buttonPurchase = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonPurchase setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_buttonPurchase.layer setBorderColor:[_buttonPurchase titleColorForState:UIControlStateNormal].CGColor];
        [_buttonPurchase.layer setBorderWidth:1.0];
        [_buttonPurchase.layer setCornerRadius:5.0];
        [_buttonPurchase setTitle:[LocalizedString Purchase] forState:UIControlStateNormal];
        [_buttonPurchase addTarget:self action:@selector(buttonPurchasePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonPurchase;
}

- (void)setImageUrl:(NSURL *)imageUrl
{
    _imageUrl = imageUrl;
    if (_imageUrl == nil)
    {
        self.imageView.image = nil;
        return;
    }
    __weak AdditionalProductCollectionViewCell *weakSelf = self;
    UIImage *image = [UIImage imageNamed:@"ico_default"];
    [self.imageView sd_setImageWithURL:_imageUrl placeholderImage:image options:SDWebImageAvoidAutoSetImage|SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
        if (error || image == nil)
            return;
        if ([[imageURL absoluteString] isEqualToString:[_imageUrl absoluteString]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.imageView setImage:image];
            });
        }
    }];
}

- (NSDictionary *)attributesMarketName
{
    if (_attributesMarketName == nil)
    {
        UIFont *font = kMarketNameFont;
        _attributesMarketName = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, [UIColor orangeColor], NSForegroundColorAttributeName, nil];
    }
    return _attributesMarketName;
}

- (NSDictionary *)attributesText
{
    if (_attributesText == nil)
    {
        UIFont *font = kNameFont;
        _attributesText = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
    }
    return _attributesText;
}

#pragma mark - Private Methods

- (void)buttonPurchasePressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(additionalProductCollectionViewCell:didSelectPurchaseBySender:)])
    {
        [_delegate additionalProductCollectionViewCell:self didSelectPurchaseBySender:sender];
    }
}

#pragma mark - Class Methods

+ (CGFloat)cellHeightForWidth:(CGFloat)cellWidth containsMarketName:(NSString *)marketName productName:(NSString *)productName andPrice:(NSString *)price
{
    CGFloat totalHeight = kMarginV + kImageSideLength + kIntervalV;
    if (marketName)
    {
        UIFont *font = kMarketNameFont;
        NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, [UIColor orangeColor], NSForegroundColorAttributeName, nil];
        CGSize sizeText = [marketName boundingRectWithSize:CGSizeMake(kImageSideLength, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(kImageSideLength), ceil(sizeText.height));
        totalHeight += sizeLabel.height + kIntervalV;
    }
    if (productName)
    {
        UIFont *font = kNameFont;
        NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, [UIColor orangeColor], NSForegroundColorAttributeName, nil];
        CGSize sizeText = [productName boundingRectWithSize:CGSizeMake(kImageSideLength, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGSize sizeLabel = CGSizeMake(ceil(kImageSideLength), ceil(sizeText.height));
        totalHeight += sizeLabel.height + kIntervalV;
    }
    totalHeight += kSeparatorHeight + kIntervalV;
    if (price)
    {
        CGSize sizeText = [price sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kPriceFont, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        totalHeight += sizeLabel.height + kIntervalV;
    }
    totalHeight += kPurchaseButtonHeight + kMarginV;
    return totalHeight;
}

@end
