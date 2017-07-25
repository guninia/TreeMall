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
#import "EmailAuthViewController.h"
#import "ChangePasswordViewController.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

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

@interface MemberSettingsViewController () {
    id<GAITracker> gaTracker;
}

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)prepareOptions;
- (void)updateAdditionalInformation;
- (void)presentEmailAuthAlert;
- (void)presentPasswordChangeAlert;
- (void)presentNewsletterSubscribeView;
- (void)presentActionSheetForAuthenticateType;
- (void)startAuthenticateWithUrlString:(NSString *)urlString;
- (void)presentInfoModificationView;
- (void)presentContactsModificationView;
- (void)presentWebViewForUrl:(NSURL *)url forType:(WebViewType)type andTitle:(NSString *)title;

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
    
    // To remove unnecessary separator on lower part of tableview.
    self.tableView.tableFooterView = [UIView new];
    
    [self.navigationController.tabBarController.view addSubview:self.viewLoading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfUserInformationUpdatedNotification:) name:PostNotificationName_UserInformationUpdated object:nil];

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

- (NSMutableArray *)arrayOptionIds
{
    if (_arrayOptionIds == nil)
    {
        _arrayOptionIds = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayOptionIds;
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
                [self.arrayOptionIds addObject:[NSNumber numberWithInteger:index]];
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
                [self.arrayOptionIds addObject:[NSNumber numberWithInteger:index]];
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
                [self.arrayOptionIds addObject:[NSNumber numberWithInteger:index]];
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
                [self.arrayOptionIds addObject:[NSNumber numberWithInteger:index]];
                UIImage *image = [UIImage imageNamed:@"men_my_info_icon4"];
                if (image)
                {
                    [self.dictionaryIconImage setObject:image forKey:optionText];
                }
            }
                break;
            case MemberSettingOptionPassword:
            {
                if ([TMInfoManager sharedManager].userHasPassword == NO)
                    break;
                NSString *optionText = [LocalizedString ChangePassword];
                [self.arrayOptions addObject:optionText];
                [self.arrayOptionIds addObject:[NSNumber numberWithInteger:index]];
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
                [self.arrayOptionIds addObject:[NSNumber numberWithInteger:index]];
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
    EmailAuthViewController *viewController = [[EmailAuthViewController alloc] initWithNibName:@"EmailAuthViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentPasswordChangeAlert
{
    ChangePasswordViewController *viewController = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:viewController animated:YES];
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
    [self presentWebViewForUrl:url forType:WebViewTypeAuth andTitle:[LocalizedString Authentication]];
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
    [self presentWebViewForUrl:url forType:WebViewTypeContactEdit andTitle:[LocalizedString ContactsSettings]];
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
    [self presentWebViewForUrl:url forType:WebViewTypeInfoEdit andTitle:[LocalizedString BasicInformationModification]];
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

- (void)presentWebViewForUrl:(NSURL *)url forType:(WebViewType)type andTitle:(NSString *)title
{
    if (url == nil)
        return;
    WebViewViewController *viewController = [[WebViewViewController alloc] initWithNibName:@"WebViewViewController" bundle:[NSBundle mainBundle]];
    viewController.type = type;
    viewController.url = url;
    viewController.title = title;
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
    if (indexPath.row >= [self.arrayOptionIds count])
        return;
    NSInteger optionId = [[self.arrayOptionIds objectAtIndex:indexPath.row] integerValue];
    switch (optionId) {
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
