//
//  DeliverProgressViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliverProgressViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *orderId;

@end
