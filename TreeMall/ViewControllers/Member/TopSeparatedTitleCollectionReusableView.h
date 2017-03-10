//
//  TopSeparatedTitleCollectionReusableView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *TopSeparatedTitleCollectionReusableViewIdentifier = @"TopSeparatedTitleCollectionReusableView";

@interface TopSeparatedTitleCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, assign) CGFloat marginL;
@property (nonatomic, assign) CGFloat marginR;

@end
