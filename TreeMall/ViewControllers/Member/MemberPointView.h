//
//  MemberPointView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/22.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderedDoubleLabelView.h"

@class MemberPointView;

@protocol MemberPointViewDelegate <NSObject>

- (void)memberPointView:(MemberPointView *)view didPressBonusGameBySender:(id)sender;

@end

@interface MemberPointView : UIView

@property (nonatomic, weak) id <MemberPointViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelPoint;
@property (nonatomic, strong) UILabel *labelDividend;
@property (nonatomic, strong) UIButton *buttonBonusGame;
@property (nonatomic, strong) BorderedDoubleLabelView *viewTotalPoint;
@property (nonatomic, strong) BorderedDoubleLabelView *viewExpired;
@property (nonatomic, strong) NSNumber *numberPoint;
@property (nonatomic, strong) NSNumber *numberDividend;
@property (nonatomic, strong) NSNumber *numberTotal;
@property (nonatomic, strong) NSNumber *numberExpired;
@property (nonatomic, strong) NSNumberFormatter *formatter;

@end
