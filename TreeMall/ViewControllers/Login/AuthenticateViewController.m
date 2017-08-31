//
//  AuthenticateViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "AuthenticateViewController.h"
#import "Definition.h"
#import "LocalizedString.h"
#import "WebViewViewController.h"
#import "TMInfoManager.h"
#import "Utility.h"
#import "APIDefinition.h"
#import "CryptoModule.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface AuthenticateViewController () {
    id<GAITracker> gaTracker;
}

- (void)presentActionSheetForAuthenticateType;
- (void)startAuthenticateWithUrlString:(NSString *)urlString;
- (void)presentWebViewForUrl:(NSURL *)url;

- (IBAction)buttonAuthenticatePressed:(id)sender;
- (IBAction)buttonClosePressed:(id)sender;

@end

@implementation AuthenticateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // The Register procedure is complete, should remove the back button to prevent user go back to register page again.
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    _labelTitle.textColor = TMMainColor;
    _labelTitle.backgroundColor = [UIColor clearColor];
    
    [_buttonAuthenticate.layer setCornerRadius:5.0];
    [_buttonClose.layer setCornerRadius:5.0];

    gaTracker = [GAI sharedInstance].defaultTracker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // GA screen log
    [gaTracker set:kGAIScreenName value:logPara_註冊成功];
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

#pragma mark - Private Methods

- (void)presentActionSheetForAuthenticateType
{
    __weak AuthenticateViewController *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Authentication] message:[LocalizedString SelectAuthenticationType] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *creditCardAction = [UIAlertAction actionWithTitle:[LocalizedString CreditCardMemberAuth] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf startAuthenticateWithUrlString:SymphoxAPI_authenticationCreditCard];
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:logPara_註冊成功 _:logPara_立即認證]
                          action:[EventLog to_:logPara_網頁]
                          label:logPara_國泰世華卡友認證
                          value:nil] build]];        
    }];
    UIAlertAction *employeeAction = [UIAlertAction actionWithTitle:[LocalizedString ConglomerateEmployeeAuth] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf startAuthenticateWithUrlString:SymphoxAPI_authenticationEmployee];
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:logPara_註冊成功 _:logPara_立即認證]
                          action:[EventLog to_:logPara_網頁]
                          label:logPara_集團員工認證
                          value:nil] build]];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:[LocalizedString OtherCustomerOfCathay] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf startAuthenticateWithUrlString:SymphoxAPI_authenticationCathayCustomer];
        
        [gaTracker send:[[GAIDictionaryBuilder
                          createEventWithCategory:[EventLog twoString:logPara_註冊成功 _:logPara_立即認證]
                          action:[EventLog to_:logPara_網頁]
                          label:logPara_國泰金控其他客戶
                          value:nil] build]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:creditCardAction];
    [alertController addAction:employeeAction];
    [alertController addAction:otherAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)startAuthenticateWithUrlString:(NSString *)urlString
{
    NSNumber *userIndentifier = [TMInfoManager sharedManager].userIdentifier;
    NSString *ipAddress = [Utility ipAddressPreferIPv6:YES];
    if (userIndentifier == nil || ipAddress == nil)
    {
        NSLog(@"presentActionSheetForAuthenticateType - Missing necessary information.");
        return;
    }
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[userIndentifier stringValue], SymphoxAPIParam_user_num, ipAddress, SymphoxAPIParam_ip, nil];
    NSString *encodedUrlString = [[CryptoModule sharedModule] encodedUrlStringForUrlString:urlString withParameters:parameters];
    if (encodedUrlString == nil)
    {
        NSLog(@"presentActionSheetForAuthenticateType - Cannot encode url string");
        return;
    }
    NSURL *url = [NSURL URLWithString:encodedUrlString];
    if (url == nil)
    {
        NSLog(@"presentActionSheetForAuthenticateType - Invalid url from string");
    }
    [self presentWebViewForUrl:url];
}

- (void)presentWebViewForUrl:(NSURL *)url
{
    if (url == nil)
        return;
    WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
    viewController.url = url;
    viewController.type = WebViewTypeAuth;
    if (self.navigationController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

#pragma mark - Actions

- (IBAction)buttonAuthenticatePressed:(id)sender
{
    [self presentActionSheetForAuthenticateType];
}

- (IBAction)buttonClosePressed:(id)sender
{
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_UserRegisterred object:self];
    
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:logPara_註冊成功 _:logPara_下次再認證]
                      action:logPara_點擊
                      label:nil
                      value:nil] build]];
    
}

@end
