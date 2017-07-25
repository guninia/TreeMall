//
//  EmailAuthViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/6/16.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "EmailAuthViewController.h"
#import "Definition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "TMInfoManager.h"
#import "Utility.h"
#import "FullScreenLoadingView.h"
#import "LocalizedString.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface EmailAuthViewController () {
    id<GAITracker> gaTracker;
}

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITextField *textFieldEmail;
@property (nonatomic, weak) IBOutlet UIButton *buttonConfirm;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;

- (IBAction)buttonConfirmPressed:(id)sender;

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)refreshContent;
- (void)startAuthenticationForEmail:(NSString *)email;
- (void)postEmailAuthSuccessProcess:(NSString *)email;


@end

@implementation EmailAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString EmailAuthentication];
    [self.labelTitle setTextColor:TMMainColor];
    [self.buttonConfirm.layer setCornerRadius:5.0];
    
    [self refreshContent];
    
    [self.navigationController.tabBarController.view addSubview:self.viewLoading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContent) name:PostNotificationName_UserInformationUpdated object:nil];

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostNotificationName_UserInformationUpdated object:nil];
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

-(IBAction)buttonConfirmPressed:(id)sender
{
    if ([self.textFieldEmail isFirstResponder])
    {
        [self.textFieldEmail resignFirstResponder];
    }
    NSString *stringEmail = [self.textFieldEmail text];
    [self startAuthenticationForEmail:stringEmail];
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

- (void)refreshContent
{
    __weak EmailAuthViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // If Already pass the email auth or user is email member, the textField should be disabled.
        if ([TMInfoManager sharedManager].userIsEmailMember || [TMInfoManager sharedManager].userEmailAuth)
        {
            [weakSelf.textFieldEmail setEnabled:NO];
            NSString *userEmailMasked = [TMInfoManager sharedManager].userEmailMasked;
            if (userEmailMasked && [userEmailMasked length] > 0)
            {
                [weakSelf.textFieldEmail setText:userEmailMasked];
            }
            [weakSelf.buttonConfirm setEnabled:NO];
            [weakSelf.buttonConfirm setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        NSString *userEmail = [TMInfoManager sharedManager].userEmail;
        if (userEmail && [userEmail length] > 0)
        {
            [weakSelf.textFieldEmail setText:userEmail];
        }
    });
}

- (void)startAuthenticationForEmail:(NSString *)email
{
    NSString *errorMessage = nil;
    if (email == nil || [email length] == 0)
    {
        errorMessage = [LocalizedString PleaseInputEmail];
    }
    else if ([Utility evaluateEmail:email] == NO)
    {
        errorMessage = [LocalizedString PleaseInputValidEmail];
    }
    __weak EmailAuthViewController *weakSelf = self;
    if (errorMessage)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_emailAuth];
    //    NSLog(@"retrieveSubcategoryDataForIdentifier - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSNumber *userId = [TMInfoManager sharedManager].userIdentifier;
    if (userId)
    {
        [params setObject:userId forKey:SymphoxAPIParam_user_num];
    }
    if ([TMInfoManager sharedManager].userIsEmailMember == NO)
    {
        [params setObject:email forKey:SymphoxAPIParam_email];
    }
    NSString *ipAddress = [Utility ipAddressPreferIPv6:YES];
    if (ipAddress)
    {
        [params setObject:ipAddress forKey:SymphoxAPIParam_ip];
    }
    [self showLoadingViewAnimated:YES];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
            // Success
            [weakSelf postEmailAuthSuccessProcess:email];
        }
        else
        {
            NSString *errorMessage = [LocalizedString AuthenticateFailed];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
                NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                if (serverMessage)
                {
                    errorMessage = serverMessage;
                }
            }
            NSLog(@"startAuthenticationForEmail - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:YES];
    }];
}

- (void)postEmailAuthSuccessProcess:(NSString *)email
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString AuthenticateSuccess] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    [self showLoadingViewAnimated:YES];
    [[TMInfoManager sharedManager] retrieveUserInformation];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
