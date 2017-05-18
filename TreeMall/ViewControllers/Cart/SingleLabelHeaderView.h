//
//  SingleLabelHeaderView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/3.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SingleLabelHeaderViewIdentifier = @"SingleLabelHeaderView";

@class SingleLabelHeaderView;

@protocol SingleLabelHeaderViewDelegate <NSObject>

- (void)singleLabelHeaderView:(SingleLabelHeaderView *)headerView didPressButton:(id)sender;

@end

@interface SingleLabelHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id <SingleLabelHeaderViewDelegate> delegate;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, assign) CGFloat marginH;

@end
