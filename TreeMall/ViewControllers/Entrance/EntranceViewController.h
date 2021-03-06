//
//  EntranceViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntranceFunctionSectionHeader.h"
#import "EntranceMemberPromoteHeader.h"
#import "SearchViewController.h"

@interface EntranceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EntranceFunctionSectionHeaderDelegate, SearchViewControllerDelegate, EntranceMemberPromoteHeaderDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableViewEntrance;
@property (nonatomic, strong) NSMutableDictionary *dictionaryData;

@end
