//
//  CartViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SemiCircleEndsSegmentedView.h"
#import "LabelButtonView.h"
#import "CartProductTableViewCell.h"
#import "TMInfoManager.h"
#import "SHPickerView.h"
#import "FullScreenLoadingView.h"
#import "FullScreenSelectNumberView.h"

@interface CartViewController : UIViewController <SemiCircleEndsSegmentedViewDelegate, UITableViewDataSource, UITableViewDelegate, CartProductTableViewCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate, LabelButtonViewDelegate, FullScreenSelectNumberViewDelegate>

@property (nonatomic, strong) SemiCircleEndsSegmentedView *segmentedView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LabelButtonView *bottomBar;
@property (nonatomic, assign) CartType currentType;
@property (nonatomic, strong) NSMutableArray *arrayProducts;
@property (nonatomic, strong) NSMutableDictionary *dictionaryTotal;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) UIImageView *tableBackgroundView;
@property (nonatomic, strong) UILabel *labelNoContent;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;
@property (nonatomic, strong) FullScreenSelectNumberView *viewQuantityInput;

@end
