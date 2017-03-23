//
//  OrderHeaderReusableView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *OrderHeaderReusableViewIdentifier = @"OrderHeaderReusableView";

@class OrderHeaderReusableView;

@protocol OrderHeaderReusableViewDelegate <NSObject>

- (void)orderHeaderReusableView:(OrderHeaderReusableView *)view didPressButtonBySender:(id)sender;

@end

@interface OrderHeaderReusableView : UICollectionReusableView

@property (nonatomic, weak) id <OrderHeaderReusableViewDelegate> delegate;
@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UIView *viewTopLine;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *labelDateTime;
@property (nonatomic, strong) UILabel *labelSerialNumber;

@end
