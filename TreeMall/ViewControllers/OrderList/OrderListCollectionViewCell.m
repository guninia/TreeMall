//
//  OrderListCollectionViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "OrderListCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "APIDefinition.h"

#define kImageSize CGSizeMake(80.0, 80.0)

static CGFloat marginL = 10.0;
static CGFloat marginR = 10.0;
static CGFloat marginT = 10.0;
static CGFloat marginB = 10.0;
static CGFloat intervalV = 5.0;
static CGFloat intervalH = 5.0;
static CGFloat separatorHeight = 1.0;
static CGFloat progressViewHeight = 70.0;
static CGFloat buttonDeliverIdHeight = 40.0;
static CGFloat buttonTotalProductsHeight = 20.0;

@interface OrderListCollectionViewCell ()

- (void)buttonDeliverIdPressed:(id)sender;
- (void)buttonTotalProductsPressed:(id)sender;

@end

@implementation OrderListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.viewBackground];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.viewOrderStateBackground];
        [self.contentView addSubview:self.labelOrderState];
        [self.contentView addSubview:self.labelPrice];
        [self.contentView addSubview:self.separator];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.buttonDeliverId];
        [self.contentView addSubview:self.buttonTotalProducts];
    }
    return self;
}

#pragma mark - Override

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
    self.labelTitle.text = @"";
    self.labelOrderState.text = @"";
    self.labelOrderState.hidden = YES;
    self.progressView.arrayProgress = nil;
    self.progressView.hidden = YES;
    [self.buttonDeliverId setTitle:@"" forState:UIControlStateNormal];
    self.buttonDeliverId.hidden = YES;
    [self.buttonTotalProducts setTitle:@"" forState:UIControlStateNormal];
    self.indexPath = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat originY = marginT;
    CGFloat originX = marginL;
    
    if (self.viewBackground)
    {
        CGFloat displacementFromHeader = 1.0;
        CGRect frame = self.contentView.bounds;
        frame.origin.y -= displacementFromHeader;
        frame.size.height += displacementFromHeader;
        self.viewBackground.frame = frame;
    }
    
    if (self.imageView)
    {
        CGSize imageSize = kImageSize;
        CGRect frame = CGRectMake(originX, originY, imageSize.width, imageSize.height);
        self.imageView.frame = frame;
        originX = self.imageView.frame.origin.x + self.imageView.frame.size.width + intervalH;
    }
    
    CGFloat rightEnd = self.contentView.frame.size.width - marginR;
    if (self.labelOrderState)
    {
        NSString *defaultString = @"ＸＸＸＸＸ";
        CGFloat marginH = 3.0;
        CGFloat marginV = 2.0;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.labelOrderState.font, NSFontAttributeName, nil];
        CGSize sizeText = [defaultString sizeWithAttributes:attributes];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        if (self.viewOrderStateBackground)
        {
            CGSize sizeBackground = CGSizeMake(sizeLabel.width + marginH * 2, sizeLabel.height + marginV * 2);
            CGFloat viewOriginX = rightEnd - sizeBackground.width;
            CGRect frame = CGRectMake(viewOriginX, originY, sizeBackground.width, sizeBackground.height);
            self.viewOrderStateBackground.frame = frame;
            rightEnd = viewOriginX - intervalH;
        }
        CGRect frame = CGRectInset(self.viewOrderStateBackground.frame, marginH, marginV);
        self.labelOrderState.frame = frame;
    }
    
    if (self.labelPrice)
    {
        CGSize sizeText = [self.labelPrice.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelPrice.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(originX, originY + kImageSize.height - sizeLabel.height, self.contentView.frame.size.width - marginR - originX, sizeLabel.height);
        self.labelPrice.frame = frame;
        originY = self.labelPrice.frame.origin.y + self.labelPrice.frame.size.height + intervalV;
    }
    
    if (self.labelTitle)
    {
        CGRect frame = CGRectMake(originX, marginT, (rightEnd - originX), kImageSize.height - self.labelPrice.frame.size.height - 2.0);
        self.labelTitle.frame = frame;
    }
    
    CGFloat columnWidth = self.contentView.frame.size.width - (marginL + marginR);
    if (self.separator)
    {
        CGRect frame = CGRectMake(marginL, originY, columnWidth, separatorHeight);
        self.separator.frame = frame;
        originY = self.separator.frame.origin.y + self.separator.frame.size.height + intervalV;
    }
    
    if (self.progressView && [self.progressView isHidden] == NO)
    {
        CGRect frame = CGRectMake(marginL, originY, columnWidth, progressViewHeight);
        self.progressView.frame = frame;
        [self.progressView layoutIfNeeded];
        [self.progressView setNeedsDisplay];
        originY = self.progressView.frame.origin.y + self.progressView.frame.size.height + intervalV;
//        NSLog(@"self.progressView[%4.2f,%4.2f,%4.2f,%4.2f]", self.progressView.frame.origin.x, self.progressView.frame.origin.y, self.progressView.frame.size.width, self.progressView.frame.size.height);
    }
    
    if (self.buttonDeliverId && [self.buttonDeliverId isHidden] == NO)
    {
        CGRect frame = CGRectMake(marginL, originY, columnWidth, buttonDeliverIdHeight);
        self.buttonDeliverId.frame = frame;
        originY = self.buttonDeliverId.frame.origin.y + self.buttonDeliverId.frame.size.height + intervalV;
//        NSLog(@"self.buttonDeliverId[%4.2f,%4.2f,%4.2f,%4.2f]", self.buttonDeliverId.frame.origin.x, self.buttonDeliverId.frame.origin.y, self.buttonDeliverId.frame.size.width, self.buttonDeliverId.frame.size.height);
    }
    
    if (self.buttonTotalProducts)
    {
        CGRect frame = CGRectMake(marginL, originY, columnWidth, buttonTotalProductsHeight);
        self.buttonTotalProducts.frame = frame;
        originY = self.buttonTotalProducts.frame.origin.y + self.buttonDeliverId.frame.size.height + marginB;
//        NSLog(@"self.buttonTotalProducts[%4.2f,%4.2f,%4.2f,%4.2f]", self.buttonTotalProducts.frame.origin.x, self.buttonTotalProducts.frame.origin.y, self.buttonTotalProducts.frame.size.width, self.buttonTotalProducts.frame.size.height);
    }
}

