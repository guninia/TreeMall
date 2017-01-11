//
//  EntranceFunctionSectionHeader.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/9.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *EntranceFunctionSectionHeaderIdentifier = @"EntranceFunctionSectionHeader";

typedef enum : NSUInteger {
    EntranceFunctionExchange,
    EntranceFunctionCoupon,
    EntranceFunctionPromotion,
    EntranceFunctionTotal
} EntranceFunction;

@class EntranceFunctionSectionHeader;

@protocol EntranceFunctionSectionHeaderDelegate <NSObject>

- (void)entranceFunctionSectionHeader:(EntranceFunctionSectionHeader *)header didSelectFunction:(EntranceFunction)function;

@end

@interface EntranceFunctionSectionHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id <EntranceFunctionSectionHeaderDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *arrayButtons;

@end
