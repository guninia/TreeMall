//
//  MemberViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberTitleView.h"
#import "MemberPointView.h"
#import "ProductDetailSectionTitleView.h"
#import "IconLabelView.h"

@interface MemberViewController : UIViewController <ProductDetailSectionTitleViewDelegate, MemberTitleViewDelegate, IconLabelViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MemberTitleView *viewTitle;
@property (nonatomic, strong) UIButton *buttonAdvertisement;
@property (nonatomic, strong) MemberPointView *viewPoint;
@property (nonatomic, strong) ProductDetailSectionTitleView *viewCouponTitle;
@property (nonatomic, strong) BorderedDoubleLabelView *viewTotalCoupon;
@property (nonatomic, strong) ProductDetailSectionTitleView *viewOrderTitle;
@property (nonatomic, strong) IconLabelView *viewProcessing;
@property (nonatomic, strong) IconLabelView *viewShipped;
@property (nonatomic, strong) IconLabelView *viewReturnReplace;
@property (nonatomic, strong) NSNumber *numberCoupon;
@property (nonatomic, strong) NSArray *arrayOfOrderNumberOfStatus;
@property (nonatomic, strong) NSNumber *numberOrderProcessing;
@property (nonatomic, strong) NSNumber *numberOrderShipping;
@property (nonatomic, strong) NSNumber *numberOrderReturnReplace;

@end
