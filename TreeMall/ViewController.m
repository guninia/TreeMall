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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *vControllerArray = [NSMutableArray array];
    EntranceViewController *vControllerEntrance = [[EntranceViewController alloc] initWithNibName:@"EntranceViewController" bundle:[NSBundle mainBundle]];
    if (vControllerEntrance != nil)
    {
        vControllerEntrance.title = [LocalizedString Homepage];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerEntrance];
        [vControllerArray addObject:navigationController];
    }
    
    ShoppingMallViewController *vControllerShoppingMall = [[ShoppingMallViewController alloc] initWithNibName:@"ShoppingMallViewController" bundle:[NSBundle mainBundle]];
    if (vControllerShoppingMall != nil)
    {
        vControllerShoppingMall.title = [LocalizedString ProductOverview];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerShoppingMall];
        [vControllerArray addObject:navigationController];
    }
    
    CartViewController *vControllerCart = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:[NSBundle mainBundle]];
    if (vControllerCart != nil)
    {
        vControllerCart.title = [LocalizedString ShoppingCart];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerCart];
        [vControllerArray addObject:navigationController];
    }
    
    FavoriteViewController *vControllerFavorite = [[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:[NSBundle mainBundle]];
    if (vControllerFavorite != nil)
    {
        vControllerFavorite.title = [LocalizedString MyFavorite];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerFavorite];
        [vControllerArray addObject:navigationController];
    }
    
    MemberViewController *vControllerMember = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:[NSBundle mainBundle]];
    if (vControllerMember != nil)
    {
        vControllerMember.title = [LocalizedString Member];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vControllerMember];
        [vControllerArray addObject:navigationController];
    }
    
    _tbControllerMain = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    _tbControllerMain.delegate = self;
    [_tbControllerMain setViewControllers:vControllerArray];
    
    [self addChildViewController:_tbControllerMain];
    [self.view addSubview:_tbControllerMain.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL shouldSelect = YES;
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        UIViewController *rootViewController = [[navigationController viewControllers] objectAtIndex:0];
        if ([rootViewController isKindOfClass:[MemberViewController class]])
        {
            // Should check user state here.
            shouldSelect = NO;
            LoginViewController *viewControllerLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerLogin];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
    }
    return shouldSelect;
}

@end
