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

static NSInteger MaxTagsNumber = 5;

@interface HotSaleTableViewCell ()

@property (nonatomic, strong) NSMutableArray *arrayViewTags;
@property (nonatomic, strong) NSDictionary *attributesRedLarge;
@property (nonatomic, strong) NSDictionary *attributesRedSmall;
@property (nonatomic, strong) NSDictionary *attributesGrayLarge;
@property (nonatomic, strong) NSDictionary *attributesGraySmall;
@property (nonatomic, strong) NSNumberFormatter *formatter;

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
        _arrayTagsData = nil;
        [self.contentView setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1.0]];
        [self.contentView addSubview:self.viewContainer];
        [self.viewContainer addSubview:self.imageViewProduct];
        [self.viewContainer addSubview:self.imageViewTag];
        [self.imageViewTag addSubview:self.labelTag];
//        [self.viewContainer addSubview:self.labelTitle];
        [self.viewContainer addSubview:self.labelMarketing];
        [self.viewContainer addSubview:self.labelProductName];
        [self.viewContainer addSubview:self.separator];
        [self.viewContainer addSubview:self.labelPrice];
        [self.viewContainer addSubview:self.buttonAddToCart];
        [self.viewContainer addSubview:self.buttonFavorite];
        for (UILabel *label in self.arrayViewTags)
        {
            [self.viewContainer addSubview:label];
        }
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
        self.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
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
    
    CGFloat marginH = 8.0;
    CGFloat marginV = 8.0;
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
//        originY = self.imageViewProduct.frame.origin.y + self.imageViewProduct.frame.size.height + intervalV;
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
    
    CGFloat tagOriginX = originX;
    CGFloat tagOriginY = marginV;
    CGFloat tagIntervalH = 2.0;
    CGFloat tagIntervalV = 2.0;
    NSDictionary *tagAttributes = nil;
    for (NSInteger index = 0; index < self.arrayViewTags.count; index++)
    {
        UILabel *label = [self.arrayViewTags objectAtIndex:index];
        if ([label isHidden])
        {
            break;
        }
        if (tagAttributes == nil)
        {
            tagAttributes = [NSDictionary dictionaryWithObjectsAndKeys:label.font, NSFontAttributeName, nil];
        }
        CGSize textSize = [label.text sizeWithAttributes:tagAttributes];
        CGSize labelSize = CGSizeMake(ceil(textSize.width) + 4, ceil(textSize.height) + 4);
        if ((tagOriginX + labelSize.width + marginH) > self.viewContainer.frame.size.width)
        {
            // Should go to next line
            tagOriginX = originX;
            tagOriginY = tagOriginY + labelSize.height + tagIntervalV;
        }
        CGRect labelFrame = CGRectMake(tagOriginX, tagOriginY, labelSize.width, labelSize.height);
        label.frame = labelFrame;
        tagOriginX = label.frame.origin.x + label.frame.size.width + tagIntervalH;
        originY = label.frame.origin.y + label.frame.size.height + intervalV;
    }
    
    CGFloat labelMaxWidth = self.viewContainer.frame.size.width - originX - marginH;
    NSString *defaultString = @"XXXX\nXXXX";
    
    if (self.labelMarketing && [self.labelMarketing isHidden] == NO)
    {
        CGRect defaultTextRect = [defaultString boundingRectWithSize:CGSizeMake(labelMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributesMarketing context:nil];
        CGRect boundRect = [self.labelMarketing.text boundingRectWithSize:CGSizeMake(labelMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributesMarketing context:nil];
        CGSize size = CGSizeMake(ceil(boundRect.size.width), ceil((boundRect.size.height > defaultTextRect.size.height)?defaultTextRect.size.height:boundRect.size.height));
        CGRect frame = CGRectMake(originX, originY, size.width, size.height);
        self.labelMarketing.frame = frame;
        originY = self.labelMarketing.frame.origin.y + self.labelMarketing.frame.size.height + intervalV;
    }
    if (self.labelProductName && [self.labelProductName isHidden] == NO)
    {
        CGRect defaultTextRect = [defaultString boundingRectWithSize:CGSizeMake(labelMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributesProductName context:nil];
        CGRect boundRect = [self.labelProductName.text boundingRectWithSize:CGSizeMake(labelMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributesProductName context:nil];
        CGSize size = CGSizeMake(ceil(boundRect.size.width), ceil((boundRect.size.height > defaultTextRect.size.height)?defaultTextRect.size.height:boundRect.size.height));
        CGRect frame = CGRectMake(originX, originY, size.width, size.height);
        self.labelProductName.frame = frame;
        originY = self.labelProductName.frame.origin.y + self.labelProductName.frame.size.height + intervalV;
    }
    CGFloat imageBottom = self.imageViewProduct.frame.origin.y + self.imageViewProduct.frame.size.height + intervalV;
    CGFloat upperSectionBottom = MAX(imageBottom, originY);
    originY = upperSectionBottom;
    originX = marginH;
    if (self.separator)
    {
        CGRect frame = CGRectMake(0.0, originY, self.viewContainer.frame.size.width, 1.0);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    }
    
    CGFloat priceBottom = originY;
    CGFloat labelOriginX = marginH;
    
    
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
        CGRect frame = CGRectMake((CGRectGetMinX(self.buttonAddToCart.frame) - intervalH * 2 - size.width), originY, size.width, size.height);
        self.buttonFavorite.frame = frame;
    }
    if (self.labelPrice && [self.labelPrice isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelPrice.font, NSFontAttributeName, nil];
        CGSize textSize = [self.labelPrice.text sizeWithAttributes:attributes];
        CGSize labelSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
        CGRect frame = CGRectMake(labelOriginX, originY, CGRectGetMinX(self.buttonFavorite.frame) - intervalH - labelOriginX, labelSize.height);
        self.labelPrice.frame = frame;
        labelOriginX = self.labelPrice.frame.origin.x + self.labelPrice.frame.size.width + intervalH;
        priceBottom = self.labelPrice.frame.origin.y + self.labelPrice.frame.size.height;
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

- (TTTAttributedLabel *)labelMarketing
{
    if (_labelMarketing == nil)
    {
        _labelMarketing = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelMarketing.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        [_labelMarketing setBackgroundColor:[UIColor clearColor]];
        [_labelMarketing setNumberOfLines:0];
        NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:self.attributesMarketing];
        [_labelMarketing setAttributedTruncationToken:truncationToken];
    }
    return _labelMarketing;
}

- (TTTAttributedLabel *)labelProductName
{
    if (_labelProductName == nil)
    {
        _labelProductName = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelProductName.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        [_labelProductName setBackgroundColor:[UIColor clearColor]];
        [_labelProductName setNumberOfLines:0];
        NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:self.attributesProductName];
        [_labelMarketing setAttributedTruncationToken:truncationToken];
    }
    return _labelProductName;
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
//- (UILabel *)labelTitle
//{
//    if (_labelTitle == nil)
//    {
//        _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
//        [_labelTitle setBackgroundColor:[UIColor clearColor]];
//        [_labelTitle setTextColor:[UIColor blackColor]];
//        UIFont *font = [UIFont systemFontOfSize:16.0];
//        [_labelTitle setFont:font];
//        [_labelTitle setNumberOfLines:0];
//        [_labelTitle setLineBreakMode:NSLineBreakByWordWrapping];
//    }
//    return _labelTitle;
//}

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
    }
    return _labelPrice;
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
    UIImage *image = [UIImage imageNamed:@"ico_default"];
    [self.imageViewProduct sd_setImageWithURL:_imageUrl placeholderImage:image options:SDWebImageAvoidAutoSetImage|SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
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
    _price = price;
}

- (void)setPoint:(NSNumber *)point
{
    if ([point isEqual:[NSNull null]])
    {
        point = nil;
    }
    _point = point;
}

- (void)setMixPrice:(NSNumber *)mixPrice
{
    if ([mixPrice isEqual:[NSNull null]])
    {
        mixPrice = nil;
    }
    _mixPrice = mixPrice;
}

- (void)setMixPoint:(NSNumber *)mixPoint
{
    if ([mixPoint isEqual:[NSNull null]])
    {
        mixPoint = nil;
    }
    _mixPoint = mixPoint;
}

- (void)setFavorite:(BOOL)favorite
{
    _favorite = favorite;
    
    __weak HotSaleTableViewCell *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.buttonFavorite setSelected:_favorite];
    });
}

