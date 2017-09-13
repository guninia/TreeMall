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
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "TMInfoManager.h"
#import "Definition.h"
#import "TermsViewController.h"
#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface LoginViewController () {
    id<GAITracker> gaTracker;
}

- (void)loginFacebook;
- (void)retrieveFacebookData;
- (void)signInGoogle;
- (void)registerWithOptions:(NSDictionary *)options andType:(NSString *)type;
- (BOOL)processRegisterData:(NSData *)data;
- (void)startPreloginProcess;
- (void)loginWithOptions:(NSDictionary *)options;
- (BOOL)processLoginData:(NSData *)data;
- (void)presentSimpleAlertViewForMessage:(NSString *)message;

- (void)actButtonLoginPressed:(id)sender;
- (void)actButtonFacebookAccountLoginPressed:(id)sender;
- (void)actButtonGooglePlusAccountLoginPressed:(id)sender;
- (void)actCheckButtonAgreementPressed:(id)sender;
- (void)actButtonAgreementContentPressed:(id)sender;
- (void)actButtonJoinMemberPressed:(id)sender;
- (void)actButtonForgetPasswordPressed:(id)sender;
- (void)actButtonClosePressed:(id)sender;

- (void)facebookTokenDidChangeNotification:(NSNotification *)notification;
- (void)facebookProfileDidChangeNotification:(NSNotification *)notification;
- (void)userDidLoggedInNotification:(NSNotification *)notification;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *image = [UIImage imageNamed:@"log_ico_logo"];
    if (image)
    {
        [_imageViewLogo setImage:image];
    }
    [_imageViewLogo setBackgroundColor:[UIColor clearColor]];
    [_imageViewLogo setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_imageViewLogo];
    
    _textFieldAccount = [[UITextField alloc] initWithFrame:CGRectZero];
    [_textFieldAccount setBorderStyle:UITextBorderStyleRoundedRect];
    [_textFieldAccount setPlaceholder:[LocalizedString PleaseInputEmailOrIdNumber]];
    [_textFieldAccount setKeyboardType:UIKeyboardTypeEmailAddress];
    [_textFieldAccount setReturnKeyType:UIReturnKeyDone];
    [_textFieldAccount setAutocapitalizationType:UITextAutocapitalizationTypeNone];
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
    [_textFieldPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _textFieldPassword.delegate = self;
    [self.view addSubview:_textFieldPassword];
    
    _buttonLogin = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buttonLogin.layer setCornerRadius:5.0];
    [_buttonLogin setBackgroundColor:[UIColor colorWithRed:(132.0/255.0) green:(187.0/255.0) blue:(29.0/255.0) alpha:1.0]];
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
    [_buttonFacebookLogin setBackgroundColor:[UIColor colorWithRed:(124.0/255.0) green:(163.0/255.0) blue:(243.0/255.0) alpha:1.0]];
    [_buttonFacebookLogin setTitle:[LocalizedString facebookAccountLogin] forState:UIControlStateNormal];
    [_buttonFacebookLogin addTarget:self action:@selector(actButtonFacebookAccountLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonFacebookLogin];
    
    _switchAgreement = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_switchAgreement];
    
    _checkButtonAgreement = [[UIButton alloc] initWithFrame:CGRectZero];
    [_checkButtonAgreement setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_checkButtonAgreement setTitle:@"我同意會員條款" forState:UIControlStateNormal];
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
    
    _buttonClose = [[UIButton alloc] initWithFrame:CGRectZero];
    if (_buttonClose)
    {
        UIImage *image = [UIImage imageNamed:@"car_popup_close"];
        if (image)
        {
            [_buttonClose setImage:image forState:UIControlStateNormal];
        }
        [_buttonClose addTarget:self action:@selector(actButtonClosePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_buttonClose];
    }
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    NSString *googleServiceInfoPath = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist"];
    NSDictionary *googleInfo = [NSDictionary dictionaryWithContentsOfFile:googleServiceInfoPath];
    if (googleInfo)
    {
        NSString *clientId = [googleInfo objectForKey:@"CLIENT_ID"];
        NSLog(@"googleInfo:\n%@", googleInfo);
        if (clientId)
        {
            [GIDSignIn sharedInstance].clientID = clientId;
            [GIDSignIn sharedInstance].delegate = self;
            [GIDSignIn sharedInstance].uiDelegate = self;
            
            _buttonGooglePlusLogin = [[UIButton alloc] initWithFrame:CGRectZero];
            [_buttonGooglePlusLogin.layer setCornerRadius:5.0];
            [_buttonGooglePlusLogin setBackgroundColor:[UIColor colorWithRed:(248.0/255.0) green:(34.0/255.0) blue:(35.0/255.0) alpha:1.0]];
            [_buttonGooglePlusLogin setTitle:[LocalizedString googlePlusAccountLogin] forState:UIControlStateNormal];
            [_buttonGooglePlusLogin addTarget:self action:@selector(actButtonGooglePlusAccountLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_buttonGooglePlusLogin];
        }
    }
    if (self.navigationController.tabBarController != nil)
    {
        [self.navigationController.tabBarController.view addSubview:self.viewLoading];
    }
    else if (self.navigationController != nil)
    {
        [self.navigationController.view addSubview:self.viewLoading];
    }
    else
    {
        [self.view addSubview:self.viewLoading];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookTokenDidChangeNotification:) name:FBSDKAccessTokenDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookProfileDidChangeNotification:) name:FBSDKProfileDidChangeNotification object:nil];
    
    gaTracker = [GAI sharedInstance].defaultTracker;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.navigationController)
    {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoggedInNotification:) name:PostNotificationName_UserLoggedIn object:nil];
    
    // GA screen log
    [gaTracker set:kGAIScreenName value:logPara_登入];
    [gaTracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserLoggedIn object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKAccessTokenDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize sizeRatio = [Utility sizeRatioAccordingTo320x480];
    CGSize logoSize = CGSizeMake(158.0 * sizeRatio.height, 60.0 * sizeRatio.height);
    CGSize columnSize = CGSizeMake(280.0, 40.0);
    CGFloat columnOriginX = ceil((self.view.frame.size.width - columnSize.width)/2);
    CGFloat vInterval = 10.0 * sizeRatio.height;
    
    CGFloat originY = 60.0 * sizeRatio.height;
    if (_imageViewLogo != nil)
    {
        CGRect frame = _imageViewLogo.frame;
        frame.origin.x = (self.view.frame.size.width - logoSize.width)/2;
        frame.origin.y = originY;
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
        originY = _buttonLogin.frame.origin.y + _buttonLogin.frame.size.height;
    }
    if (_separatorHorizon != nil)
    {
        CGRect frame = _separatorHorizon.frame;
        frame.origin.x = columnOriginX;
        frame.origin.y = originY;
        frame.size.width = columnSize.width;
        frame.size.height = columnSize.height;
        _separatorHorizon.frame = frame;
        originY = _separatorHorizon.frame.origin.y + _separatorHorizon.frame.size.height;
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
    
    if (_switchAgreement != nil)
    {
        CGSize switchSize = CGSizeMake(40.0, 30.0);
        CGRect frame = CGRectMake(columnOriginX, originY, switchSize.width, switchSize.height);
        self.switchAgreement.frame = frame;
    }
    
    if (_checkButtonAgreement != nil && _buttonAgreementContent != nil)
    {
        // Temporarily for pre-layout, should use real size later.
        CGSize checkButtonSize = CGSizeMake(120.0, 30.0);
        CGSize buttonSize = CGSizeMake(60.0, 20.0);
        CGFloat hInterval = 5 * sizeRatio.width;
//        CGFloat totalWidth = checkButtonSize.width + hInterval + buttonSize.width;
        CGFloat checkButtonOriginX = CGRectGetMaxX(self.switchAgreement.frame) + 3.0;
        
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
        
//        originY = _checkButtonAgreement.frame.origin.y + _checkButtonAgreement.frame.size.height + vInterval;
    }
    if (_buttonAgreementContent != nil)
    {
        CGSize buttonSize = CGSizeMake(60.0, 30.0);
        CGRect frame = _buttonAgreementContent.frame;
        frame.origin.x = CGRectGetMaxX(self.checkButtonAgreement.frame) + 3.0;
        frame.origin.y = originY;
        frame.size.width = buttonSize.width;
        frame.size.height = buttonSize.height;
        _buttonAgreementContent.frame = frame;
        
        originY = _buttonAgreementContent.frame.origin.y + _buttonAgreementContent.frame.size.height + vInterval;
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
    if (_buttonClose != nil)
    {
        CGSize size = CGSizeMake(40.0, 40.0);
        [_buttonClose setFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    }
    
    if (self.viewLoading)
    {
        if (self.navigationController.tabBarController != nil)
        {
            self.viewLoading.frame = self.navigationController.tabBarController.view.bounds;
        }
        else if (self.navigationController != nil)
        {
            self.viewLoading.frame = self.navigationController.view.bounds;
        }
        else
        {
            self.viewLoading.frame = self.view.bounds;
        }
        self.viewLoading.indicatorCenter = self.viewLoading.center;
        [self.viewLoading setNeedsLayout];
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

#pragma mark - Override

- (FullScreenLoadingView *)viewLoading
{
    if (_viewLoading == nil)
    {
        _viewLoading = [[FullScreenLoadingView alloc] initWithFrame:CGRectZero];
        [_viewLoading setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        _viewLoading.alpha = 0.0;
    }
    return _viewLoading;
}

#pragma mark - Private Methods

- (void)showLoadingViewAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewLoading.activityIndicator startAnimating];
        if (animated)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                [self.viewLoading setAlpha:1.0];
            } completion:nil];
        }
        else
        {
            [self.viewLoading setAlpha:1.0];
        }
    });
}

