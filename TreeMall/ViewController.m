//
//  ViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "LocalizedString.h"
#import "ViewController.h"
#import "EntranceViewController.h"
#import "ShoppingMallViewController.h"
#import "CartViewController.h"
#import "FavoriteViewController.h"
#import "MemberViewController.h"
#import "LoginViewController.h"
#import "Utility.h"
#import "Definition.h"
#import "TMInfoManager.h"
#import "CryptoTool.h"
#import "CouponListViewController.h"
#import "IntroduceViewController.h"
#import "APIDefinition.h"
#import "StorePickupWebViewController.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface ViewController () {
    id<GAITracker> gaTracker;
}

- (void)postUserLogoutProcedure;
- (void)JumpToTab:(NSInteger)tabIndex;
- (void)updateCartBadge;
- (void)updateFavoriteBadge;

- (void)handlerOfNoInitialTokenNotification:(NSNotification *)notification;
- (void)handlerOfEntranceDataPreparedNotification:(NSNotification *)notification;
- (void)handlerOfUserLogoutNotification:(NSNotification *)notification;
- (void)handlerOfJumpingToMemberTabNotification:(NSNotification *)notification;
- (void)handlerOfJumpingToMemberTabAndPresentCouponNotification:(NSNotification *)notification;
- (void)handlerOfCartContentChangedNotification:(NSNotification *)notification;
- (void)handlerOfApplicationDidBecomeActiveNotification:(NSNotification *)notification;
- (void)handlerOfJumpToShoppingMallAndPresentHallNotification:(NSNotification *)notification;
- (void)handlerOfFavoriteContentChangedNotification:(NSNotification *)notification;
- (void)handlerOfCompleteOrderProcessNotification:(NSNotification *)notification;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _initialized = NO;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _initialized = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    gaTracker = [GAI sharedInstance].defaultTracker;
    
    NSMutableArray *vControllerArray = [NSMutableArray array];
    NSMutableDictionary *itemImageDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *itemSelectedImageDictionary = [NSMutableDictionary dictionary];
    NSInteger vControllerIndex = 0;
    EntranceViewController *vControllerEntrance = [[EntranceViewController alloc] initWithNibName:@"EntranceViewController" bundle:[NSBundle mainBundle]];
    if (vControllerEntrance != nil)
    {
        vControllerEntrance.title = [LocalizedString Homepage];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerEntrance];
        [vControllerArray addObject:navigationController];
        UIImage *selectedImage = [[UIImage imageNamed:@"ind_ico_f_menu_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (selectedImage)
        {
            NSNumber *key = [NSNumber numberWithInteger:vControllerIndex];
            [itemSelectedImageDictionary setObject:selectedImage forKey:key];
            UIImage *normalImage = [[Utility colorizeImage:selectedImage withColor:[UIColor colorWithWhite:1.0 alpha:1.0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [itemImageDictionary setObject:normalImage forKey:key];
        }
        vControllerIndex++;
    }
    
    ShoppingMallViewController *vControllerShoppingMall = [[ShoppingMallViewController alloc] initWithNibName:@"ShoppingMallViewController" bundle:[NSBundle mainBundle]];
    if (vControllerShoppingMall != nil)
    {
        vControllerShoppingMall.title = [LocalizedString ProductOverview];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerShoppingMall];
        [vControllerArray addObject:navigationController];
        UIImage *selectedImage = [[UIImage imageNamed:@"ind_ico_f_menu_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (selectedImage)
        {
            NSNumber *key = [NSNumber numberWithInteger:vControllerIndex];
            [itemSelectedImageDictionary setObject:selectedImage forKey:key];
            UIImage *normalImage = [[Utility colorizeImage:selectedImage withColor:[UIColor colorWithWhite:1.0 alpha:1.0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [itemImageDictionary setObject:normalImage forKey:key];
        }
        vControllerIndex++;
    }
    
    CartViewController *vControllerCart = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:[NSBundle mainBundle]];
    if (vControllerCart != nil)
    {
        vControllerCart.title = [LocalizedString ShoppingCart];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerCart];
        [vControllerArray addObject:navigationController];
        UIImage *selectedImage = [[UIImage imageNamed:@"sho_info_bnt_cat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (selectedImage)
        {
            NSNumber *key = [NSNumber numberWithInteger:vControllerIndex];
            [itemSelectedImageDictionary setObject:selectedImage forKey:key];
            UIImage *normalImage = [[Utility colorizeImage:selectedImage withColor:[UIColor colorWithWhite:1.0 alpha:1.0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [itemImageDictionary setObject:normalImage forKey:key];
        }
        vControllerIndex++;
    }
    
    FavoriteViewController *vControllerFavorite = [[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:[NSBundle mainBundle]];
    if (vControllerFavorite != nil)
    {
        vControllerFavorite.title = [LocalizedString MyFavorite];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerFavorite];
        [vControllerArray addObject:navigationController];
        UIImage *selectedImage = [[UIImage imageNamed:@"ind_ico_f_menu_4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (selectedImage)
        {
            NSNumber *key = [NSNumber numberWithInteger:vControllerIndex];
            [itemSelectedImageDictionary setObject:selectedImage forKey:key];
            UIImage *normalImage = [[Utility colorizeImage:selectedImage withColor:[UIColor colorWithWhite:1.0 alpha:1.0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [itemImageDictionary setObject:normalImage forKey:key];
        }
        vControllerIndex++;
    }
    
    MemberViewController *vControllerMember = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:[NSBundle mainBundle]];
    if (vControllerMember != nil)
    {
        vControllerMember.title = [LocalizedString Member];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerMember];
        [vControllerArray addObject:navigationController];
        UIImage *selectedImage = [[UIImage imageNamed:@"ind_ico_f_menu_5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (selectedImage)
        {
            NSNumber *key = [NSNumber numberWithInteger:vControllerIndex];
            [itemSelectedImageDictionary setObject:selectedImage forKey:key];
            UIImage *normalImage = [[Utility colorizeImage:selectedImage withColor:[UIColor colorWithWhite:1.0 alpha:1.0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [itemImageDictionary setObject:normalImage forKey:key];
        }
        vControllerIndex++;
    }
    
    _tbControllerMain = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    _tbControllerMain.delegate = self;
    [_tbControllerMain setViewControllers:vControllerArray];
//    NSLog(@"tabBarItem[%li] ", _tbControllerMain.tabBar.items.count);
    for (NSInteger index = 0; index < _tbControllerMain.tabBar.items.count; index++)
    {
        NSNumber *key = [NSNumber numberWithInteger:index];
        UIImage *image = [itemImageDictionary objectForKey:key];
        if (image == nil)
            continue;
        UIImage *selectedImage = [itemSelectedImageDictionary objectForKey:key];
        UITabBarItem *item = [_tbControllerMain.tabBar.items objectAtIndex:index];
        item.image = image;
        if (selectedImage)
        {
            item.selectedImage = selectedImage;
        }
    }
    [self updateCartBadge];
    [self updateFavoriteBadge];
    
    [self addChildViewController:_tbControllerMain];
    [self.view addSubview:_tbControllerMain.view];
    
    [self.view addSubview:self.imageViewLaunchScreen];
    [self.view addSubview:self.viewLoading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfNoInitialTokenNotification:) name:PostNotificationName_NoInitialToken object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfEntranceDataPreparedNotification:) name:PostNotificationName_EntranceDataPrepared object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfUserLogoutNotification:) name:PostNotificationName_UserLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfJumpingToMemberTabNotification:) name:PostNotificationName_JumpToMemberTab object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfJumpingToMemberTabAndPresentCouponNotification:) name:PostNotificationName_JumpToMemberTabAndPresentCoupon object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfCartContentChangedNotification:) name:PostNotificationName_CartContentChanged object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfApplicationDidBecomeActiveNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfJumpToShoppingMallAndPresentHallNotification:) name:PostNotificationName_JumpToShoppingMallAndPresentHall object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfFavoriteContentChangedNotification:) name:PostNotificationName_FavoriteContentChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfCompleteOrderProcessNotification:) name:PostNotificationName_CompleteOrderProcess object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.initialized == NO)
    {
        [self showLaunchScreenLoadingViewAnimated:NO];
    }
    [self checkToShowIntroduce];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_NoInitialToken object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_EntranceDataPrepared object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserLogout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_JumpToMemberTab object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_JumpToMemberTabAndPresentCoupon object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_CartContentChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_JumpToShoppingMallAndPresentHall object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_FavoriteContentChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_CompleteOrderProcess object:nil];
}

#pragma mark - Override

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.imageViewLaunchScreen)
    {
        self.imageViewLaunchScreen.frame = self.view.bounds;
    }
    if (self.viewLoading)
    {
        CGSize ratio = [Utility sizeRatioAccordingTo320x480];
        self.viewLoading.indicatorCenter = CGPointMake(self.imageViewLaunchScreen.center.x, 300.0 * ratio.height);
        self.viewLoading.frame = self.view.bounds;
    }
    if (self.tbControllerMain)
    {
        [self.tbControllerMain.view setFrame:self.view.bounds];
        [self.tbControllerMain.view setNeedsLayout];
    }
}

- (UIImageView *)imageViewLaunchScreen
{
    if (_imageViewLaunchScreen == nil)
    {
        _imageViewLaunchScreen = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageViewLaunchScreen setBackgroundColor:[UIColor whiteColor]];
        [_imageViewLaunchScreen setContentMode:UIViewContentModeScaleAspectFit];
        UIImage *image = [UIImage imageNamed:@"LaunchImage"];
        if (image)
        {
            [_imageViewLaunchScreen setImage:image];
        }
    }
    return _imageViewLaunchScreen;
}

- (FullScreenLoadingView *)viewLoading
{
    if (_viewLoading == nil)
    {
        _viewLoading = [[FullScreenLoadingView alloc] initWithFrame:CGRectZero withActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _viewLoading.alpha = 0.0;
    }
    return _viewLoading;
}

#pragma mark - Private Methods

- (void)showLaunchScreenLoadingViewAnimated:(BOOL)animated
{
    [self.viewLoading.activityIndicator startAnimating];
    if (animated)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
            [self.imageViewLaunchScreen setAlpha:1.0];
            [self.viewLoading setAlpha:1.0];
        } completion:nil];
    }
    else
    {
        [self.imageViewLaunchScreen setAlpha:1.0];
        [self.viewLoading setAlpha:1.0];
    }
}

- (void)hideLaunchScreenLoadingViewAnimated:(BOOL)animated
{
    [self.viewLoading.activityIndicator stopAnimating];
    if (animated)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
            [self.imageViewLaunchScreen setAlpha:0.0];
            [self.viewLoading setAlpha:0.0];
        } completion:nil];
    }
    else
    {
        [self.imageViewLaunchScreen setAlpha:0.0];
        [self.viewLoading setAlpha:0.0];
    }
}

