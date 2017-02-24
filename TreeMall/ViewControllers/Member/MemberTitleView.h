//
//  MemberTitleView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/22.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberTitleView;

@protocol MemberTitleViewDelegate <NSObject>

- (void)memberTitleView:(MemberTitleView *)view didSelectToModifyPersonalInformationBySender:(id)sender;

@end

@interface MemberTitleView : UIView

@property (nonatomic, weak) id <MemberTitleViewDelegate> delegate;
@property (nonatomic, strong) UILabel *labelWelcome;
@property (nonatomic, strong) UIButton *buttonModify;

@end
