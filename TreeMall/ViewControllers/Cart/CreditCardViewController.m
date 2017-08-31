//
//  CreditCardViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/16.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "CreditCardViewController.h"
#import "LocalizedString.h"
#import "APIDefinition.h"
#import "CryptoModule.h"
#import "SHAPIAdapter.h"
#import "FullScreenLoadingView.h"
#import "CompleteOrderViewController.h"
#import "Utility.h"
#import <Google/Analytics.h>
#import "EventLog.h"

@import FirebaseCrash;

@interface CreditCardViewController () {
    id<GAITracker> gaTracker;
}

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *textField1;
@property (nonatomic, weak) IBOutlet UITextField *textField2;
@property (nonatomic, weak) IBOutlet UITextField *textField3;
@property (nonatomic, weak) IBOutlet UITextField *textField4;
@property (nonatomic, weak) IBOutlet UITextField *textFieldM;
@property (nonatomic, weak) IBOutlet UITextField *textFieldY;
@property (nonatomic, weak) IBOutlet UITextField *textFieldS;
@property (nonatomic, weak) IBOutlet UIButton *buttonConfirm;
@property (nonatomic, strong) FullScreenLoadingView *viewLoading;
@property (nonatomic, strong) NSOrderedSet *orderedSetCNo;

- (void)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;
- (void)checkDataThenCreateOrder;
- (void)startToBuildOrderWithParams:(NSMutableDictionary *)params;
- (BOOL)processBuildOrderResult:(id)result;
- (void)presentCompleteOrderViewWithDelivery:(NSDictionary *)delivery;

- (IBAction)buttonConfirmPressed:(id)sender;
- (void)tapRecognized:(UITapGestureRecognizer *)recognizer;
- (void)handlerOfTextFieldTextDidChangeNotification:(NSNotification *)notification;

@end