- (void)hideLoadingViewAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewLoading.activityIndicator stopAnimating];
        if (animated)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
                [self.viewLoading setAlpha:0.0];
            } completion:nil];
        }
        else
        {
            [self.viewLoading setAlpha:0.0];
        }
    });
}

- (void)loginFacebook
{
    [self showLoadingViewAnimated:YES];
    __weak LoginViewController *weakSelf = self;
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:[NSArray arrayWithObjects:@"public_profile", @"email", nil] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error){
        if (error)
        {
            NSLog(@"Facebook login error:\n%@", error.description);
            [weakSelf hideLoadingViewAnimated:YES];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        else if (result.isCancelled)
        {
            NSLog(@"Facebook login canceled.");
            [weakSelf hideLoadingViewAnimated:YES];
        }
        else
        {
            // Login success, should continue.
            NSLog(@"Facebook login success.");
        }
    }];
}

- (void)retrieveFacebookData
{
    if ([FBSDKProfile currentProfile])
    {
        __weak LoginViewController *weakSelf = self;
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"gender, picture, email", @"fields", nil] HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){
            NSLog(@"result:\n%@", [result description]);
            if (error)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:action];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                [weakSelf hideLoadingViewAnimated:YES];
                return;
            }
            NSString *email = [result objectForKey:@"email"];
            NSString *ipAddress = [Utility ipAddressPreferIPv6:YES];
            if (email != nil && ipAddress != nil)
            {
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:email, SymphoxAPIParam_account, ipAddress, SymphoxAPIParam_ip, nil];
                [weakSelf registerWithOptions:dictionary andType:@"facebook"];
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString CannotLoadData] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:action];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                [weakSelf hideLoadingViewAnimated:YES];
            }
        }];
    }
}

