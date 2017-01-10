//
//  LoginViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "LoginViewController.h"
#import "LocalizedString.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>

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
    [_imageViewLogo setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_imageViewLogo];
    
    _textFieldAccount = [[UITextField alloc] initWithFrame:CGRectZero];
    [_textFieldAccount setBorderStyle:UITextBorderStyleRoundedRect];
    [_textFieldAccount setPlaceholder:[LocalizedString Account]];
    [_textFieldAccount setKeyboardType:UIKeyboardTypeEmailAddress];
    [_textFieldAccount setReturnKeyType:UIReturnKeyDone];
    [_textFieldAccount setAutocorrectionType:UITextAutocorrectionTypeNo];
    _textFieldAccount.delegate = self;
    [self.view addSubview:_textFieldAccount];
    
    _textFieldPassword = [[UITextField alloc] initWithFrame:CGRectZero];
    [_textFieldPassword setBorderStyle:UITextBorderStyleRoundedRect];
    [_textFieldPassword setPlaceholder:[LocalizedString Password]];
    [_textFieldPassword setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textFieldPassword setReturnKeyType:UIReturnKeyDone];
    [_textFieldPassword setSecureTextEntry:YES];
    [_textFieldPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    _textFieldPassword.delegate = self;
    [self.view addSubview:_textFieldPassword];
    
    _buttonLogin = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonLogin.layer setCornerRadius:5.0];
    [_buttonLogin setBackgroundColor:[UIColor colorWithRed:(152.0/255.0) green:(194.0/255.0) blue:(68.0/255.0) alpha:1.0]];
    [_buttonLogin setTitle:[LocalizedString Login] forState:UIControlStateNormal];
    [_buttonLogin addTarget:self action:@selector(actButtonLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonLogin];
    
    _separatorHorizon = [[TextHorizontalSeparator alloc] initWithFrame:CGRectZero];
    _separatorHorizon.tintColor = [UIColor lightGrayColor];
//    _separatorHorizon.backgroundColor = [UIColor redColor];
    _separatorHorizon.text = @"OR";
    [self.view addSubview:_separatorHorizon];
    
    _buttonFacebookLogin = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonFacebookLogin.layer setCornerRadius:5.0];
    [_buttonFacebookLogin setBackgroundColor:[UIColor colorWithRed:(140.0/255.0) green:(172.0/255.0) blue:(240.0/255.0) alpha:1.0]];
    [_buttonFacebookLogin setTitle:[LocalizedString facebookAccountLogin] forState:UIControlStateNormal];
    [_buttonFacebookLogin addTarget:self action:@selector(actButtonFacebookAccountLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonFacebookLogin];
    
    _buttonGooglePlusLogin = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonGooglePlusLogin.layer setCornerRadius:5.0];
    [_buttonGooglePlusLogin setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(64.0/255.0) blue:(54.0/255.0) alpha:1.0]];
    [_buttonGooglePlusLogin setTitle:[LocalizedString googlePlusAccountLogin] forState:UIControlStateNormal];
    [_buttonGooglePlusLogin addTarget:self action:@selector(actButtonGooglePlusAccountLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonGooglePlusLogin];
    
    _checkButtonAgreement = [[UIButton alloc] initWithFrame:CGRectZero];
    [_checkButtonAgreement setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_checkButtonAgreement setTitle:@"我什麼都同意" forState:UIControlStateNormal];
    [_checkButtonAgreement.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_checkButtonAgreement addTarget:self action:@selector(actCheckButtonAgreementPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkButtonAgreement];
    
    _buttonAgreementContent = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonAgreementContent.layer setCornerRadius:3.0];
    [_buttonAgreementContent setBackgroundColor:[UIColor grayColor]];
    [_buttonAgreementContent setTitle:@"詳細內容" forState:UIControlStateNormal];
    [_buttonAgreementContent.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_buttonAgreementContent addTarget:self action:@selector(actButtonAgreementContentPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonAgreementContent];
    
    _buttonJoinMember = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonJoinMember setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_buttonJoinMember setTitle:@"加入會員" forState:UIControlStateNormal];
    [_buttonJoinMember.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_buttonJoinMember addTarget:self action:@selector(actButtonJoinMemberPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonJoinMember];
    
    _separatorVertical = [[UIView alloc] initWithFrame:CGRectZero];
    [_separatorVertical setBackgroundColor:[_buttonJoinMember titleColorForState:UIControlStateNormal]];
    [self.view addSubview:_separatorVertical];
    
    _buttonForgetpassword = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonForgetpassword setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_buttonForgetpassword setTitle:@"忘記密碼" forState:UIControlStateNormal];
    [_buttonForgetpassword.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_buttonForgetpassword addTarget:self action:@selector(actButtonForgetPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonForgetpassword];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize sizeRatio = [Utility sizeRatioAccordingTo320x480];
    CGSize logoSize = CGSizeMake(self.view.frame.size.width, 100.0 * sizeRatio.height);
    CGSize columnSize = CGSizeMake(280.0, 40.0);
    CGFloat columnOriginX = ceil((self.view.frame.size.width - columnSize.width)/2);
    CGFloat vInterval = 10.0 * sizeRatio.height;
    
    CGFloat originY = 0.0;
    if (_imageViewLogo != nil)
    {
        CGRect frame = _imageViewLogo.frame;
        frame.size.width = logoSize.width;
        frame.size.height = logoSize.height;
        _imageViewLogo.frame = frame;
        originY = _imageViewLogo.frame.origin.y + _imageViewLogo.frame.size.height + vInterval;
    }
    if (_textFieldAccount != nil)
    {
        CGRect frame = _textFieldAccount.frame;
        frame.origin.x = columnOriginX;
        frame.origin.y = originY;
        frame.size.width = columnSize.width;
        frame.size.height = columnSize.height;
        _textFieldAccount.frame = frame;
        originY = _textFieldAccount.frame.origin.y + _textFieldAccount.frame.size.height + vInterval;
    }
    if (_textFieldPassword != nil)
    {
        CGRect frame = _textFieldPassword.frame;
        frame.origin.x = columnOriginX;
        frame.origin.y = originY;
        frame.size.width = columnSize.width;
        frame.size.height = columnSize.height;
        _textFieldPassword.frame = frame;
        originY = _textFieldPassword.frame.origin.y + _textFieldPassword.frame.size.height + vInterval;
    }
    if (_buttonLogin != nil)
    {
        CGRect frame = _buttonLogin.frame;
        frame.origin.x = columnOriginX;
        frame.origin.y = originY;
        frame.size.width = columnSize.width;
        frame.size.height = columnSize.height;
        _buttonLogin.frame = frame;
        originY = _buttonLogin.frame.origin.y + _buttonLogin.frame.size.height + vInterval;
    }
    if (_separatorHorizon != nil)
    {
        CGRect frame = _separatorHorizon.frame;
        frame.origin.x = columnOriginX;
        frame.origin.y = originY;
        frame.size.width = columnSize.width;
        frame.size.height = columnSize.height;
        _separatorHorizon.frame = frame;
        originY = _separatorHorizon.frame.origin.y + _separatorHorizon.frame.size.height + vInterval;
    }
    if (_buttonFacebookLogin != nil)
    {
        CGRect frame = _buttonFacebookLogin.frame;
        frame.origin.x = columnOriginX;
        frame.origin.y = originY;
        frame.size.width = columnSize.width;
        frame.size.height = columnSize.height;
        _buttonFacebookLogin.frame = frame;
        originY = _buttonFacebookLogin.frame.origin.y + _buttonFacebookLogin.frame.size.height + vInterval;
    }
    if (_buttonGooglePlusLogin != nil)
    {
        CGRect frame = _buttonGooglePlusLogin.frame;
        frame.origin.x = columnOriginX;
        frame.origin.y = originY;
        frame.size.width = columnSize.width;
        frame.size.height = columnSize.height;
        _buttonGooglePlusLogin.frame = frame;
        originY = _buttonGooglePlusLogin.frame.origin.y + _buttonGooglePlusLogin.frame.size.height + vInterval;
    }
    if (_checkButtonAgreement != nil && _buttonAgreementContent != nil)
    {
        // Temporarily for pre-layout, should use real size later.
        CGSize checkButtonSize = CGSizeMake(200.0, 30.0);
        CGSize buttonSize = CGSizeMake(60.0, 20.0);
        CGFloat hInterval = 5 * sizeRatio.width;
        CGFloat totalWidth = checkButtonSize.width + hInterval + buttonSize.width;
        CGFloat checkButtonOriginX = ceil((self.view.frame.size.width - totalWidth)/2);
        
        CGRect frame = _checkButtonAgreement.frame;
        frame.origin.x = checkButtonOriginX;
        frame.origin.y = originY;
        frame.size.width = checkButtonSize.width;
        frame.size.height = checkButtonSize.height;
        _checkButtonAgreement.frame = frame;
        
        frame = _buttonAgreementContent.frame;
        frame.origin.x = _checkButtonAgreement.frame.origin.x + _checkButtonAgreement.frame.size.width + hInterval;
        frame.origin.y = ceil(_checkButtonAgreement.center.y - buttonSize.height / 2);
        frame.size.width = buttonSize.width;
        frame.size.height = buttonSize.height;
        _buttonAgreementContent.frame = frame;
        
        originY = _checkButtonAgreement.frame.origin.y + _checkButtonAgreement.frame.size.height + vInterval;
    }
    if (_buttonJoinMember != nil && _buttonForgetpassword != nil)
    {
        CGSize buttonSize = CGSizeMake(60.0, 20.0);
        CGFloat separatorLineWidth = 1.0;
        CGFloat hInterval = 5.0 * sizeRatio.width;
        CGFloat totalWidth = buttonSize.width * 2 + hInterval * 2 + separatorLineWidth;
        CGFloat buttonOriginX = ceil((self.view.frame.size.width - totalWidth)/2);
        CGRect frame = _buttonJoinMember.frame;
        frame.origin.x = buttonOriginX;
        frame.origin.y = originY;
        frame.size.width = buttonSize.width;
        frame.size.height = buttonSize.height;
        _buttonJoinMember.frame = frame;
        
        frame.origin.x = _buttonJoinMember.frame.origin.x + _buttonJoinMember.frame.size.width + hInterval;
        frame.origin.y = originY;
        frame.size.width = separatorLineWidth;
        frame.size.height = _buttonJoinMember.frame.size.height;
        _separatorVertical.frame = frame;
        
        frame.origin.x = _separatorVertical.frame.origin.x + _separatorVertical.frame.size.width + hInterval;
        frame.origin.y = originY;
        frame.size.width = buttonSize.width;
        frame.size.height = buttonSize.height;
        _buttonForgetpassword.frame = frame;
        
        originY = _buttonJoinMember.frame.origin.y + _buttonJoinMember.frame.size.height + vInterval;
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

