//
//  MemberSettingsViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/3/21.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "MemberSettingsViewController.h"
#import "LocalizedString.h"
#import "TMInfoManager.h"
#import "Definition.h"
#import "MemberSettingsTableViewCell.h"
#import "Utility.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "APIDefinition.h"
#import "NewsletterSubscribeViewController.h"
#import "WebViewViewController.h"

typedef enum : NSUInteger {
    MemberSettingOptionStart,
    MemberSettingOptionEmailAuth = MemberSettingOptionStart,
    MemberSettingOptionIdentityAuth,
    MemberSettingOptionInfoModify,
    MemberSettingOptionContacts,
    MemberSettingOptionPassword,
    MemberSettingOptionNewsletterSubscription,
    MemberSettingOptionTotal
} MemberSettingOption;

typedef enum : NSUInteger {
    TextFieldTagEmail,
    TextFieldTagPasswordStart,
    TextFieldTagPasswordOld = TextFieldTagPasswordStart,
    TextFieldTagPasswordNew,
    TextFieldTagPasswordConfirm,
    TextFieldTagTotal
} TextFieldTag;

@interface MemberSettingsViewController ()

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)prepareOptions;
- (void)updateAdditionalInformation;
- (void)presentEmailAuthAlert;
- (void)startAuthenticationForEmail:(NSString *)email;
- (void)postEmailAuthSuccessProcess:(NSString *)email;
- (void)presentPasswordChangeAlert;
- (void)startToChangePasswordFromOld:(NSString *)passwordOld toNew:(NSString *)passwordNew confirmBy:(NSString *)passwordCon;
- (void)postPasswordChangeSuccessProcess;
- (void)presentNewsletterSubscribeView;
- (void)presentActionSheetForAuthenticateType;
- (void)startAuthenticateWithUrlString:(NSString *)urlString;
- (void)presentInfoModificationView;
- (void)presentContactsModificationView;
- (void)presentWebViewForUrl:(NSURL *)url forType:(WebViewType)type;

- (void)textDidChangedInTextField:(id)sender;
- (void)handlerOfUserInformationUpdatedNotification:(NSNotification *)notification;

@end

@implementation MemberSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self prepareOptions];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = [LocalizedString AccountInformationMaintain];
    [self.tableView registerClass:[MemberSettingsTableViewCell class] forCellReuseIdentifier:MemberSettingsTableViewCellIdentifier];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    
    [self.navigationController.tabBarController.view addSubview:self.viewLoading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfUserInformationUpdatedNotification:) name:PostNotificationName_UserInformationUpdated object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.viewLoading removeFromSuperview];
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

