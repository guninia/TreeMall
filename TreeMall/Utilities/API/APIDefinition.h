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
static NSString *SymphoxAPI_promotion = @"http://tomcat8.mdevelop.com/TreeMall/api/onlineService.do";
static NSString *SymphoxAPI_register = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/register";
static NSString *SymphoxAPI_login = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/identify";
static NSString *SymphoxAPI_terms = @"http://tomcat8.mdevelop.com/TreeMall/api/onlineService.do";
static NSString *SymphoxAPI_forgetPassword = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/password/forget";
static NSString *SymphoxAPI_mobileVerification = @"http://tomcat8.mdevelop.com/TreeMall/api/portal/app/member/verify/mobile";
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
static NSString *SymphoxAPIParam_serviceMessage = @"serviceMessage";
static NSString *SymphoxAPIParam_name = @"name";
static NSString *SymphoxAPIParam_tips = @"tips";
static NSString *SymphoxAPIParam_content = @"content";
static NSString *SymphoxAPIParam_account = @"account";
static NSString *SymphoxAPIParam_password = @"password";
static NSString *SymphoxAPIParam_check_pwd = @"check_pwd";
static NSString *SymphoxAPIParam_mobile = @"mobile";
static NSString *SymphoxAPIParam_verify_code = @"verify_code";
static NSString *SymphoxAPIParam_ip = @"ip";
static NSString *SymphoxAPIParam_status_id = @"status_id";
static NSString *SymphoxAPIParam_status_desc = @"status_desc";
static NSString *SymphoxAPIParam_user_num = @"user_num";
static NSString *SymphoxAPIParam_sex = @"sex";
static NSString *SymphoxAPIParam_epoint = @"epoint";
static NSString *SymphoxAPIParam_ecoupon = @"ecoupon";
static NSString *SymphoxAPIParam_send_email = @"send_email";
static NSString *SymphoxAPIParam_send_sms = @"send_sms";
static NSString *SymphoxAPIParam_email = @"email";;

#endif /* APIDefinition_h */
