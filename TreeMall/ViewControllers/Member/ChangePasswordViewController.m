//
//  ChangePasswordViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/6/16.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "TMInfoManager.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "LocalizedString.h"
#import "FullScreenLoadingView.h"
#import "Definition.h"
#import "Utility.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface ChangePasswordViewController () {
    id<GAITracker> gaTracker;
}

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITextField *textFieldOldP;
@property (nonatomic, weak) IBOutlet UITextField *textFieldNewP;
@property (nonatomic, weak) IBOutlet UITextField *textFieldConP;
@property (nonatomic, weak) IBOutlet UIButton *buttonConfirm;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;

- (IBAction)buttonConfirmPressed:(id)sender;

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)resetContent;
- (void)startToChangePasswordFromOld:(NSString *)passwordOld toNew:(NSString *)passwordNew confirmBy:(NSString *)passwordCon;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString ChangePassword];
    [self.labelTitle setTextColor:TMMainColor];
    [self.buttonConfirm.layer setCornerRadius:5.0];
    
    [self.navigationController.tabBarController.view addSubview:self.viewLoading];

    gaTracker = [GAI sharedInstance].defaultTracker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // GA screen log
    [gaTracker set:kGAIScreenName value:self.title];
    [gaTracker send:[[GAIDictionaryBuilder createScreenView] build]];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *aTouch in touches) {
        if (aTouch.tapCount == 1) {
            if ([self.textFieldOldP isFirstResponder])
            {
                [self.textFieldOldP resignFirstResponder];
            }
            if ([self.textFieldNewP isFirstResponder])
            {
                [self.textFieldNewP resignFirstResponder];
            }
            if ([self.textFieldConP isFirstResponder])
            {
                [self.textFieldConP resignFirstResponder];
            }
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.viewLoading)
    {
        self.viewLoading.frame = self.navigationController.tabBarController.view.bounds;
        self.viewLoading.indicatorCenter = self.viewLoading.center;
        [self.viewLoading setNeedsLayout];
    }
}

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

#pragma mark - Actions

- (IBAction)buttonConfirmPressed:(id)sender
{
    if ([self.textFieldConP isFirstResponder])
    {
        [self.textFieldConP resignFirstResponder];
    }
    else if ([self.textFieldNewP isFirstResponder])
    {
        [self.textFieldNewP resignFirstResponder];
    }
    else if ([self.textFieldOldP isFirstResponder])
    {
        [self.textFieldOldP resignFirstResponder];
    }
    NSString *oldP = self.textFieldOldP.text;
    NSString *newP = self.textFieldNewP.text;
    NSString *conP = self.textFieldConP.text;
    [self startToChangePasswordFromOld:oldP toNew:newP confirmBy:conP];
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

- (void)resetContent
{
    __weak ChangePasswordViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.textFieldOldP.text = @"";
        weakSelf.textFieldNewP.text = @"";
        weakSelf.textFieldConP.text = @"";
    });
}

- (void)startToChangePasswordFromOld:(NSString *)passwordOld toNew:(NSString *)passwordNew confirmBy:(NSString *)passwordCon
{
    NSString *errorMessage = nil;
    if (passwordOld == nil || [passwordOld length] == 0)
    {
        errorMessage = [LocalizedString PleaseInputOldPassword];
    }
    else if (passwordNew == nil || [passwordNew length] == 0)
    {
        errorMessage = [LocalizedString PleaseInputNewPassword];
    }
    else if ([Utility evaluatePassword:passwordNew] == NO)
    {
        errorMessage = [LocalizedString PleaseInputValidPassword];
    }
    else if (passwordCon == nil || [passwordCon length] == 0)
    {
        errorMessage = [LocalizedString PleaseConfirmNewPassword];
    }
    else if ([passwordNew isEqualToString:passwordCon])
    {
        errorMessage = [LocalizedString PleaseConfirmNewPassword];
    }
    __weak ChangePasswordViewController *weakSelf = self;
    if (errorMessage)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf resetContent];
        }];
        [alertController addAction:action];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    NSNumber *userId = [TMInfoManager sharedManager].userIdentifier;
    if (userId == nil)
    {
        return;
    }
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_changePassword];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:SymphoxAPIParam_user_num];
    [params setObject:passwordOld forKey:SymphoxAPIParam_old_pwd];
    [params setObject:passwordNew forKey:SymphoxAPIParam_password];
    [params setObject:passwordCon forKey:SymphoxAPIParam_check_pwd];
    
    [self showLoadingViewAnimated:YES];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
            // Success
            [weakSelf postPasswordChangeSuccessProcess];
        }
        else
        {
            NSString *errorMessage = [LocalizedString ChangePasswordFailed];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
                NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                if (serverMessage)
                {
                    errorMessage = serverMessage;
                }
            }
            NSLog(@"startToChangePasswordFromOld - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [weakSelf resetContent];
            }];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:YES];
    }];
}

- (void)postPasswordChangeSuccessProcess
{
    [self resetContent];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString ChangePasswordSuccess] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
