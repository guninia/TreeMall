//
//  ProductPriceLabel.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/18.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductPriceLabel : UILabel

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *prefix;
@property (nonatomic, strong) UIView *viewLine;
@property (nonatomic, assign) BOOL shouldShowCutLine;
@property (nonatomic, strong) NSNumberFormatter *formatter;

- (CGSize)referenceSize;

@end