@implementation CreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [LocalizedString  CreditCardInfo];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.buttonConfirm setBackgroundColor:[UIColor orangeColor]];
    [self.buttonConfirm.layer setCornerRadius:5.0];
    
    if (self.navigationController.tabBarController)
    {
        [self.navigationController.tabBarController.view addSubview:self.viewLoading];
    }
    else if (self.navigationController)
    {
        [self.navigationController.view addSubview:self.viewLoading];
    }
    else
    {
        [self.view addSubview:self.viewLoading];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_textField1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_textField2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_textField3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_textField4];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_textFieldM];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_textFieldY];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerOfTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_textFieldS];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [self.scrollView addGestureRecognizer:tapRecognizer];

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textField1];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textField2];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textField3];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textField4];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textFieldM];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textFieldY];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textFieldS];
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
    if ([_textField1 isFirstResponder])
    {
        [_textField1 resignFirstResponder];
    }
    if ([_textField2 isFirstResponder])
    {
        [_textField2 resignFirstResponder];
    }
    if ([_textField3 isFirstResponder])
    {
        [_textField3 resignFirstResponder];
    }
    if ([_textField4 isFirstResponder])
    {
        [_textField4 resignFirstResponder];
    }
    if ([_textFieldM isFirstResponder])
    {
        [_textFieldM resignFirstResponder];
    }
    if ([_textFieldY isFirstResponder])
    {
        [_textFieldY resignFirstResponder];
    }
    if ([_textFieldS isFirstResponder])
    {
        [_textFieldS resignFirstResponder];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat bottom = CGRectGetMaxY(self.buttonConfirm.frame) + 20.0;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, bottom)];
    
    if (self.viewLoading)
    {
        if (self.navigationController.tabBarController)
        {
            self.viewLoading.frame = self.navigationController.tabBarController.view.bounds;
        }
        else if (self.navigationController)
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

- (NSOrderedSet *)orderedSetCNo
{
    if (_orderedSetCNo == nil)
    {
        _orderedSetCNo = [NSOrderedSet orderedSetWithObjects:@"456311", @"456310", @"438582", @"456328", @"456327", @"438581", @"402310", @"402656", @"428430", @"451871", @"402555", @"402556", @"406376", @"543375", @"541510", @"540842", @"542440", @"552197", @"552032", @"524106", @"546696", @"552579", @"515713", @"518826", @"518844", @"514869", @"356080", @"356380", @"356580", @"356085", @"356385", @"428368", @"511846", nil];
    }
    return _orderedSetCNo;
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

- (void)checkDataThenCreateOrder
{
    NSString *cNo1 = self.textField1.text;
    NSString *cNo2 = self.textField2.text;
    NSString *cNo3 = self.textField3.text;
    NSString *cNo4 = self.textField4.text;
    
    NSString *MM = self.textFieldM.text;
    NSString *yy = self.textFieldY.text;
    
    NSString *sNo = self.textFieldS.text;
    
    NSMutableString *cNo = [NSMutableString string];
    [cNo appendString:cNo1];
    [cNo appendString:cNo2];
    [cNo appendString:cNo3];
    [cNo appendString:cNo4];
    if ([cNo1 length] < 4 || [cNo2 length] < 4 || [cNo3 length] < 4 || [cNo4 length] < 4 || ([Utility evaluateCreditCardNumber:cNo] == NO))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString PleaseInputValidCardNumber] preferredStyle:UIAlertControllerStyleAlert];
        __weak CreditCardViewController *weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if ([weakSelf.textField1 canBecomeFirstResponder])
            {
                [weakSelf.textField1 becomeFirstResponder];
                if ([weakSelf.textField1.text length] > 0)
                {
                    [weakSelf.textField1 selectAll:nil];
                }
            }
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if ([self.tradeId isEqualToString:@"I"] && [self.orderedSetCNo containsObject:[cNo substringWithRange:NSMakeRange(0, 6)]] == NO)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString InstallmentOnlyForCathay] preferredStyle:UIAlertControllerStyleAlert];
        __weak CreditCardViewController *weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if ([weakSelf.textField1 canBecomeFirstResponder])
            {
                [weakSelf.textField1 becomeFirstResponder];
                if ([weakSelf.textField1.text length] > 0)
                {
                    [weakSelf.textField1 selectAll:nil];
                }
            }
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([MM integerValue] < 1 || [MM integerValue] > 12 || [yy length] < 2)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString PleaseInputValidValidDate] preferredStyle:UIAlertControllerStyleAlert];
        __weak CreditCardViewController *weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if ([weakSelf.textFieldM canBecomeFirstResponder])
            {
                [weakSelf.textFieldM becomeFirstResponder];
                if ([weakSelf.textFieldM.text length] > 0)
                {
                    [weakSelf.textFieldM selectAll:nil];
                }
            }
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([sNo length] < 3)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[LocalizedString PleaseInputValidSecurityCode] preferredStyle:UIAlertControllerStyleAlert];
        __weak CreditCardViewController *weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if ([weakSelf.textFieldS canBecomeFirstResponder])
            {
                [weakSelf.textFieldS becomeFirstResponder];
                if ([weakSelf.textFieldS.text length] > 0)
                {
                    [weakSelf.textFieldS selectAll:nil];
                }
            }
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (self.params == nil)
        return;
    
    NSMutableString *vD = [NSMutableString string];
    [vD appendString:MM];
    [vD appendString:yy];
    
    NSMutableDictionary *shopping_payment = [[self.params objectForKey:SymphoxAPIParam_shopping_payment] mutableCopy];
    if (cNo)
    {
        [shopping_payment setObject:cNo forKey:SymphoxAPIParam_card_no];
    }
    if (vD)
    {
        [shopping_payment setObject:vD forKey:SymphoxAPIParam_card_expired_date];
    }
    if (sNo)
    {
        [shopping_payment setObject:sNo forKey:SymphoxAPIParam_card_cvc2];
    }
    [self.params setObject:shopping_payment forKey:SymphoxAPIParam_shopping_payment];
    [self startToBuildOrderWithParams:self.params];
}

- (void)startToBuildOrderWithParams:(NSMutableDictionary *)params
{
    __weak CreditCardViewController *weakSelf = self;
    NSString *apiKey = [CryptoModule sharedModule].apiKey;
    NSString *token = [SHAPIAdapter sharedAdapter].token;
    NSURL *url = [NSURL URLWithString:SymphoxAPI_buildOrder];
    //    NSLog(@"startToBuildOrderWithParams - url [%@]", [url absoluteString]);
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:apiKey, SymphoxAPIParam_key, token, SymphoxAPIParam_token, nil];
    [self showLoadingViewAnimated:YES];
    [[SHAPIAdapter sharedAdapter] sendRequestFromObject:weakSelf ToUrl:url withHeaderFields:headerFields andPostObject:params inPostFormat:SHPostFormatJson encrypted:YES decryptedReturnData:YES completion:^(id resultObject, NSError *error){
        if (error == nil)
        {
            NSLog(@"resultObject[%@]:\n%@", [[resultObject class] description], [resultObject description]);
            if ([weakSelf processBuildOrderResult:resultObject])
            {
                NSDictionary *shopping_delivery = [params objectForKey:SymphoxAPIParam_shopping_delivery];
                [weakSelf presentCompleteOrderViewWithDelivery:shopping_delivery];
            }
            else
            {
                NSLog(@"startToBuildOrderWithParams - Cannot process data.");
            }
        }
        else
        {
            NSString *errorMessage = [LocalizedString CannotLoadData];
            NSDictionary *userInfo = error.userInfo;
            if (userInfo)
            {
                NSString *statusId = [userInfo objectForKey:SymphoxAPIParam_id];
                if ([statusId isEqualToString:@"E238"])
                {
                    errorMessage = [LocalizedString PleaseInputValidCardNumber];
                }
                else if ([statusId isEqualToString:@"E239"])
                {
                    errorMessage = [LocalizedString InstallmentOnlyForCathayCard];
                }
                else
                {
                    NSString *serverMessage = [userInfo objectForKey:SymphoxAPIParam_status_desc];
                    if (serverMessage)
                    {
                        errorMessage = serverMessage;
                    }
                }
            }
            NSLog(@"startToBuildOrderWithParams - error:\n%@", [error description]);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:actionConfirm];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        [weakSelf hideLoadingViewAnimated:NO];
    }];
}

