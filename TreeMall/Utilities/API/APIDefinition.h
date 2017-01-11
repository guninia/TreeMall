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
static NSString *SymphoxAPI_token = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/token";
static NSString *SymphoxAPI_homepage = @"http://tomcat8.mdevelop.com/TreeMall/api/onlineService.do";
#else
static NSString *SymphoxAPI_token = @"https://api.symphox.com.tw/portal/app/token";
#endif

static NSString *SymphoxAPIParam_key = @"sym-api-key";
static NSString *SymphoxAPIParam_token = @"sym-api-token";
static NSString *SymphoxAPIParam_txid = @"txid";
static NSString *SymphoxAPIParam_id = @"id";
static NSString *SymphoxAPIParam_result = @"result";
static NSString *SymphoxAPIParam_productBanner = @"productBanner";
static NSString *SymphoxAPIParam_img = @"img";
static NSString *SymphoxAPIParam_link = @"link";
static NSString *SymphoxAPIParam_type = @"type";
static NSString *SymphoxAPIParam_serviceText = @"serviceText";
static NSString *SymphoxAPIParam_toDayFocus = @"toDayFocus";
static NSString *SymphoxAPIParam_now = @"now";


#endif /* APIDefinition_h */
