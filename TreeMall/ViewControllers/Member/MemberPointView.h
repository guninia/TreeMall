//
//  MemberPointView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/22.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderedDoubleLabelView.h"

@interface MemberPointView : UIView

@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelPoint;
@property (nonatomic, strong) UILabel *labelDividend;
@property (nonatomic, strong) BorderedDoubleLabelView *viewTotalPoint;
@property (nonatomic, strong) BorderedDoubleLabelView *viewExpired;

@end
