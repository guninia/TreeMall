//
//  ReceiverInfoCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ReceiverInfoCellIdentifier = @"ReceiverInfoCell";

@class ReceiverInfoCell;

@protocol ReceiverInfoCellDelegate <NSObject>

- (void)receiverInfoCell:(ReceiverInfoCell *)cell didPressAccessoryView:(UIButton *)accessoryView;

@end

@interface ReceiverInfoCell : UITableViewCell

@property (nonatomic, weak) id <ReceiverInfoCellDelegate> delegate;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelContent;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSString *accessoryTitle;

@end
