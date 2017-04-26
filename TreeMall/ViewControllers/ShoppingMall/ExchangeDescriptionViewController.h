//
//  ExchangeDescriptionViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/25.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText.h>

@interface ExchangeDescriptionViewController : UIViewController <DTAttributedTextContentViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DTAttributedLabel *label;

@end
