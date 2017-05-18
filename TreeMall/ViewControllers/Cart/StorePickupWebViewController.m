//
//  StorePickupWebViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/17.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "StorePickupWebViewController.h"

@interface StorePickupWebViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation StorePickupWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.group == ConvenienceStoreGroupSevenEleven)
    {
        
    }
    else
    {
        
    }
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