- (void)setPriceType:(PriceType)priceType
{
    _priceType = priceType;
    [self checkPriceAndPointSeparatorState];
}

- (void)setArrayTagsData:(NSArray *)arrayTagsData
{
    _arrayTagsData = arrayTagsData;
    [self refreshTagsFromArray:_arrayTagsData];
}

- (NSMutableArray *)arrayViewTags
{
    if (_arrayViewTags == nil)
    {
        _arrayViewTags = [[NSMutableArray alloc] initWithCapacity:0];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        for (NSInteger index = 0; index < MaxTagsNumber; index++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor lightTextColor]];
            [label setFont:font];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label.layer setBorderColor:label.textColor.CGColor];
            [label.layer setBorderWidth:1.0];
            [_arrayViewTags addObject:label];
        }
    }
    return _arrayViewTags;
}

- (void)setMarketingText:(NSString *)marketingText
{
    if ([marketingText isEqual:[NSNull null]])
    {
        marketingText = nil;
    }
    if (marketingText == nil || [marketingText length] == 0)
    {
        [self.labelMarketing setHidden:YES];
    }
    else
    {
        [self.labelMarketing setHidden:NO];
        if (_marketingText == nil || ([_marketingText isEqualToString:marketingText] == NO))
        {
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:marketingText attributes:self.attributesMarketing];
            [self.labelMarketing setAttributedText:attrString];
        }
    }
    _marketingText = marketingText;
    [self setNeedsLayout];
}

