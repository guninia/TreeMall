//
//  MemberViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "MemberViewController.h"
#import "LocalizedString.h"
#import "TMInfoManager.h"

@interface MemberViewController ()

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.viewTitle];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.viewPoint];
    [self.scrollView addSubview:self.viewCouponTitle];
    [self.scrollView addSubview:self.viewTotalCoupon];
    [self.scrollView addSubview:self.viewOrderTitle];
    [self.scrollView addSubview:self.viewProcessing];
    [self.scrollView addSubview:self.viewShipped];
    [self.scrollView addSubview:self.viewReturnReplace];
    
    NSLog(@"User:\nName: %@\nIdentifier: %li\nEmail: %@\nGender: %li\nEpoint: %li\nEcoupon: %li", [TMInfoManager sharedManager].userName, (long)[[TMInfoManager sharedManager].userIdentifier integerValue], [TMInfoManager sharedManager].userEmail, (long)([TMInfoManager sharedManager].userGender), (long)([[TMInfoManager sharedManager].userEpoint integerValue]), (long)([[TMInfoManager sharedManager].userEcoupon integerValue]));
    NSNumber *userIdentifier = [TMInfoManager sharedManager].userIdentifier;
    if (userIdentifier)
    {
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"MemberViewController - viewWillAppear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Override

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat originY = 0.0;
    if (self.viewTitle)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, 40.0);
        self.viewTitle.frame = frame;
        originY = self.viewTitle.frame.origin.y + self.viewTitle.frame.size.height;
    }
    if (self.scrollView)
    {
        CGRect frame = CGRectMake(0.0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        self.scrollView.frame = frame;
    }
    originY = 0.0;
    if (self.viewPoint)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 200.0);
        self.viewPoint.frame = frame;
        originY = self.viewPoint.frame.origin.y + self.viewPoint.frame.size.height;
    }
    if (self.viewCouponTitle)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
        self.viewCouponTitle.frame = frame;
        originY = self.viewCouponTitle.frame.origin.y + self.viewCouponTitle.frame.size.height;
    }
    if (self.viewTotalCoupon)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 40.0);
        self.viewTotalCoupon.frame = frame;
        originY = self.viewTotalCoupon.frame.origin.y + self.viewTotalCoupon.frame.size.height;
    }
    if (self.viewOrderTitle)
    {
        CGRect frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, 50.0);
        self.viewOrderTitle.frame = frame;
        originY = self.viewOrderTitle.frame.origin.y + self.viewOrderTitle.frame.size.height;
    }
    NSArray *array = [NSArray arrayWithObjects:self.viewProcessing, self.viewShipped, self.viewReturnReplace, nil];
    NSInteger totalCount = [array count];
    CGFloat viewWidth = ceil(self.scrollView.frame.size.width / totalCount);
    CGFloat maxViewHeight = 0.0;
    for (IconLabelView *view in array)
    {
        CGSize referenceSize = [view referenceSizeForMaxWidth:viewWidth];
        if (referenceSize.height > maxViewHeight)
        {
            maxViewHeight = referenceSize.height;
        }
    }
    for (NSInteger index = 0; index < totalCount; index++)
    {
        IconLabelView *view = [array objectAtIndex:index];
        CGRect frame = CGRectMake(viewWidth * index, originY, viewWidth, maxViewHeight);
        view.frame = frame;
    }
    CGFloat scrollBottom = originY + maxViewHeight + 20.0;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, scrollBottom)];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _scrollView;
}

- (MemberTitleView *)viewTitle
{
    if (_viewTitle == nil)
    {
        _viewTitle = [[MemberTitleView alloc] initWithFrame:CGRectZero];
    }
    return _viewTitle;
}

- (MemberPointView *)viewPoint
{
    if (_viewPoint == nil)
    {
        _viewPoint = [[MemberPointView alloc] initWithFrame:CGRectZero];
    }
    return _viewPoint;
}

- (ProductDetailSectionTitleView *)viewCouponTitle
{
    if (_viewCouponTitle == nil)
    {
        _viewCouponTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_icon3"];
        if (image)
        {
            [_viewCouponTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewCouponTitle.viewTitle.labelText setText:[LocalizedString MyCoupon]];
    }
    return _viewCouponTitle;
}

- (BorderedDoubleLabelView *)viewTotalCoupon
{
    if (_viewTotalCoupon == nil)
    {
        _viewTotalCoupon = [[BorderedDoubleLabelView alloc] initWithFrame:CGRectZero];
        [_viewTotalCoupon.layer setBorderWidth:0.0];
        [_viewTotalCoupon.labelL setText:[LocalizedString TotalCount]];
    }
    return _viewTotalCoupon;
}

- (ProductDetailSectionTitleView *)viewOrderTitle
{
    if (_viewOrderTitle == nil)
    {
        _viewOrderTitle = [[ProductDetailSectionTitleView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_icon1"];
        if (image)
        {
            [_viewOrderTitle.viewTitle.imageViewIcon setImage:image];
        }
        [_viewOrderTitle.viewTitle.labelText setText:[LocalizedString MyOrder]];
    }
    return _viewOrderTitle;
}

- (IconLabelView *)viewProcessing
{
    if (_viewProcessing == nil)
    {
        _viewProcessing = [[IconLabelView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_ord_icon2"];
        if (image)
        {
            [_viewProcessing.imageView setImage:image];
        }
        NSString *stringDefault = [NSString stringWithFormat:[LocalizedString Processing_BRA_S_BRA], @"0"];
        _viewProcessing.label.text = stringDefault;
    }
    return _viewProcessing;
}

- (IconLabelView *)viewShipped
{
    if (_viewShipped == nil)
    {
        _viewShipped = [[IconLabelView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_ord_icon1"];
        if (image)
        {
            [_viewShipped.imageView setImage:image];
        }
        NSString *stringDefault = [NSString stringWithFormat:[LocalizedString Shipped_BRA_S_BRA], @"0"];
        _viewShipped.label.text = stringDefault;
    }
    return _viewShipped;
}

- (IconLabelView *)viewReturnReplace
{
    if (_viewReturnReplace == nil)
    {
        _viewReturnReplace = [[IconLabelView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"men_my_ord_icon3"];
        if (image)
        {
            [_viewReturnReplace.imageView setImage:image];
        }
        NSString *stringDefault = [NSString stringWithFormat:[LocalizedString ReturnReplace_BRA_S_BRA], @"0"];
        _viewReturnReplace.label.text = stringDefault;
    }
    return _viewReturnReplace;
}

@end
