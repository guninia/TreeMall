//
//  EventLog.m
//  TreeMall
//
//  Created by symphox symphox on 2017/7/23.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import "EventLog.h"

@implementation EventLog

+ (NSString *)twoString:(NSString *)first _:(NSString *)second {
    NSString * returnString = [NSString stringWithFormat:@"%@_%@", first, second];
    return returnString;
}


+ (NSString *)threeString:(NSString *)first _:(NSString *)second _:(NSString *)third {
    NSString * returnString = [NSString stringWithFormat:@"%@_%@_%@", first, second, third];
    return returnString;
}


+ (NSString *)to_:(NSString *)first {
    NSString * returnString = [NSString stringWithFormat:@"to_%@", first];
    return returnString;
}


+ (NSString *)webViewWithName:(NSString *)first {
    NSString * returnStirng = [NSString stringWithFormat:@"網頁:%@", first];
    return returnStirng;
}


+ (NSString *)index:(NSInteger)indexPath _:(NSString *)first {
    NSString * indexString = [NSString stringWithFormat:@"%ld", (long)indexPath];
    NSString * returnString = [NSString stringWithFormat:@"index%@_%@", indexString, first];
    return returnString;
}


+ (NSString *)index:(NSInteger)indexPath _to_:(NSString *)first {
    NSString * indexString = [NSString stringWithFormat:@"%ld", (long)indexPath];
    NSString * returnString = [NSString stringWithFormat:@"index%@_to_%@", indexString, first];
    return returnString;
}


+ (NSString *)typeInString:(NSUInteger)type {
    NSString * returnString = @"";
    
    if (type == 1)
        returnString = @"type1_館別";
    else if (type == 2)
        returnString = @"type2_點數";
    else if (type == 3)
        returnString = @"type3_折價券";
    else
        returnString = [NSString stringWithFormat:@"%lu", (unsigned long)type];
    
    return returnString;
}


+ (NSString *)cartTypeInString:(NSUInteger)type {
    NSString * returnString = @"";
    
    if (type == 1)
        returnString = @"一般";
    else if (type == 2)
        returnString = @"超取";
    else if (type == 3)
        returnString = @"快捷";
    else if (type == 4)
        returnString = @"直接購買";
   
    return returnString;
}


@end



