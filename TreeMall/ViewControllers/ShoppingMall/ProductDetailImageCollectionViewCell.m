//
//  ProductDetailImageCollectionViewCell.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/20.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ProductDetailImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ProductDetailImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imagePath = nil;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.activityIndicator];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView)
    {
        self.imageView.frame = self.contentView.bounds;
    }
    if (self.activityIndicator)
    {
        self.activityIndicator.center = self.imageView.center;
    }
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

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setHidesWhenStopped:YES];
    }
    return _activityIndicator;
}

- (void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
    if (_imagePath == nil)
    {
        return;
    }
    NSURL *url = [NSURL URLWithString:imagePath];
    if (url == nil)
    {
        return;
    }
    
    [self.activityIndicator startAnimating];
    UIImage *placeholder = [UIImage imageNamed:@"ico_default"];
    __weak ProductDetailImageCollectionViewCell *weakSelf = self;
    [self.imageView sd_setImageWithURL:url placeholderImage:placeholder options:(SDWebImageAvoidAutoSetImage|SDWebImageAllowInvalidSSLCertificates) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
        if (error == nil)
        {
            NSLog(@"load image success from [%@]", [imageURL absoluteString]);
            if ([[imageURL absoluteString] isEqualToString:imagePath])
            {
                if (error == nil && image)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.imageView setImage:image];
                    });
                }
            }
        }
        else
        {
            NSLog(@"load image error:\n%@", [error description]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.activityIndicator stopAnimating];
        });
    }];
}

@end
