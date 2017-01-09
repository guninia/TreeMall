//
//  ViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ViewController.h"
#import "EntranceViewController.h"
#import "ShoppingMallViewController.h"
#import "CartViewController.h"
#import "FavoriteViewController.h"
#import "MemberViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *vControllerArray = [NSMutableArray array];
    EntranceViewController *vControllerEntrance = [[EntranceViewController alloc] initWithNibName:@"EntranceViewController" bundle:[NSBundle mainBundle]];
    [vControllerArray addObject:vControllerEntrance];
    
    ShoppingMallViewController *vControllerShoppingMall = [[ShoppingMallViewController alloc] initWithNibName:@"ShoppingMallViewController" bundle:[NSBundle mainBundle]];
    [vControllerArray addObject:vControllerShoppingMall];
    
    CartViewController *vControllerCart = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:[NSBundle mainBundle]];
    [vControllerArray addObject:vControllerCart];
    
    FavoriteViewController *vControllerFavorite = [[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:[NSBundle mainBundle]];
    [vControllerArray addObject:vControllerFavorite];
    
    MemberViewController *vControllerMember = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:[NSBundle mainBundle]];
    [vControllerArray addObject:vControllerMember];
    
    _tbControllerMain = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    [_tbControllerMain setViewControllers:vControllerArray];
    
    [self addChildViewController:_tbControllerMain];
    [self.view addSubview:_tbControllerMain.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
