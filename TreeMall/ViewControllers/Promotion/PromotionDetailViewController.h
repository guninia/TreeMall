//
//  PromotionDetailViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/27.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionDetailViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIButton *buttonAction;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UILabel *labelContent;

@property (nonatomic, strong) NSDictionary *dictionaryData;

@end
