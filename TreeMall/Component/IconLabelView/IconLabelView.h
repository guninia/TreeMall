//
//  IconLabelView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconLabelView;

@protocol IconLabelViewDelegate <NSObject>

- (void)iconLabelView:(IconLabelView *)view didPressedBySender:(id)sender;

@end

@interface IconLabelView : UIView

@property (nonatomic, weak) id <IconLabelViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

- (CGSize)referenceSizeForMaxWidth:(CGFloat)maxWidth;

@end
