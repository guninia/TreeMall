//
//  CircularSideLabelView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/22.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularSideLabelView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, assign) CGSize textIndent;

- (void)setText:(NSString *)text withAttributes:(NSDictionary *)attributes;

@end