- (BOOL)processBuildOrderResult:(id)result
{
    BOOL success = NO;
    
    if ([result isKindOfClass:[NSData class]])
    {
        NSData *data = (NSData *)result;
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"processBuildOrderResult - string:\n%@", string);
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error == nil)
        {
            NSLog(@"processBuildOrderResult - jsonObject:\n%@", [jsonObject description]);
            self.dictionaryOrderResultData = jsonObject;
            success = YES;
        }
    }
    return success;
}

- (void)presentCompleteOrderViewWithDelivery:(NSDictionary *)delivery
{
    CompleteOrderViewController *viewController = [[CompleteOrderViewController alloc] initWithNibName:@"CompleteOrderViewController" bundle:[NSBundle mainBundle]];
    viewController.dictionaryTotalCost = self.dictionaryTotalCost;
    viewController.dictionaryOrderData = self.dictionaryOrderResultData;
    viewController.tradeId = self.tradeId;
    viewController.type = self.type;
    viewController.dictionaryInstallment = self.dictionaryInstallment;
    viewController.selectedPaymentDescription = self.selectedPaymentDescription;
    viewController.dictionaryDelivery = delivery;
    [viewController setHidesBottomBarWhenPushed:YES];
    
    [gaTracker send:[[GAIDictionaryBuilder
                      createEventWithCategory:[EventLog twoString:self.title _:logPara_確認付款]
                      action:[EventLog to_:viewController.title]
                      label:nil
                      value:nil] build]];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Actions

- (IBAction)buttonConfirmPressed:(id)sender
{
    [self checkDataThenCreateOrder];
}

#pragma mark - Gesture Recognizer

- (void)tapRecognized:(UITapGestureRecognizer *)recognizer
{
//    NSLog(@"tapRecognized");
    if ([_textField1 isFirstResponder])
    {
        [_textField1 resignFirstResponder];
    }
    if ([_textField2 isFirstResponder])
    {
        [_textField2 resignFirstResponder];
    }
    if ([_textField3 isFirstResponder])
    {
        [_textField3 resignFirstResponder];
    }
    if ([_textField4 isFirstResponder])
    {
        [_textField4 resignFirstResponder];
    }
    if ([_textFieldM isFirstResponder])
    {
        [_textFieldM resignFirstResponder];
    }
    if ([_textFieldY isFirstResponder])
    {
        [_textFieldY resignFirstResponder];
    }
    if ([_textFieldS isFirstResponder])
    {
        [_textFieldS resignFirstResponder];
    }
}

#pragma mark - Notification Handler

- (void)handlerOfTextFieldTextDidChangeNotification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[UITextField class]] == NO)
        return;
    UITextField *textField = notification.object;
    BOOL shouldGoNext = NO;
    NSInteger maxStringLength = 0;
    switch (textField.tag) {
        case 1:
        case 2:
        case 3:
        case 4:
        {
            maxStringLength = 4;
        }
            break;
        case 5:
        case 6:
        {
            maxStringLength = 2;
        }
            break;
        case 7:
        {
            maxStringLength = 3;
        }
            break;
        default:
            break;
    }
    if ([textField.text length] == maxStringLength)
    {
        shouldGoNext = YES;
    }
    UITextField *targetTextField = nil;
    if (shouldGoNext)
    {
        switch (textField.tag) {
            case 1:
            {
                targetTextField = self.textField2;
            }
                break;
            case 2:
            {
                targetTextField = self.textField3;
            }
                break;
            case 3:
            {
                targetTextField = self.textField4;
            }
                break;
            case 4:
            {
                targetTextField = self.textFieldM;
            }
                break;
            case 5:
            {
                targetTextField = self.textFieldY;
            }
                break;
            case 6:
            {
                targetTextField = self.textFieldS;
            }
                break;
            default:
                break;
        }
        if (targetTextField && [targetTextField canBecomeFirstResponder])
        {
            [targetTextField becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text length] > 0)
    {
        [textField selectAll:nil];
    }
}

@end
