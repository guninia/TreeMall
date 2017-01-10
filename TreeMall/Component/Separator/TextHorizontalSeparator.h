//
//  TextHorizontalSeparator.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextHorizontalSeparator : UIView
{
    UIView *lineLeft;
    UIView *lineRight;
    UILabel *labelText;
}

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *tintColor;

@end
