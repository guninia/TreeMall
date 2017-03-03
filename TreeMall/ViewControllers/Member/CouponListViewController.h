//
//  CouponListViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/2.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SemiCircleEndsSegmentedView.h"
#import "DropdownListButton.h"
#import "TMInfoManager.h"

typedef enum : NSUInteger {
    CouponSortOptionValueHighToLow,
    CouponSortOptionValueLowToHigh,
    CouponSortOptionValidDateEarlyToLate,
    CouponSortOptionValidDateLateToEarly,
    CouponSortOptionTotal
} CouponSortOption;

@interface CouponListViewController : UIViewController <SemiCircleEndsSegmentedViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SemiCircleEndsSegmentedView *segmentedView;
@property (nonatomic, strong) DropdownListButton *buttonSort;
@property (nonatomic, strong) UITableView *tableViewCoupon;
@property (nonatomic, strong) NSMutableArray *arraySortType;
@property (nonatomic, assign) CouponSortOption sortType;
@property (nonatomic, assign) CouponState stateIndex;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *arrayCoupon;
@property (nonatomic, assign) NSInteger totalCoupon;
@property (nonatomic, assign) BOOL shouldShowLoadingView;

@end
