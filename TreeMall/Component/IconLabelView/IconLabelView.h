//
//  IconLabelView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconLabelView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

- (CGSize)referenceSizeForMaxWidth:(CGFloat)maxWidth;

@end
