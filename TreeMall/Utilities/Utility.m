//
//  Utility.m
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/10.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "Utility.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

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

+ (NSString *)ipAddress
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