- (NSMutableArray *)arrayOptions
{
    if (_arrayOptions == nil)
    {
        _arrayOptions = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayOptions;
}

- (NSMutableDictionary *)dictionaryAddition
{
    if (_dictionaryAddition == nil)
    {
        _dictionaryAddition = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryAddition;
}

- (NSMutableDictionary *)dictionaryIconImage
{
    if (_dictionaryIconImage == nil)
    {
        _dictionaryIconImage = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dictionaryIconImage;
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

- (void)prepareOptions
{
    for (NSInteger index = MemberSettingOptionStart; index < MemberSettingOptionTotal; index++)
    {
        switch (index) {
            case MemberSettingOptionEmailAuth:
            {
                NSString *optionText = [LocalizedString EmailAuthentication];
                [self.arrayOptions addObject:optionText];
                UIImage *image = [UIImage imageNamed:@"men_my_info_icon2"];
                if (image)
                {
                    [self.dictionaryIconImage setObject:image forKey:optionText];
                }
            }
                break;
            case MemberSettingOptionIdentityAuth:
            {
                NSString *optionText = [LocalizedString IdentityAuthentication];
                [self.arrayOptions addObject:optionText];
                UIImage *image = [UIImage imageNamed:@"men_my_info_icon1"];
                if (image)
                {
                    [self.dictionaryIconImage setObject:image forKey:optionText];
                }
            }
                break;
            case MemberSettingOptionInfoModify:
            {
                NSString *optionText = [LocalizedString BasicInformationModification];
                [self.arrayOptions addObject:optionText];
                UIImage *image = [UIImage imageNamed:@"men_my_info_icon3"];
                if (image)
                {
                    [self.dictionaryIconImage setObject:image forKey:optionText];
                }
            }
                break;
            case MemberSettingOptionContacts:
            {
                NSString *optionText = [LocalizedString ContactsSettings];
                [self.arrayOptions addObject:optionText];
                UIImage *image = [UIImage imageNamed:@"men_my_info_icon4"];
                if (image)
                {
                    [self.dictionaryIconImage setObject:image forKey:optionText];
                }
            }
                break;
            case MemberSettingOptionPassword:
            {
                NSString *optionText = [LocalizedString ChangePassword];
                [self.arrayOptions addObject:optionText];
                UIImage *image = [UIImage imageNamed:@"men_my_info_icon5"];
                if (image)
                {
                    [self.dictionaryIconImage setObject:image forKey:optionText];
                }
            }
                break;
            case MemberSettingOptionNewsletterSubscription:
            {
                NSString *optionText = [LocalizedString NewsletterSubscribe];
                [self.arrayOptions addObject:optionText];
                UIImage *image = [UIImage imageNamed:@"men_my_info_icon6"];
                if (image)
                {
                    [self.dictionaryIconImage setObject:image forKey:optionText];
                }
            }
                break;
            default:
                break;
        }
    }
    [self updateAdditionalInformation];
}

- (void)updateAdditionalInformation
{
    if ([self.dictionaryAddition count] > 0)
    {
        [self.dictionaryAddition removeAllObjects];
    }
    
    if ([TMInfoManager sharedManager].userEmailAuth == NO)
    {
        NSString *totalString = [NSString stringWithFormat:[LocalizedString CompleteAuthenticationToGet_N_Points], 500];
        [self.dictionaryAddition setObject:totalString forKey:[LocalizedString EmailAuthentication]];
    }
    else
    {
        [self.dictionaryAddition setObject:[LocalizedString Authenticated] forKey:[LocalizedString EmailAuthentication]];
    }
    if ([[TMInfoManager sharedManager].userAuthStatus isEqualToString:@"100"])
    {
        [self.dictionaryAddition setObject:[LocalizedString Authenticated] forKey:[LocalizedString IdentityAuthentication]];
    }
    else if ([[TMInfoManager sharedManager].userAuthStatus isEqualToString:@"000"])
    {
        NSString *totalString = [NSString stringWithFormat:[LocalizedString CompleteAuthenticationToGet_N_Points], 500];
        [self.dictionaryAddition setObject:totalString forKey:[LocalizedString IdentityAuthentication]];
    }
    else
    {
        [self.dictionaryAddition setObject:[LocalizedString CardMemberAuthenticationNotComplete] forKey:[LocalizedString IdentityAuthentication]];
    }
}

- (void)presentEmailAuthAlert
{
    __weak MemberSettingsViewController *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString EmailAuthentication] message:[LocalizedString PleaseInputYourEmail] preferredStyle:UIAlertControllerStyleAlert];
    
    __block BOOL shouldEnableConfirmButton = NO;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.tag = TextFieldTagEmail;
        [textField setPlaceholder:[LocalizedString PleaseInputEmail]];
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setDelegate:self];
        
        // If Already pass the email auth or user is email member, the textField should be disabled.
        if ([TMInfoManager sharedManager].userIsEmailMember || [TMInfoManager sharedManager].userEmailAuth)
        {
            [textField setEnabled:NO];
            NSString *userEmailMasked = [TMInfoManager sharedManager].userEmailMasked;
            if (userEmailMasked && [userEmailMasked length] > 0)
            {
                [textField setText:userEmailMasked];
            }
        }
        
        NSString *userEmail = [TMInfoManager sharedManager].userEmail;
        if (userEmail && [userEmail length] > 0)
        {
            [textField setText:userEmail];
        }
        
        if ([textField text] > 0 && [Utility evaluateEmail:[textField text]])
        {
            shouldEnableConfirmButton = YES;
        }
        [textField addTarget:weakSelf action:@selector(textDidChangedInTextField:) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSArray *textFields = [alertController textFields];
        if ([textFields count] > 0)
        {
            UITextField *textField = [textFields objectAtIndex:0];
            NSString *stringEmail = [textField text];
            [weakSelf startAuthenticationForEmail:stringEmail];
        }
    }];
    [actionConfirm setEnabled:shouldEnableConfirmButton];
    [alertController addAction:actionCancel];
    [alertController addAction:actionConfirm];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)startAuthenticationForEmail:(NSString *)email
{
    if (email == nil || [email length] == 0)
        return;
    __weak MemberSettingsViewController *weakSelf = self;
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

- (void)presentPasswordChangeAlert
{
    __weak MemberSettingsViewController *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString ChangePassword] message:[LocalizedString PleaseInputYourNewPassword] preferredStyle:UIAlertControllerStyleAlert];
    
    __block BOOL shouldEnableConfirmButton = NO;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.tag = TextFieldTagPasswordOld;
        [textField setPlaceholder:[LocalizedString PleaseInputOldPassword]];
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        [textField setReturnKeyType:UIReturnKeyNext];
        [textField setSecureTextEntry:YES];
        [textField addTarget:weakSelf action:@selector(textDidChangedInTextField:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.tag = TextFieldTagPasswordNew;
        [textField setPlaceholder:[LocalizedString PleaseInputNewPassword]];
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        [textField setReturnKeyType:UIReturnKeyNext];
        [textField setSecureTextEntry:YES];
        [textField setDelegate:self];
        [textField addTarget:weakSelf action:@selector(textDidChangedInTextField:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.tag = TextFieldTagPasswordConfirm;
        [textField setPlaceholder:[LocalizedString PleaseConfirmNewPassword]];
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setSecureTextEntry:YES];
        [textField setDelegate:self];
        [textField addTarget:weakSelf action:@selector(textDidChangedInTextField:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *passwordOld = nil;
        NSString *passwordNew = nil;
        NSString *passwordCon = nil;
        NSArray *textFields = [alertController textFields];
        NSInteger indexOfPasswordOld = TextFieldTagPasswordOld - TextFieldTagPasswordStart;
        if ([textFields count] > indexOfPasswordOld)
        {
            UITextField *textField = [textFields objectAtIndex:indexOfPasswordOld];
            passwordOld = [textField text];
        }
        NSInteger indexOfPasswordNew = TextFieldTagPasswordNew - TextFieldTagPasswordStart;
        if ([textFields count] > indexOfPasswordNew)
        {
            UITextField *textField = [textFields objectAtIndex:indexOfPasswordNew];
            passwordNew = [textField text];
        }
        NSInteger indexOfPasswordCon = TextFieldTagPasswordConfirm - TextFieldTagPasswordStart;
        if ([textFields count] > indexOfPasswordCon)
        {
            UITextField *textField = [textFields objectAtIndex:indexOfPasswordCon];
            passwordCon = [textField text];
        }
        [weakSelf startToChangePasswordFromOld:passwordOld toNew:passwordNew confirmBy:passwordCon];
    }];
    [actionConfirm setEnabled:shouldEnableConfirmButton];
    [alertController addAction:actionCancel];
    [alertController addAction:actionConfirm];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)startToChangePasswordFromOld:(NSString *)passwordOld toNew:(NSString *)passwordNew confirmBy:(NSString *)passwordCon
{
    if (passwordOld == nil || passwordNew == nil || passwordCon == nil)
        return;
    NSNumber *userId = [TMInfoManager sharedManager].userIdentifier;
    if (userId == nil)
    {
        return;
    }
    __weak MemberSettingsViewController *weakSelf = self;
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
            NSLog(@"startToChangePasswordFromOld - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:YES];
    }];
}

- (void)postPasswordChangeSuccessProcess
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString ChangePasswordSuccess] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentNewsletterSubscribeView
{
    NewsletterSubscribeViewController *viewController = [[NewsletterSubscribeViewController alloc] initWithNibName:@"NewsletterSubscribeViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentActionSheetForAuthenticateType
{
    __weak MemberSettingsViewController *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LocalizedString Authentication] message:[LocalizedString SelectAuthenticationType] preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *creditCardAction = [UIAlertAction actionWithTitle:[LocalizedString CreditCardMemberAuth] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf startAuthenticateWithUrlString:SymphoxAPI_authenticationCreditCard];
    }];
    [alertController addAction:creditCardAction];
    if ([[TMInfoManager sharedManager].userAuthStatus isEqualToString:@"000"])
    {
        UIAlertAction *employeeAction = [UIAlertAction actionWithTitle:[LocalizedString ConglomerateEmployeeAuth] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf startAuthenticateWithUrlString:SymphoxAPI_authenticationEmployee];
        }];
        [alertController addAction:employeeAction];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:[LocalizedString OtherCustomerOfCathay] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [weakSelf startAuthenticateWithUrlString:SymphoxAPI_authenticationCathayCustomer];
        }];
        [alertController addAction:otherAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[LocalizedString Cancel] style:UIAlertActionStyleDestructive handler:nil];
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
    [self presentWebViewForUrl:url forType:WebViewTypeAuth];
}