- (void)setProductName:(NSString *)productName
{
    if ([productName isEqual:[NSNull null]])
    {
        productName = nil;
    }
    if (productName == nil || [productName length] == 0)
    {
        [self.labelProductName setHidden:YES];
    }
    else
    {
        [self.labelProductName setHidden:NO];
        if (_productName == nil || ([_productName isEqualToString:productName] == NO))
        {
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:productName attributes:self.attributesProductName];
            [self.labelProductName setAttributedText:attrString];
        }
    }
    _productName = productName;
    [self setNeedsLayout];
}

- (NSDictionary *)attributesMarketing
{
    if (_attributesMarketing == nil)
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByCharWrapping;
        style.alignment = NSTextAlignmentLeft;
        UIFont *font = [UIFont systemFontOfSize:14.0];
        UIColor *textColor = [UIColor orangeColor];
        _attributesMarketing = [[NSDictionary alloc] initWithObjectsAndKeys:style, NSParagraphStyleAttributeName, font, NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];
    }
    return _attributesMarketing;
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

- (NSDictionary *)attributesRedLarge
{
    if (_attributesRedLarge == nil)
    {
        _attributesRedLarge = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:22.0], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
    }
    return _attributesRedLarge;
}

- (NSDictionary *)attributesRedSmall
{
    if (_attributesRedSmall == nil)
    {
        _attributesRedSmall = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:20.0], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
    }
    return _attributesRedSmall;
}

- (NSDictionary *)attributesGrayLarge
{
    if (_attributesGrayLarge == nil)
    {
        _attributesGrayLarge = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:16.0], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
    }
    return _attributesGrayLarge;
}

- (NSDictionary *)attributesGraySmall
{
    if (_attributesGraySmall == nil)
    {
        _attributesGraySmall = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14.0], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
    }
    return _attributesGraySmall;
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

