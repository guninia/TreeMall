//
//  PromotionViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableViewPromotion;
@property (nonatomic, strong) NSMutableArray *arrayPromotion;

@end
