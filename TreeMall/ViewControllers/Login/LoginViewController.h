//
//  LoginViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) UIImageView *imageViewLogo;
@property (nonatomic, strong) UITextField *textFieldAccount;
@property (nonatomic, strong) UITextField *textFieldPassword;
@property (nonatomic, strong) UIButton *buttonLogin;
@property (nonatomic, strong) UIButton *buttonFacebookLogin;
@property (nonatomic, strong) UIButton *buttonGooglePlusLogin;
@property (nonatomic, strong) UIButton *checkButtonAgreement;
@property (nonatomic, strong) UIButton *buttonAgreementContent;
@property (nonatomic, strong) UIButton *buttonJoinMember;
@property (nonatomic, strong) UIButton *buttonForgetpassword;

@end