- (UIView *)viewBackground
{
    if (_viewBackground == nil)
    {
        _viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewBackground.layer setBorderWidth:1.0];
        [_viewBackground.layer setBorderColor:[UIColor colorWithRed:(142.0/255.0) green:(170.0/255.0) blue:(214.0/255.0) alpha:1.0].CGColor];
    }
    return _viewBackground;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView.layer setMasksToBounds:YES];
    }
    return _imageView;
}

- (TTTAttributedLabel *)labelTitle
{
    if (_labelTitle == nil)
    {
        _labelTitle = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _labelTitle.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextColor:[UIColor darkGrayColor]];
        [_labelTitle setNumberOfLines:0];
        NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:self.attributesTitle];
        [_labelTitle setAttributedTruncationToken:truncationToken];
    }
    return _labelTitle;
}

- (UIView *)viewOrderStateBackground
{
    if (_viewOrderStateBackground == nil)
    {
        _viewOrderStateBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewOrderStateBackground setBackgroundColor:[UIColor clearColor]];
        [_viewOrderStateBackground.layer setBorderWidth:1.0];
        [_viewOrderStateBackground.layer setBorderColor:self.labelOrderState.textColor.CGColor];
    }
    return _viewOrderStateBackground;
}

- (UILabel *)labelOrderState
{
    if (_labelOrderState == nil)
    {
        _labelOrderState = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_labelOrderState setFont:font];
        [_labelOrderState setTextColor:[UIColor colorWithRed:(142.0/255.0) green:(170.0/255.0) blue:(214.0/255.0) alpha:1.0]];
        [_labelOrderState setBackgroundColor:[UIColor clearColor]];
        [_labelOrderState setTextAlignment:NSTextAlignmentCenter];
    }
    return _labelOrderState;
}

