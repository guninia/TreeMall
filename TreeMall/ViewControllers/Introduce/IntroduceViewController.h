//
//  IntroduceViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/11.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroduceViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *buttonStart;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@end
