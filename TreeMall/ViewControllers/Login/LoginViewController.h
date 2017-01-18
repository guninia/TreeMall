//
//  LoginViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextHorizontalSeparator.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) UIImageView *imageViewLogo;
@property (nonatomic, strong) UITextField *textFieldAccount;
@property (nonatomic, strong) UITextField *textFieldPassword;
@property (nonatomic, strong) UIButton *buttonLogin;
@property (nonatomic, strong) TextHorizontalSeparator *separatorHorizon;
@property (nonatomic, strong) UIButton *buttonFacebookLogin;
@property (nonatomic, strong) UIButton *buttonGooglePlusLogin;
@property (nonatomic, strong) UIButton *checkButtonAgreement;
@property (nonatomic, strong) UIButton *buttonAgreementContent;
@property (nonatomic, strong) UIButton *buttonJoinMember;
@property (nonatomic, strong) UIView *separatorVertical;
@property (nonatomic, strong) UIButton *buttonForgetpassword;

@end