- (void)presentContactsModificationView
{
    NSNumber *userIndentifier = [TMInfoManager sharedManager].userIdentifier;
    NSString *ipAddress = [Utility ipAddressPreferIPv6:YES];
    if (userIndentifier == nil || ipAddress == nil)
    {
        NSLog(@"presentActionSheetForAuthenticateType - Missing necessary information.");
        return;
    }
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[userIndentifier stringValue], SymphoxAPIParam_user_num, ipAddress, SymphoxAPIParam_ip, nil];
    NSString *encodedUrlString = [self encodedUrlStringForUrlString:SymphoxAPI_editContacts withParameters:parameters];
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
    [self presentWebViewForUrl:url forType:WebViewTypeContactEdit];
}

- (void)presentInfoModificationView
{
    NSNumber *userIndentifier = [TMInfoManager sharedManager].userIdentifier;
    NSString *ipAddress = [Utility ipAddressPreferIPv6:YES];
    if (userIndentifier == nil || ipAddress == nil)
    {
        NSLog(@"presentActionSheetForAuthenticateType - Missing necessary information.");
        return;
    }
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[userIndentifier stringValue], SymphoxAPIParam_user_num, ipAddress, SymphoxAPIParam_ip, nil];
    NSString *encodedUrlString = [self encodedUrlStringForUrlString:SymphoxAPI_editBasicInfo withParameters:parameters];
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
    [self presentWebViewForUrl:url forType:WebViewTypeInfoEdit];
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

