//
//  ShoppingMallViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingMallViewController : UIViewController

@property (nonatomic, strong) IBOutlet UICollectionView *collectionViewCategory;
@property (nonatomic, strong) IBOutlet UITableView *tableViewSubcategory;
@property (nonatomic, strong) IBOutlet UITableView *tableViewExtraSubcategory;

@end