- (void)postUserLogoutProcedure
{
    [self JumpToTab:0];
}

- (void)JumpToTab:(NSInteger)tabIndex
{
    if (tabIndex == self.tbControllerMain.selectedIndex)
        return;
    __weak ViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tbControllerMain setSelectedIndex:tabIndex];
        UINavigationController *navigationController = (UINavigationController *)[weakSelf.tbControllerMain.viewControllers objectAtIndex:tabIndex];
        [navigationController popToRootViewControllerAnimated:NO];
    });
}

- (void)updateCartBadge
{
    for (UINavigationController *navigationViewController in self.tbControllerMain.viewControllers)
    {
        UIViewController *viewController = [[navigationViewController viewControllers] objectAtIndex:0];
        if ([viewController isKindOfClass:[CartViewController class]])
        {
            NSInteger totalCount = [[TMInfoManager sharedManager] numberOfProductsInCart:CartTypeTotal];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (totalCount > 0)
                {
                    NSString *stringValue = [NSString stringWithFormat:@"%li", (long)totalCount];
                    [navigationViewController.tabBarItem setBadgeValue:stringValue];
                }
                else
                {
                    [navigationViewController.tabBarItem setBadgeValue:nil];
                }
            });
            break;
        }
    }
}

- (void)updateFavoriteBadge
{
    for (UINavigationController *navigationViewController in self.tbControllerMain.viewControllers)
    {
        UIViewController *viewController = [[navigationViewController viewControllers] objectAtIndex:0];
        if ([viewController isKindOfClass:[FavoriteViewController class]])
        {
            NSInteger totalCount = [[TMInfoManager sharedManager] numberOfProductsInFavorite];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (totalCount > 0)
                {
                    NSString *stringValue = [NSString stringWithFormat:@"%li", (long)totalCount];
                    [navigationViewController.tabBarItem setBadgeValue:stringValue];
                }
                else
                {
                    [navigationViewController.tabBarItem setBadgeValue:nil];
                }
            });
            break;
        }
    }
}

