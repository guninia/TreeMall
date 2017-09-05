//
//  RegisterViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/20.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "RegisterViewController.h"
#import "LocalizedString.h"
#import "Definition.h"
#import "Utility.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "TMInfoManager.h"
#import "AuthenticateViewController.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface RegisterViewController () {
    id<GAITracker> gaTracker;
}

@property (nonatomic, assign) CGRect defaultViewFrame;

- (UITextField *)currentEditingTextField;
- (void)startPreregisterProcedure;
- (void)requestMobileVerificationWithOptions:(NSDictionary *)options;
- (void)presentMobileVerificationAlert;
- (void)startRegisterProcedureWithVerificationCode:(NSString *)verificationCode;
- (void)registerWithOptions:(NSDictionary *)options andType:(NSString *)type;
- (BOOL)processRegisterData:(NSData *)data;

- (IBAction)buttonNextPressed:(id)sender;

- (void)keyboardFrameWillChangeNotificationHandler:(NSNotification *)notification;
- (void)keyboardWillHideNotificationHandler:(NSNotification *)notification;

@end

@implementation RegisterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _dictionaryRegister = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString JoinMember];
    _defaultViewFrame = CGRectZero;
    
    _labelTitle.textColor = TMMainColor;
    _labelTitle.backgroundColor = [UIColor clearColor];
    
    _labelPhone.textColor = [UIColor redColor];
    _labelPhone.backgroundColor = [UIColor clearColor];
    
    [_textFieldEmail setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_textFieldEmail setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_textFieldEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [_textFieldEmail setReturnKeyType:UIReturnKeyNext];
    [_textFieldEmail setDelegate:self];
    
    [_textFieldPhone setKeyboardType:UIKeyboardTypePhonePad];
    [_textFieldPhone setDelegate:self];
    
    [_textFieldPassword setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textFieldPassword setReturnKeyType:UIReturnKeyNext];
    [_textFieldPassword setSecureTextEntry:YES];
    [_textFieldPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_textFieldPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_textFieldPassword setDelegate:self];
    
    [_textFieldConfirm setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textFieldConfirm setReturnKeyType:UIReturnKeyDone];
    [_textFieldConfirm setSecureTextEntry:YES];
    [_textFieldConfirm setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_textFieldConfirm setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_textFieldConfirm setDelegate:self];
    
    [_buttonNext.layer setCornerRadius:5.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChangeNotificationHandler:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotificationHandler:) name:UIKeyboardWillHideNotification object:nil];

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    UITextField *currentEditingTextField = [self currentEditingTextField];
    if (currentEditingTextField != nil)
    {
        [currentEditingTextField resignFirstResponder];
    }
}

#pragma mark - Private Methods

- (UITextField *)currentEditingTextField
{
    UITextField *currentTextField = nil;
    if ([_textFieldEmail isEditing])
    {
        currentTextField = _textFieldEmail;
    }
    else if ([_textFieldPhone isEditing])
    {
        currentTextField = _textFieldPhone;
    }
    else if ([_textFieldPassword isEditing])
    {
        currentTextField = _textFieldPassword;
    }
    else if ([_textFieldConfirm isEditing])
    {
        currentTextField = _textFieldConfirm;
    }
    return currentTextField;
}

