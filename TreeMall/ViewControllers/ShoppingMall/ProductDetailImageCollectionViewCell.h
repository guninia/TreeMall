//
//  ProductDetailImageCollectionViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/20.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ProductDetailImageCollectionViewCellIdentifier = @"ProductDetailImageCollectionViewCell";

@interface ProductDetailImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
