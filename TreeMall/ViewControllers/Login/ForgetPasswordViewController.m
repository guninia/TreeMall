//
//  ForgetPasswordViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/19.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LocalizedString.h"
#import "Definition.h"
#import "Utility.h"
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"

@interface ForgetPasswordViewController ()

- (void)startForgetPasswordProcess;
- (void)requestPasswordWithOptions:(NSDictionary *)options;
- (BOOL)processData:(id)data;

- (IBAction)buttonConfirmPressed:(id)sender;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString ForgetPassword];
    
    _labelTitle.textColor = TMMainColor;
    _labelTitle.backgroundColor = [UIColor clearColor];
    
    [_textFieldAccount setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_textFieldAccount setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_textFieldAccount setKeyboardType:UIKeyboardTypeEmailAddress];
    [_textFieldAccount setReturnKeyType:UIReturnKeyDone];
    [_textFieldAccount setDelegate:self];
    
    [_textFieldPhone setKeyboardType:UIKeyboardTypePhonePad];
    [_textFieldPhone setDelegate:self];
    
    [_buttonConfirm.layer setCornerRadius:5.0];
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([_textFieldAccount isEditing])
    {
        [_textFieldAccount endEditing:YES];
    }
    if ([_textFieldPhone isEditing])
    {
        [_textFieldPhone endEditing:YES];
    }
}

#pragma mark - Actions

- (IBAction)buttonConfirmPressed:(id)sender
{
    [self startForgetPasswordProcess];
}

#pragma mark - Private Methods

- (void)startForgetPasswordProcess
{
    NSString *account = [[_textFieldAccount text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([Utility evaluateEmail:account] == NO)
    {
        // Should show alert to modify account.
        NSLog(@"Account is not illegal.");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString AccountInputError] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if ([_textFieldAccount canBecomeFirstResponder])
            {
                [_textFieldAccount becomeFirstResponder];
            }
        }];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    NSString *phone = [[_textFieldPhone text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([phone length] > 0)
    {
        if ([Utility evaluatePhoneNumber:phone] == NO)
        {
            // Should show alert to modify account.
            NSLog(@"Account is not illegal.");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PhoneInputError] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                if ([_textFieldPhone canBecomeFirstResponder])
                {
                    [_textFieldPhone becomeFirstResponder];
                }
            }];
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:account forKey:SymphoxAPIParam_account];
    if ([phone length] > 0)
    {
        [options setObject:phone forKey:SymphoxAPIParam_mobile];
    }
    [self requestPasswordWithOptions:options];
}

- (void)requestPasswordWithOptions:(NSDictionary *)options
{
    __weak ForgetPasswordViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_forgetPassword];
    NSLog(@"login url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        NSString *errorDescription = nil;
        if (error == nil)
        {
//            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([resultObject isKindOfClass:[NSData class]])
            {
                NSData *data = (NSData *)resultObject;
//                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"string[%@]", string);
                
                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error == nil && jsonObject != nil)
                {
                    if ([self processData:jsonObject] == NO)
                    {
                        errorDescription = [LocalizedString UnexpectedFormatAfterParsing];
                    }
                }
                else
                {
                    errorDescription = error.localizedDescription;
                }
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
            NSString *errorDescription = [userInfo objectForKey:SymphoxAPIParam_status_desc];
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
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString ProcessFailed] message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [_textFieldAccount setText:@""];
                [_textFieldPhone setText:@""];
                if ([_textFieldAccount canBecomeFirstResponder])
                {
                    [_textFieldAccount becomeFirstResponder];
                }
            }];
            [alertController addAction:cancelAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (BOOL)processData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]] == NO)
    {
        return NO;
    }
    NSDictionary *jsonObject = (NSDictionary *)data;
    BOOL sentByEmail = [[jsonObject objectForKey:SymphoxAPIParam_send_email] boolValue];
    BOOL sentBySMS = [[jsonObject objectForKey:SymphoxAPIParam_send_sms] boolValue];
    NSString *email = sentByEmail?@"Email":nil;
    NSString *SMS = sentBySMS?[LocalizedString MessageFromSMS]:nil;
    NSString *channel = nil;
    NSString *message = nil;
    if (email && SMS)
    {
        channel = [NSString stringWithFormat:@"%@%@%@", email, [LocalizedString And], SMS];
    }
    else if (email || SMS)
    {
        channel = (email == nil)?email:SMS;
    }
    else
    {
        message = [LocalizedString NoWayToSendPassword];
    }
    if (message == nil)
    {
        message = [NSString stringWithFormat:[LocalizedString PasswordResent], channel];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (self.navigationController)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if (self.presentingViewController)
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