#pragma mark - Public Methods

- (void)checkToShowIntroduce
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([TMInfoManager sharedManager].userIdentifier == nil)
        {
            NSNumber *numberBool = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_IntroduceShown];
            if (numberBool == nil || [numberBool boolValue] == NO)
            {
                IntroduceViewController *viewController = [[IntroduceViewController alloc] initWithNibName:@"IntroduceViewController" bundle:[NSBundle mainBundle]];
                [self presentViewController:viewController animated:NO completion:nil];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:UserDefault_IntroduceShown];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    });
}

#pragma mark - NSNotification Handler

- (void)handlerOfNoInitialTokenNotification:(NSNotification *)notification
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString CannotLoadData] message:[LocalizedString PleaseTryAgainLater] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:[LocalizedString Reload] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [[TMInfoManager sharedManager] retrieveToken:nil];
    }];
    [alertController addAction:retryAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handlerOfEntranceDataPreparedNotification:(NSNotification *)notification
{
    self.initialized = YES;
    [self hideLaunchScreenLoadingViewAnimated:YES];
}

- (void)handlerOfUserLogoutNotification:(NSNotification *)notification
{
    [self postUserLogoutProcedure];
    [self updateCartBadge];
    [self updateFavoriteBadge];
}

- (void)handlerOfJumpingToMemberTabNotification:(NSNotification *)notification
{
    [self JumpToTab:4];
}

- (void)handlerOfJumpingToMemberTabAndPresentCouponNotification:(NSNotification *)notification
{
    [self JumpToTab:4];
    UINavigationController *navigationController = [[self.tbControllerMain viewControllers] objectAtIndex:4];
    if ([navigationController.topViewController isKindOfClass:[MemberViewController class]] == NO)
    {
        [navigationController popToRootViewControllerAnimated:NO];
    }
    CouponListViewController *viewController = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:[NSBundle mainBundle]];
    [navigationController pushViewController:viewController animated:YES];
}

