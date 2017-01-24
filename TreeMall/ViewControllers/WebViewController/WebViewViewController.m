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

@interface WebViewViewController ()

- (void)loadRequestFromUrl:(NSURL *)url;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Private Methods

- (void)loadRequestFromUrl:(NSURL *)url
{
    if ([self.webView isLoading])
    {
        [self.webView stopLoading];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    [self.webView loadRequest:request];
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"message:\n%@", message);
    UIAlertAction *confirmAction = nil;
    NSString *alertTitle = nil;
    NSString *alertMessage = nil;
    if ([message compare:@"success" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        alertTitle = nil;
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
        alertTitle = [LocalizedString AuthenticateFailed];
        if ([message length] > 0)
        {
            alertMessage = message;
        }
        
        confirmAction = [UIAlertAction actionWithTitle:[LocalizedString Confirm] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            completionHandler();
        }];
    }
    if ((alertTitle || alertMessage) && confirmAction)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end