//
//  ProductListToolView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductListToolView;

@protocol ProductListToolViewDelegate <NSObject>

@optional
- (void)productListToolView:(ProductListToolView *)view didSelectSortBySender:(id)sender;
- (void)productListToolView:(ProductListToolView *)view didSelectFilterBySender:(id)sender;

@end

@interface ProductListToolView : UIView

@property (nonatomic, weak) id <ProductListToolViewDelegate> delegate;
@property (nonatomic, strong) UIButton *buttonSort;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIButton *buttonFilter;
@property (nonatomic, strong) UIImageView *imageViewSort;

@end
