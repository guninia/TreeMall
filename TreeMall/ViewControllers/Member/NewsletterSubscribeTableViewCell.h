//
//  NewsletterSubscribeTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *NewsletterSubscribeTableViewCellIdentifier = @"NewsletterSubscribeTableViewCell";

@interface NewsletterSubscribeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelDetail;
@property (nonatomic, strong) UIButton *buttonCheck;
@property (nonatomic, assign) BOOL subscribed;

@end