- (void)signInGoogle
{
    [GIDSignIn sharedInstance].scopes = [NSArray arrayWithObjects:@"profile", @"email", nil];
    [[GIDSignIn sharedInstance] signIn];
}

- (void)registerWithOptions:(NSDictionary *)options andType:(NSString *)type
{
    __weak LoginViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [[NSURL URLWithString:SymphoxAPI_register] URLByAppendingPathComponent:type];
    NSLog(@"register url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [self showLoadingViewAnimated:YES];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        NSString *errorMessage = nil;
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
//                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"string[%@]", string);
                if ([self processRegisterData:data])
                {
                    // Should go next step.
                    [[TMInfoManager sharedManager] retrieveUserInformation];
                    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_UserLoggedIn object:nil];

                    if ([type isEqualToString:@"facebook"]) {
                        [gaTracker send:[[GAIDictionaryBuilder
                                          createEventWithCategory:[EventLog twoString:logPara_登入 _:logPara_Facebook帳號]
                                          action:logPara_成功
                                          label:nil
                                          value:nil] build]];
                    } else if ([type isEqualToString:@"google"]) {
                        [gaTracker send:[[GAIDictionaryBuilder
                                          createEventWithCategory:[EventLog twoString:logPara_登入 _:logPara_Google帳號]
                                          action:logPara_成功
                                          label:nil
                                          value:nil] build]];
                    }
                }
                else
                {
                    NSLog(@"Cannot process register data.");
                    errorMessage = [LocalizedString CannotLoadData];
                }
            }
            else
            {
                NSLog(@"Unexpected data format.");
                errorMessage = [LocalizedString CannotLoadData];
            }
        }
        else
        {
            NSLog(@"error:\n%@", [error description]);
            errorMessage = error.localizedDescription;
        }
        if (errorMessage)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:YES];
    }];
}

