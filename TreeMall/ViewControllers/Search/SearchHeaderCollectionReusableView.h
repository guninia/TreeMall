//
//  SearchHeaderCollectionReusableView.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/17.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SearchHeaderCollectionReusableViewIdentifier = @"SearchHeaderCollectionReusableView";

@class SearchHeaderCollectionReusableView;

@protocol SearchHeaderCollectionReusableViewDelegate <NSObject>

- (void)searchHeaderCollectionReusableView:(SearchHeaderCollectionReusableView *)view didSelectRecycleBySender:(id)sender;

@end

@interface SearchHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) id <SearchHeaderCollectionReusableViewDelegate> delegate;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL shouldShowRecycle;
@property (nonatomic, strong) UIView *separatorTop;
@property (nonatomic, strong) UIView *separatorBot;

@end
