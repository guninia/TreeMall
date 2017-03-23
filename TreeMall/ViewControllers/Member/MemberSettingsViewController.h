//
//  MemberSettingsViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullScreenLoadingView.h"

@interface MemberSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;
@property (nonatomic, strong) NSMutableArray *arrayOptions;
@property (nonatomic, strong) NSMutableDictionary *dictionaryAddition;
@property (nonatomic, strong) NSMutableDictionary *dictionaryIconImage;

@end
