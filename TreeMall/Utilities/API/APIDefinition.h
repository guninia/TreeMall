//
//  APIDefinition.h
//  TreeMall
//
//  Created by 黃思敬 on 2017/1/6.
//  Copyright © 2017年 Symphox. All rights reserved.
//

#ifndef APIDefinition_h
#define APIDefinition_h

#import <Foundation/Foundation.h>

#ifdef DEBUG
static NSString *SymphoxAPI_token = @"https://tapi.symphox.com.tw/portal/app/token";
#else
static NSString *SymphoxAPI_token = @"https://api.symphox.com.tw/portal/app/token";
#endif

#endif /* APIDefinition_h */
