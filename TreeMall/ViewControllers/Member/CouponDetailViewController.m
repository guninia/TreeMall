//
//  CouponDetailViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/3.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "LocalizedString.h"

@interface CouponDetailViewController ()

@end

@implementation CouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setTitle:[LocalizedString CouponDetail]];
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

@end
