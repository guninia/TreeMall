//
//  AuthenticateViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "AuthenticateViewController.h"
#import "Definition.h"

@interface AuthenticateViewController ()

- (IBAction)buttonAuthenticatePressed:(id)sender;
- (IBAction)buttonClosePressed:(id)sender;

@end

@implementation AuthenticateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _labelTitle.textColor = TMMainColor;
    _labelTitle.backgroundColor = [UIColor clearColor];
    
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

- (void)setTextDescription:(NSString *)textDescription
{
    if ([_textDescription isEqualToString:textDescription])
        return;
    _textDescription = textDescription;
    [_labelDescription setText:_textDescription];
}

- (void)setTextContent:(NSString *)textContent
{
    if ([_textContent isEqualToString:textContent])
        return;
    _textContent = textContent;
    
    // Customize the UI.
}

#pragma mark - Actions

- (IBAction)buttonAuthenticatePressed:(id)sender
{
    
}

- (IBAction)buttonClosePressed:(id)sender
{
    
}

@end
