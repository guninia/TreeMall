//
//  WebViewViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewViewController : UIViewController <WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) NSURL *url;

@end
