//
//  WebViewViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "WebViewViewController.h"
#import "LocalizedString.h"
#import "Definition.h"
#import "ProductDetailViewController.h"
#import "TMInfoManager.h"
#import "TermsViewController.h"

@interface WebViewViewController ()

- (void)loadRequestFromUrl:(NSURL *)url;

@end

@implementation WebViewViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.type = WebViewTypeOthers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.view addSubview:self.webView];
    
    if (self.url)
    {
        [self loadRequestFromUrl:self.url];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.webView setFrame:self.view.bounds];
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

- (WKWebView *)webView
{
    if (_webView == nil)
    {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)setUrlString:(NSString *)urlString
{
    if ([_urlString isEqualToString:urlString])
        return;
    
    _urlString = urlString;
    NSURL *url = [NSURL URLWithString:_urlString];
    self.url = url;
}

- (void)setUrl:(NSURL *)url
{
    NSString *urlString = url.absoluteString;
    if ([_url.absoluteString isEqualToString:urlString])
        return;

    _url = url;
    if ([_urlString isEqualToString:urlString] == NO)
    {
        _urlString = urlString;
    }
    
    if (self.webView == nil)
        return;
    
    [self loadRequestFromUrl:_url];
}

- (void)setHtmlString:(NSString *)htmlString
{
    _htmlString = htmlString;
    if (_htmlString == nil)
        return;
    if ([self.webView isLoading])
    {
        [self.webView stopLoading];
    }
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicator setHidesWhenStopped:YES];
    }
    return _activityIndicator;
}

#pragma mark - Private Methods

- (void)loadRequestFromUrl:(NSURL *)url
{
    if ([self.webView isLoading])
    {
        [self.webView stopLoading];
    }
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error\n%@", [error description]);
    [self.activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
//    NSLog(@"WKNavigationAction.type[%li]", (long)navigationAction.navigationType);
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if (self.type == WebViewTypeOthers)
    {
        if (navigationAction.navigationType == WKNavigationTypeLinkActivated)
        {
            NSURL *url = navigationAction.request.URL;
            NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
            NSString *stringProductId = nil;
            for (NSURLQueryItem *item in components.queryItems)
            {
                NSLog(@"queryItem [%@][%@]", item.name, item.value);
                if ([item.name compare:@"cpdtnum" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                {
                    stringProductId = item.value;
                }
            }
            if (stringProductId != nil)
            {
                policy = WKNavigationActionPolicyCancel;
                NSNumber *productId = [NSNumber numberWithInteger:[stringProductId integerValue]];
                ProductDetailViewController *viewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:[NSBundle mainBundle]];
                viewController.productIdentifier = productId;
                viewController.title = [LocalizedString ProductInfo];
                [viewController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (url)
            {
                if ([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url];
                    policy = WKNavigationActionPolicyCancel;
                }
            }
        }
    }
    decisionHandler(policy);
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"message:\n%@", message);
    UIAlertAction *confirmAction = nil;
    NSString *alertTitle = nil;
    NSString *alertMessage = nil;
    BOOL success = NO;
    if ([message compare:@"success" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        success = YES;
    }
    else
    {
        if ([message length] > 0)
        {
            alertMessage = message;
        }
    }
    
    switch (self.type) {
        case WebViewTypeAuth:
        {
            if (success)
            {
                alertMessage = [LocalizedString AuthenticateSuccess];
                __weak WebViewViewController *weakSelf = self;
                confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    completionHandler();
                    if (weakSelf.navigationController.presentingViewController)
                    {
                        [weakSelf.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                    else if (weakSelf.presentingViewController)
                    {
                        [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:PostNotificationName_UserAuthenticated object:self];
                }];
            }
            else
            {
                if ([message containsString:@"terms"])
                {
                    NSArray *components = [message componentsSeparatedByString:@"_"];
                    NSString *sn = [components lastObject];
                    NSString *content = [[TMInfoManager sharedManager].dictionaryDocuments objectForKey:sn];
                    if (content)
                    {
                        TermsViewController *viewController = [[TermsViewController alloc] initWithNibName:@"TermsViewController" bundle:[NSBundle mainBundle]];
                        viewController.content = content;
                        __weak WebViewViewController *weakSelf = self;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (weakSelf.navigationController)
                            {
                                [weakSelf.navigationController pushViewController:viewController animated:YES];
                            }
                            else
                            {
                                [weakSelf presentViewController:viewController animated:YES completion:nil];
                            }
                        });
                    }
                    completionHandler();
                }
                else
                {
                    confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        completionHandler();
                    }];
                }
            }
        }
            break;
        case WebViewTypeInfoEdit:
        case WebViewTypeContactEdit:
        {
            if (success)
            {
                alertMessage = [LocalizedString ModifySuccess];
                __weak WebViewViewController *weakSelf = self;
                confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    completionHandler();
                    if (weakSelf.navigationController.presentingViewController)
                    {
                        [weakSelf.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                    else if (weakSelf.navigationController)
                    {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                    else if (weakSelf.presentingViewController)
                    {
                        [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                    [[TMInfoManager sharedManager] retrieveUserInformation];
                }];
            }
            else
            {
                if ([alertMessage compare:@"cancel" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                {
                    completionHandler();
                    __weak WebViewViewController *weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.navigationController.presentingViewController)
                        {
                            [weakSelf.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                        }
                        else if (weakSelf.navigationController)
                        {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                        else if (weakSelf.presentingViewController)
                        {
                            [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                        }
                    });
                }
                else
                {
                    alertTitle = [LocalizedString ModifyFailed];
                    confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        completionHandler();
                    }];
                }
            }
        }
            break;
        default:
        {
            confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                completionHandler();
            }];
        }
            break;
    }
    
    
    if ((alertTitle || alertMessage) && confirmAction)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
