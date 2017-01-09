//
//  LoginViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "LoginViewController.h"
#import "LocalizedString.h"

@interface LoginViewController ()

- (void)actButtonLoginPressed:(id)sender;
- (void)actButtonFacebookAccountLoginPressed:(id)sender;
- (void)actButtonGooglePlusAccountLoginPressed:(id)sender;
- (void)actCheckButtonAgreementPressed:(id)sender;
- (void)actButtonAgreementContentPressed:(id)sender;
- (void)actButtonJoinMemberPressed:(id)sender;
- (void)actButtonForgetPasswordPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageViewLogo setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_imageViewLogo];
    
    _textFieldAccount = [[UITextField alloc] initWithFrame:CGRectZero];
    [_textFieldAccount setBorderStyle:UITextBorderStyleRoundedRect];
    [_textFieldAccount setPlaceholder:[LocalizedString Account]];
    [_textFieldAccount setKeyboardType:UIKeyboardTypeEmailAddress];
    [_textFieldAccount setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:_textFieldAccount];
    
    _textFieldPassword = [[UITextField alloc] initWithFrame:CGRectZero];
    [_textFieldPassword setBorderStyle:UITextBorderStyleRoundedRect];
    [_textFieldPassword setPlaceholder:[LocalizedString Password]];
    [_textFieldPassword setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textFieldPassword setReturnKeyType:UIReturnKeyDone];
    [_textFieldPassword setSecureTextEntry:YES];
    [self.view addSubview:_textFieldPassword];
    
    _buttonLogin = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonLogin setBackgroundColor:[UIColor colorWithRed:(130.0/255.0) green:(188.0/255.0) blue:(30.0/255.0) alpha:1.0]];
    [_buttonLogin setTitle:[LocalizedString Login] forState:UIControlStateNormal];
    [_buttonLogin addTarget:self action:@selector(actButtonLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonLogin];
    
    _buttonFacebookLogin = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonFacebookLogin setBackgroundColor:[UIColor colorWithRed:(123.0/255.0) green:(163.0/255.0) blue:(245.0/255.0) alpha:1.0]];
    [_buttonFacebookLogin setTitle:[LocalizedString facebookAccountLogin] forState:UIControlStateNormal];
    [_buttonFacebookLogin addTarget:self action:@selector(actButtonFacebookAccountLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonFacebookLogin];
    
    _buttonGooglePlusLogin = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonGooglePlusLogin setBackgroundColor:[UIColor colorWithRed:(246.0) green:(35.0) blue:(36.0) alpha:1.0]];
    [_buttonGooglePlusLogin setTitle:[LocalizedString googlePlusAccountLogin] forState:UIControlStateNormal];
    [_buttonGooglePlusLogin addTarget:self action:@selector(actButtonGooglePlusAccountLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonGooglePlusLogin];
    
    _checkButtonAgreement = [[UIButton alloc] initWithFrame:CGRectZero];
    [_checkButtonAgreement setTitle:@"我什麼都同意" forState:UIControlStateNormal];
    [_checkButtonAgreement addTarget:self action:@selector(actCheckButtonAgreementPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkButtonAgreement];
    
    _buttonAgreementContent = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonAgreementContent setTitle:@"詳細內容" forState:UIControlStateNormal];
    [_buttonAgreementContent addTarget:self action:@selector(actButtonAgreementContentPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonAgreementContent];
    
    _buttonJoinMember = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonJoinMember setTitle:@"加入會員" forState:UIControlStateNormal];
    [_buttonJoinMember addTarget:self action:@selector(actButtonJoinMemberPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonJoinMember];
    
    _buttonForgetpassword = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonForgetpassword setTitle:@"忘記密碼" forState:UIControlStateNormal];
    [_buttonForgetpassword addTarget:self action:@selector(actButtonForgetPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonForgetpassword];
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

#pragma mark - Actions

- (void)actButtonLoginPressed:(id)sender
{
    
}

- (void)actButtonFacebookAccountLoginPressed:(id)sender
{
    
}

- (void)actButtonGooglePlusAccountLoginPressed:(id)sender
{
    
}

- (void)actCheckButtonAgreementPressed:(id)sender
{
    
}

- (void)actButtonAgreementContentPressed:(id)sender
{
    
}

- (void)actButtonJoinMemberPressed:(id)sender
{
    
}

- (void)actButtonForgetPasswordPressed:(id)sender
{
    
}

@end

