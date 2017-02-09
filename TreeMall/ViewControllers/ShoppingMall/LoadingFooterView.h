//
//  LoadingFooterView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LoadingFooterViewIdentifier = @"LoadingFooterView";

@interface LoadingFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
