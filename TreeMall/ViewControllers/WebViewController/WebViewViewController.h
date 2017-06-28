//
//  WebViewViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef enum : NSUInteger {
    WebViewTypeAuth,
    WebViewTypeInfoEdit,
    WebViewTypeContactEdit,
    WebViewTypeOthers,
    WebViewTypeTotal
} WebViewType;

@interface WebViewViewController : UIViewController <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSString *htmlString;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, assign) WebViewType type;

@end
