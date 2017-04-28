//
//  HotSaleTableViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/28.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "HotSaleTableViewCell.h"
#import <UIImageView+WebCache.h>

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
    if (self.labelPrice)
    {
        CGSize sizeText = [self.labelPrice.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.labelPrice.font, NSFontAttributeName, nil]];
        CGSize sizeLabel = CGSizeMake(ceil(sizeText.width), ceil(sizeText.height));
        CGRect frame = CGRectMake(marginH, originY, self.viewContainer.frame.size.width - marginH * 2, sizeLabel.height);
        self.labelPrice.frame = frame;
    }
    
    if (self.labelTitle)
    {
        CGFloat height = self.separator.frame.origin.y - intervalV - marginV;
        CGFloat width = self.viewContainer.frame.size.width - marginH - originX;
        CGRect frame = CGRectMake(originX, marginV, width, height);
        self.labelTitle.frame = frame;
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
        UIFont *font = [UIFont systemFontOfSize:18.0];
        [_labelPrice setFont:font];
    }
    return _labelPrice;
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

@end
