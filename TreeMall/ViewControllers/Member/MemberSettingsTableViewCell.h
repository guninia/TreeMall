//
//  MemberSettingsTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircularSideLabelView.h"

static NSString *MemberSettingsTableViewCellIdentifier = @"MemberSettingsTableViewCell";

@interface MemberSettingsTableViewCell : UITableViewCell

@property (nonatomic, strong) CircularSideLabelView *labelView;

@end