- (void)checkPriceAndPointSeparatorState
{
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] init];
    switch (self.priceType) {
        case PriceTypePurePrice:
        {
            if (self.price)
            {
                NSString *formattedString = [self.formatter stringFromNumber:self.price];
                NSString *priceString = [NSString stringWithFormat:@"＄%@", formattedString];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:priceString attributes:self.attributesRedLarge];
                [totalString appendAttributedString:attrString];
            }
            if (self.point)
            {
                NSAttributedString *slashString = [[NSAttributedString alloc] initWithString:@"/" attributes:self.attributesGrayLarge];
                [totalString appendAttributedString:slashString];
                
                NSString *formattedString = [self.formatter stringFromNumber:self.point];
                NSAttributedString *pointString = [[NSAttributedString alloc] initWithString:formattedString attributes:self.attributesGrayLarge];
                [totalString appendAttributedString:pointString];
                
                NSAttributedString *unitString = [[NSAttributedString alloc] initWithString:[LocalizedString Point] attributes:self.attributesGraySmall];
                [totalString appendAttributedString:unitString];
            }
        }
            break;
        case PriceTypePurePoint:
        {
            if (self.point)
            {
                NSString *formattedString = [self.formatter stringFromNumber:self.point];
                NSAttributedString *pointString = [[NSAttributedString alloc] initWithString:formattedString attributes:self.attributesRedLarge];
                [totalString appendAttributedString:pointString];
                
                NSAttributedString *unitString = [[NSAttributedString alloc] initWithString:[LocalizedString Point] attributes:self.attributesRedSmall];
                [totalString appendAttributedString:unitString];
            }
        }
            break;
        case PriceTypeMixed:
        {
            if (self.mixPrice)
            {
                NSString *formattedString = [self.formatter stringFromNumber:self.mixPrice];
                NSString *priceString = [NSString stringWithFormat:@"＄%@", formattedString];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:priceString attributes:self.attributesRedLarge];
                [totalString appendAttributedString:attrString];
            }
            if (self.mixPoint)
            {
                NSAttributedString *plusString = [[NSAttributedString alloc] initWithString:@"+" attributes:self.attributesRedLarge];
                [totalString appendAttributedString:plusString];
                
                NSString *formattedString = [self.formatter stringFromNumber:self.mixPoint];
                NSAttributedString *pointString = [[NSMutableAttributedString alloc] initWithString:formattedString attributes:self.attributesRedLarge];
                [totalString appendAttributedString:pointString];
                
                NSAttributedString *unitString = [[NSAttributedString alloc] initWithString:[LocalizedString Point] attributes:self.attributesRedSmall];
                [totalString appendAttributedString:unitString];
            }
            if (self.point)
            {
                NSAttributedString *slashString = [[NSAttributedString alloc] initWithString:@"/" attributes:self.attributesGrayLarge];
                [totalString appendAttributedString:slashString];
                
                NSString *formattedString = [self.formatter stringFromNumber:self.point];
                NSAttributedString *pointString = [[NSAttributedString alloc] initWithString:formattedString attributes:self.attributesGrayLarge];
                [totalString appendAttributedString:pointString];
                
                NSAttributedString *unitString = [[NSAttributedString alloc] initWithString:[LocalizedString Point] attributes:self.attributesGraySmall];
                [totalString appendAttributedString:unitString];
            }
        }
            break;
        default:
            break;
    }
    if ([totalString length] == 0)
    {
        NSString *formattedString = [self.formatter stringFromNumber:[NSNumber numberWithInteger:0]];
        NSString *priceString = [NSString stringWithFormat:@"＄%@", formattedString];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:priceString attributes:self.attributesRedLarge];
        [totalString appendAttributedString:attrString];
    }
    [self.labelPrice setAttributedText:totalString];
    [self setNeedsLayout];
}

- (void)refreshTagsFromArray:(NSArray *)arrayTagsData
{
    for (NSInteger index = 0; index < [_arrayViewTags count]; index++)
    {
        UILabel *label = [_arrayViewTags objectAtIndex:index];
        if (index >= [arrayTagsData count])
        {
            [label setHidden:YES];
            continue;
        }
        [label setHidden:NO];
        NSDictionary *dictionary = [arrayTagsData objectAtIndex:index];
//        NSLog(@"refreshTagsFromArray:\n%@", [arrayTagsData description]);
        NSString *text = [dictionary objectForKey:ProductTableViewCellTagText];
        if (text == nil || [text length] == 0)
        {
            [label setHidden:YES];
            continue;
        }
        [label setText:text];
        UIColor *color = [dictionary objectForKey:NSForegroundColorAttributeName];
        if (color == nil)
        {
            [label setTextColor:[UIColor lightTextColor]];
            [label.layer setBorderColor:label.textColor.CGColor];
            continue;
        }
        [label setTextColor:color];
        [label.layer setBorderColor:color.CGColor];
    }
    [self setNeedsLayout];
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
