//
//  BorderedDoubleLabelView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BorderedDoubleLabelView;

@protocol BorderedDoubleViewDelegate <NSObject>

@optional
- (void)didTouchUpInsideBorderedDoubleView:(BorderedDoubleLabelView *)view;

@end

@interface BorderedDoubleLabelView : UIView

@property (nonatomic, weak) id <BorderedDoubleViewDelegate> delegate;
@property (nonatomic, strong) UILabel *labelL;
@property (nonatomic, strong) UILabel *labelR;
@property (nonatomic, strong) UIButton *buttonTransparent;

@end
