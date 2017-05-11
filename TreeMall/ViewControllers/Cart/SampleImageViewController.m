//
//  SampleImageViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "SampleImageViewController.h"

@interface SampleImageViewController ()

- (void)buttonImagePressed:(id)sender;

@end

@implementation SampleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.buttonImage];
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
    if (self.buttonImage)
    {
        [self.buttonImage setFrame:self.view.bounds];
    }
}

- (UIButton *)buttonImage
{
    if (_buttonImage == nil)
    {
        _buttonImage = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonImage addTarget:self action:@selector(buttonImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonImage;
}

#pragma mark - Actions

- (void)buttonImagePressed:(id)sender
{
    if (self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