- (BOOL)processRegisterData:(NSData *)data
{
    BOOL success = NO;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil)
    {
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            [[TMInfoManager sharedManager] updateUserInformationFromInfoDictionary:dictionary afterLoadingArchive:YES];
            [[TMInfoManager sharedManager] retrieveUserInformation];
            success = YES;
        }
    }
    return success;
}

- (void)startPreloginProcess
{
    NSString *account = [[_textFieldAccount text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([Utility evaluateEmail:account] == NO && [Utility evaluateIdCardNumber:account] == NO)
    {
        // Should show alert to modify account.
        NSLog(@"Account is not illegal.");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString AccountInputError] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [_textFieldPassword setText:@""];
            if ([_textFieldAccount canBecomeFirstResponder])
            {
                [_textFieldAccount becomeFirstResponder];
            }
        }];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    NSString *password = [_textFieldPassword text];
    if ([Utility evaluatePassword:password] == NO)
    {
        // Should show alert to modify password.
        NSLog(@"Password is not illegal.");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PasswordInputError] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [_textFieldPassword setText:@""];
            if ([_textFieldAccount canBecomeFirstResponder])
            {
                [_textFieldAccount becomeFirstResponder];
            }
        }];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    // Should start login
    NSString *ipAddress = [Utility ipAddressPreferIPv6:YES];
    if (ipAddress == nil)
    {
        NSLog(@"No ip address");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString SystemErrorTryLater] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:account, SymphoxAPIParam_account, password, SymphoxAPIParam_password, ipAddress, SymphoxAPIParam_ip, nil];
    [self loginWithOptions:options];
}

- (void)loginWithOptions:(NSDictionary *)options
{
    __weak LoginViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_login];
    NSLog(@"login url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [self showLoadingViewAnimated:YES];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:NO decryptedReturnData:NO completion:^(id resultObject, NSError *error){
        NSString *errorDescription = nil;
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
//                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"string[%@]", string);
                // Should continue to process data.
                [weakSelf processLoginData:data];
                [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_UserLoggedIn object:nil];
                
                [gaTracker send:[[GAIDictionaryBuilder
                                  createEventWithCategory:[EventLog twoString:logPara_登入 _:logPara_登入]
                                  action:logPara_成功
                                  label:nil
                                  value:nil] build]];
                
            }
            else
            {
                NSLog(@"Unexpected data format.");
                errorDescription = [LocalizedString UnexpectedFormatFromNetwork];
            }
        }
        else
        {
            NSLog(@"error:\n%@", [error description]);
            NSDictionary *userInfo = error.userInfo;
            errorDescription = [userInfo objectForKey:SymphoxAPIParam_status_desc];
            if (errorDescription == nil)
            {
                errorDescription = error.localizedDescription;
            }
            if (errorDescription == nil)
            {
                errorDescription = [LocalizedString UnknownError];
            }
        }
        if (errorDescription != nil)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString LoginFailed] message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [_textFieldPassword setText:@""];
                if ([_textFieldPassword canBecomeFirstResponder])
                {
                    [_textFieldPassword becomeFirstResponder];
                }
            }];
            [alertController addAction:cancelAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:YES];
    }];
}