- (void)startPreregisterProcedure
{
    [_dictionaryRegister removeAllObjects];
    
    NSString *email = [[_textFieldEmail text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([Utility evaluateEmail:email] == NO)
    {
        // Should show alert to modify account.
        NSLog(@"Account is not illegal.");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString EmailInputError] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [_textFieldPassword setText:@""];
            [_textFieldConfirm setText:@""];
            if ([_textFieldEmail canBecomeFirstResponder])
            {
                [_textFieldEmail becomeFirstResponder];
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
                [_textFieldPassword setText:@""];
                [_textFieldConfirm setText:@""];
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
    NSString *password = [_textFieldPassword text];
    if ([Utility evaluatePassword:password] == NO)
    {
        // Should show alert to modify password.
        NSLog(@"Password is not illegal.");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PasswordInputError] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [_textFieldPassword setText:@""];
            [_textFieldConfirm setText:@""];
            if ([_textFieldPassword canBecomeFirstResponder])
            {
                [_textFieldPassword becomeFirstResponder];
            }
        }];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    NSString *confirm = [_textFieldPassword text];
    if ([Utility evaluatePassword:confirm] == NO)
    {
        // Should show alert to modify password.
        NSLog(@"Password is not illegal.");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PasswordInputError] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [_textFieldPassword setText:@""];
            [_textFieldConfirm setText:@""];
            if ([_textFieldPassword canBecomeFirstResponder])
            {
                [_textFieldPassword becomeFirstResponder];
            }
        }];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if ([password isEqualToString:confirm] == NO)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PasswordNotConfirmed] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [_textFieldPassword setText:@""];
            [_textFieldConfirm setText:@""];
            if ([_textFieldPassword canBecomeFirstResponder])
            {
                [_textFieldPassword becomeFirstResponder];
            }
        }];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    // Should request SMS
    NSString *ipAddress = [Utility ipAddressPreferIPv6:NO];
    if (ipAddress == nil)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString SystemErrorTryLater] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [_textFieldPassword setText:@""];
            [_textFieldConfirm setText:@""];
            if ([_textFieldPassword canBecomeFirstResponder])
            {
                [_textFieldPassword becomeFirstResponder];
            }
        }];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [_dictionaryRegister setObject:email forKey:SymphoxAPIParam_account];
    [_dictionaryRegister setObject:password forKey:SymphoxAPIParam_password];
    [_dictionaryRegister setObject:confirm forKey:SymphoxAPIParam_check_pwd];
    [_dictionaryRegister setObject:phone forKey:SymphoxAPIParam_mobile];
    [_dictionaryRegister setObject:ipAddress forKey:SymphoxAPIParam_ip];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:phone, SymphoxAPIParam_mobile, ipAddress, SymphoxAPIParam_ip, nil];
    [self requestMobileVerificationWithOptions:options];
}

- (void)requestMobileVerificationWithOptions:(NSDictionary *)options
{
    __weak RegisterViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_mobileVerification];
    NSLog(@"login url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:options inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        NSString *errorDescription = nil;
        if (error == nil)
        {
            [weakSelf presentMobileVerificationAlert];
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
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString RequestMobileVerificationFailed] message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [_textFieldPassword setText:@""];
                [_textFieldConfirm setText:@""];
                if ([_textFieldPassword canBecomeFirstResponder])
                {
                    [_textFieldPassword becomeFirstResponder];
                }
            }];
            [alertController addAction:cancelAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)presentMobileVerificationAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString PleaseInputMobileVerificationCode] message:[LocalizedString AlreadySendVerificationCode] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [_textFieldPassword setText:@""];
        [_textFieldConfirm setText:@""];
        if ([_textFieldPassword canBecomeFirstResponder])
        {
            [_textFieldPassword becomeFirstResponder];
        }
    }];
    UIAlertAction *resendAction = [UIAlertAction actionWithTitle:[LocalizedString ResendCode] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self startPreregisterProcedure];
    }];
    UIAlertAction *nextAction = [UIAlertAction actionWithTitle:[LocalizedString NextStep] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSArray *textFields = alertController.textFields;
        if ([textFields count] == 0)
            return;
        UITextField *textField = [textFields objectAtIndex:0];
        NSString *code = [textField text];
        [self startRegisterProcedureWithVerificationCode:code];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:resendAction];
    [alertController addAction:nextAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)startRegisterProcedureWithVerificationCode:(NSString *)verificationCode
{
    if ([verificationCode length] == 0 || [verificationCode length] != 4)
    {
        __weak RegisterViewController *weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Notice] message:[LocalizedString PleaseInputMobileVerificationCode] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf presentMobileVerificationAlert];
        }];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [_dictionaryRegister setObject:verificationCode forKey:SymphoxAPIParam_verify_code];
    [self registerWithOptions:_dictionaryRegister andType:SymphoxAPIParam_email];
}

