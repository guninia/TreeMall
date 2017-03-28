//
//  ImageTitleButton.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTitleButton : UIButton

@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, assign) CGFloat marginL;
@property (nonatomic, assign) CGFloat marginR;

@end
