//
//  StorePickupWebViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/17.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef enum : NSUInteger {
    ConvenienceStoreGroupSevenEleven,
    ConvenienceStoreGroupOthers,
    ConvenienceStoreGroupTotal
} ConvenienceStoreGroup;

@class StorePickupWebViewController;

@protocol StorePickupWebViewControllerDelegate <NSObject>

- (void)storePickupWebViewController:(StorePickupWebViewController *)viewController didSelectStoreWithDictionary:(NSDictionary *)storeDictionary;

@end

@interface StorePickupWebViewController : UIViewController <UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, weak) id <StorePickupWebViewControllerDelegate> delegate;
@property (nonatomic, assign) ConvenienceStoreGroup group;

@end
