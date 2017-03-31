//
//  LabelButtonView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/29.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LabelButtonView;

@protocol LabelButtonViewDelegate <NSObject>

- (void)labelButtonView:(LabelButtonView *)view didPressButton:(id)sender;

@end

@interface LabelButtonView : UIView

@property (nonatomic, weak) id <LabelButtonViewDelegate> delegate;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end
