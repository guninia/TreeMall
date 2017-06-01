//
//  FullScreenSelectNumberView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/6/1.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FullScreenSelectNumberView;

@protocol FullScreenSelectNumberViewDelegate <NSObject>

- (void)fullScreenSelectNumberView:(FullScreenSelectNumberView *)view didSelectNumberAsString:(NSString *)stringNumber;

@end

@interface FullScreenSelectNumberView : UIView

@property (nonatomic, weak) id <FullScreenSelectNumberViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger currentValue;
@property (nonatomic, assign) NSUInteger maxValue;
@property (nonatomic, assign) NSUInteger minValue;

- (void)show;
- (void)close;

@end
