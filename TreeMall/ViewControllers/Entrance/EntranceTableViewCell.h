//
//  EntranceTableViewCell.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEntranceTableViewCellImageFrameRatio0 (360.0f / 888.0f)
#define kEntranceTableViewCellImageFrameRatio1 (144.0f / 888.0f)

static NSString *EntranceTableViewCellIdentifier = @"EntranceTableViewCell";

@interface EntranceTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat frameRatio;

@end
