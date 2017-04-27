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

@interface AuthenticateViewController ()

- (void)presentActionSheetForAuthenticateType;
- (void)startAuthenticateWithUrlString:(NSString *)urlString;
- (void)presentWebViewForUrl:(NSURL *)url;
- (NSString *)encodedUrlStringForUrlString:(NSString *)urlString withParameters:(NSDictionary *)parameters;

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

#pragma mark - Private Methods

- (void)presentActionSheetForAuthenticateType
{
    __weak AuthenticateViewController *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Authentication] message:[LocalizedString SelectAuthenticationType] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *creditCardAction = [UIAlertAction actionWithTitle:[LocalizedString CreditCardMemberAuth] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf startAuthenticateWithUrlString:SymphoxAPI_authenticationCreditCard];
    }];
    UIAlertAction *employeeAction = [UIAlertAction actionWithTitle:[LocalizedString ConglomerateEmployeeAuth] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf startAuthenticateWithUrlString:SymphoxAPI_authenticationEmployee];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:[LocalizedString OtherCustomerOfCathay] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf startAuthenticateWithUrlString:SymphoxAPI_authenticationCathayCustomer];
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
    NSString *encodedUrlString = [self encodedUrlStringForUrlString:urlString withParameters:parameters];
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

- (NSString *)encodedUrlStringForUrlString:(NSString *)urlString withParameters:(NSDictionary *)parameters
{
    if (parameters == nil)
    {
        return urlString;
    }
    NSError *error = nil;
    NSData *paramData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    if (error != nil || paramData == nil)
    {
        NSLog(@"encodedUrlStringForUrlString[%@] error:\n%@", urlString, [error description]);
        return nil;
    }
    NSData *encryptedData = [[CryptoModule sharedModule] encryptFromSourceData:paramData];
    if (encryptedData == nil)
    {
        NSLog(@"encodedUrlStringForUrlString - encrypt error");
        return nil;
    }
    NSString *encryptedString = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    if (encryptedString == nil)
    {
        NSLog(@"encodedUrlStringForUrlString - Cannot produce encryptedString.");
        return nil;
    }
//    NSString *encodedString = [encryptedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedString = [encryptedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
//    NSLog(@"encodedUrlStringForUrlString - encodedString[%@]", encodedString);
    NSString *encodedUrlString = [urlString stringByAppendingFormat:@"?body=%@", encodedString];
    return encodedUrlString;
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
}

@end
