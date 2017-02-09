//
//  ExtraSubcategoryHeaderView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/26.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExtraSubcategoryHeaderView;

@protocol ExtraSubcategoryHeaderViewDelegate <NSObject>

- (void)extraSubcategoryHeaderView:(ExtraSubcategoryHeaderView *)view didSelectBySender:(id)sender;

@end

static NSString *ExtraSubcategoryHeaderViewIdentifier = @"ExtraSubcategoryHeaderView";

@interface ExtraSubcategoryHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id <ExtraSubcategoryHeaderViewDelegate> delegate;
@property (nonatomic, strong) UIButton *button;

@end


