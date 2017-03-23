//
//  NewsletterSubscribeViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullScreenLoadingView.h"

@interface NewsletterSubscribeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableViewNewsletter;
@property (nonatomic, strong) UIButton *buttonSend;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;
@property (nonatomic, strong) NSMutableArray *arrayNewsletter;

@end
