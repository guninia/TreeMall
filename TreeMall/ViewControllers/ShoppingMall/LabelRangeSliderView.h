//
//  LabelRangeSliderView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/14.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface LabelRangeSliderView : UIView

@property (nonatomic, strong) NMRangeSlider *slider;
@property (nonatomic, strong) UILabel *labelLowerValue;
@property (nonatomic, strong) UILabel *labelHigherValue;
@property (nonatomic, strong) UILabel *labelLowerBoundary;
@property (nonatomic, strong) UILabel *labelHigherBoundary;
@property (nonatomic, assign) CGFloat maxLabelWidth;
@property (nonatomic, strong) NSString *textLowerBoundary;
@property (nonatomic, strong) NSString *textHigherBoundary;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) NSString *textPrefix;
@end
