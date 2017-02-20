//
//  ProductDetailPromotionLabelView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/18.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailPromotionLabelView : UIView

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelPromotion;
@property (nonatomic, strong) NSString *promotion;
@property (nonatomic, strong) NSDictionary *attributesPromotion;

- (CGFloat)referenceHeightForViewWidth:(CGFloat)viewWidth;
- (CGFloat)referenceHeightForPromotion:(NSString *)promotion withViewWidth:(CGFloat)viewWidth;

@end
