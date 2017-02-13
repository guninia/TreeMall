//
//  ProductListTitleView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductListTitleView;

@protocol ProductListTitleViewDelegate <NSObject>

- (void)productListTitleView:(ProductListTitleView *)view willSelectTitleBySender:(id)sender;

@end

@interface ProductListTitleView : UIView

@property (nonatomic, weak) id <ProductListTitleViewDelegate> delegate;
@property (nonatomic, strong) UIButton *buttonTitle;
@property (nonatomic, strong) UIButton *buttonArrowDown;
@property (nonatomic, strong) NSString *titleText;

@end
