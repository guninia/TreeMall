//
//  ViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullScreenLoadingView.h"

@interface ViewController : UIViewController <UITabBarControllerDelegate>

@property (nonatomic, strong) UITabBarController *tbControllerMain;
@property (nonatomic, strong) UIImageView *imageViewLaunchScreen;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;
@property (nonatomic, assign) BOOL initialized;

- (void)checkToShowIntroduce;
- (void)showLaunchScreenLoadingViewAnimated:(BOOL)animated;
- (void)hideLaunchScreenLoadingViewAnimated:(BOOL)animated;

@end