- (void)handlerOfCartContentChangedNotification:(NSNotification *)notification
{
    [self updateCartBadge];
}

- (void)handlerOfApplicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self checkToShowIntroduce];
}

- (void)handlerOfJumpToShoppingMallAndPresentHallNotification:(NSNotification *)notification
{
//    NSLog(@"notification.userInfo:\n%@", notification.userInfo);
    NSString *hallId = [notification.userInfo objectForKey:SymphoxAPIParam_hallId];
    NSString *hallName = [notification.userInfo objectForKey:SymphoxAPIParam_hallName];
    NSNumber *layer = [notification.userInfo objectForKey:SymphoxAPIParam_layer];
    NSInteger tabIndex = 1;
    [self JumpToTab:tabIndex];
    UINavigationController *navigationController = [self.tbControllerMain.viewControllers objectAtIndex:tabIndex];
    if ([navigationController.topViewController isKindOfClass:[ShoppingMallViewController class]] == NO)
    {
        [navigationController popToRootViewControllerAnimated:NO];
    }
    ShoppingMallViewController *shoppingViewController = (ShoppingMallViewController *)navigationController.topViewController;
    [shoppingViewController presentProductListViewForIdentifier:hallId named:hallName andLayer:layer];
}

- (void)handlerOfFavoriteContentChangedNotification:(NSNotification *)notification
{
    [self updateFavoriteBadge];
}

- (void)handlerOfCompleteOrderProcessNotification:(NSNotification *)notification
{
    [self JumpToTab:0];
    [[TMInfoManager sharedManager] retrievePointDataFromObject:self withCompletion:nil];
    [[TMInfoManager sharedManager] retrieveCouponDataFromObject:self forPageIndex:1 couponState:CouponStateNotUsed sortFactor:SymphoxAPIParamValue_worth withSortOrder:SymphoxAPIParamValue_desc withCompletion:nil];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL shouldSelect = YES;
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        UIViewController *rootViewController = [[navigationController viewControllers] objectAtIndex:0];
        if ([rootViewController isKindOfClass:[MemberViewController class]] || [rootViewController isKindOfClass:[CartViewController class]])
        {
            // Should check user state here.
            if ([TMInfoManager sharedManager].userIdentifier == nil)
            {
                shouldSelect = NO;
                    
                LoginViewController *viewControllerLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerLogin];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
        }
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:logPara_主選單 _:rootViewController.title]
                          action:logPara_點擊
                          label:nil
                          value:nil] build]];
        
    }
    return shouldSelect;
}

@end