- (void)registerWithOptions:(NSDictionary *)options andType:(NSString *)type
{
    __weak RegisterViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [[NSURL URLWithString:SymphoxAPI_register] URLByAppendingPathComponent:type];
    NSLog(@"registerWithOptions - register url [%@]", [url absoluteString]);
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
                if ([self processRegisterData:data])
                {
                    // Should go next step.
                    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_UserLoggedIn object:nil];
                    AuthenticateViewController *viewController = [[AuthenticateViewController alloc] initWithNibName:@"AuthenticateViewController" bundle:[NSBundle mainBundle]];
                    viewController.textDescription = @"恭喜新年\n大發財";
                    
                    [gaTracker send:[[GAIDictionaryBuilder
                                      createEventWithCategory:[EventLog twoString:self.title _:logPara_下一步]
                                      action:[EventLog to_:logPara_註冊成功]
                                      label:nil
                                      value:nil] build]];
                    
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                else
                {
                    NSLog(@"registerWithOptions - Cannot process register data.");
                    errorDescription = [LocalizedString UnexpectedFormatAfterParsing];
                }
            }
            else
            {
                NSLog(@"registerWithOptions - Unexpected data format.");
                errorDescription = [LocalizedString UnexpectedFormatFromNetwork];
            }
        }
        else
        {
            NSLog(@"registerWithOptions - error:\n%@", [error description]);
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
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString RegisterFailed] message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [_textFieldPassword setText:@""];
                [_textFieldConfirm setText:@""];
                if ([_textFieldPassword canBecomeFirstResponder])
                {
                    [_textFieldPassword becomeFirstResponder];
                }
            }];
            [alertController addAction:cancelAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
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
            success = YES;
        }
    }
    return success;
}

#pragma mark - Actions

- (IBAction)buttonNextPressed:(id)sender
{
    
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:self.title _:logPara_下一步]
                      action:logPara_點擊
                      label:nil
                      value:nil] build]];
    
    [self startPreregisterProcedure];
}

#pragma mark - NSNotification Handler

- (void)keyboardFrameWillChangeNotificationHandler:(NSNotification *)notification
{
    UITextField *currentEditingTextField = [self currentEditingTextField];
    if (currentEditingTextField == nil)
        return;
    
    NSDictionary *userInfo = notification.userInfo;
    NSValue *frameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if (frameValue == nil)
        return;
    CGRect frame = [frameValue CGRectValue];
//    NSLog(@"Keyboard[%4.2f,%4.2f,%4.2f,%4.2f]", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    if (CGRectEqualToRect(_defaultViewFrame, CGRectZero))
    {
        _defaultViewFrame = self.view.frame;
    }
    CGRect viewFrame = self.view.frame;
//    NSLog(@"viewFrame[%4.2f,%4.2f,%4.2f,%4.2f]", viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
    CGFloat maxVisibleHeight = viewFrame.origin.y + currentEditingTextField.frame.origin.y + currentEditingTextField.frame.size.height + 5.0;
//    NSLog(@"maxVisibleHeight[%4.2f] keyboard.frame.origin.y[%4.2f]", maxVisibleHeight, frame.origin.y);
    if (maxVisibleHeight > frame.origin.y)
    {
        CGFloat shift = maxVisibleHeight - frame.origin.y;
        viewFrame.origin.y -= shift;
        __weak RegisterViewController *weakSelf = self;
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut) animations:^{
            weakSelf.view.frame = viewFrame;
        } completion:nil];
    }
}

- (void)keyboardWillHideNotificationHandler:(NSNotification *)notification
{
    CGRect viewFrame = self.view.frame;
//    NSLog(@"self.view.frame[%4.2f,%4.2f,%4.2f,%4.2f]", viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
//    NSLog(@"_defaultViewFrame[%4.2f,%4.2f,%4.2f,%4.2f]", _defaultViewFrame.origin.x, _defaultViewFrame.origin.y, _defaultViewFrame.size.width, _defaultViewFrame.size.height);
    if (viewFrame.origin.y < _defaultViewFrame.origin.y)
    {
        viewFrame.origin.y = _defaultViewFrame.origin.y;
        __weak RegisterViewController *weakSelf = self;
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut) animations:^{
            weakSelf.view.frame = viewFrame;
        } completion:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _textFieldEmail)
    {
        if ([_textFieldPhone canBecomeFirstResponder])
        {
            [_textFieldPhone becomeFirstResponder];
        }
    }
    else if (textField == _textFieldPassword)
    {
        if ([_textFieldConfirm canBecomeFirstResponder])
        {
            [_textFieldConfirm becomeFirstResponder];
        }
    }
    return YES;
}

@end
