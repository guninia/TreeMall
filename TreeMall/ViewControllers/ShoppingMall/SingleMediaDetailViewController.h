//
//  SingleMediaDetailViewController.h
//  Fiziko
//
//  Created by Ryo on 6/4/16.
//  Copyright © 2016 ryo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SingleMediaDetailViewController;

@interface SingleMediaDetailViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>{
}

/*
array的格式 @[@"url",@"url".......,nil];
idxStart 第幾張圖開始看 , 未填從array第一個開始
*/
@property (strong , nonatomic) NSMutableArray *aryData;
@property (nonatomic)       NSInteger idxStart;

@end