- (UILabel *)labelPrice
{
    if (_labelPrice == nil)
    {
        _labelPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:16.0];
        [_labelPrice setFont:font];
        [_labelPrice setTextColor:[UIColor grayColor]];
        [_labelPrice setBackgroundColor:[UIColor clearColor]];
    }
    return _labelPrice;
}

- (UIView *)separator
{
    if (_separator == nil)
    {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        [_separator setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    }
    return _separator;
}

- (OrderDeliverProgressView *)progressView
{
    if (_progressView == nil)
    {
        _progressView = [[OrderDeliverProgressView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}

- (UIButton *)buttonDeliverId
{
    if (_buttonDeliverId == nil)
    {
        _buttonDeliverId = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonDeliverId setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonDeliverId setBackgroundColor:[UIColor orangeColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_buttonDeliverId.titleLabel setFont:font];
        [_buttonDeliverId.layer setCornerRadius:5.0];
        [_buttonDeliverId addTarget:self action:@selector(buttonDeliverIdPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonDeliverId;
}

- (UIButton *)buttonTotalProducts
{
    if (_buttonTotalProducts == nil)
    {
        _buttonTotalProducts = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonTotalProducts setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_buttonTotalProducts setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [_buttonTotalProducts.titleLabel setFont:font];
        [_buttonTotalProducts addTarget:self action:@selector(buttonTotalProductsPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonTotalProducts;
}

- (NSDictionary *)attributesTitle
{
    if (_attributesTitle == nil)
    {
        UIFont *font = [UIFont systemFontOfSize:14.0];
        _attributesTitle = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    }
    return _attributesTitle;
}

- (void)setShouldShowProgress:(BOOL)shouldShowProgress
{
    _shouldShowProgress = shouldShowProgress;
    [self.progressView setHidden:!shouldShowProgress];
}

- (void)setImageUrl:(NSURL *)imageUrl
{
    _imageUrl = imageUrl;
    if (imageUrl == nil)
    {
        self.imageView.image = nil;
        return;
    }
    UIImage *placeholder = [UIImage imageNamed:@"transparent"];
    __weak OrderListCollectionViewCell *weakSelf = self;
    [self.imageView sd_setImageWithURL:_imageUrl placeholderImage:placeholder options:(SDWebImageAvoidAutoSetImage|SDWebImageAllowInvalidSSLCertificates) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
        if ([[_imageUrl absoluteString] isEqualToString:[imageURL absoluteString]])
        {
            weakSelf.imageView.image = image;
        }
    }];
}

#pragma mark - Class Methods

+ (CGFloat)heightForCellWidth:(CGFloat)width andDataDictionary:(NSDictionary *)dictionary
{
    CGFloat height = 0.0;
    height += marginT;
    CGSize imageSize = kImageSize;
    height += imageSize.height;
    height += intervalV;
    height += separatorHeight;
    height += intervalV;
    NSArray *array = [dictionary objectForKey:SymphoxAPIParam_step];
    if (array && [array isEqual:[NSNull null]] == NO && [array count] > 0)
    {
        height += progressViewHeight;
        height += intervalV;
    }
    NSString *message = [dictionary objectForKey:SymphoxAPIParam_message];
    if (message && [message isEqual:[NSNull null]] == NO && [message length] > 0 && [message isEqualToString:@"無物流"] == NO)
    {
        height += buttonDeliverIdHeight;
        height += intervalV;
    }
    height += buttonTotalProductsHeight;
    height += marginB;
    
    return height;
}

#pragma mark - Private Methods

- (void)buttonDeliverIdPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(orderListCollectionViewCell:didSelectDeliverInfoBySender:)])
    {
        [_delegate orderListCollectionViewCell:self didSelectDeliverInfoBySender:sender];
    }
}

- (void)buttonTotalProductsPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(orderListCollectionViewCell:didSelectTotalProductsBySender:)])
    {
        [_delegate orderListCollectionViewCell:self didSelectTotalProductsBySender:sender];
    }
}

@end
