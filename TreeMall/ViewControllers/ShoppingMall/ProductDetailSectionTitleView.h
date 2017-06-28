//
//  ProductDetailSectionTitleView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTextView.h"

@class ProductDetailSectionTitleView;

@protocol ProductDetailSectionTitleViewDelegate <NSObject>

@optional
- (void)productDetailSectionTitleView:(ProductDetailSectionTitleView *)view didPressButtonBySender:(id)sender;

@end

@interface ProductDetailSectionTitleView : UIView

@property (nonatomic, weak) id <ProductDetailSectionTitleViewDelegate> delegate;
@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) ImageTextView *viewTitle;
@property (nonatomic, strong) UILabel *labelR;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *buttonTransparent;
@property (nonatomic, strong) UIButton *buttonRight;
@property (nonatomic, assign) CGFloat topSeparatorHeight;

@end
