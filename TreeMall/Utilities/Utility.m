//
//  Utility.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (CGSize)sizeRatioAccordingTo320x480
{
    CGSize sizeRatio = [Utility sizeRatioAccordingToRefrenceSize:CGSizeMake(320.0, 480.0)];
    return sizeRatio;
}

+ (CGSize)sizeRatioAccordingToRefrenceSize:(CGSize)referenceSize
{
    CGSize sizeRatio = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        sizeRatio.width = [UIScreen mainScreen].bounds.size.width / referenceSize.width;
        sizeRatio.height = [UIScreen mainScreen].bounds.size.height / referenceSize.height;
    }
    else
    {
        sizeRatio.width = [UIScreen mainScreen].bounds.size.width / referenceSize.height;
        sizeRatio.height = [UIScreen mainScreen].bounds.size.height /referenceSize.width;
    }
    return sizeRatio;
}

@end
