//
//  ProductTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "LocalizedString.h"

static NSInteger MaxTagsNumber = 5;

@interface ProductTableViewCell ()

@property (nonatomic, strong) NSDictionary *attributesRedLarge;
@property (nonatomic, strong) NSDictionary *attributesRedSmall;
@property (nonatomic, strong) NSDictionary *attributesGrayLarge;
@property (nonatomic, strong) NSDictionary *attributesGraySmall;
@property (nonatomic, strong) NSNumberFormatter *formatter;

- (void)refreshTagsFromArray:(NSArray *)arrayTagsData;
- (void)checkPriceAndPointSeparatorState;
- (void)buttonCartPressed:(id)sender;
- (void)buttonFavoritePressed:(id)sender;

@end

@implementation ProductTableViewCell

@synthesize viewContainer = _viewContainer;
@synthesize viewSeparator = _viewSeparator;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _arrayTagsData = nil;
        [self.contentView addSubview:self.viewContainer];
        [self.viewContainer addSubview:self.imageViewProduct];
        [self.viewContainer addSubview:self.labelMarketing];
        [self.viewContainer addSubview:self.labelProductName];
        [self.viewContainer addSubview:self.viewSeparator];
        [self.viewContainer addSubview:self.labelPrice];
//        [self.viewContainer addSubview:self.labelSeparator];
//        [self.viewContainer addSubview:self.labelPoint];
        [self.viewContainer addSubview:self.buttonCart];
        [self.viewContainer addSubview:self.buttonFavorite];
        [self.viewContainer addSubview:self.viewDiscount];
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

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginL = 12.0;
    CGFloat marginR = 12.0;
    CGFloat marginT = 10.0;
    CGFloat marginB = 6.0;
    
    CGFloat containMarginH = 8.0;
    CGFloat containMarginV = 8.0;
    CGFloat intervalH = 5.0;
    CGFloat intervalV = 5.0;
    
    CGRect containerFrame = CGRectMake(marginL, marginT, self.contentView.frame.size.width - (marginL + marginR), self.contentView.frame.size.height - (marginT + marginB));
    self.viewContainer.frame = containerFrame;
    [self.contentView bringSubviewToFront:self.viewContainer];
    
//    NSLog(@"self.viewContainer.frame[%4.2f,%4.2f,%4.2f,%4.2f]", self.viewContainer.frame.origin.x, self.viewContainer.frame.origin.y, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height);
    
    CGFloat originX = containMarginH;
    CGFloat originY = containMarginV;
    if (self.imageViewProduct)
    {
        CGSize imageSize = CGSizeMake(100.0, 100.0);
        CGRect frame = CGRectMake(originX, originY, imageSize.width, imageSize.height);
        self.imageViewProduct.frame = frame;
        originX = self.imageViewProduct.frame.origin.x + self.imageViewProduct.frame.size.width + intervalH;
    }
    
    CGFloat tagOriginX = originX;
    CGFloat tagOriginY = containMarginV;
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
        if ((tagOriginX + labelSize.width + containMarginH) > self.viewContainer.frame.size.width)
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
    
    
    CGFloat labelMaxWidth = self.viewContainer.frame.size.width - originX - containMarginH;
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
    originX = containMarginH;
    if (self.viewSeparator)
    {
        CGRect frame = CGRectMake(containMarginH, originY, self.viewContainer.frame.size.width - containMarginH * 2, 1.0);
        self.viewSeparator.frame = frame;
        originY = self.viewSeparator.frame.origin.y + self.viewSeparator.frame.size.height + intervalV;
    }
    CGFloat priceBottom = originY;
    
//    if (self.labelSeparator && [self.labelSeparator isHidden] == NO)
//    {
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelSeparator.font, NSFontAttributeName, nil];
//        CGSize textSize = [self.labelSeparator.text sizeWithAttributes:attributes];
//        CGSize labelSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
//        CGRect frame = CGRectMake(originX, ((priceBottom > originY)?(priceBottom - labelSize.height):originY), labelSize.width, labelSize.height);
//        self.labelSeparator.frame = frame;
//        originX = self.labelSeparator.frame.origin.x + self.labelSeparator.frame.size.width;
//    }
//    if (self.labelPoint && [self.labelPoint isHidden] == NO)
//    {
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelPoint.font, NSFontAttributeName, nil];
//        CGSize textSize = [self.labelPoint.text sizeWithAttributes:attributes];
//        CGSize labelSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
//        CGRect frame = CGRectMake(originX, ((priceBottom > originY)?(priceBottom - labelSize.height):originY), labelSize.width, labelSize.height);
//        self.labelPoint.frame = frame;
//        originX = self.labelPoint.frame.origin.x + self.labelPoint.frame.size.width + intervalH;
//    }
    CGFloat buttonOriginX = containerFrame.size.width - containMarginH;
    if (self.buttonCart && [self.buttonCart isHidden] == NO)
    {
        CGSize size = CGSizeMake(30.0, 30.0);
        UIImage *image = [self.buttonCart imageForState:UIControlStateNormal];
        if (image)
        {
            size = image.size;
        }
        buttonOriginX = buttonOriginX - size.width;
        CGRect frame = CGRectMake(buttonOriginX, originY, size.width, size.height);
        self.buttonCart.frame = frame;
        buttonOriginX = buttonOriginX - intervalH * 2;
    }
    if (self.buttonFavorite && [self.buttonFavorite isHidden] == NO)
    {
        CGSize size = CGSizeMake(30.0, 30.0);
        UIImage *image = [self.buttonFavorite imageForState:UIControlStateNormal];
        if (image)
        {
            size = image.size;
        }
        buttonOriginX = buttonOriginX - size.width;
        CGRect frame = CGRectMake(buttonOriginX, originY, size.width, size.height);
        self.buttonFavorite.frame = frame;
        buttonOriginX = buttonOriginX - intervalH;
    }
    if (self.labelPrice && [self.labelPrice isHidden] == NO)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelPrice.font, NSFontAttributeName, nil];
        CGSize textSize = [self.labelPrice.text sizeWithAttributes:attributes];
        CGSize labelSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
        CGRect frame = CGRectMake(originX, originY, buttonOriginX - originX, labelSize.height);
        self.labelPrice.frame = frame;
        originX = self.labelPrice.frame.origin.x + self.labelPrice.frame.size.width;
        priceBottom = self.labelPrice.frame.origin.y + self.labelPrice.frame.size.height;
    }
    
    if (self.viewDiscount && [self.viewDiscount isHidden] == NO)
    {
        CGSize viewSize = CGSizeMake(60.0, 30.0);
        if (self.viewDiscount.imageViewTag.image)
        {
            viewSize = self.viewDiscount.imageViewTag.image.size;
        }
        CGRect frame = CGRectMake(self.imageViewProduct.frame.origin.x - self.viewDiscount.edgeInsets.left - 7.0, self.imageViewProduct.frame.origin.y, viewSize.width, viewSize.height);
        self.viewDiscount.frame = frame;
    }