- (BOOL)processLoginData:(NSData *)data
{
    BOOL success = NO;
    if (data == nil || [data isEqual:[NSNull null]])
    {
        return success;
    }
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        [[TMInfoManager sharedManager] updateUserInformationFromInfoDictionary:dictionary afterLoadingArchive:YES];
    }
    
    return success;
}

- (void)presentSimpleAlertViewForMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Actions

- (void)actButtonLoginPressed:(id)sender
{
//    if (self.switchAgreement.isOn == NO)
//    {
//        [self presentSimpleAlertViewForMessage:[LocalizedString PleaseAgreeMemberTermsFirst]];
//        return;
//    }
    [self startPreloginProcess];
}

- (void)actButtonFacebookAccountLoginPressed:(id)sender
{
    if (self.switchAgreement.isOn == NO)
    {
        [self presentSimpleAlertViewForMessage:[LocalizedString PleaseAgreeMemberTermsFirst]];
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:logPara_登入 _:logPara_警告]
                          action:logPara_請先同意會員條款
                          label:nil
                          value:nil] build]];
        
        return;
    }
    [self loginFacebook];
}

- (void)actButtonGooglePlusAccountLoginPressed:(id)sender
{
    if (self.switchAgreement.isOn == NO)
    {
        [self presentSimpleAlertViewForMessage:[LocalizedString PleaseAgreeMemberTermsFirst]];
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:logPara_登入 _:logPara_警告]
                          action:logPara_請先同意會員條款
                          label:nil
                          value:nil] build]];
        
        return;
    }
    [self signInGoogle];
}

- (void)actCheckButtonAgreementPressed:(id)sender
{
    [self.switchAgreement setOn:!self.switchAgreement.isOn animated:YES];
    
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:logPara_登入 _:logPara_同意會員條款]
                      action:logPara_點擊
                      label:nil
                      value:nil] build]];
}

- (void)actButtonAgreementContentPressed:(id)sender
{
    TermsViewController *viewController = [[TermsViewController alloc] initWithNibName:@"TermsViewController" bundle:[NSBundle mainBundle]];
    
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:logPara_登入 _:logPara_詳細內容]
                      action:[EventLog to_:logPara_會員條款]
                      label:nil
                      value:nil] build]];
    
    if (self.navigationController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)actButtonJoinMemberPressed:(id)sender
{
    RegisterViewController *viewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]];
    
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:logPara_登入 _:logPara_加入會員]
                      action:viewController.title
                      label:nil
                      value:nil] build]];
    
    if (self.navigationController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)actButtonForgetPasswordPressed:(id)sender
{
    ForgetPasswordViewController *viewController = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:[NSBundle mainBundle]];
    
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:logPara_登入 _:logPara_忘記密碼]
                      action:viewController.title
                      label:nil
                      value:nil] build]];
    
    if (self.navigationController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)actButtonClosePressed:(id)sender
{
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSNotification Handler

- (void)facebookTokenDidChangeNotification:(NSNotification *)notification
{
    NSLog(@"facebookTokenDidChangeNotification");
    if ([FBSDKAccessToken currentAccessToken])
    {
        [self facebookProfileDidChangeNotification:notification];
    }
}

- (void)facebookProfileDidChangeNotification:(NSNotification *)notification
{
    NSLog(@"facebookProfileDidChangeNotification");
    [self retrieveFacebookData];
}

- (void)userDidLoggedInNotification:(NSNotification *)notification
{
    if (self.navigationController)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    NSString *email = user.profile.email;
//    NSLog(@"userId[%@] fullName[%@] email[%@]", userId, fullName, email);
    NSString *ipAddress = [Utility ipAddressPreferIPv6:YES];
    if (email && ipAddress)
    {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:email, SymphoxAPIParam_account, ipAddress, SymphoxAPIParam_ip, nil];
        [self registerWithOptions:options andType:@"google"];
    }
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

