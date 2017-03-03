//
//  SemiCircleEndsSegmentedView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SemiCircleEndsSegmentedView;

@protocol SemiCircleEndsSegmentedViewDelegate <NSObject>

@optional
- (void)semiCircleEndsSegmentedView:(SemiCircleEndsSegmentedView *)view didChangeToIndex:(NSInteger)index;

@end

@interface SemiCircleEndsSegmentedView : UIView

@property (nonatomic, weak) id <SemiCircleEndsSegmentedViewDelegate> delegate;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIButton *buttonSort;
@property (nonatomic, strong) NSArray *items;

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items;

@end