//    NSLog(@"originY = %4.2f", originY);
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

- (void)setArrayTagsData:(NSArray *)arrayTagsData
{
    _arrayTagsData = arrayTagsData;
    [self refreshTagsFromArray:_arrayTagsData];
}

- (UIView *)viewContainer
{
    if (_viewContainer == nil)
    {
        _viewContainer = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewContainer setBackgroundColor:[UIColor whiteColor]];
        [_viewContainer.layer setShadowColor:[UIColor colorWithWhite:0.2 alpha:0.5].CGColor];
        [_viewContainer.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
        [_viewContainer.layer setShadowRadius:2.0];
        [_viewContainer.layer setShadowOpacity:1.0];
        [_viewContainer.layer setMasksToBounds:NO];
    }
    return _viewContainer;
}

- (DiscountLabelView *)viewDiscount
{
    if (_viewDiscount == nil)
    {
        _viewDiscount = [[DiscountLabelView alloc] initWithFrame:CGRectZero];
    }
    return _viewDiscount;
}

- (UIImageView *)imageViewProduct
{
    if (_imageViewProduct == nil)
    {
        _imageViewProduct = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageViewProduct;
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

- (UIView *)viewSeparator
{
    if (_viewSeparator == nil)
    {
        _viewSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewSeparator setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _viewSeparator;
}

- (UILabel *)labelPrice
{
    if (_labelPrice == nil)
    {
        _labelPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelPrice setTextColor:[UIColor redColor]];
        [_labelPrice setBackgroundColor:[UIColor clearColor]];
    }
    return _labelPrice;
}

- (UIButton *)buttonCart
{
    if (_buttonCart == nil)
    {
        _buttonCart = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sho_ico_car"];
        if (image)
        {
            [_buttonCart setImage:image forState:UIControlStateNormal];
        }
        [_buttonCart addTarget:self action:@selector(buttonCartPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonCart;
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

- (void)setImagePath:(NSString *)imagePath
{
    if ([_imagePath isEqualToString:imagePath])
        return;
    _imagePath = imagePath;
    UIImage *placeholderImage = [UIImage imageNamed:@"ico_default"];
    if (_imagePath == nil)
    {
        [self.imageViewProduct setImage:placeholderImage];
        return;
    }
    NSURL *url = [NSURL URLWithString:imagePath];
    
    __weak ProductTableViewCell *weakSelf = self;
    [self.imageViewProduct sd_setImageWithURL:url placeholderImage:placeholderImage options:(SDWebImageAvoidAutoSetImage|SDWebImageAllowInvalidSSLCertificates) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
        if ([[imageURL absoluteString] isEqualToString:_imagePath] == NO)
        {
            return;
        }
        [weakSelf.imageViewProduct setImage:image];
    }];
}

- (void)setDiscount:(NSNumber *)discount
{
    if ([discount isEqual:[NSNull null]])
    {
        discount = nil;
    }
    if (discount == nil || [discount doubleValue] == 0)
    {
        [self.viewDiscount setHidden:YES];
    }
    else
    {
        [self.viewDiscount setHidden:NO];
        if ([discount isKindOfClass:[NSNumber class]])
        {
            NSString *discountString = [NSString stringWithFormat:[LocalizedString F_PercentOff], [discount doubleValue] * 100];
            self.viewDiscount.text = discountString;
        }
    }
    _discount = discount;
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

- (void)setFavorite:(BOOL)favorite
{
    _favorite = favorite;
    
    __weak ProductTableViewCell *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.buttonFavorite setSelected:_favorite];
    });
}

- (void)setPriceType:(PriceType)priceType
{
    _priceType = priceType;
    [self checkPriceAndPointSeparatorState];
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

#pragma mark - Actions

- (void)buttonCartPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productTableViewCell:didSelectToAddToCartBySender:)])
    {
        [_delegate productTableViewCell:self didSelectToAddToCartBySender:sender];
    }
}

- (void)buttonFavoritePressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(productTableViewCell:didSelectToAddToCartBySender:)])
    {
        [_delegate productTableViewCell:self didSelectToAddToFavoriteBySender:sender];
    }
}

@end
