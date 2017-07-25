//
//  StorePickupWebViewController.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/17.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "StorePickupWebViewController.h"
#import "APIDefinition.h"
#import "LocalizedString.h"
#import <Google/Analytics.h>
#import "EventLog.h"
@import FirebaseCrash;

@interface StorePickupWebViewController () {
    id<GAITracker> gaTracker;
}

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (void)dismiss;

@end

@implementation StorePickupWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *buttonItemIndicator = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self.navigationItem setRightBarButtonItem:buttonItemIndicator];
    UIImage *image = [[UIImage imageNamed:@"car_popup_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(buttonItemClosePressed:)];
    
    
    [self.webView setHidden:YES];
    [self.view addSubview:self.wkWebView];
    
    NSString *urlString = nil;
    if (self.group == ConvenienceStoreGroupSevenEleven)
    {
        urlString = [NSString stringWithFormat:@"https://emap.presco.com.tw/emapmobileu.ashx?eshopid=767001&servicetype=3&url=%@store/store2.do", SymphoxAPIDomain];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"https://mcvs.map.com.tw/default.asp?cvsname=%@store/store.do", SymphoxAPIDomain];
//        urlString = [NSString stringWithFormat:@"https://www.google.com.tw/maps"];
    }
    if (urlString)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        [self.webView loadRequest:request];
        [self.wkWebView loadRequest:request];
        [self.activityIndicator startAnimating];
    }
    
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.wkWebView)
    {
        self.wkWebView.frame = self.view.bounds;
    }
}

- (WKWebView *)wkWebView
{
    if (_wkWebView == nil)
    {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityIndicator setHidesWhenStopped:YES];
    }
    return _activityIndicator;
}

#pragma mark - Private Methods

- (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.navigationController.presentingViewController)
        {
            [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else if (self.navigationController)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.presentingViewController)
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

#pragma mark - Actions

- (void)buttonItemClosePressed:(id)sender
{
    [self dismiss];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest:\n%@", request.URL.absoluteString);
    return YES;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    [self.activityIndicator startAnimating];
}

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
    NSLog(@"WKNavigationAction.type[%li]:\n%@", (long)navigationAction.navigationType, navigationAction.request.URL.absoluteString);
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    NSString *urlString = navigationAction.request.URL.absoluteString;
    if ([urlString rangeOfString:@"cvsspot"].location != NSNotFound)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
        NSArray *items = components.queryItems;
        for (NSURLQueryItem *item in items)
        {
            if ([item.name isEqualToString:@"cvsspot"])
            {
                NSString *value = item.value;
                if (value)
                {
                    [dictionary setObject:value forKey:SymphoxAPIParam_storeid];
                }
            }
            else if ([item.name isEqualToString:@"name"])
            {
                NSString *value = item.value;
                if (value)
                {
                    value = [value stringByRemovingPercentEncoding];
                    [dictionary setObject:value forKey:SymphoxAPIParam_storename];
                }
            }
            else if ([item.name isEqualToString:@"addr"])
            {
                NSString *value = item.value;
                if (value)
                {
                    value = [value stringByRemovingPercentEncoding];
                    [dictionary setObject:value forKey:SymphoxAPIParam_address];
                }
            }
        }
        if (_delegate && [_delegate respondsToSelector:@selector(storePickupWebViewController:didSelectStoreWithDictionary:)])
        {
            [_delegate storePickupWebViewController:self didSelectStoreWithDictionary:dictionary];
        }
        [self dismiss];
    }
    
    decisionHandler(policy);
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"message:\n%@", message);
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error == nil && jsonObject && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(storePickupWebViewController:didSelectStoreWithDictionary:)])
        {
            [_delegate storePickupWebViewController:self didSelectStoreWithDictionary:jsonObject];
        }
        [self dismiss];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    completionHandler();
}

@end
