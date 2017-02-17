//
//  SearchViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/2/16.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchHeaderCollectionReusableView.h"

@class SearchViewController;

@protocol SearchViewControllerDelegate <NSObject>

- (void)searchViewController:(SearchViewController *)viewController didSelectToSearchKeyword:(NSString *)keyword;

@end

@interface SearchViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SearchHeaderCollectionReusableViewDelegate>

@property (nonatomic, weak) id <SearchViewControllerDelegate> delegate;
@property (nonatomic, strong) UITextField *textFieldSearch;
@property (nonatomic, strong) UICollectionView *collectionViewKeyword;
@property (nonatomic, strong) NSArray *arraySearchLatest;
@property (nonatomic, strong) NSArray *arraySearchHot;

@end