- (void)presentWebViewForUrl:(NSURL *)url forType:(WebViewType)type
{
    if (url == nil)
        return;
    WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
    viewController.type = type;
    viewController.url = url;
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

- (void)textDidChangedInTextField:(id)sender
{
    if ([sender isKindOfClass:[UITextField class]] == NO)
        return;
    if (self.presentedViewController == nil || [self.presentedViewController isKindOfClass:[UIAlertController class]] == NO)
        return;
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    UIAlertAction *actionConfirm = alertController.actions.lastObject;
    UITextField *textField = (UITextField *)sender;
    
    switch (textField.tag) {
        case TextFieldTagEmail:
        {
            NSString *stringEmail = [textField text];
            [actionConfirm setEnabled:[Utility evaluateEmail:stringEmail]];
        }
            break;
        case TextFieldTagPasswordNew:
        case TextFieldTagPasswordConfirm:
        {
            NSArray *arrayTextFields = alertController.textFields;
            NSInteger indexOfPasswordNew = TextFieldTagPasswordNew - TextFieldTagPasswordStart;
            NSInteger indexOfPasswordCon = TextFieldTagPasswordConfirm - TextFieldTagPasswordStart;
            if (indexOfPasswordNew < [arrayTextFields count] && indexOfPasswordCon < [arrayTextFields count])
            {
                UITextField *textFieldPasswordNew = [arrayTextFields objectAtIndex:indexOfPasswordNew];
                UITextField *textFieldPasswordCon = [arrayTextFields objectAtIndex:indexOfPasswordCon];
                NSString *passwordNew = [textFieldPasswordNew text];
                NSString *passwordCon = [textFieldPasswordCon text];
                
                if ([Utility evaluatePassword:passwordNew] && [passwordCon isEqualToString:passwordNew])
                {
                    [actionConfirm setEnabled:YES];
                }
                else
                {
                    [actionConfirm setEnabled:NO];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - NSNotification Handler

- (void)handlerOfUserInformationUpdatedNotification:(NSNotification *)notification
{
    [self updateAdditionalInformation];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self hideLoadingViewAnimated:YES];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.arrayOptions count];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberSettingsTableViewCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell.accessoryView == nil)
    {
        UIImage *image = [UIImage imageNamed:@"men_my_ord_go"];
        if (image)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            cell.accessoryView = imageView;
        }
    }
    if (indexPath.row < [self.arrayOptions count])
    {
        NSString *option = [self.arrayOptions objectAtIndex:indexPath.row];
        if (option)
        {
            cell.textLabel.text = option;
        }
        UIImage *image = [self.dictionaryIconImage objectForKey:option];
        if (image)
        {
            cell.imageView.image = image;
        }
        NSString *addition = [self.dictionaryAddition objectForKey:option];
        if (addition)
        {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0], NSFontAttributeName, [UIColor orangeColor], NSForegroundColorAttributeName, nil];
            [cell.labelView setText:addition withAttributes:dictionary];
            [cell.labelView setHidden:NO];
        }
        else
        {
            [cell.labelView setHidden:YES];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case MemberSettingOptionEmailAuth:
        {
            if ([TMInfoManager sharedManager].userEmailAuth == NO)
            {
                // Should pop alert;
                [self presentEmailAuthAlert];
            }
        }
            break;
        case MemberSettingOptionIdentityAuth:
        {
            if ([[TMInfoManager sharedManager].userAuthStatus isEqualToString:@"100"] == NO)
            {
                [self presentActionSheetForAuthenticateType];
            }
            
        }
            break;
        case MemberSettingOptionInfoModify:
        {
            [self presentInfoModificationView];
        }
            break;
        case MemberSettingOptionContacts:
        {
            [self presentContactsModificationView];
        }
            break;
        case MemberSettingOptionPassword:
        {
            [self presentPasswordChangeAlert];
        }
            break;
        case MemberSettingOptionNewsletterSubscription:
        {
            [self presentNewsletterSubscribeView];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = NO;
    switch (textField.tag) {
        case TextFieldTagEmail:
        {
            NSString *stringEmail = [textField text];
            shouldReturn = [Utility evaluateEmail:stringEmail];
            if (shouldReturn == NO)
            {
                UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
                [alertController setMessage:[LocalizedString PleaseInputValidEmail]];
            }
        }
            break;
        case TextFieldTagPasswordNew:
        {
            NSString *stringPassword = [textField text];
            shouldReturn = [Utility evaluatePassword:stringPassword];
            if (shouldReturn == NO)
            {
                UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
                [alertController setMessage:[LocalizedString PleaseInputValidPassword]];
            }
        }
            break;
        case TextFieldTagPasswordConfirm:
        {
            NSString *stringPassword = [textField text];
            shouldReturn = [Utility evaluatePassword:stringPassword];
            if (shouldReturn == NO)
            {
                UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
                [alertController setMessage:[LocalizedString PleaseInputValidPassword]];
            }
        }
            break;
        default:
            break;
    }
    return shouldReturn;
}

@end
