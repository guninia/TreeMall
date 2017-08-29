//
//  SingleLabelCollectionReusableView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/8/8.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SingleLabelCollectionReusableViewIdentifier = @"SingleLabelCollectionReusableView";

@interface SingleLabelCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *label;

+ (CGFloat)heightForText:(NSString *)text inViewWithWidth:(CGFloat)width;

@end
