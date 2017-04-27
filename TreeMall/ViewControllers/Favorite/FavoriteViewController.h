//
//  FavoriteViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductTableViewCell.h"
#import "LoadingFooterView.h"

@interface FavoriteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableViewFavorites;
@property (nonatomic, strong) NSArray *arrayFavorites;
@property (nonatomic, assign) BOOL shouldShowLoadingFooter;
@property (nonatomic, strong) UIButton *buttonEdit;
@property (nonatomic, strong) UIImageView *tableBackgroundView;
@property (nonatomic, strong) UILabel *labelNoContent;

@end
