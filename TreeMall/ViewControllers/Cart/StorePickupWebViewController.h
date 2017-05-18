//
//  StorePickupWebViewController.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/5/17.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ConvenienceStoreGroupSevenEleven,
    ConvenienceStoreGroupOthers,
    ConvenienceStoreGroupTotal
} ConvenienceStoreGroup;

@interface StorePickupWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) ConvenienceStoreGroup group;

@end
