//
//  ExchangeDescriptionViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/4/25.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText.h>

typedef enum : NSUInteger {
    DescriptionViewTypeExchange,
    DescriptionViewTypeEcommercial,
    DescriptionViewTypeTotal,
} DescriptionViewType;

@interface ExchangeDescriptionViewController : UIViewController <DTAttributedTextContentViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DTAttributedLabel *label;

@property (nonatomic, assign) DescriptionViewType type;
@property (nonatomic, strong) UIButton *buttonClose;

@end
