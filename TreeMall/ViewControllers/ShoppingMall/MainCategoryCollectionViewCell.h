//
//  MainCategoryCollectionViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/24.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *MainCategoryCollectionViewCellIdentifier = @"MainCategoryCollectionViewCell";

@interface MainCategoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end
