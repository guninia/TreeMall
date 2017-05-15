//
//  CompleteOrderViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/15.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMInfoManager.h"
#import "BorderedDoubleLabelView.h"
#import <DTCoreText.h>
#import "FullScreenLoadingView.h"

@interface CompleteOrderViewController : UIViewController <DTAttributedTextContentViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *viewLabelBackground;
@property (nonatomic, weak) IBOutlet UILabel *labelTotalItem;
@property (nonatomic, strong) BorderedDoubleLabelView *viewOrderId;
@property (nonatomic, strong) BorderedDoubleLabelView *viewCash;
@property (nonatomic, strong) BorderedDoubleLabelView *viewEPoint;
@property (nonatomic, strong) BorderedDoubleLabelView *viewPoint;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) DTAttributedLabel *labelOrderDescription;
@property (nonatomic, strong) UITableView *tableViewOrderContent;
@property (nonatomic, strong) UIButton *buttonConfirm;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;

@property (nonatomic, strong) NSDictionary *dictionaryTotalCost;
@property (nonatomic, strong) NSDictionary *dictionaryOrderData;
@property (nonatomic, strong) NSString *tradeId;

@end
